
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
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subject.receive(subscriber: subscriber)
            
            // send Elements now?
            elements.forEach {
                subject.send($0)
            }
            
            subject.send(completion: .finished)
        }
    }
}
