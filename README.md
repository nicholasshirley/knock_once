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

Then run generators to generate migration
```
rails g knock_once:install
```

## Returning user info
By default `knock_once` will only return the user's id and email address when user information is encoded in the token (on login and create token). To include additional information add the method `to_token_payload` to the `user.rb` model that was created by the generator and define the values you would like to return. Example:

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
