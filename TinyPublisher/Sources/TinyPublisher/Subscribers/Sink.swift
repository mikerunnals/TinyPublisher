
extension Publisher {
        
    func sink(receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil,
              receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
   
        let subscriber = ClosureSubscriber<Self.Output, Self.Failure>(receiveCompletion: receiveCompletion,
                                                                      receiveValue: receiveValue)
        subscribe(subscriber)

        return subscriber.eraseToAnyCancellable()
    }
}

class ClosureSubscriber<Input, Failure> : Subscriber where Failure : Error {
    
    let combineIdentifier = CombineIdentifier()

    typealias Input = Input
    typealias Failure = Failure
        
    private var receiveCompletion: ((Subscribers.Completion<Failure>) -> Void)?
    private var receiveValue: ((Input) -> Void)
    
    fileprivate var subscription: Subscription?
    
    init(receiveCompletion: ((Subscribers.Completion<Failure>) -> Void)? = nil,
         receiveValue: @escaping ((Input) -> Void)) {
        self.receiveCompletion = receiveCompletion
        self.receiveValue = receiveValue
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        receiveValue(input)
        return .unlimited
    }
    
    func receive() -> Subscribers.Demand {
        return .unlimited
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        receiveCompletion?(completion)
    }
    
    func eraseToAnyCancellable() -> AnyCancellable {
        let subscriptionCancellable = ClosureCancellable {
            // capture self strongly? so anyone holding the AnyCancellable will hold this
            self.subscription?.cancel()
        }
        return AnyCancellable(cancellable: subscriptionCancellable)
    }
}
