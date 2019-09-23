# Spicerack

This collection of gems will spice up your rails and kick your rubies up a notch. Bam!

[![Gem Version](https://badge.fury.io/rb/spicerack.svg)](https://badge.fury.io/rb/spicerack)
[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

* [Installation](#installation)
* [Included Gems](#included-gems)
* [Development](#development)
* [Contributing](#contributing)
   * [Adding a New Spicerack Gem](#adding-a-new-spicerack-gem)
   * [Release](#release)
   * [Versions](#versions)
* [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "spicerack"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spicerack

## Included Gems

* [AroundTheWorld](around_the_world/README.md) allows you to easily wrap methods with custom logic on any class.
* [Collectible](collectible/README.md) provides an extensible framework for building array-like object collections.
* [Facet](facet/README.md) is a filterable, sortable, pageable, and Rails cacheable `ActiveRecord::Relation`.
* [RedisHash](redis_hash/README.md) provides a class that matches the Hash api by wrapping Redis.
* [RSpice](rspice/README.md) is an `RSpec` utility gem of custom matchers, shared contexts and examples.
* [ShortCircuIt](short_circu_it/README.md) is an intelligent and feature rich memoization gem.
* [Spicerack::Styleguide](spicerack-styleguide/README.md) is [Freshly](https://www.freshly.com/)'s Rubocop Styleguide for Rails and RSpec.
* [Technologic](technologic/README.md) is a logging system built on an extensible event triggering system requiring minimal implementation.
* [Tablesalt](tablesalt/README.md) is full of miscellaneous helper modules, POROs, and more, that standardize common behavior.
* [Stockpot](stockpot/README.md) makes setting up test data in your Rails database from an external location easier.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

This Open Source is supported by [Freshly](https://freshly.com), a company committed to quality code and delicious food.

We're basically [always hiring](https://jobs.lever.co/freshly).

Come join us in our New York City, Phoenix, or Minsk offices and write some awesome software!

Community support is always appreciated! Bug reports and pull requests are welcome on [GitHub](https://github.com/Freshly/spicerack).

### Adding a New Spicerack Gem

To add a new gem to the spicerack:

```
cd spicerack
bundle gem GEM
cd GEM
rm -rf .git
rm .travis.yml
rm .gitignore
rm Gemfile
chmod 0664 lib/GEM/version.rb
```

Here's a checklist of some other tasks (see another gem as reference):

⚠️ Reminder: Add the magic comment to the top of all the generated ruby files!

- Create a `CHANGELOG.md` and make the first entry
- Add to the [Included Gems](#included-gems) section
- Edit `lib/GEM/version.rb` to add the comment line
- Edit `README.md` to add badges, update development & contributor sections, generate ToC
- Copy over `GEM/Rakefile` from any other gem
- Remove the failing spec in `spec/GEM_spec.rb` and replace it with the rspice shared example
- Edit `spec/spec_helper.rb` to use the shared spec helper
- Remove the default error in `lib/GEM/GEM.rb`
- Edit `GEM.gemspec` and clean up the boilerplate

Then in the base directory:

- Edit `Rakefile` to add GEM to the `SPICERACK_GEMS` constant
- Add a require for your new gem into `lib/spicerack.rb`
- Add the new gem into `spicerack.gemspec`
- Increment the version in `SPICERACK_VERSION`
- Run `rake spicerack:update_all_versions` to the correct version

🚨 Don't forget to run `bundle` so the `Gemfile.lock` gets updated!!

Next, push the code up and open a new pull request.

Once that gets merged into master, run:

- Run `rake spicerack:release_all` to claim the new gem name with the empty build

### Release

💁‍ Please remember to keep all the `CHANGELOGS` up to date!

This is a monorepo which contains several gems designed to build and release together.

To perform release, set the new canonical version in the .4.4`SPICERACK_VERSION` file then run the task.

```ruby
echo "0.1.0" > SPICERACK_VERSION
rake spicerack:update_all_versions
git commit -am "Updating to version 0.1.0 for release"
rake spicerack:release_all
```

This will build and release all dependent gems at the same time.

Only the master branch should be released!

### Versions

Spicerack uses `Major.Minor.Patch` version control.

Versions should be increased according to the following rules:

- *Major Version* for non-backwards compatible changes.
- *Minor Version* for new gems or important features.
- *Patch Version* for bug fixes, enhancements, and optimizations.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
