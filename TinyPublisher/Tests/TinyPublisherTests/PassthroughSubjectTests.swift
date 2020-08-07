import XCTest
@testable import TinyPublisher
import Combine

final class PassthroughSubjectTests: XCTestCase {
    
    func testPassthroughSubjectBool() {
        
        var cancellables: [TinyPublisher.AnyCancellable] = []
        
        let subject = TinyPublisher.PassthroughSubject<Bool, Never>()
        let publisher = subject.eraseToAnyPublisher()
        
        let e = expectation(description: "true")
        
        publisher.sink { value in
            XCTAssertTrue(value)
            e.fulfill()
        }.store(in: &cancellables)
        
        subject.send(true)
        
        waitForExpectations(timeout: 1)
    }
    
    @available(iOS 13.0, *)
    func testCombinePassthroughSubjectBool() {
        
        var cancellables: [Combine.AnyCancellable] = []
        
        let subject = Combine.PassthroughSubject<Bool, Never>()
        let publisher = subject.eraseToAnyPublisher()

        let e = expectation(description: "true")
        
        publisher.sink { value in
            XCTAssertTrue(value)
            e.fulfill()
        }.store(in: &cancellables)
        
        subject.send(true)
        
        waitForExpectations(timeout: 1)
    }

    
    func testGivenSubscriberCancelledThenSinkClosureIsNotCalled() {
        let subject = TinyPublisher.PassthroughSubject<Bool, Never>()
        
        let e = expectation(description: "Expect NOT to be fulfilled!")
        e.isInverted = true
        
        let cancellable = subject.sink { value in
            e.fulfill()
        }
        
        cancellable.cancel()
        
        subject.send(true)
        
        waitForExpectations(timeout: 1)

    }
    
    @available(iOS 13.0, *)
    func testCombineGivenSubscriberCancelledThenSinkClosureIsNotCalled() {
        let subject = Combine.PassthroughSubject<Bool, Never>()
        
        let e = expectation(description: "Expect NOT to be fulfilled!")
        e.isInverted = true
        
        let cancellable = subject.sink { value in
            e.fulfill()
        }
        
        cancellable.cancel()
        
        subject.send(true)
        
        waitForExpectations(timeout: 1)

    }

    
    static var allTests = [
        ("testPassthroughSubjectBool", testPassthroughSubjectBool),
    ]
}
