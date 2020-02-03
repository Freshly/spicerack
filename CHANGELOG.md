# Changelog

## v0.22.2

*Release Date*: 1/28/2020

- Remove all references to `Spicerack::Configurable` except deprecation support

### Conjunction - [see changes](conjunction/CHANGELOG.md#v0222)

## v0.22.1 [Yanked]

*Release Date*: 1/28/2020

### Conjunction - [see changes](conjunction/CHANGELOG.md#v0221)

## v0.22.0

*Release Date*: 1/28/2020

- Deprecated `Spicerack::Configurable`, to be replaced by `Directive` ([#344](https://github.com/Freshly/spicerack/pull/344))

### Directive - [see changes](directive/CHANGELOG.md#v0220)
### Spicerack::Styleguide - [see changes](spicerack-styleguide/CHANGELOG.md#v0220)
### Technologic - [see changes](technologic/CHANGELOG.md#v0220)

## v0.21.0

*Release Date*: 1/10/2020

### Conjunction - [see changes](conjunction/CHANGELOG.md#v0210)
### Spicery - [see changes](spicery/CHANGELOG.md#v0210)

- Add `.to_h` method to AttributeObjects ([#326](https://github.com/Freshly/spicerack/pull/326))
- Improve failure message for `define_config_option` matcher ([#327](https://github.com/Freshly/spicerack/pull/327))
- Fix unintentionally committed `StatefulObject` ([#334](https://github.com/Freshly/spicerack/pull/334))
- Rename `StatefulObject` to `OutputObject` ([#335](https://github.com/Freshly/spicerack/pull/335))

## v0.20.4 [Yanked]

*Release Date*: 1/8/2020

## v0.20.3 [Yanked]

*Release Date*: 1/8/2020

## v0.20.2

*Release Date*: 1/6/2020

### Rspice - [see changes](rspice/CHANGELOG.md#v0202)

## v0.20.1 [Yanked]

*Release Date*: 1/6/2020

### Rspice - [see changes](rspice/CHANGELOG.md#v0201)

## 0.20.0.1

*Release Date*: 1/3/2020

- Add missing require statement

## 0.20.0

*Release Date*: 1/3/2020

- Add callback support to Configurable, add `configure` callback event ([#318](https://github.com/Freshly/spicerack/pull/318)), ([#320](https://github.com/Freshly/spicerack/pull/320)), ([#321](https://github.com/Freshly/spicerack/pull/321))

## v0.19.3

*Release Date*: 12/16/2019

- No code changes, just some documentation tweaks

## v0.19.2

*Release Date*: 12/2/2019

- Add `delegate_config_to` matcher ([#300](https://github.com/Freshly/spicerack/pull/300))

## v0.19.1

*Release Date*: 11/27/2019

### AroundTheWorld - [see changes](around_the_worrld/CHANGELOG.md#v0191)

- [BUGFIX] Fix a bug in `Spicerack` internals ([#294](https://github.com/Freshly/spicerack/pull/294))

## v0.19.0

*Release Date*: 11/20/2019

🚨 *Breaking Changes*: Some gem requirements were moved out of `Spicerack` and into `Spicery`.

This was intended to break a circular dependency for gems which require the utility objects in Spicerack but want to be included along for the ride.

From this version onwards, you should almost certainly be including the gem `spicery` rather than `spicerack` directly.

### Spicery - [see changes](spicery/CHANGELOG.md#v0190)

- Adds a forgotten feature to Configurable allowing nested configuration setting within a block ([#286](https://github.com/Freshly/spicerack/pull/286))

## v0.18.1

*Release Date*: 11/19/2019

- [BUGFIX] Fix a bug in `Configurable` ([#282](https://github.com/Freshly/spicerack/pull/282))

## v0.18.0

*Release Date*: 11/4/2019

### Conjunction - [see changes](conjunction/CHANGELOG.md#v0180)
### SpicerackStyleguide - [see changes](spicerack-styleguide/CHANGELOG.md#v0180)

## v.0.17.4

*Release Date*: 11/4/2019

- [BUGFIX] Fix a critical bug in Configurable introduced in 0.17.0 ([#268](https://github.com/Freshly/spicerack/pull/268))

## v0.17.3 [Yanked - Upgrade to >= 0.17.4]

*Release Date*: 10/28/2019

### Collectible - [see changes](collectible/CHANGELOG.md#v0173)

## v0.17.2 [Yanked - Upgrade to >= 0.17.4]

*Release Date*: 10/18/2019

### RSpice - [see changes](rspice/CHANGELOG.md#v0172)

## v0.17.1 [Yanked - Upgrade to >= 0.17.4]

*Release Date*: 10/14/2019

### Facet - [see changes](facet/CHANGELOG.md#v0171)

## v0.17.0 [Yanked - Upgrade to >= 0.17.4]

*Release Date*: 10/1/2019

### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v0170)

### Spicerack::Configurable v2 [#200](https://github.com/Freshly/spicerack/pull/200)
- Added `nested_config` functionality and spec helper
- Added `config_eval` for runtime config evaluation ([#206](https://github.com/Freshly/spicerack/pull/206))
- Added mutexes for thread safety ([#246](https://github.com/Freshly/spicerack/pull/246))
- Added `assign` method for multi-assignment ([#253](https://github.com/Freshly/spicerack/pull/253))


### Other Changes
- Fixed issue in `Spicerack::Objects::Defaults` when modules/classes are provided as default values ([#251](https://github.com/Freshly/spicerack/pull/251))

## v0.16.3

*Release Date*: 9/18/2019

- Loosened dependency requirements to allow for the Rails 6 suite

## v0.16.2

*Release Date*: 8/27/2019

### Facet - [see changes](facet/CHANGELOG.md#v0162)

## v0.16.1

*Release Date*: 8/27/2019

- Fix Facet dependency

## v0.16.0 [Yanked]

*Release Date*: 8/27/2019

### Facet - [see changes](facet/CHANGELOG.md#v0160)
### SpicerackStyleguide - [see changes](spicerack-styleguide/CHANGELOG.md#v0160)
### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v0160)

- Add rubocop to codeclimate [#225](https://github.com/Freshly/spicerack/pull/225)

## v0.15.2

*Release Date*: 8/15/2019

### SpicerackStyleguide - [see changes](spicerack-styleguide/CHANGELOG.md#v0152)

## v0.15.1

*Release Date*: 8/8/2019

### Collectible - [see changes](collectible/CHANGELOG.md#v0151)
### RedisHash - [see changes](redis_hash/CHANGELOG.md#v0151)
### Rspice - [see changes](rspice/CHANGELOG.md#v0151)
### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v0151)

## v0.15.0

*Release Date*: 8/8/2019

### Collectible - [see changes](collectible/CHANGELOG.md#v0150)
### Rspice - [see changes](rspice/CHANGELOG.md#v0150)

## v0.14.3

*Release Date*: 8/5/2019

### Rspice - [see changes](rspice/CHANGELOG.md#v0143)

## v0.14.2

*Release Date*: 6/26/2019

### Rspice - [see changes](rspice/CHANGELOG.md#v0142)
### Technologic - [see changes](technologic/CHANGELOG.md#v0142)

## v0.14.1

*Release Date*: 6/7/2019

### RedisHash - [see changes](redis_hash/CHANGELOG.md#v0141)

## v0.14.0

*Release Date*: 6/5/2019

### Spicerack

- Added `Configurable` module

## v0.13.5

*Release Date*: 6/5/2019

### Spicerack-Styleguide - [see changes](spicerack-styleguide/CHANGELOG.md#v0135)

## v0.13.4

*Release Date*: 6/5/2019

- Removed gemfiles and gemspecs from global Rubocop ignore
- Linted and updated all gemspecs

## v0.13.3

*Release Date*: 6/3/2019

### Spicerack-Styleguide - [see changes](spicerack-styleguide/CHANGELOG.md#v0133)

## v0.13.2

*Release Date*: 5/30/2019

### Spicerack

- Added `technologic/spec_helper` to `spec_helper`

### Technologic - [see changes](technologic/CHANGELOG.md#v0132)

## v0.13.1

*Release Date*: 5/29/2019

### Spicerack

- Added `.define_callbacks_with_handler` to `RootObject`

### Rspice - [see changes](rspice/CHANGELOG.md#v0131)

## v0.13.0

*Release Date*: 5/29/2019

### Spicerack

- Consolidated `RootObject` and abandoned gem
- Consolidated `Instructor` as `InputModel` and abandoned gem
- Consolidated `Ascriptor` as `AttributeObject` and abandoned gem
- Refactored `Instructor` to be based on `AttributeObject`
- Move `Tablesalt::Dsl::Defaults` to `Spicerack::Objects::Defaults`
- Refactored `Instructor` into a `InputObject` and `InputModel`

### Rspice - [see changes](rspice/CHANGELOG.md#v0130)
### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v0130)

## v0.12.0

*Release Date*: 5/28/2019

### RootObject [Consolidated]

- Claimed gem name

## v0.11.0

*Release Date*: 5/28/2019

### Ascriptor [Consolidated]

- Claimed gem name

## v0.10.2

*Release Date*: 5/28/2019

### Instructor [Consolidated]

- Move `Instructor::Defaults` to `Tablesalt::Dsl::Defaults`
- Refactor to replace string module with `Tablesalt::Dsl::Defaults`

### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v0102)

## v0.10.1

*Release Date*: 5/23/2019

### Spicerack

- Added `RedisModel` which is a fusion of `RedisHash` and `HashModel`

## v0.10.0

*Release Date*: 5/21/2019

### Spicerack

- Added `spec_helper` (which includes other spice's spec_helpers too)
- Move `ArrayIndex` to spicerack gem
- Allow `ArrayIndex` to update itself when its source array is modified
- Move `HashModel` to spicerack gem
- Fix `HashModel` naming collision with the `#hash` method (oopsie!)
- Added command `rake spicerack:yank_release[x.x.x]` for pruning

### Instructor [Consolidated]

- Move `StringableObject` to tablesalt gem
- Refactor to replace string module with `StringableObject`

### RedisHash - [see changes](redis_hash/CHANGELOG.md#v0100)
### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v0100)

## v0.9.6 [Yanked]

This was yanked as the API changed enough to justify a minor release instead.

*Release Date*: 5/21/2019

### Spicerack

- Added `spec_helper` (which includes other spice's spec_helpers too)
- Move `ArrayIndex` to spicerack gem
- Allow `ArrayIndex` to update itself when its source array is modified
- Move `HashModel` to spicerack gem
- Fix `HashModel` naming collision with the `#hash` method (oopsie!)

### Instructor [Consolidated]

- Move `StringableObject` to tablesalt gem
- Refactor to replace string module with `StringableObject`

### RedisHash - [see changes](redis_hash/CHANGELOG.md#v096) [Yanked]
### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v096) [Yanked]

## v0.9.5

*Release Date*: 5/20/2019

### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v095)

## v0.9.4 [Yanked]

*Release Date*: 5/20/2019

### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v094) [Yanked]

## v0.9.3 [Yanked]

*Release Date*: 5/17/2019

### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v093) [Yanked]

## v0.9.2

*Release Date*: 5/16/2019

### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v092)

## v0.9.1

*Release Date*: 5/16/2019

### RedisHash - [see changes](redis_hash/CHANGELOG.md#v091)

## v0.9.0

*Release Date*: 5/16/2019

### RedisHash - [see changes](redis_hash/CHANGELOG.md#v090)

## v0.8.4

*Release Date*: 5/15/2019

### Rspice - [see changes](rspice/CHANGELOG.md#v084)

## v0.8.3

*Release Date*: 5/12/2019

### Instructor [Consolidated]

- Adding missing test for Default::Value subclass
- Sharing an example useful to extension classes

## v0.8.2

*Release Date*: 5/12/2019

### Instructor [Consolidated]

- Initial implementation (copied out of `Freshly/flow`)

## v0.8.1

*Release Date*: 5/11/2019

### Spicerack

Renamed a gem and otherwise this is 0.8.0.

## v0.8.0

🙅‍ No Good. Yanked due to a name collision.

*Release Date*: 5/11/2019

### Instructor [Consolidated]

- Claimed gem name

### Tablesalt - [see changes](tablesalt/CHANGELOG.md#v080)

## v0.7.4

*Release Date*: 5/7/2019

### SpicerackStyleguide - [see changes](spicerack-styleguide/CHANGELOG.md#v074)

## v0.7.3

*Release Date*: 5/3/2019

### SpicerackStyleguide - [see changes](spicerack-styleguide/CHANGELOG.md#v073)

## v0.7.2

*Release Date*: 5/1/2019

### Rspice - [see changes](rspice/CHANGELOG.md#v072)

## v0.7.1

*Release Date*: 4/24/2019

### Rspice - [see changes](rspice/CHANGELOG.md#v071)

## v0.7.0

*Release Date*: 4/13/2019

### Callforth

- Claimed gem name (later abandoned)

## v0.6.4

*Release Date*: 4/11/2019

### Spicerack

- Updated `.codeclimate.yml` URL for spicerack-styleguide to point to `master`.

### Rspice - [see changes](rspice/CHANGELOG.md#v064)
### ShortCircuIt - [see changes](short_circu_it/CHANGELOG.md#v064)
### Technologic - [see changes](technologic/CHANGELOG.md#v064)

## v0.6.3

*Release Date*: 3/29/2019

### Rspice - [see changes](rspice/CHANGELOG.md#v063)

## v0.6.2

*Release Date*: 3/29/2019

### Rspice - [see changes](rspice/CHANGELOG.md#v062)

## v0.6.1

*Release Date*: 3/25/2019

### Technologic - [see changes](technologic/CHANGELOG.md#v061)

## v0.6.0

*Release Date*: 3/13/2019

### AroundTheWorld - [see changes](around_the_world/CHANGELOG.md#v060)
### ShortCircuIt - [see changes](short_circu_it/CHANGELOG.md#v060)

## v0.5.0

*Release Date*: 11/10/18

### AroundTheWorld - [see changes](around_the_world/CHANGELOG.md#v050)

## v0.2.5

*Release Date*: 10/3/18

### Spicerack

- Forgot to move require line. 5th times the charm! 🤩

## v0.2.4

*Release Date*: 10/3/18

🙅‍ No Good. Yanked due to a newly introduced bug.

### Spicerack

- Fixing new bug found in `v0.2.3` with faker for Spicerack. 💀

## v0.2.3

*Release Date*: 10/3/18

🙅‍ No Good. Yanked due to a newly uncovered bug.

### Spicerack

- Actual fix of the bug mentioned in `v0.2.1` and `v0.2.2`. 😰

## v0.2.2

*Release Date*: 10/3/18

🙅‍ No Good. Yanked due to the same bug.

### Spicerack

- Fix of the bug mentioned in `v0.2.1`. 😅

## v0.2.1

*Release Date*: 10/3/18

🙅‍ No Good. Yanked due to a bug.

### Spicerack

- Learning to gem is fun and rewarding. 🤩

## v0.2.0

*Release Date*: 10/1/18

### AroundTheWorld - [see changes](around_the_world/CHANGELOG.md#v020)
### Rspice - [see changes](rspice/CHANGELOG.md#v020)
### ShortCircuIt - [see changes](short_circu_it/CHANGELOG.md#v020)
### Technologic - [see changes](technologic/CHANGELOG.md#v020)

## v0.1.9

*Release Date*: 8/18/18

⚠️ Lots of crazy nonsense versions (like `0.0.0c` were pushed while trying to configure the repository).

- Setting up open source monorepo of releasable gems
- Establishing standards and stripping down boilerplate
