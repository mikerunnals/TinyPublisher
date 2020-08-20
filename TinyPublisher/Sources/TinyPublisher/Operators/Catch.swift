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

        public let upstream: Upstream

        public let handler: (Upstream.Failure) -> NewPublisher
        
        private var subscribers: [AnySubscriber<Output, Upstream.Failure>] = []

        public init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> NewPublisher) {
            self.upstream = upstream
            self.handler = handler
        }

        public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

            let sub = ClosureSubscriber<Upstream.Output, Upstream.Failure>(
                receiveCompletion: receiveCompletion(subscriber),
                receiveValue: receiveValue(subscriber))
            upstream.subscribe(sub)
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
        
        private func receiveNewCompletion<S>(_ subscriber: S) -> ((Subscribers.Completion<Failure>) -> Void)? where S : Subscriber, Failure == S.Failure, Output == S.Input {
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
            let newUpstream = handler(failure)
            subscribers.forEach { subscriber in
                if subscriber.receive() == .unlimited /*|| demand not met*/  {
                    let sub = ClosureSubscriber<Upstream.Output, Upstream.Failure>(
                        receiveCompletion: receiveNewCompletion(subscriber),
                        receiveValue: receiveValue(subscriber))
                    newUpstream.subscribe(subscriber)
                }
            }
        }
        
        private func receiveValue<S>(_ subscriber: S) -> ((Upstream.Output) -> Void) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            return { input in
                subscriber.receive(input)
            }
        }
    }
}
