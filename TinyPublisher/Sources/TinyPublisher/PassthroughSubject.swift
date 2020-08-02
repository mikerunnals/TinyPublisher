import Foundation

public class PassthroughSubject<Output, Failure> : Subject where Failure : Error {
    
    public typealias Output = Output
    public typealias Failure = Failure

    private var cancellableSubscribers: [UUID: (Output) -> Void] = [:]

    public init() {}
    
    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // TODO: ???
    }

    public func sink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        let uuid = UUID()
        let cancellable = AnyCancellable { [weak self] in
            self?.removeObserver(uuid)
        }
        cancellableSubscribers[uuid] = receiveValue
        return cancellable
    }
    
    private func removeObserver(_ uuid: UUID) {
        cancellableSubscribers.removeValue(forKey: uuid)
    }

    public func send(_ value: Output) {
        cancellableSubscribers.forEach { $0.1(value) }
    }
}
