# Stockpot

`Stockpot` makes setting up test data in your Rails database from an external resource easier.

`Stockpot` gives you an easy way to expose a number of end points from your app, enabling CRUD actions that you can utilize from things like a standalone test suite to set up state. (think: Cypress, Cucumber, etc.) For instance, rather than going through the entirety of a new user creation flow just to check that users can update their data once registered, simply make a POST call to `/stockpot/database_management` with your dummy user's data, shortcutting that unnecessary setup and enabling you to go to directly checking the system behavior needed.

Why the name `stockpot`? Keeping with Freshly's food related naming, a [stockpot](https://en.wikipedia.org/wiki/Stock_pot) is one of the most common types of cooking pots worldwide, and a stockpot is traditionally use to make stock or broth which can be the basis for cooking more complex recipes. You put ingredients in, do some cooking, and take out a finished product. For this project, think of your database as being the stockpot, putting in test data, doing some action in the system under test, and then pulling out data to use in your assertions of your system's behavior.

[![Gem Version](https://badge.fury.io/rb/rspice.svg)](https://badge.fury.io/rb/rspice)
[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
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
gem 'stockpot'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install stockpot
```

## Usage

TODO: Write usage instructions here

## Development

See Spicerack development instructions [here](https://github.com/Freshly/spicerack/blob/develop/README.md#development).

## Contributing

See Spicerack contribution instructions [here](https://github.com/Freshly/spicerack/blob/develop/README.md#contributing).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
