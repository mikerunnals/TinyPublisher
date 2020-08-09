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
        
        private var cancellables: [AnyCancellable] = []

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
            return { upstreamCompletion in
                switch upstreamCompletion {
                case .finished:
                    subscriber.receive(completion: .finished)
                case .failure(let failure):
                    subscriber.receive(completion: .failure(failure))
                }
            }
        }
        
        private func receiveValue(_ subscriber: AnySubscriber<Output, Failure>) -> ((Upstream.Output) -> Void) {
            return { input in
                do {
                    let output = try self.transform(input)
                    subscriber.receive(output) // MLR TODO??
                } catch {
                    subscriber.receive(completion: .failure(error))
                }
            }
        }
    }
}
