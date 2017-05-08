# Pragma on Rails

[![Build Status](https://img.shields.io/travis/pragmarb/pragma-rails.svg?maxAge=3600&style=flat-square)](https://travis-ci.org/pragmarb/pragma-rails)
[![Dependency Status](https://img.shields.io/gemnasium/pragmarb/pragma-rails.svg?maxAge=3600&style=flat-square)](https://gemnasium.com/github.com/pragmarb/pragma-rails)
[![Code Climate](https://img.shields.io/codeclimate/github/pragmarb/pragma-rails.svg?maxAge=3600&style=flat-square)](https://codeclimate.com/github/pragmarb/pragma-rails)
[![Coveralls](https://img.shields.io/coveralls/pragmarb/pragma-rails.svg?maxAge=3600&style=flat-square)](https://coveralls.io/github/pragmarb/pragma-rails)

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

## Generators

This gem provides a `pragma:resource` generator for creating a new resource with the default CRUD
operations:

```console
$ rails g pragma:resource article
      create  app/resources/api/v1/article
      create  app/resources/api/v1/article/contract/base.rb
      create  app/resources/api/v1/article/contract/create.rb
      create  app/resources/api/v1/article/contract/update.rb
      create  app/resources/api/v1/article/decorator.rb
      create  app/resources/api/v1/article/operation/create.rb
      create  app/resources/api/v1/article/operation/destroy.rb
      create  app/resources/api/v1/article/operation/index.rb
      create  app/resources/api/v1/article/operation/update.rb
      create  app/resources/api/v1/article/policy.rb
```

You can also specify an API version (the default is 1):

```console
$ rails g pragma:resource article -v 2
      create  app/resources/api/v2/article
      create  app/resources/api/v2/article/contract/base.rb
      create  app/resources/api/v2/article/contract/create.rb
      create  app/resources/api/v2/article/contract/update.rb
      create  app/resources/api/v2/article/decorator.rb
      create  app/resources/api/v2/article/operation/create.rb
      create  app/resources/api/v2/article/operation/destroy.rb
      create  app/resources/api/v2/article/operation/index.rb
      create  app/resources/api/v2/article/operation/update.rb
      create  app/resources/api/v2/article/policy.rb
```

## Controllers

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

## Resource Controllers

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
