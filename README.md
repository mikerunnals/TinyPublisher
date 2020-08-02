# TinyPublisher
A Tiny Stand-in that mimics some of Swift Combine API

Intent is to bridge a few useful concepts from Combine into codebases that cannot yet import Combine.
i.e. codebases still targeting iOS 12.x and below.

This Package intentially uses type names that collide with Swift Combine. The intent is that once a codebase can import Swift Combine, TinyPublisher will be remove.
Thus a goal of this Package is that there is little to no refactoring nessisary when swithcing to Swift Combine.

Testing: example code and unit tests will be maintained that tests the ablity of TinyPublisher Package to be swapped out for Swift Combine. 
How todo this? Atm copying all unit test and modifing to use Combine API.

[Documentation and Usage](TinyPublisher/README.md)

Examples Ideas: 

* App using TinyPublisher to implement dynamic Feature Flags

* Classic Username and Password example from [WWDC Combine in Practie](https://developer.apple.com/videos/play/wwdc2019/721/)

