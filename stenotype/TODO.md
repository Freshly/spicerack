# Stenotype TODO list

 - [x] Figure out how to pass context to data publisher. **Context is passed explicitly**
 - [x] Switch from synchronous to asynchronous message publishing. **A config option for this is available**
 - [x] Figure out how to unwind from using a specific framework (e.g Rails), but rather implement events in a general way suitable for plain ruby classes. **Event emitters inject in dynamic way based on what framework the gem is being used in.**
 - [x] Infer data in extensible way. Given a common context implement context handlers capable of fetching data for specific cases (Controller, ActiveJobs, Models, etc.). **Context handlers are introduced. New handlers might be implemented and registered easily**
 - [x] Figure out the most common default context handlers (Controller, something else). **Controller, ActiveJob and Plain ruby classes are the case now**
 - [x] Develop an extensible schema for formatting the messages. **A serializer is introduced**
 - [x] Cover the existing code with specs. **Coverage increased to 100%**
 - [ ] Consider using batch publishing in case the load is high (how do we measure this, perhaps rpm?)
 - [ ] Consider using JSON schema to validate the input for publisher
 - [ ] Consider enabling an option to publish to multiple topics. Do we need to publish to multiple topics?
 - [ ] Consider adding state to message dispatcher and instantiate it on every event
 - [ ] Consider using `::ActiveJob::Base.around_perform` or `::ActiveJob::Base.around_enqueue` in case we need to track all jobs.
 - [ ] Figure out the params for plain ruby class context handler.
 - [ ] Consider `ContextHandlers::ActiveJob` params. How to deal with \_args? It won't necessarily respond to `#as_json`.
 - [ ] Consider a way to switch from evaluating ruby code to using plain modules extension.

Feedback TODO:

 - [x] Move all exceptions into root module Stenotype. **Moved exceptions into root module**
 - [x] Inherit gem specific error from a root error object specific for the gem. **All gem specific error inherit from Stenotype::Errors**
 - [x] Inherit the root error from standard error. **Stenotype::Errors inherits from StandardError**
 - [x] Utilize concerns and allow gem users to extend the code they need with a concern rather than aggressively extend Object. **Added an Stenotype::Emitter module instead of aggressively including it into Object**
 - [x] Use Railtie to introduce rails specific logic instead of checking whether Rails is defined in the root module. **Added a Railtie, active only in Rails world**
 - [?] Use delegation instead of defining tiny methods. Do not forget about Demeter's. **Rails `delegate` method is used in Rails specific extensions. Otherwise simple methods are used**
 - [x] Add more examples to yard documentation, consider collecting README.md from the yard doc. **Covered most of the classes/modules with yard examples**
 - [x] Enable on-off triggers in the configuration to  enable/disable framework specific features. Like whether  we want to extend ActiveJob or not. **Added two configuration options for currently implemented Rails extensions**
 - [x] Memoization! **Not actually needed**
 - [ ] Consider potential double wrapping in the meta-programming stuff. Take a look at around-the-world and consider switching to using it.
 - [ ] Utilize input objects for attr_readers (what was the name of the tool?)
 - [ ] Consider configurable for configuration instead of implementing custom configuration object
 - [ ] Consider using collectible gem to handle collection of context handlers
 - [ ] Consider naming (e.g. #as_json => #to_h), try to be more  specific to not pollute the namespace or introduce any ambiguity.
 - [ ] Remove freshly mentions from the gem.
