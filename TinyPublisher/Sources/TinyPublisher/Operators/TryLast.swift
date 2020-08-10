
extension Publisher {
    func tryLast(where predicate: @escaping (Self.Output) throws -> Bool) -> Publishers.TryLastWhere<Self> {
        return Publishers.TryLastWhere<Self>(upstream: self, predicate: predicate)
    }
}

extension Publishers {
    class TryLastWhere<Upstream> : Publisher where Upstream : Publisher {
        
        public typealias Failure = Error
        public typealias Output = Upstream.Output
        
        typealias Predicate = (Output) throws -> Bool
        
        let upstream: Upstream
        var lastValue: Output?
        let predicate: Predicate
        
        init(upstream: Upstream, predicate: @escaping Predicate) {
            self.upstream = upstream
            self.predicate = predicate
        }
        
        public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

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
                    self.applyPredicate(subscriber)
                case .failure(let failure):
                    subscriber.receive(completion: .failure(failure))
                }
            }
        }
        
        private func applyPredicate(_ subscriber: AnySubscriber<Output, Failure>) {
            subscriber.receive(completion: .finished)
            do {
                guard let value = lastValue, try predicate(value) else {
                    //subscriber.receive(completion: .failure(error))
                    return
                }
            } catch {
                subscriber.receive(completion: .failure(error))
            }
        }
        
        private func receiveValue() -> ((Upstream.Output) -> Void) {
            return { self.lastValue = $0 }
        }
    }
}
