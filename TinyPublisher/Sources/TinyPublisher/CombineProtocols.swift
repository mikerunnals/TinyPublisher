
/// As closely as possible this file should contain
/// the Combine protocols unchanged to use in absentia

import Foundation

public protocol Cancellable {
    func cancel()
}

public protocol CustomCombineIdentifierConvertible {
    var combineIdentifier: CombineIdentifier { get }
}

public protocol Subscription : Cancellable, CustomCombineIdentifierConvertible {}

public enum Subscribers {
    @frozen public struct Demand : Equatable {
        static let unlimited = Demand()
        static func max(_ todo: Int) -> Subscribers.Demand {
            return unlimited
        }
        static let none = Demand()
    }
    
    @frozen public enum Completion<Failure> {
        case finished
        case failure(Failure)
    }
    
}

public protocol Subscriber : CustomCombineIdentifierConvertible {
    associatedtype Input
    associatedtype Failure
    
    func receive(_ input: Self.Input) -> Subscribers.Demand
    
    func receive() -> Subscribers.Demand
    
    func receive(subscription: Subscription)

    func receive(completion: Subscribers.Completion<Failure>)
}

public protocol Publisher {
    associatedtype Output
    associatedtype Failure: Error
    
    func subscribe<S: Subscriber>(_ subscriber:S) where S.Input == Output, S.Failure == Failure
}

enum Publishers {
    // see list here https://developer.apple.com/documentation/combine/publishers
}

//public protocol Subject: Publisher, AnyObject {
//    func send(_ value: Output)
//}

public protocol Subject : AnyObject, Publisher {

    /// Sends a value to the subscriber.
    ///
    /// - Parameter value: The value to send.
    func send(_ value: Self.Output)

    /// Sends a completion signal to the subscriber.
    ///
    /// - Parameter completion: A `Completion` instance which indicates whether publishing has finished normally or failed with an error.
    func send(completion: Subscribers.Completion<Self.Failure>)

    /// Provides this Subject an opportunity to establish demand for any new upstream subscriptions (say via, ```Publisher.subscribe<S: Subject>(_: Subject)`
    func send(subscription: Subscription)
}
