
public class PassthroughSubject<Output, Failure> : Subject where Failure : Error {
    
    public typealias Output = Output
    public typealias Failure = Failure
    
    private var cancellableSubscribers: [CombineIdentifier : (Output) -> Void] = [:]

    public init() {}
    
    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        subscriber.receive(subscription: MySubscription(subscriber.combineIdentifier) { [weak self] in
            self?.removeSubscriber(subscriber.combineIdentifier)
        })
        cancellableSubscribers[subscriber.combineIdentifier] = { _ = subscriber.receive($0) }
    }
    
    private func removeSubscriber(_ identifier: CombineIdentifier) {
        cancellableSubscribers.removeValue(forKey: identifier)
    }

    public func send(_ value: Output) {
        cancellableSubscribers.forEach { $0.1(value) }
    }
}

fileprivate class MySubscription : Subscription {
    
    let combineIdentifier: CombineIdentifier
    let cancelCall: () -> Void
    
    init(_ combineIdentifier: CombineIdentifier, _ cancelCall: @escaping () -> Void) {
        self.combineIdentifier = combineIdentifier
        self.cancelCall = cancelCall
    }
    
    func cancel() {
        cancelCall()
    }
}
