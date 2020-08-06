extension Publisher {
    func eraseToAnyPublisher() -> AnyPublisher<Self.Output, Self.Failure> {
        return AnyPublisher(subscribeClosure: { self.subscribe($0) })
    }
}

@frozen public struct AnyPublisher<Output, Failure>: Publisher where Failure : Error {
    
    let subscribeClosure: (_ S: Subscriber) -> () 
        
    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        subscribeClosure(subscriber)
    }
    
}

protocol SubscribeClosure {
    associatedtype Input
    associatedtype Failure: Error

    typealias subscribe = (_ S: Subscriber) -> Void

    func perform<S: Subscriber>(then handler: @escaping S) where S : Subscriber, Self.Failure == S.Failure, Self.Input == S.Input
}
