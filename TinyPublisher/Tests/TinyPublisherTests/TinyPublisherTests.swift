import XCTest
import Foundation
@testable import TinyPublisher

final class TinyPublisherTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
    
    func testTinyPublisherBool() {
        
        let publisher = TinyPublisher<Bool>()
        
        let e = expectation(description: "true")
        
        publisher.sink { value in
            XCTAssertTrue(value)
            e.fulfill()
        }.store(in: &cancellables)
        
        publisher.send(true)
        
        waitForExpectations(timeout: 1)
    }
    
    class TestClass {
        @TinyPublished var testProperty: Bool = false
    }
    
    func testPublishedPropertyWrapper() {
        
        let testClass = TestClass()
        testClass.testProperty = false

        let e = expectation(description: "true")

        testClass.$testProperty.sink { value in
            XCTAssertTrue(value)
            e.fulfill()
        }.store(in: &cancellables)

        testClass.testProperty = true

        waitForExpectations(timeout: 1)
    }


    static var allTests = [
        ("testTinyPublisherBool", testTinyPublisherBool),
    ]
}
