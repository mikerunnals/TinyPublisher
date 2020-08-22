
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
        var subscriptions: [CombineIdentifier: Subscription] = [:]
        
        init(upstream: Upstream, predicate: @escaping Predicate) {
            self.upstream = upstream
            self.predicate = predicate
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

            let anySubscriber = subscriber.eraseToAnySubscriber()
            let upstreamSubscriber = ClosureSubscriber<Upstream.Output, Upstream.Failure>(
                receiveCompletion: receiveCompletion(anySubscriber),
                receiveValue: receiveValue(anySubscriber),
                receiveSubscription: receiveSubscription(anySubscriber))
            upstream.receive(subscriber: upstreamSubscriber)
        }
        
        private func receiveCompletion(_ subscriber: AnySubscriber<Output, Failure>) -> ((Subscribers.Completion<Upstream.Failure>) -> Void)? {
            return { [unowned self] upstreamCompletion in
                switch upstreamCompletion {
                case .finished:
                    if let lastValue = self.lastValue {
                        subscriber.receive(lastValue)
                    }
                    subscriber.receive(completion: .finished)
                case .failure(let failure):
                    subscriber.receive(completion: .failure(failure))
                }
            }
        }
        
        private func applyPredicate(_ subscriber: AnySubscriber<Output, Failure>) {
            do {
                guard let value = lastValue, try predicate(value) else {
                    return
                }
            } catch {
                subscriptions[subscriber.combineIdentifier]?.cancel()
                subscriber.receive(completion: .failure(error))
            }
        }
        
        private func receiveValue(_ subscriber: AnySubscriber<Output, Failure>) -> ((Upstream.Output) -> Void) {
            return {
                self.lastValue = $0
                self.applyPredicate(subscriber)
            }
        }
        
        private func receiveSubscription(_ subscriber: AnySubscriber<Output, Failure>) -> ((Subscription) -> Void) {
            return { subscription in
                self.subscriptions[subscriber.combineIdentifier] = subscription
                subscriber.receive(subscription: subscription)
            }
        }

    }
}
