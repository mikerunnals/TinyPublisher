extension Publisher {
    func eraseToAnyPublisher() -> AnyPublisher<Self.Output, Self.Failure> {
        return AnyPublisher(self)
    }
}

@frozen public struct AnyPublisher<Output, Failure>: Publisher where Failure : Error {
    
    public typealias Output = Output
    
    public typealias Failure = Failure
    
    let subscribeClosure: (AnySubscriber<Output, Failure>) -> Void
                
    init<P: Publisher>(_ publisher: P) where Self.Failure == P.Failure, Self.Output == P.Output {
        subscribeClosure = { publisher.receive(subscriber: $0) }
    }
        
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        subscribeClosure(subscriber.eraseToAnySubscriber())
    }
}

extension Subscriber {
    func eraseToAnySubscriber() -> AnySubscriber<Self.Input, Self.Failure> {
        return AnySubscriber(self)
    }
}

public class AnySubscriber<Input, Failure>: Subscriber {
    
    public typealias Input = Input
    public typealias Failure = Failure

    typealias ReceiveSubscriptionHandler = () -> ()

    private let receiveInputClosure: (Input) -> Subscribers.Demand
    private let receiveClosure: () -> Subscribers.Demand
    private let receiveSubscriptionClosure: (Subscription) -> ()
    private let receiveCompletionClosure: (Subscribers.Completion<Failure>) -> ()

    init<S: Subscriber>(_ subscriber: S) where Failure == S.Failure, Input == S.Input {
        receiveSubscriptionClosure = subscriber.receive(subscription:)
        receiveInputClosure = subscriber.receive(_:)
        receiveClosure = subscriber.receive
        receiveCompletionClosure = subscriber.receive(completion:)
        self.combineIdentifier = subscriber.combineIdentifier
    }
    
    public let combineIdentifier: CombineIdentifier
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        return receiveInputClosure(input)
    }
    
    public func receive() -> Subscribers.Demand {
        return receiveClosure()
    }
    
    public func receive(subscription: Subscription) {
        receiveSubscriptionClosure(subscription)
    }

    public func receive(completion: Subscribers.Completion<Failure>) {
        receiveCompletionClosure(completion)
    }
}
