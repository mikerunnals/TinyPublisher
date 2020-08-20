
extension Sequence {
    var publisher: Publishers.Sequence<Self, Never> {
        get {
            return Publishers.Sequence<Self, Never>(self)
        }
    }
}

extension Publishers {
    
    public struct Sequence<Elements, Failure>: Publisher where Elements: Swift.Sequence, Failure : Error {

        public typealias Output = Elements.Element
        public typealias Failure = Failure
        
        private let elements: Elements
        private let subject = PassthroughSubject<Elements.Element, Failure>()
        
        init(_ elements: Elements) {
            self.elements = elements
        }
        
        public func subscribe<S>(_ subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subject.subscribe(subscriber)
            
            // send Elements now?
            elements.forEach {
                subject.send($0)
            }
            
            // MLR TODO: don't call subscriber.receive if subscription is cancelled.
            subscriber.receive(completion: .finished)
        }
    }
}
