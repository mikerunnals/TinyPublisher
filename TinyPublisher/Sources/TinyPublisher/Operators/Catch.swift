extension Publisher {
    
    func `catch`<P>(_ handler: @escaping (Self.Failure) -> P) -> Publishers.Catch<Self, P> where P : Publisher, Self.Output == P.Output {
        return Publishers.Catch<Self, P>(upstream: self, handler: handler)
    }
}

extension Publishers {
    public class Catch<Upstream, P> : Publisher where Upstream : Publisher, P : Publisher {

        public typealias Failure = Upstream.Failure
        public typealias Output = P

        public let upstream: Upstream

        public let handler: (Upstream.Output) -> Output
        
        private var cancellables: [TinyPublisher.AnyCancellable] = []

        public init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> Output) {
            self.upstream = upstream
            self.handler = handler
        }

        public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

            let sub = ClosureSubscriber<Upstream.Output, Failure>(receiveCompletion: receiveCompletion(subscriber),
                                                                   receiveValue: receiveValue(subscriber))
            upstream.subscribe(sub)
            cancellables.append(sub.eraseToAnyCancellable())
        }
        
        private func receiveCompletion<S>(_ subscriber: S) -> ((Subscribers.Completion<Failure>) -> Void)? where S : Subscriber, Failure == S.Failure, Output == S.Input {
            return { completion in
                subscriber.receive(completion: completion)
            }
        }
        
        private func receiveValue<S>(_ subscriber: S) -> ((Upstream.Output) -> Void) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            return { input in
                subscriber.receive(self.transform(input))
            }
        }
    }
}
