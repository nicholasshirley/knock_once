# KnockOnce
knock_once is a user auth gem built on top of [knock](https://github.com/nsarno/knock) to provide a basic JWT user auth system for APIs. The goals of knock_once are twofold:
* Provide the minimum functionality required to register, authenticate, and reset user passwords. 
* Provide easy extensibility and customization. Because the first goal is to provide only basic auth, it's expected that all or most users will want to add or modify functionality and development choices in this gem should be made with this in mind.

Though it is not released now, it is planned to have additional functionality available either here or through additional gems (e.g. confirming users, lockable accounts...). The goal here is to provide much of the functionality available in other packages, such as [devise](https://github.com/plataformatec/devise) and [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth), using JWT.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'knock_once'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install knock_once
```

Mount the gem in our `routes.rb` file:

```ruby
mount KnockOnce::Engine, at: '/auth' # Can mount at whatever path you like
```

Then run generators and include the name for your user model
```
rails g knock_once:install [User]
```

## Setting up
After you run the install generator, you will have a user model, user migration and an initialization file. You only need to run `rails db:migrate`  to get started, but realistically your user model will have more information than just an email. Add your additional user fields to the migration (and any validations etc you need for them on the model) and then whitelist the required user params in the initializer.

### Require user auth on a controller
You have access to the `authenticate_user` method via the `knock` gem. The easiest way to incorporate this is to include the module in your application controller:
```
class ApplicationController < ActionController::API
  include Knock::Authenticable
end
```

Then you can add the standard before action on each controller you would like to require authentication for: `before_action :authenticate_user`

## User


### User validations
knock_once has basic user validation for the following fields:

* email: must be unique, less than 255 characters and conform to a very basic regext test
* password: must be at least 8 characters
*Note:* Password is allowed to be nil on update, but enforced for changes on the controller, so if you decide to override either the user or passwords_controller you can update attributes without changing this validation on the model.
* password_digest: must be present (fails if you forget to pass a `password_confirmation` on registration)

If you would like to add additional validations, you can do so directly inside the `user.rb` file that is created by the generator.

### User endpoints
User endpoints are avalailable under `#{mount_path}/users` with the exception of retrieving a token, which is available under `#{mount_path}/user_token`. For example, if you have mounted the engine at `auth` then your user show action is at `/auth/users`.

*Note:* for the rest of the examples it is assumed that you have mounted the engine at `auth`.

#### Registering a new user
To register a new user `POST` to `/auth/users` with the information required by your application. At a minimum, user registration must include an `email`, `password` and `password confirmation`. 

Example:
```
{
    "email": "exampleuser@example.com",
    "password": "password",
    "password_confirmation": "password"
}
```

#### Get user token (Login)
To get a new user token `POST` the user `email` and `password` to `auth/user_token`.

Example:
```
{
	"auth": {
		"email": "firstuser@example.com",
		"password": "password"
	}
}
```

#### Returning user info in user token
By default `knock_once` will only return the user's id and email address when user information is encoded in the token (on login, create token and get user). To overwrite this add the method `to_token_payload` to the `user.rb` model that was created by the generator and define the values you would like to return.
Example:

```ruby
def to_token_payload
  {
    sub: id,
    email: email,
    user_name: user_name,
    image: image
  }
end
```

#### Get user
The default show action returns the current user based on the token passed. To retrieve current user information `GET` to `/auth/users` with a valid authorization token.

If you would like to retrieve other users, you can add a controller action and route. If you choose to have this controller inherit from `KnockOnce::UsersController` then there is no need to call `authenticate_user` as it is already called in the engine. A very basic example would be:

`app/controller/users_controller.rb`
```ruby
class UsersController < KnockOnce::UsersController
  def show
    @user = User.find(params[:id])
    render json: @user
  end
end
```

`config/routes.rb`
```ruby
Rails.application.routes.draw do
  mount KnockOnce::Engine, at: '/auth'

  post '/users', to: 'users#show'
end
```

#### Updating a user
To update a user attribute(s), `PATCH` or `PUT` to `/auth/users` with a valid token, the `current_password` and the updated attributes.

Example:
```
{
	"current_password": "password",
	"email": "newemail@example.com"
}
```

*Note:* You will need to strip empty fields on the front end. If you pass empty strings as values, they will save as those values (with the exception of `email` which will fail validation).

*Note:* To change a user password, see the passwords section below.

#### Deleting a user
To delete a user `DELETE` to `/auth/users` with a valid token and the current password.

Example:
```
{
  "current_password": "password",
}
```

### Passwords
Password changes and the forgot password flow are handled by the passwords controller. The passwords controller, like the users controller, enforces that a current password is passed to update. To override this behavior, see the notes in the the initializer.

#### Updating a user password (when the user knows their current password)
To update a user password `PATCH` or `PUT` to `/auth/passwords` with a valid authorization token, the `current_password`, the desired new `password` and a matching `password_confirmation`.

Example:
```
{
	"current_password": "password",
	"password": "newpassword",
	"password_confirmation": "newpassword"
}
```

### Forgot password flow
To allow the user to reset their password `POST` a valid email to `/auth/passwords/reset`. This will trigger an email which has a token. To select a new password the token must be passed with a `PATCH` or `PUT` to `/auth/passwords/reset` along with a `token`, `password` and `password_confirmation`. There is also a convenience method avalable at `/auth/passwords/validate` which will return an empty `202` if the token passed to it is valid (this though is the only function, it does not reset passwords or invalidate tokens; it only validates that they exist in the database).

#### Creating a token
To create a token simply `POST` to `/auth/passwords/reset` with a valid email address. As a security precaution, the server will return `200` and a non-commital message regardless of whether the email is registered.

Password Reset tokens are good for 1 hour by default. This can be customized in the initializer.

#### Updating password with token
To reset a user password with a valid reset token `PATCH` or `PUT` to `/auth/passwords/reset` with the `token`, a `password` and `password_confirmation`.

Example:
```
{
	"token": "t7wHptqkZIGAirwdq5Ubt_rx",
	"password": "newpassword",
	"password_confirmation": "newpassword"
}
```

#### Validation endpoint
If you would like to check if a user token is valid (e.g. you are making them enter a pin or copy a token from an email) you can `POST` to `/auth/passwords/validate` with a `token`. This will return an empty `202` on success and `404` on failure.

## Current state
The gem has been extracted from a test project and as such has only limited configurability (but it works at least within those parameters). The primary next steps are to add user configuration options, additional documentation, add tests for current functionality and improve the generators.

## Contributing
Pull requests are very welcome.

Current list of items that I would like to add to the gem

* Tests! The current test suite needs work. Please see [CONTRIBUTING](https://github.com/nicholasshirley/knock_once/blob/master/CONTRIBUTING.md) for the current test strategy.
* Initializer + code changes to let users set password recovery method (e.g. token vs pin), length
* Initializer + code changes to customize what is required on delete (default is a valid token only)
* Forgot password mail template that generate based on the choosen strategy (e.g. reset link, email token, pin reset...) and the initializers to suppor this
* Hook into knock initializer so that users can customize those options from the knock_once initializer file

Please see [CONTRIBUTING](https://github.com/nicholasshirley/knock_once/blob/master/CONTRIBUTING.md) for specicifics.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
