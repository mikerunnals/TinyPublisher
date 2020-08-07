
public final class AnyCancellable : Cancellable {
    
    func store(in array: inout [AnyCancellable]) {
        array.append(self)
    }
    
    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    private var cancellable: Cancellable?
        
    init(cancellable: Cancellable) {
        self.cancellable = cancellable
    }
    
    init(cancelClosure: (() -> Void)?) {
        self.cancellable = ClosureCancellable(cancelClosure: cancelClosure)
    }
    
    deinit {
        cancel()
    }
}

final class SubscriptionCancellable<S: Subscriber> : Cancellable {
        
    public func cancel() {
        // TODO: must be thread-safe.
        subscription.cancel()
    }
    
    private let subscriber: S
    private let subscription: Subscription

    init(subscriber: S, subscription: Subscription) {
        self.subscriber = subscriber
        self.subscription = subscription
    }
    
    deinit {
        cancel()
    }
}

final class ClosureCancellable : Cancellable {
        
    public func cancel() {
        cancelClosure?()
        cancelClosure = nil
    }
    
    private var cancelClosure: (() -> Void)?
        
    init(cancelClosure: (() -> Void)?) {
        self.cancelClosure = cancelClosure
    }
    
    deinit {
        cancel()
    }
}
