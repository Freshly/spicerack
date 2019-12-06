# Stenotype

This gem is a tool providing extensions to several rails components in order to track events along with the execution context. Currently ActionController and ActionJob are supported to name a few.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "Stenotype"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install Stenotype

## Usage

### Configuration

Configuring the library is as simple as:
```ruby
Stenotype.configure do |config|
  config.targets = [ # Supported targets
    Stenotype::Adapters::StdoutAdapter.new,
    Stenotype::Adapters::GoogleCloud.new
  ]

  config.uuid_generator = SecureRandom
  config.dispatcher     = Stenotype::Dispatcher.new
  config.gc_project_id  = "google_cloud_project_id"
  config.gc_credentials = "path_to_key_json"
  config.gc_topic       = "google_cloud_topic"
  config.gc_mode        = :async # either :sync or :async
end
```

#### config.targets

Contain an array of targets for the events to be published to. Targets must implement method `#publish(event_data, **additional_arguments)`.

#### config.uuid_generator

An object that must implement method `#uuid`. Used when an event is emitted to generate a unique id for each event.

#### config.dispatcher

Dispatcher used to dispatch the event. A dispatcher must implement method `#publish(even, serializer: Stenotype::EventSerializer)`. By default `Stenotype::EventSerializer` is used, which is responsible for collecting the data from the event and evaluation context.

#### config.gc_project_id

Google cloud project ID. Please refer to Google Cloud management console to get one.

#### config.gc_credentials

Google cloud credentials. Might be obtained from Google Cloud management console.

#### config.gc_topic

Google Cloud topic used for publishing the events.

#### config.gc_mode

Google Cloud publish mode. Two options are available: `:sync, :async`. When in `sync` mode the event will be published in the same thread (which might influence performance). For `async` mode the event will be put into a pull which is going to be flushed after a threshold is met.

#### Configuring context handlers

Each event is emitted in a context which might be an ActionController instance or an ActiveJob instance or potentially any other place. Context handlers are implemented as plain ruby classes, so before using them you must register them. By default a plain `Class` handler is registered when not used with any framework. In case Ruby on Rails is used, then there are two additional context handlers for `ActionController` and `ActiveJob` instances.

### Emitting Events

Emitting an event is as simple as:
```ruby
Stenotype::Event.emit!(
    data,
    options: additional_options,
    eval_context: { name_of_registered_context_handler: context_object }
)
```

The event is then going to be passed to a dispatcher responsible for sending the evens to targets. Note that a context handler must be registered before using it. See [Custom context handlers](#custom-context-handlers) for more details.

#### ActionController

Upon loading the library `ActionController` is going to be extended with a class method `track_view(*actions)`, where `actions` is a list of trackable controller actions.

Here is an example usage:

```ruby
class MyController < ActionController::Base
  track_view :index, :show

  def index
    # do_something
  end

  def show
    # do something
  end
end
```

#### ActiveJob

Upon loading the library `ActiveJob` is going to be extended with a class method `trackable_job!`.

Example:
```ruby
class MyJob < ActiveJob::Base
  trackable_job!

  def perform(data)
    # do_something
  end
end
```

#### Plain Ruby classes

To track methods from arbitrary ruby classes `Object` is extended. Any instance method of a Ruby class might be prepended with sending an event:
```ruby
class PlainRubyClass
  emit_event_before :some_method, :another_method
  emit_klass_event_before :class_method

  def some_method(data)
    # do something
  end

  def another_method(args)
    # do something
  end

  def self.class_method
    # do something
  end
end
```

You could also use a generic method `emit_event` from anywhere. The method is mixed into `Object` class. It takes several optional kw arguments. `data` is a hash which is going to be serialized and sent as event data, `method` is by default the method you trigger `emit_event` from. `eval_context` is a hash containing the name of context handler and a context object itself.

An example usage is as follows (see [Custom context handlers](#custom-context-handlers) for more details.):
```ruby
# BaseClass sets some state
class BaseClass
  attr_reader :local_state

  def initialize
    @local_state = "some state"
  end
end

# A custom handler is introduced
class CustomHandler < Stenotype::ContextHandlers::Base
  self.handler_name = :overriden_handler

  def as_json(*_args)
    {
      state: context.local_state
    }
  end
end

Stenotype::ContextHandlers.register CustomHandler

# Event is being emitted twice. First time with default options.
# Second time with overriden method name and eval_context.
class PlainRubyClass < BaseClass
  def some_method(data)
    event_data = collect_some_data_as_a_hash
    emit_event(event_data) # method name will be `some_method`, eval_context: { klass: self }
    other_event_data = do_something_else
    emit_event(other_event_data, method: :custom_method_name, eval_context: { overriden_handler: self })
  end
end
```

### Adding customizations

#### Custom adapters
By default two adapters are implemented: Google Cloud and simple Stdout adapter.

Adding a new one might be performed by defining a class inheriting from `Stenotype::Adapters::Base`:
```ruby
class CustomAdapter < Stenotype::Adapters::Base
  # A client might be optionally passed to
  # the constructor.
  #
  # def initialize(client: nil)
  #   @client = client
  # end

  def publish(event_data, **additional_arguments)
    # custom publishing logic
  end
end
```

After defining a custom adapter it must be added to the list of adapters:
```ruby
Stenotype.config.targets.push(CustomAdapter.new)
```

#### Custom context handlers

A list of context handlers might be extended by defining a class inheriting from `Stenotype::ContextHandlers::Base` and registering a new context handler. Event handler must have a `self.handler_name` in order to use it during context serialization. Also custom handler must implement method `#as_json`:
```ruby
class CustomHandler < Stenotype::ContextHandlers::Base
  self.handler_name = :custom_handler_name

  def as_json(*_args)
    {
      something: something,
      another: another
    }
  end

  private

  def something_from_context
    context.something
  end

  def another_from_context
    context.another
  end
end
```

After defining a new context handler you must register it as follows:
```ruby
Stenotype::ContextHandlers.register CustomHandler
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/Stenotype.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
