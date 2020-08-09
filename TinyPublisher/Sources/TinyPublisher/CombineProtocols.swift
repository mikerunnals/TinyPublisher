
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
    
    @frozen public enum Completion<Failure> where Failure : Error {
        case finished
        case failure(Failure)
    }
    
}

public protocol Subscriber : CustomCombineIdentifierConvertible where Failure: Error {
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

public protocol Subject: Publisher, AnyObject {
    func send(_ value: Output)
}
