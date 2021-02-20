# The Magic Here

To support the TinyPublisher Package having two test targets: `SwiftCombineTests` the runs all the unit tests against Swift Combine, and `TinyPublisherTests` that runs unit tests with TinyPublisher...

The magic here is that the `SwiftCombineTests` directory is just a symbolic link to the `TinyPublisherTests` directory, i.e,

> :$ ls -l SwiftCombineTests
>
> lrwxr-xr-x  1 user  group  18 Feb 20 06:59 SwiftCombineTests -> TinyPublisherTests

It was created with a command like:

> :$ ln -s TinyPublisherTests SwiftCombineTests
