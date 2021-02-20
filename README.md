# TinyPublisher

A Tiny Stand-in that mimics some of Swift Combine API

![TinyPublisher CI](https://github.com/mikerunnals/TinyPublisher/workflows/TinyPublisher%20CI/badge.svg)

## Why TinyPublisher?

So Application Developers who cannot import Combine because they target iOS 10, 11 or 12 can:
  
> ...get started right away. Compose small parts of your application into custom Publishers, identify small pieces of logic you can break up into little tiny Publishers and use composition along the way to chain them all together.
>
>You can totally adopt incrementally. You don't have to change everything right away or, you know, you can mix and match.
>
>[From Combine in Practice WWDC 2019](https://developer.apple.com/videos/play/wwdc2019/721/?time=2028)

This Package uses type names that collide with Swift Combine.
The intent is that once a codebase can import Swift Combine, TinyPublisher will be removed!

Thus a goal of this Package is that **there is little to no refactoring necessary** when switching to Swift Combine.

## Testing

Unit tests will be maintained that test the ability of the TinyPublisher Package to be swapped out with Swift Combine.

### How todo this?

So far copying all unit test and modifying to use Combine API.

[Documentation and Usage](TinyPublisher/README.md)

## Examples

### TODO

* App using TinyPublisher to implement dynamic Feature Flags

* Classic Username and Password example from [WWDC Combine in Practice](https://developer.apple.com/videos/play/wwdc2019/721/)

## Contributing to TinyPublisher

Contributions are welcome. Please see the [Contributing guidelines](CONTRIBUTING.md).

TinyPublisher has adopted a [code of conduct](CODE_OF_CONDUCT.md) defined by the [Contributor Covenant](http://contributor-covenant.org), the same used by the [Swift language](https://swift.org) and countless other open source software teams.
