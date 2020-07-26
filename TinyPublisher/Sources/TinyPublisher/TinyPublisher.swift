import Foundation

public protocol AnyCancellable: class {
    func store(in array: inout [AnyCancellable])
}

fileprivate final class TinyPublisherCancellable<U, Never>: AnyCancellable {
    
    func store(in array: inout [AnyCancellable]) {
        array.append(self)
    }
    
    let uuid: UUID
    weak var publisher: TinyPublisher<U, Never>?
    
    init(uuid: UUID, publisher: TinyPublisher<U, Never>) {
        self.uuid = uuid
        self.publisher = publisher
    }
    
    deinit {
        publisher?.removeObserver(uuid: uuid)
    }
}

@propertyWrapper
public class TinyPublished<Value> {
    private var value: Value
    private let publisher = TinyPublisher<Value, Never>()
    
    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    public init(initialValue: Value) {
        self.value = initialValue
    }
        
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
            publisher.send(wrappedValue)
        }
    }
    
    public var projectedValue: TinyPublisher<Value, Never> {
        publisher
    }
}

public class TinyPublisher<U, Never> {
    
    private var observers: [UUID: (U) -> Void] = [:]

    public init() {}
    
    public func sink(receiveValue: @escaping ((U) -> Void)) -> AnyCancellable {
        let cancellable = TinyPublisherCancellable<U, Never>(uuid: UUID(), publisher: self)
        observers[cancellable.uuid] = receiveValue
        return cancellable
    }
    
    fileprivate func removeObserver(uuid: UUID) {
        observers.removeValue(forKey: uuid)
    }

    public func send(_ update: U) {
        observers.forEach { $0.1(update) }
    }
}
