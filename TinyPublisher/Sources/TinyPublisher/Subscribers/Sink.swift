
extension Publisher {
        
    func sink(receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil,
              receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
   
        let subscriber = ClosureSubscriber<Self.Output, Self.Failure>(receiveCompletion: receiveCompletion,
                                                                      receiveValue: receiveValue)
        receive(subscriber: subscriber)

        return subscriber.eraseToAnyCancellable()
    }
}

class ClosureSubscriber<Input, Failure> : Subscriber {

    let combineIdentifier = CombineIdentifier()

    typealias Input = Input
    
    typealias Failure = Failure
        
    private var receiveCompletion: ((Subscribers.Completion<Failure>) -> Void)?
    private var receiveValue: ((Input) -> Void)
    private var receiveSubscription: ((Subscription) -> Void)?

    fileprivate var subscription: Subscription?
    
    init(receiveCompletion: ((Subscribers.Completion<Failure>) -> Void)? = nil,
         receiveValue: @escaping ((Input) -> Void), receiveSubscription: ((Subscription) -> Void)? = nil) {
        self.receiveCompletion = receiveCompletion
        self.receiveValue = receiveValue
        self.receiveSubscription = receiveSubscription
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
        receiveSubscription?(subscription)
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
