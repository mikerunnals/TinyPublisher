import Foundation

public protocol AnyCancellable: class {
    func store(in array: inout [AnyCancellable])
}

fileprivate final class TinyPublisherCancellable<U>: AnyCancellable {
    
    func store(in array: inout [AnyCancellable]) {
        array.append(self)
    }
    
    let uuid: UUID
    weak var publisher: TinyPublisher<U>?
    
    init(uuid: UUID, publisher: TinyPublisher<U>) {
        self.uuid = uuid
        self.publisher = publisher
    }
    
    deinit {
        publisher?.removeObserver(uuid: uuid)
    }
}

public protocol Publisher {
    associatedtype Output
    func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable
}

public class TinyPublisher<U> : Publisher {
    
    private var observers: [UUID: (U) -> Void] = [:]

    public init() {}
    
    public func sink(receiveValue: @escaping ((U) -> Void)) -> AnyCancellable {
        let cancellable = TinyPublisherCancellable<U>(uuid: UUID(), publisher: self)
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
