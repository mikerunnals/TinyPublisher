extension Publisher {
    func eraseToAnyPublisher() -> AnyPublisher<Self.Output, Self.Failure> {
        return AnyPublisher(self)
    }
}

@frozen public struct AnyPublisher<Output, Failure>: Publisher where Failure : Error {
    
    public typealias Output = Output
    public typealias Failure = Failure
    
    typealias GenericSubscriber<Output, Failure> = Subscriber
    typealias SubscribingHandler = (GenericSubscriber<Output, Failure>) -> Void
    private let subscribingClosure: (SubscribingHandler) -> Void
                
    init<P: Publisher>(_ publisher: P) where Self.Failure == P.Failure, Self.Output == P.Output {
        self.publisher = publisher.subscribe
    }
        
    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
    }
}

class AnySubscriber<Input, Failure>: Subscriber where Failure : Error {
    public typealias Input = Input
    public typealias Failure = Failure

    typealias ReceiveSubscriptionHandler = (Subscription) -> Void

    private let receiveClosure: (ReceiveSubscriptionHandler) -> Void

    init<S: Subscriber>(subscriber: S) where Failure == S.Failure, Input == S.Input{
        receiveClosure = subscriber.receive
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        return nil!
    }
    
    func receive() -> Subscribers.Demand
    
    func receive(subscription: Subscription)

    func receive(completion: Subscribers.Completion<Failure>)

}


class AnyModelLoader<T>: ModelLoading {
    typealias CompletionHandler = (Result<T>) -> Void

    private let loadingClosure: (CompletionHandler) -> Void

    init<L: ModelLoading>(loader: L) where L.Model == T {
        loadingClosure = loader.load
    }

    func load(completionHandler: CompletionHandler) {
        loadingClosure(completionHandler)
    }
}
