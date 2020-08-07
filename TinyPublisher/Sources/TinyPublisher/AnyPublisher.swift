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
    //private let subscribingClosure: (SubscribingHandler) -> Void
                
    init<P: Publisher>(_ publisher: P) where Self.Failure == P.Failure, Self.Output == P.Output {
        //self.publisher = publisher.subscribe
    }
        
    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
    }
}

class AnySubscriber<Input, Failure>: Subscriber where Failure : Error {
    
    public typealias Input = Input
    public typealias Failure = Failure

    typealias ReceiveSubscriptionHandler = () -> ()

    private let receiveInputClosure: (Input) -> Subscribers.Demand
    private let receiveClosure: () -> Subscribers.Demand
    private let receiveSubscriptionClosure: (Subscription) -> ()
    private let receiveCompletionClosure: (Subscribers.Completion<Failure>) -> ()

    init<S: Subscriber>(subscriber: S) where Failure == S.Failure, Input == S.Input{
        receiveSubscriptionClosure = subscriber.receive(subscription:)
        receiveInputClosure = subscriber.receive(_:)
        receiveClosure = subscriber.receive
        receiveCompletionClosure = subscriber.receive(completion:)
        self.combineIdentifier = subscriber.combineIdentifier
    }
    
    let combineIdentifier: CombineIdentifier
    
    func receive(_ input: Input) -> Subscribers.Demand {
        return receiveInputClosure(input)
    }
    
    func receive() -> Subscribers.Demand {
        return receiveClosure()
    }
    
    func receive(subscription: Subscription) {
        receiveSubscriptionClosure(subscription)
    }

    func receive(completion: Subscribers.Completion<Failure>) {
        receiveCompletionClosure(completion)
    }

}


//class AnyModelLoader<T>: ModelLoading {
//    typealias CompletionHandler = (Result<T>) -> Void
//
//    private let loadingClosure: (CompletionHandler) -> Void
//
//    init<L: ModelLoading>(loader: L) where L.Model == T {
//        loadingClosure = loader.load
//    }
//
//    func load(completionHandler: CompletionHandler) {
//        loadingClosure(completionHandler)
//    }
//}
