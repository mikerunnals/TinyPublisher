
public class PassthroughSubject<Output, Failure> : Subject where Failure : Error {
    
    public typealias Output = Output
    public typealias Failure = Failure

    private var cancellableSubscribers: [CombineIdentifier: (Output) -> Void] = [:]

    public init() {}
    
    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // TODO: ???
    }

//    public func sink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
//        let identifier = CombineIdentifier()
//        let cancellable = AnyCancellable { [weak self] in
//            self?.removeSubscriber(identifier)
//        }
//        cancellableSubscribers[identifier] = receiveValue
//        //subscribe(<#T##subscriber: Subscriber##Subscriber#>)
//        return cancellable
//    }
    
    private func removeSubscriber(_ identifier: CombineIdentifier) {
        cancellableSubscribers.removeValue(forKey: identifier)
    }

    public func send(_ value: Output) {
        cancellableSubscribers.forEach { $0.1(value) }
    }
}
