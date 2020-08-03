import XCTest
@testable import TinyPublisher
import Combine

final class PublisherAssignTests: XCTestCase {
    
    func testAssignBool() {
        
        var cancellables: [TinyPublisher.AnyCancellable] = []
        
        let subject = TinyPublisher.PassthroughSubject<Bool, Never>()
        
        let e = expectation(description: "true")
        
        subject.sink { value in
            XCTAssertTrue(value)
            e.fulfill()
        }.store(in: &cancellables)
        
        subject.send(true)
        
        waitForExpectations(timeout: 1)
    }
    
    @available(iOS 13.0, *)
    func testCombineAssignBool() {
        
        var cancellables: [Combine.AnyCancellable] = []
        
        let subject = Combine.PassthroughSubject<Bool, Never>()
        
        struct Test {
            var value: Bool
        }
        
        let e = expectation(description: "true")
        
        subject.sink { value in
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
