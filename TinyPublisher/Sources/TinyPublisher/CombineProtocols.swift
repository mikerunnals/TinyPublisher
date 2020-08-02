
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
    @frozen public struct Demand {
        static let unlimited = Demand()
//        static func max(_ todo: Int) -> Subscribers.Demand {
//            return unlimited
//        }
//        static let none: Subscribers.Demand
    }
    
    @frozen enum Completion<Failure> where Failure : Error {
        case finished
        case failure(Failure)
    }
    
}

public protocol Subscriber {
    associatedtype Input
    associatedtype Failure
    
    func receive(_ input: Self.Input) -> Subscribers.Demand
    
    func receive() -> Subscribers.Demand
}

public protocol Publisher {
    associatedtype Output
    associatedtype Failure: Error
    
    func subscribe<S: Subscriber>(_ subscriber:S) where S.Input == Output, S.Failure == Failure
}

public protocol Subject: Publisher, AnyObject {
    func send(_ value: Output)
}
