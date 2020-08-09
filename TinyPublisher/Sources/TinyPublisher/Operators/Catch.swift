extension Publisher {
    
    func `catch`<P>(_ handler: @escaping (Self.Failure) -> P) -> Publishers.Catch<Self, P> where P : Publisher, Self.Output == P.Output {
        return Publishers.Catch<Self, P>(upstream: self, handler: handler)
    }
}

extension Publishers {
    public class Catch<Upstream, P> : Publisher where Upstream : Publisher {

        public typealias Failure = Upstream.Failure
        public typealias Output = Upstream.Output

        public let upstream: Upstream

        public let handler: (Upstream.Failure) -> P
        
        private var cancellables: [TinyPublisher.AnyCancellable] = []

        public init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> P) {
            self.upstream = upstream
            self.handler = handler
        }

        public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

            let sub = ClosureSubscriber<Upstream.Output, Failure>(receiveCompletion: receiveCompletion(subscriber),
                                                                  receiveValue: subscriber.receive)
            upstream.subscribe(sub)
            cancellables.append(sub.eraseToAnyCancellable())
        }
        
        private func receiveCompletion<S>(_ subscriber: S) -> ((Subscribers.Completion<Failure>) -> Void)? where S : Subscriber, Failure == S.Failure, Output == S.Input {
            return { [weak self] completion in
                switch completion {
                case .finished:
                    subscriber.receive(completion: completion)
                case .failure(let failure):
                    self?.resubscribeAll(failure)
                }
            }
        }
        
        private func resubscribeAll(_ failure: Upstream.Failure) {
            let newUpstream = handler(failure)
            // foreach s in upstream.subscribers
                // let demand = s.reveice()
                // if demand
                    // newUpstream.subscribe(s)
            //self.upstream = newUpstream
        }
        
//        private func receiveValue<S>(_ subscriber: S) -> ((Upstream.Output) -> Void) where S : Subscriber, Failure == S.Failure, Output == S.Input {
//            return { input in
//                subscriber.receive(self.transform(input))
//            }
//        }
    }
}
