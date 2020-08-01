import Foundation

public protocol Cancellable {
    func cancel()
}

public protocol Publisher {
    associatedtype Output
}

public protocol Subject: Publisher, AnyObject {
    func send(_ value: Output)
}

public final class AnyCancellable : Cancellable {
    
    func store(in array: inout [AnyCancellable]) {
        array.append(self)
    }
    
    public func cancel() {
        cancelClosure?()
        cancelClosure = nil
    }
    
    private var cancelClosure: (() -> Void)?
        
    init(cancelClosure: (() -> Void)?) {
        self.cancelClosure = cancelClosure
    }
    
    deinit {
        cancel()
    }
}

@propertyWrapper
public class TinyPublished<Value> { // TODO: How to name this Published<Value> and not collide with Foundation?
    private var value: Value
    private let publisher = PassthroughSubject<Value, Never>()
    
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
    
    public var projectedValue: PassthroughSubject<Value, Never> {
        publisher
    }
}

public class PassthroughSubject<Output, Never> : Subject { // TODO: change Never to Failure where Failure : Error
    
    private var observers: [UUID: (Output) -> Void] = [:]

    public init() {}
    
    public func sink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        let uuid = UUID()
        let cancellable = AnyCancellable { [weak self] in
            self?.removeObserver(uuid)
        }
        observers[uuid] = receiveValue
        return cancellable
    }
    
    private func removeObserver(_ uuid: UUID) {
        observers.removeValue(forKey: uuid)
    }

    public func send(_ value: Output) {
        observers.forEach { $0.1(value) }
    }
}
