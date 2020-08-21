extension Publisher {
    
    func map<T>(_ transform: @escaping (Self.Output) -> T) -> Publishers.Map<Self, T> {
        return Publishers.Map<Self, T>(upstream: self, transform: transform)
    }
}

extension Publishers {
    public class Map<Upstream, Output> : Publisher where Upstream : Publisher {

        public typealias Failure = Upstream.Failure
        
        public typealias Output = Output

        public let upstream: Upstream

        public let transform: (Upstream.Output) -> Output
        
        private var cancellables: [AnyCancellable] = []

        public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
            self.upstream = upstream
            self.transform = transform
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

            let sub = ClosureSubscriber<Upstream.Output, Failure>(receiveCompletion: receiveCompletion(subscriber),
                                                                   receiveValue: receiveValue(subscriber))
            upstream.receive(subscriber: sub)
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
