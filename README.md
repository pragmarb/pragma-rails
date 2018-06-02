# Pragma on Rails

[![Build Status](https://travis-ci.org/pragmarb/pragma-rails.svg?branch=master)](https://travis-ci.org/pragmarb/pragma-rails)
[![Dependency Status](https://gemnasium.com/badges/github.com/pragmarb/pragma-rails.svg)](https://gemnasium.com/github.com/pragmarb/pragma-rails)
[![Coverage Status](https://coveralls.io/repos/github/pragmarb/pragma-rails/badge.svg?branch=master)](https://coveralls.io/github/pragmarb/pragma-rails?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e51e8d7489eb72ab97ba/maintainability)](https://codeclimate.com/github/pragmarb/pragma-rails/maintainability)

This gem provides Ruby on Rails integration for the [Pragma](https://github.com/pragmarb/pragma) architecture.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragma-rails'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install pragma-rails
```

## Usage

### Generators

This gem provides a `pragma:resource` generator for creating a new resource with the default CRUD
operations:

```console
$ rails g pragma:resource image
      create  app/resources/api/v1/image
      create  app/resources/api/v1/image/contract/base.rb
      create  app/resources/api/v1/image/contract/create.rb
      create  app/resources/api/v1/image/contract/update.rb
      create  app/resources/api/v1/image/decorator/instance.rb
      create  app/resources/api/v1/image/decorator/collection.rb
      create  app/resources/api/v1/image/operation/create.rb
      create  app/resources/api/v1/image/operation/destroy.rb
      create  app/resources/api/v1/image/operation/index.rb
      create  app/resources/api/v1/image/operation/show.rb
      create  app/resources/api/v1/image/operation/update.rb
      create  app/resources/api/v1/image/policy.rb
      create  app/controllers/api/v1/images_controller.rb
      create  spec/requests/api/v1/images_spec.rb
       route  namespace :api do
    namespace :v1 do
      resources :images, only: %i(index show create update destroy)
    end
  end
```

You can also specify an API version (the default is 1):

```console
$ rails g pragma:resource image -v 2
      create  app/resources/api/v2/image
      create  app/resources/api/v2/image/contract/base.rb
      create  app/resources/api/v2/image/contract/create.rb
      create  app/resources/api/v2/image/contract/update.rb
      create  app/resources/api/v2/image/decorator.rb
      create  app/resources/api/v2/image/operation/create.rb
      create  app/resources/api/v2/image/operation/destroy.rb
      create  app/resources/api/v2/image/operation/index.rb
      create  app/resources/api/v2/image/operation/show.rb
      create  app/resources/api/v2/image/operation/update.rb
      create  app/resources/api/v2/image/policy.rb
      create  app/controllers/api/v2/images_controller.rb
      create  spec/requests/api/v2/images_spec.rb
       route  namespace :api do
    namespace :v2 do
      resources :images, only: %i(index show create update destroy)
    end
  end

```

### Controllers

`Pragma::Rails::Controller` gives your controller the ability to run Pragma operations:

```ruby
module API
  module V1
    class ArticlesController < ApplicationController
      include Pragma::Rails::Controller

      def create
        run API::V1::Article::Operation::Create
      end
    end
  end
end
```

In the example above, `ArticlesController#create` will run the `API::V1::Article::Operation::Create`
operation and respond with the status code, headers and resource returned by the operation.

By default, the `#params` method will be used as the operation's parameters and `#current_user`, if
available, will be used as the operation's user. You can override these defaults by overriding the
`#operation_params` and `#operation_user` methods in your controller:

```ruby
module API
  module V1
    class ArticlesController < ApplicationController
      include Pragma::Rails::Controller

      def create
        run API::V1::Article::Operation::Create
      end

      private

      def operation_params
        params.merge(my_additional: 'param')
      end

      def operation_user
        User.authenticate_from params
      end
    end
  end
end
```

You may also define `#policy_context` to [pass additional context](https://github.com/pragmarb/pragma-policy#passing-additional-context) 
to your policies.

### Resource Controllers

Resource controllers (provided by the `Pragma::Rails::ResourceController` module) abstract even more 
of the logic behind your controllers by inferring the operations supported by a resource and 
automatically providing controller actions that run them.

With a resource controller, the example above could be rewritten as:

```ruby
module API
  module V1
    class ArticlesController < ApplicationController
      include Pragma::Rails::ResourceController

      private

      def operation_params
        params.merge(my_additional: 'param')
      end

      def operation_user
        User.authenticate_from params
      end
    end
  end
end
```

You will still have to define a route to your `#create` action, of course, but you don't have to
write the action anymore!

This works with any actions, not only the default CRUD actions defined by Rails. So, for instance, 
if you have an `API::V1::Article::Operation::Publish` operation, a `#publish` action will be 
accessible in the `API::V1::ArticlesController` controller.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pragmarb/pragma-rails.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
