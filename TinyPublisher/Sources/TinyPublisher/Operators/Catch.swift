extension Publisher {
    
    func `catch`<P>(_ handler: @escaping (Self.Failure) -> P) -> Publishers.Catch<Self, P> where P : Publisher, Self.Output == P.Output {
        return Publishers.Catch<Self, P>(upstream: self, handler: handler)
    }
}

extension Publishers {
    
    public class Catch<Upstream, NewPublisher> : Publisher where Upstream : Publisher,
    NewPublisher : Publisher, Upstream.Output == NewPublisher.Output {

        public typealias Failure = NewPublisher.Failure
        
        public typealias Output = Upstream.Output

        private let oldUpstream: Upstream
        
        private var newUpstream: NewPublisher?
    
        private let handler: (Upstream.Failure) -> NewPublisher
        
        private var subscribers: [AnySubscriber<Upstream.Output, Upstream.Failure>] = []
        
        private var newSubscribers: [AnySubscriber<Upstream.Output, NewPublisher.Failure>] {
            get {
                var newSubscribers: [AnySubscriber<Upstream.Output, NewPublisher.Failure>] = []
                subscribers.forEach { subscriber in
                    let newSubscriber: AnySubscriber<Upstream.Output, NewPublisher.Failure> = subscriber.convertTo().eraseToAnySubscriber()
                    newSubscribers.append(newSubscriber)
                }
                return newSubscribers
            }
        }

        public init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> NewPublisher) {
            self.oldUpstream = upstream
            self.handler = handler
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            
            let anysub = ClosureSubscriber<Upstream.Output, Upstream.Failure>(
                receiveCompletion: receiveCompletion(subscriber),
                receiveValue: receiveValue(subscriber)).eraseToAnySubscriber()
            subscribers.append(anysub)

            if let newUpstream = newUpstream {
                newUpstream.receive(subscriber: anysub.convertTo())
            } else {
                oldUpstream.receive(subscriber: anysub)
            }
        }
        
        private func receiveCompletion<S>(_ subscriber: S) -> ((Subscribers.Completion<Upstream.Failure>) -> Void)? where S : Subscriber, Failure == S.Failure, Output == S.Input {
            return { [weak self] completion in
                switch completion {
                case .finished:
                    subscriber.receive(completion: .finished)
                case .failure(let failure):
                    self?.resubscribeAll(failure)
                }
            }
        }
        
        private func receiveNewCompletion(_ subscriber: AnySubscriber<Upstream.Output, NewPublisher.Failure>) -> ((Subscribers.Completion<NewPublisher.Failure>) -> Void)? {
            return { completion in
                switch completion {
                case .finished:
                    subscriber.receive(completion: .finished)
                case .failure(_):
                    break // Never?
                }
            }
        }
        
        private func resubscribeAll(_ failure: Upstream.Failure) {
            newUpstream = handler(failure)
            
            guard let newUpstream = newUpstream else {
                return
            }
            
            newSubscribers.forEach { subscriber in
                if subscriber.receive() == .unlimited /*|| demand not met*/  {
                    newUpstream.receive(subscriber: subscriber)
                }
            }
        }
        
        private func subscribeNewUpstream<S>(_ subscriber: S) -> ClosureSubscriber<Upstream.Output, NewPublisher.Failure>
            where S : Subscriber, Output == S.Input, S.Failure == NewPublisher.Failure {
            let sub = ClosureSubscriber<Upstream.Output, NewPublisher.Failure>(
                receiveCompletion: receiveNewCompletion(subscriber.eraseToAnySubscriber()),
                receiveValue: receiveNewValue(subscriber))
            newUpstream!.receive(subscriber: sub)
            return sub
        }
        
        private func receiveValue<S>(_ subscriber: S) -> ((Upstream.Output) -> Void) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            return { input in
                subscriber.receive(input)
            }
        }
        
        private func receiveNewValue<S>(_ subscriber: S) -> ((Upstream.Output) -> Void) where S : Subscriber, Output == S.Input {
            return { input in
                subscriber.receive(input)
            }
        }

    }
}

extension Subscriber {
    
    public func convertTo<NewFailure>() -> ConvertedSubscriber<Self.Input, Self.Failure, NewFailure> {
        return ConvertedSubscriber<Input, Failure, NewFailure>(self)
    }
}

public class ConvertedSubscriber<Input, OldFailure, NewFailure>: Subscriber {
        
    public typealias Input = Input
    public typealias Failure = NewFailure

    typealias ReceiveSubscriptionHandler = () -> ()

    private let receiveInputClosure: (Input) -> Subscribers.Demand
    private let receiveClosure: () -> Subscribers.Demand
    private let receiveSubscriptionClosure: (Subscription) -> ()
    private let receiveCompletionClosure: (Subscribers.Completion<Failure>) -> ()

    init<S: Subscriber>(_ subscriber: S) where OldFailure == S.Failure, Input == S.Input {
        receiveSubscriptionClosure = subscriber.receive(subscription:)
        receiveInputClosure = subscriber.receive(_:)
        receiveClosure = subscriber.receive
        self.combineIdentifier = subscriber.combineIdentifier
        
        receiveCompletionClosure = ConvertedSubscriber<Input, OldFailure, NewFailure>.wrapInClosure(subscriber.receive(completion:))

    }
    
    private static func wrapInClosure(_ receiveCompletion: @escaping (Subscribers.Completion<OldFailure>) -> Void) -> (Subscribers.Completion<Failure>) -> Void {
        return { completion in
            switch completion {
            case .finished:
                receiveCompletion(.finished)
            case .failure(_):
                break
//                if let newError = error as? NewFailure {
//                    receiveCompletion(Subscribers.Completion<OldFailure>.failure(<#T##OldFailure#>))
//                }
            }
        }
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
