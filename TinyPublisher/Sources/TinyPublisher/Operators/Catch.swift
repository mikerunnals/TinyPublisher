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

        public init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> NewPublisher) {
            self.oldUpstream = upstream
            self.handler = handler
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

            if let newUpstream = newUpstream {
                subscribeNewUpstream(subscriber)
            } else {
                let sub = ClosureSubscriber<Upstream.Output, Upstream.Failure>(
                    receiveCompletion: receiveCompletion(subscriber),
                    receiveValue: receiveValue(subscriber))
                oldUpstream.receive(subscriber: sub)
            }
            subscribers.append(sub.eraseToAnySubscriber())
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
        
        private func receiveNewCompletion(_ subscriber: AnySubscriber<Upstream.Output, Upstream.Failure>) -> ((Subscribers.Completion<NewPublisher.Failure>) -> Void)? {
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
            subscribers.forEach { subscriber in
                if subscriber.receive() == .unlimited /*|| demand not met*/  {
                    subscribeNewUpstream(subscriber)
                }
            }
        }
        
        private func subscribeNewUpstream<S>(_ subscriber: S) where S : Subscriber, Output == S.Input {
            let sub = ClosureSubscriber<Upstream.Output, NewPublisher.Failure>(
                receiveCompletion: receiveNewCompletion(subscriber),
                receiveValue: receiveNewValue(subscriber))
            newUpstream!.receive(subscriber: sub)
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
