extension Publisher {
    
    func tryMap<T>(_ transform: @escaping (Self.Output) throws -> T) -> Publishers.TryMap<Self, T> {
        return Publishers.TryMap<Self, T>(upstream: self, transform: transform)
    }
}

extension Publishers {
    public class TryMap<Upstream, Output> : Publisher where Upstream : Publisher {

        public typealias Failure = Error
        public typealias Output = Output

        public let upstream: Upstream

        public let transform: (Upstream.Output) throws -> Output
        
        private var cancellables: [TinyPublisher.AnyCancellable] = []

        public init(upstream: Upstream, transform: @escaping (Upstream.Output) throws -> Output) {
            self.upstream = upstream
            self.transform = transform
        }

        public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

            let anySubscriber = subscriber.eraseToAnySubscriber()
            let upstreamSubscriber = ClosureSubscriber<Upstream.Output, Upstream.Failure>(
                receiveCompletion: receiveCompletion(anySubscriber),
                receiveValue: receiveValue(anySubscriber))
            upstream.subscribe(upstreamSubscriber)
            cancellables.append(upstreamSubscriber.eraseToAnyCancellable())
        }
        
        private func receiveCompletion(_ subscriber: AnySubscriber<Output, Failure>) -> ((Subscribers.Completion<Upstream.Failure>) -> Void)? {
            return { completion in
                //subscriber.receive(completion: completion)
            }
        }
        
        private func receiveValue(_ subscriber: AnySubscriber<Output, Failure>) -> ((Upstream.Output) -> Void) {
            return { input in
                do {
                    let output = try self.transform(input)
                    subscriber.receive(output)
                } catch {
                    subscriber.receive(completion: .failure(error))
                }
            }
        }
    }
}
