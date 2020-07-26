# TinyPublisher
A Tiny Stand-in that mimics some of Swift Combine's Publish API

The intent of this Package be a temporary bridge used to bring a few useful concepts from Combine into codebases that cannot yet import Combine.
e.g. codebases still targeting iOS 12.x and below.

This Package intentially uses type names that colide with Swift Combine. The intent is that once a codebase can import Swift Combine, TinyPublisher will be remove.
Thus a goal of this Package is that there is little to no refactoring nessisary when swithcing to Swift Combine.

Testing: example code unit test will be maintained that tests the ablity of TinyPublisher to be swapped out for Swift Combine. How todo this?

Examples: 

Idea: an example app using TinyPublisher to implement dynamic Feature Flags.

