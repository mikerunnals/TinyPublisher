
extension Publisher {
    func tryLast(where predicate: @escaping (Self.Output) throws -> Bool) -> Publishers.TryLastWhere<Self> {
        return Publishers.TryLastWhere<Self>(upstream: self, predicate: predicate)
    }
}

extension Publishers {
    struct TryLastWhere<Upstream> : Publisher where Upstream : Publisher {
        
        public typealias Failure = Upstream.Failure
        public typealias Output = Upstream.Output
        
        let upstream: Upstream
        var lastValue: Output
        let predicate: (Output) throws -> Bool
        
        public mutating func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

            let anySubscriber = subscriber.eraseToAnySubscriber()
            let upstreamSubscriber = ClosureSubscriber<Upstream.Output, Upstream.Failure>(
                receiveCompletion: receiveCompletion(anySubscriber),
                receiveValue: receiveValue())
            upstream.subscribe(upstreamSubscriber)
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
        
        private mutating func receiveValue() -> ((Upstream.Output) -> Void) {
            return { self.lastValue = $0 }
        }
    }
}
