import XCTest

#if RUN_UNIT_TESTS_AGAINST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

final class PassthroughSubjectTests: XCTestCase {
    
    @available(iOS 13.0, *)
    func testPassthroughSubjectBool() {
        
        var cancellables: [AnyCancellable] = []
        
        let subject = PassthroughSubject<Bool, Never>()
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
    func testGivenSubscriberCancelledThenSinkClosureIsNotCalled() {
        let subject = PassthroughSubject<Bool, Never>()
        
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
