# Changelog

*Release Date*: 2019/11/21

### 0.1.1: 2019/11/25

* Moves all error into top level namespace definition file.
* Introduces a root class for all gem specific errors.
* Renames ObjectExt to an Eventable concern.
* Changes the aggressive extension of Object, forces a user to include the Eventable module only where necessary.
* Moves all rails specific logic into a Railtie, which is required only if in Rails universe.
* Adds more examples to yard documentation of the classes.
* Adds a TODO list based on the feedback.
* Grinds a huge GoogleCloud adapter method into smaller ones.
* Add two 'on/off' configuration options for Rails specific components.
* Switches to using rails specific delegate method where possible (in rails components extensions).

### 0.1.0: The Big Bang

* Rails controller and active job adapters
* Generic event method
* Handlers for GCP Pub/Sub and STDOUT
* Initial commit



