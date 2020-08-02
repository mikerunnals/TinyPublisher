
/// As closely as possible this file should contain
/// the Combine protocols unchanged to use in absentia

import Foundation

public protocol Cancellable {
    func cancel()
}

protocol CustomCombineIdentifierConvertible {
    var combineIdentifier: CombineIdentifier { get }
}

protocol Subscription : Cancellable, CustomCombineIdentifierConvertible {}

public protocol Subscriber {
    associatedtype Input
    associatedtype Failure
}

public protocol Publisher {
    associatedtype Output
    associatedtype Failure //: Error TODO
    
    func subscribe<S: Subscriber>(_ subscriber:S) where S.Input == Output, S.Failure == Failure
}

public protocol Subject: Publisher, AnyObject {
    func send(_ value: Output)
}
