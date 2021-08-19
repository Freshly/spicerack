# TableSalt

A package of helpers that introduce some conventions and convenience for common behaviors.

[![Gem Version](https://badge.fury.io/rb/tablesalt.svg)](https://badge.fury.io/rb/tablesalt)
[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/main/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tablesalt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tablesalt

## Usage

### ClassPass

TODO: write usage instructions

### DSLAccessor

TODO: write usage instructions

### Isolation

TODO: write usage instructions

### StringableObject

TODO: write usage instructions

### ThreadAccessor

In the simplest use case, a ThreadAccessor can be used to set a value on the current working thread to be used later on. The `thread_accessor` method creates a singleton and instance method for reading and writing a given variable stored on the thread.

#### Defined methods
* `thread_reader(method_name, thread_key = method_name, private: true)`
  Defines singleton method and instance method to read from the given thread key.
* `thread_writer(method_name, thread_key = method_name, private: true)`
  Defines singleton method and instance method to write to the given thread key.
* `thread_accessor(method_name, thread_key = method_name, private: true)`
  Calls `thread_reader` and `thread_writer` with the given arguments.
  
#### Example

```ruby
class CurrentUser
  include TableSalt::ThreadAccessor

  thread_accessor :current_user

  def self.set(user)
    self.current_user = user
  end
end

CurrentUser.set(User.first)

# then, sometime later within the same request:
CurrentUser.current_user
# => #<User id: 1>
```

#### Thread Safety
Yep, when you mess with thread variables, you need to think about thread safety. For Rack applications, `ThreadAccessor` ships with a Rack middleware component:
```ruby
# in config/initializers/rack.rb, or config/initializers/tablesalt.rb, or anywhere else in your boot path:
config.middleware.use TableSalt::ThreadAccessor::RackMiddleware
```

If your application isn't on Rack, you'll need to add a little more code manually to take care of this:
```ruby
# Somewhere in your request path:
class YourMiddleware
  def call
    ThreadAccessor.clean_thread_context { yield }
  end
end
```

#### Namespaces

Maybe you wrote a gem that, say, sets a current user value on the thread to enable some other cool behavior. Since you don't want your gem's behavior to interfere with other behavior of the application, you can use a namespaced thread store instead:
```ruby
module MyGem
  class CurrentUser
    # This isolates the module's thread store for your gem. 
    include Tablesalt::ThreadAccessor[MyGem]

    thread_accessor :current_user

    def self.set(user)
      self.current_user = user
    end
  end

  class DoAThing
    include Tablesalt::ThreadAccessor[MyGem]
    
    thread_accessor :current_user
  end
end

MyGem::CurrentUser.set(User.first)

# then, sometime later within the same request:
MyGem::DoAThing.current_user
# => #<User id: 1>

# From class defined above:
CurrentUser.current_user
# => nil
```

Note that this will require you to clear your gem's thread store manually. It is recommended you provide your own middleware with your gem to keep the application's thread stores clean:

```ruby
module MyGem
  class MyMiddleware
    def initialize(app)
      @app = app
    end

    def call(req)
      ThreadAccessor.clean_thread_context(namespace: MyGem) { @app.call(req) }
    end
  end
end
```

#### Test Helpers

Tablesalt's spec helper provides custom RSpec matchers for thread accessor methods:
* `defines_thread_accessor(name, thread_key, private: true, namespace: nil)`
* `defines_thread_reader(name, thread_key, private: true, namespace: nil)`
* `defines_thread_writer(name, thread_key, private: true, namespace: nil)`

If your application uses ThreadAccessor, you'll need to clear the thread stores between test runs. 
* **RSpec**
  If you're using RSpec, you're in luck! Just `require tablesalt/spec_helper` in `spec_helper.rb` or `rails_helper.rb`.
* **Minitest & others**
  If you're using Minitest or some other testing framework, you'll need to clear things out manually. This is pretty simple, just run the following after each test run:
  ```ruby
  Thread.current[Tablesalt::ThreadAccessor::THREAD_ACCESSOR_STORE_THREAD_KEY] = nil
  ```

### UsesHashForEquality

TODO: write usage instructions

## Development

Consult Spicerack's [development instructions](../README.md#development) for more info.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
