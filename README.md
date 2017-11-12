# KnockOnce
knock_once is a user auth gem built on top of [knock](https://github.com/nsarno/knock). The goals of knock_once are twofold:
* Provide the minimum functionality required to register, authenticate, and reset user passwords. In this sense, minimum means only basic functionality which should apply to the largest number of users.
* Provide easy extensibility and customization. Because the first goal is to provide only basic auth, it's expected that all or most users will want to add or modify functionality and development choices in this gem should be made with this in mind.

Though it is not released in this gem, it is planned to have additional functionality available through additional gems (e.g. confirming users, lockable accounts...). The goal here is to provide much of the functionality available in other packages, such as [devise](https://github.com/plataformatec/devise) and [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth), using JWT.

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

Then run generators to generate routes, migration and models
```
rails g knock_once:install
```

## Contributing
TODO

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
