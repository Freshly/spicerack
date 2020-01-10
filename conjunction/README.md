# Conjunction

Join together related concepts for a common purpose with Conjugation.

[![Gem Version](https://badge.fury.io/rb/conjunction.svg)](https://badge.fury.io/rb/conjunction)
[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

* [Installation](#installation)
* [QuickStart Guide](#quickstart-guide)
* [Gem Developer Usage](#gem-developer-usage)
   * [On the Separation of Concerns](#on-the-separation-of-concerns)
   * [Why does this exist?](#why-does-this-exist)
   * [How's it Function?](#hows-it-function)
   * [Digging In](#digging-in)
   * [On Naming Conventions](#on-naming-conventions)
      * [Backreference](#backreference)
      * [Bi-direction Cross-Reference](#bi-direction-cross-reference)
* [Configuration](#configuration)
   * [Explicit vs Override](#explicit-vs-override)
   * [Nexus](#nexus)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'conjunction'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install conjunction

## QuickStart Guide

Let's say you have an `Order`:

```ruby
class Order < ApplicationRecord
  def self.service_class
    OrderService
  end
end
```

Which descends from an `ApplicationRecord`:

```ruby
class ApplicationRecord
  def to_service
    self.class.service_class.new(self)
  end
end
```

And you have an `OrderService`:

```ruby
class OrderService < ApplicationService
  # ...software be here...
end
```

Which descends from an `ApplicationService`:
      
```ruby
class ApplicationService
  def initialize(object)
    @object = object
  end
end
```

Use `Conjunction` to tell your Records they can be related (called a Conjunctive):

```ruby
class ApplicationRecord < ActiveRecord::Base
  include Conjunction::Conjunctive
end
```

And your services that they are a kind of relation with a naming convention (called a Junction):

```ruby
class ApplicationService
  include Conjunction::Junction
  prefixed_with "Service"
end
```

Now your can look up related objects (like services) implicitly from your objects:

```ruby
class ApplicationRecord
  def to_service
    conjugate(ApplicationService)&.new(self)
  end
end
```

And remove all the implicit boilerplate which could be assumed:

```ruby
class Order < ApplicationRecord; end

Order.conjugate(ApplicationService) # => OrderService
```

And then in the future, any new objects you create which follow convention "just work":

```ruby
class Foo < ApplicationRecord; end
class FooService < ApplicationService; end

Foo.conjugate(ApplicationService) # => FooService
```

You can also quickly an easily configure relationships explicitly, either directly:

```ruby
class Foo < ApplicationRecord
  conjoins BarService
end

Foo.conjugate(ApplicationService) # => BarService
```

Or through a central routing file called a `Nexus`:

```ruby
# config/initializers/conjunction_nexus.rb
class Conjunction::Nexus
  couple Foo, to: GazService
end

Foo.conjugate(ApplicationService) # => GazService
```

You may also be interested in reading through the [Configuration](#configuration) docs.

## Gem Developer Usage

🚨 **Note**: This is a middleware gem designed to help gem developers or folks with lots of custom DSL objects build them in a cleaner and more standardized way. It is **NOT** expected that most application developers will need to be aware of this gem's existence or configuration!

### On the Separation of Concerns

Consider the following:

```ruby
class User < ApplicationRecord
  validates :first_name, :last_name, length: { minimum: 2 }, presence: true
  
  def initials
    "#{first_name.chr}#{last_name.chr}"
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  # conventional name in application for displaying in subjects in views
  def display_name
    name
  end
  
  # name used when this user sends emails to others on platforms
  def email_from_name
    name
  end  
  
  # name used when addressing this user in emails (obviously...)
  def email_to_name
    first_name
  end
  
  # vestigial code used in the legacy half of the app... smh
  def nickname
    last_name
  end
end
```

This object has very poor [Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns); it obligates much of the application while providing little value at the cost of extraneous code.

```ruby
class User < ApplicationRecord
  include PersonNameable
  include NamedPresentable
  include NamedPersonEmailAddressable
  
  # vestigial code used in the legacy half of the app... smh
  def nickname
    last_name
  end
end
```

This kinda looks nicer. Until you look at the consequential under-the-hood code:

```ruby
module PersonNameable
  extend ActiveSupport::Concern
  
  included do 
    validates :first_name, :last_name, length: { minimum: 2 }, presence: true
  end
  
  def initials
    "#{first_name.chr}#{last_name.chr}"
  end

  def name
    "#{first_name} #{last_name}"
  end
end

module NamedPresentable
  extend ActiveSupport::Concern
  
  # conventional name in application for displaying in subjects in views, assume name
  def display_name
    name
  end
end

module NamedPersonEmailAddressable
  extend ActiveSupport::Concern
  
  # name used when this user sends emails to others on platforms
  def email_from_name
    name
  end  
  
  # name used when addressing this user in emails (obviously...)
  def email_to_name
    first_name
  end
end
```

And recognize that `user.email_to_name` is still a valid method. This object STILL has very poor `Separation of Concerns` but in this form also suffers from a much higher [Connascence](https://en.wikipedia.org/wiki/Connascence)! OH NO! 😭

⭐️ That's because **Separation of Concerns** applies to your object architecture *NOT* your file system!

An object architecture with properly separated concerns would look more like this:

```ruby
class User
  validates :first_name, :last_name, length: { minimum: 2 }, presence: true
  
  def initials
    "#{first_name.chr}#{last_name.chr}"
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  # vestigial code used in the legacy half of the app... smh
  def nickname
    last_name
  end
end
```

```ruby
class UserPresenter
  def initialize(user)
    @user = user
  end
  
  def display_name
    user.name
  end
end

class UserEmailSender
  def initialize(user)
    @user = user
  end
  
  def from_name
    user.name
  end
end

class UserEmailRecipient
  def initialize(user)
    @user = user
  end
  
  def to_name
    user.first_name
  end
end
```

Now, the `User` object has no need to know about email sending or receiving, nor whatever naming standards the application has adopted around presenting objects to users.

This is a nominal pattern adopted by several gems in the rails ecosystem: [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers/tree/0-10-stable), [Draper](https://github.com/drapergem/draper), [Pundit](https://github.com/varvet/pundit) to name a few.

Enter `Conjunction`, a gem for managing the coupling of properly separated object concerns.

### Why does this exist?

Let's imagine we're building a standardized presenter gem for displaying models:

```ruby
class ApplicationPresenter
  def initialize(model)
    @model = model
  end
  
  def name
    I18n.t("unknown")
  end
end
```

And we want to create a specialized class for displaying a specific model:

```ruby
class UserPresenter < ApplicationPresenter
  def name
    I18n.t("format_greetings.#{user.greeting_type}", user.name)
  end
end
```

So the first question is how a `User` know about it's presenter.

One option is direct reference:

```ruby
class User < ApplicationRecord
  def to_presenter
    UserPresenter.new(self)
  end
end
```

This leverages `Connascence of Name (CoN)` which is the weakest (and therefore most ideal) reference.

And this solution is nice, but it gets kind of messy at scale:

```ruby
class User < ApplicationRecord
  def to_presenter
    UserPresenter.new(self)
  end
  
  def to_serializer
    UserSerializer.new(self)
  end
  
  def to_policy
    UserPolicy.new(self)
  end
end
```

Especially when you add in the complexity of class AND/OR instance reference:

```ruby
class User < ApplicationRecord
  class << self
    def to_presenter
      UserList.new
    end
    
    def to_policy
      UserPolicy.new
    end
  end
  
  def to_presenter
    UserPresenter.new(self)
  end
  
  def to_serializer
    UserSerializer.new(self)
  end
  
  def to_policy
    UserPolicy.new(self)
  end
end
```

For just three related objects we're at 20 lines of code added to potentially `N` models in the ecosystem.

This also creates other problems, such as dissimilarity in reference, a model without a presenter will not define a `to_presenter` method, so generic code:

```ruby
model.to_presenter # => raise NoMethodError ?!
```

To get around this, you now need to put some kind of generic handling in the base object:

```ruby
class ApplicationRecord
  class << self
    def to_presenter
      nil
    end
    
    def to_policy
      raise "all records must have a policy"
    end
  end
  
  def to_presenter
    null
  end
  
  def to_serializer
    raise "all records must have a serializer"
  end
  
  def to_policy
    raise "all records must have a policy"
  end
end
```

This also obviously isn't a possibility if you are writing a third party gem to introduce a "kind" of object into the system, and the example gems have all solved this problem differently:

`ActiveModelSerializers` conjured up the [LookupChain](https://github.com/rails-api/active_model_serializers/blob/0-10-stable/lib/active_model_serializers/lookup_chain.rb), `Draper` went the concern route with [decoratable](https://github.com/drapergem/draper/blob/master/lib/draper/decoratable.rb) and `Pundit` evolved the [PolicyFinder](https://github.com/varvet/pundit/blob/master/lib/pundit/policy_finder.rb).

All these are very disparate and feature-rich implementations of a solution to the problem. All of them offering at least some configurability to control how the lookup occurred to translate the kind of "root" model object into its related SoC object.

So ultimately, `Conjunction` exists because I thought it would be nice to create a generic solution to this object reference problem that can be utilized by other gems to create some kind of standardization and consistency to this hard problem.

It also selfishly helps cleanup a lot of duplicate code across several co-developed gems which I will shamelessly plug here: [Command](https://github.com/Freshly/command), [Facet](https://github.com/Freshly/spicerack/tree/develop/facet), [Flow](https://github.com/Freshly/flow), [Law](https://github.com/Freshly/law), [Material](https://github.com/Freshly/material).

### How's it Function?

In `Conjunction` there are two distinct concepts: **Prototypes** and **Conjugates**.

A **Prototype** is unitary (named without a prefix or suffix) and represents the core object around which concerns are being separated, in the above example `User`.

A **Conjugate** is the `SoC` object which encapsulates the other behaviors or information, in the above example `UserPresenter`; named after the linguistic process that gives the different forms of an verb as they vary according to voice, mood, tense, etc. 

Generally speaking, the community assumption peddled by the ActiveModelSerializers, Drapers, and Pundits of the world seems to be a suffixed naming convention; `AuthorSerializer` for an `Author` class, `ArticleDecorator` for an `Article` class, `UserPolicy` for a `User` class.

`Conjunction` defines a `.conjugate` **Prototypes** class method to allow the lookup of **Conjugate** objects given their base classes:

```ruby
Author.conjugate(ApplicationSerializer) # => AuthorSerializer
Article.conjugate(ApplicationDecorator) # => ArticleDecorator
User.conjugate(ApplicationPolicy)       # => UserPolicy
```

### Digging In

`Conjunction` leverages two main concerns: **Conjunctives** and **Junctions**.

A **Conjunctive** is the generic base class from which your **Prototype** descends, in the above example `ApplicationRecord` is the **Conjunctive** for the `User` **Prototype**.

```ruby
class ApplicationRecord
  include Conjunction::Conjunctive
end
```

This grants `ApplicationRecord` the ability to represent itself as a **Prototype**, the primary requirement of which is to define a `.prototype_name` method (which by default is simply the class name):

```ruby
User.prototype_name # => User
User.first.prototype_name # => User
```

A **Junction** is the generic base class from which any **Conjugate** object descends, in the above example `ApplicationPresenter` is the **Junction** for the `UserPresenter` **Conjugate**.

```ruby
class ApplicationPresenter
  include Conjunction::Junction
end
```

This grants `ApplicationPresenter` the ability to reference a **Prototype** and find a related **Conjugate**; also it allows you to write `Conjunction::Junction` and commit it into a production application for serious, which is a total bonus feature 🤩.

The primary requirement of a `Junction` is to define a `.junction_key` which should be unique among your `SoC` objects. 

🚨 **WARNING**: By default, your Junctions **WILL NOT** define a junction key!

You can explicitly define a junction key:

```ruby
class ApplicationPresenter
  include Conjunction::Junction
  
  class << self
    def junction_key
      :any_key_u_want
    end
  end
end
```
😽‍ *Super Lazy??*: Good News, so am I! There are default junction keys!

### On Naming Conventions

Given the community standard of `FooBarThing` naming convention for `Things`, there is an assumption that most applications will attempt to keep a minimal `Connascence of Name (CoN)` approach; usually for any given `FooBar` you would expect it's `Thing` to be a `FooBarThing`.

You can **and should** define your expected naming convention on your Junctions:

```ruby
class ApplicationPresenter
  include Conjunction::Junction
  suffixed_with "Presenter"
end
```

This now gives the `Presenter` junction enough information to know that it's naming convention is `#{prototype_name}Presenter`. It also provides enough unique identifying information to assume the `junction_key` as an underscored version of the suffix:

```ruby
ApplicationPresenter.junction_key # => presenter
```

You can also use `suffixed_with` if you want to do namespaces instead, ex:

```ruby
class ApplicationFleeb
  include Conjunction::Junction
  suffixed_with "Grundus::Fleeb::"
end
```

This now assumes that a `Foo` prototype will have a `Grundus::Fleeb::Foo` conjugate.

💁‍ *Note*: You can use both a `suffix` and `prefix` together; the junction key will be `#{suffix}_#{prefix}`.

You can also override the default by setting it to a blank string in a descendant class:

```ruby
class PresenterBase
  include Conjunction::Junction
  suffixed_with "Presenter"
end

class ApplicationPresenter < Base::Presenter
  suffixed_with ""
  prefixed_with "Presenter::"
end
```

#### Backreference

Naming Conventions are necessary to facilitate "best guess lookup" and therefore if a Conjugate name can be intuited by the naming convention, a Prototype name can be distilled from it:

```ruby
UserPresenter.prototype_class # => User
Grundus::Fleeb::User.prototype_class # => User
```

This allows valuable class level introspection into relationships which can be quickly and easily put under test:

```ruby
RSpec.describe User do 
  it { is_expected.to conjugate_into UserPresenter }
  it { is_expected.to conjugate_into Grundus::Fleeb::User }
end
```

From either side of the equation (ideally, both!):

```ruby
RSpec.describe UserPresenter do 
  it { is_expected.to be_conjugated_from User }
end
```

```ruby
RSpec.describe Grundus::Fleeb::User do 
  it { is_expected.to be_conjugated_from User }
end
```

#### Bi-direction Cross-Reference

An even more interesting side-effect of backreference in the nominal case is Bi-direction Cross-Reference. Two Junctions which are conjugates of a given prototype can be directly conjugated into each other!

```ruby
UserPresenter.conjugate(ApplicationFleeb) # => Grundus::Fleeb::User
Grundus::Fleeb::User.conjugate(ApplicationPresenter) # => UserPresenter
```

What's *really* interesting is that you don't even *need* a user class to really exist for this kind of behavior to manifest! The above snippet works even when `defined?(User) == false`!!

## Configuration

`Conjunction` expects that a well-thought-out (or at least standardized) naming convention can get you a long way, but given software is hard there must be some mechanism for overrides. 

So it might surprise you to find that no mechanism has been exposed to override `Conjunction`! 

It will *always* run in implicit lookup mode where it attempts to use the naming convention of objects as it understands them to intuit the coupling relationships of your application. 

It *can* be configured **NOT** to perform implicit lookup at all if you hate the idea of magic names "just working":

```ruby
# config/initializers/conjunction.rb
Conjunction.configure do |config|
  config.disable_all_implicit_lookup = true
end
```

### Explicit vs Override

Instead of overriding implicit lookup, you can simply explicitly define conjunctions.

To directly tell any Conjunctive how it is related to its conjugates, use `.conjoins`:

```ruby
class User < ApplicationRecord
  conjoins UserPresenter
  conjoins Grundus::Fleeb::User
  conjoins UserPolicy
end
```

⚠️ **WARNING**: You can only provide objects which are valid `Conjunction::Junctions` to the `.conjoins` method; any object without a valid `junction_key` will raise an exception.

It is this explicit reference mechanism that exists for you to "override" the default coupling rules of your application: 

```ruby
class User < ApplicationRecord
  conjoins GenericPresenter
  conjoins Grundus::Fleeb::Dinglebop
  conjoins AdminOnlyEditOpenViewPolicy
end
```

This has the direct and immediate effect of altering what conjugates are returned:

```ruby
User.conjugate(ApplicationPresenter) # => GenericPresenter
User.conjugate(ApplicationFleeb) # => Grundus::Fleeb::Dinglebop
User.conjugate(ApplicationPolicy) # => AdminOnlyEditOpenViewPolicy
```

This is true EVEN IF you have valid naming-convention-assumed objects that exist. For example, even if there was a `UserPresenter` the immediate example above would return a `GenericPresenter`. This can best be seen in this example:

```ruby
User.conjugate(UserPresenter) # => GenericPresenter
```

Even giving the object what you assume the destination presenter would be, it's conjugate follows the explicit naming rules!

💁‍ **Note**: You can use `.conjoins` only when you need to override the otherwise "default" implicit naming conventions. This "explicit as override" methodology is the recommended way to use `Conjunction`, as it calls attention to "what's different" while letting normal "ust work". It also prevents you from having to define an object AND remember to relate it.

```ruby
class User < ApplicationRecord
  conjoins AdminOnlyEditOpenViewPolicy
end
```

Given an expected presence of other objects, this would work as follows:

```ruby
User.conjugate(ApplicationPresenter) # => UserPresenter
User.conjugate(ApplicationFleeb) # => Grundus::Fleeb::User
User.conjugate(ApplicationPolicy) # => AdminOnlyEditOpenViewPolicy
```

### Nexus

In what is arguably the coolest class name I've ever written, you can define a central routing nexus which acts as a central source of truth for all the object relationships in your application.

Create a `config/initializers/conjunction_nexus.rb` file like so:

```ruby
class Conjunction::Nexus
  couple Foo, to: CommonMaterial
  couple Bar, to: CommonMaterial

  couple FooFlow, to: FooState, bidirectional: true
end
```

The `bidirectional: true` flag above is the DRY form of this equivalent assignment:

```ruby
class Conjunction::Nexus
  couple FooFlow, to: FooState
  couple FooState, to: FooFlow
end
```

The `Nexus` file is a "best of both worlds" approach if you want to keep your models (conjunctives) limited in what they outwardly need to know about their other conjunctive forms without bloating each model individually.

💁‍ **Note**: If you make use of the nexus file and want to enforce explicit lookup behavior in your application, there is a special configuration option to disable implicit lookup for any classes which are defined within the nexus using the `nexus_use_disables_implicit_lookup` flag:

```ruby
# config/initializers/conjunction.rb
Conjunction.configure do |config|
  config.nexus_use_disables_implicit_lookup = true
end
```

Now, if you define something within the nexus for any given type of junction, ALL junctions need to follow suite:

```ruby
# Given `FooPresenter`, `BarPresenter`, `Foo`, and `Bar`:
class Conjunction::Nexus
  couple Foo, to: FooPresenter
end 

# With `nexus_use_disables_implicit_lookup` false:
Foo.conjoins(ApplicationPresenter) # => FooPresenter
Bar.conjoins(ApplicationPresenter) # => BarPresenter

# With `nexus_use_disables_implicit_lookup` true:
Foo.conjoins(ApplicationPresenter) # => FooPresenter
Bar.conjoins(ApplicationPresenter) # => nil
```

💁‍ **Note**: Nexus configuration is a "kind" of explicit configuration and shouldn't be mixed with conflicting information on the object itself:

```ruby
class Conjunction::Nexus
  couple Foo, to: FooPresenter
end 

class Foo < ApplicationRecord
  conjoins BarPresenter
end
```

In the above example, `Foo.conjoins(ApplicationPresenter)` would be `BarPresenter` as the configuration closest to the object takes precedence, but this is a really weird and not very expected behavior that is left intact "in-case you really need it". 

The overall recommendation here is to "pick a horse" and either use a Nexus file OR use explicit object level definitions for overrides.

## Development

Consult Spicerack's [development instructions](../README.md#development) for more info.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
