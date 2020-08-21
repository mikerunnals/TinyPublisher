
public class PassthroughSubject<Output, Failure> : Subject where Failure : Error {
        
    public typealias Output = Output
    
    public typealias Failure = Failure
    
    // MLR TODO: Handle concurrency of cancellableSubscribers??
    private var cancellableSubscribers: [CombineIdentifier : AnySubscriber<Output, Failure>] = [:]

    public init() {}
    
    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = TinySubscription(subscriber.combineIdentifier,
                                          cancelCall: { [weak self] in
            self?.removeSubscriber(subscriber.combineIdentifier)
        })
        subscriber.receive(subscription: subscription)
        cancellableSubscribers[subscriber.combineIdentifier] = subscriber.eraseToAnySubscriber()
    }
    
    private func removeSubscriber(_ identifier: CombineIdentifier) {
        cancellableSubscribers.removeValue(forKey: identifier)
    }

    public func send(_ value: Output) {
        cancellableSubscribers.forEach { $0.value.receive(value) }
    }
    
    public func send(completion: Subscribers.Completion<Failure>) {
        let _cancellableSubscribers = cancellableSubscribers
        cancellableSubscribers = [:]
        _cancellableSubscribers.forEach { $0.value.receive(completion: completion) }
    }
    
    public func send(subscription: Subscription) {
        // MLR TODO: ???
    }
}

fileprivate class TinySubscription : Subscription {
        
    let combineIdentifier: CombineIdentifier
    
    let cancelCall: () -> Void

    init(_ combineIdentifier: CombineIdentifier, cancelCall: @escaping () -> Void) {
        self.combineIdentifier = combineIdentifier
        self.cancelCall = cancelCall
    }
    
    func cancel() {
        cancelCall()
    }
}
