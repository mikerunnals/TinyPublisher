# EXPERIMENTAL 

# TinyPublisher
A Tiny Stand-in that mimics some of Swift Combine API

# Goal

So Application Developers who annot import Combine becuase they target iOS 10, 11 or 12 can:
  
  "...get started right away. Compose small parts of your application into custom Publishers, identify small pieces of logic you can break up into little tiny Publishers and use composition along the way to chain them all together.
You can totally adopt incrementally. You don't have to change everything right away or, you know, you can mix and match. We saw with Future how you can bring things in that you already have today. You can compose callbacks and other things using Future like we saw."

[Quote from Combine in Practice WWDC 2019](https://developer.apple.com/videos/play/wwdc2019/721/?time=2028)

This Package uses type names that collide with Swift Combine. 
The intent is that once a codebase can import Swift Combine, TinyPublisher will be remove!
Thus a goal of this Package is that **there is little to no refactoring necessary** when switching to Swift Combine.

Testing: unit tests will be maintained that test the ability of the TinyPublisher Package to be swapped out with Swift Combine. 
How todo this? So far copying all unit test and modifying to use Combine API.

[Documentation and Usage](TinyPublisher/README.md)

Examples Ideas: 

* App using TinyPublisher to implement dynamic Feature Flags

* Classic Username and Password example from [WWDC Combine in Practice](https://developer.apple.com/videos/play/wwdc2019/721/)

