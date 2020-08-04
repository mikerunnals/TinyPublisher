
extension Publisher {
            
    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on object: Root) -> AnyCancellable where Self.Failure == Never {
        let subscriber = AssignToSubscriber<Self.Output, Self.Failure, Root>(keyPath: keyPath, rootObject: object)
        
        subscribe(subscriber)
    
        return subscriber.eraseToAnyCancellable()
    }
}

fileprivate class AssignToSubscriber<Input, Failure, Root> : Subscriber where Failure : Error {
    
    let keyPath: ReferenceWritableKeyPath<Root, Input>
    var rootObject: Root
   
    let combineIdentifier = CombineIdentifier()
    
    typealias Input = Input
    typealias Failure = Failure

    fileprivate var subscription: Subscription!
    
    init(keyPath: ReferenceWritableKeyPath<Root, Input>, rootObject: Root) {
        self.keyPath = keyPath
        self.rootObject = rootObject
    }
    
    func eraseToAnyCancellable() -> AnyCancellable {
        let subscriptionCancellable = SubscriptionCancellable(subscriber: self, subscription: subscription)
        return AnyCancellable(cancellable: subscriptionCancellable)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        rootObject[keyPath: keyPath] = input
        return .unlimited
    }

    func receive() -> Subscribers.Demand {
       return .unlimited
    }

    func receive(subscription: Subscription) {
        self.subscription = subscription
    }

    func receive(completion: Subscribers.Completion<Failure>) {
    }
}
