# KnockOnce
knock_once is a user auth gem built on top of [knock](https://github.com/nsarno/knock). The goals of knock_once are twofold:
* Provide the minimum functionality required to register, authenticate, and reset user passwords. In this sense, minimum means only basic functionality which should apply to the largest number of users.
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
mount KnockOnce::Engine, at: '/auth'
```

Then run generators
```
rails g knock_once:install
```

## Assumptions
knock_once requires that you have a model called user (see generator output). In the future, this will be made configurable, but at the moment it's the only possibility.

## Setting up
After you run the install generator, you will have a user model, user migration and an initialization file. You only need to run `rails db:migrate`  to get started, but realistically your user model will have more informatino than just an email. Add your additional user fields to the migration (and any validations etc you need for them on the model) and then whitelist the required params in the initializer.

## User

### Returning user info
By default `knock_once` will only return the user's id and email address when user information is encoded in the token (on login and create token). To overwrite this add the method `to_token_payload` to the `user.rb` model that was created by the generator and define the values you would like to return. Example:

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

## Current state
The gem has been extracted from a test project and as such has very little configurability (but it works at least within those parameters). The primary next steps are to add user configuration options, additional documentation, add tests for current functionality and improve the generators.

## Contributing
Pull requests are very welcome.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
