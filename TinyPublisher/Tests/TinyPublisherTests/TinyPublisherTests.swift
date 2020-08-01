import XCTest
@testable import TinyPublisher

final class TinyPublisherTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
    
    func testTinyPublishedPropertyWrapper() {
        
        class Test {
            @TinyPublished var property = false
        }
                
        let test = Test()

        let e = expectation(description: "Expect sink event")
        test.$property.sink { value in
            XCTAssertEqual(true, value, "Expected value to be true")
            e.fulfill()
        }.store(in: &cancellables)

        test.property = true

        waitForExpectations(timeout: 1)
    }
    
    func testTinyPublishedPropertyWrapperEnum() {
        enum TestEnum {
            case Case1
            case Case2
        }

        class Test {
            @TinyPublished var property = TestEnum.Case1
        }
                
        let test = Test()

        let e = expectation(description: "Expect sink event")
        test.$property.sink { value in
            XCTAssertEqual(.Case2, value, "Expected value to be true")
            e.fulfill()
        }.store(in: &cancellables)

        test.property = .Case2

        waitForExpectations(timeout: 1)

    }
    
    static var allTests = [
        ("testTinyPublishedPropertyWrapper", testTinyPublishedPropertyWrapper),
        ("testTinyPublishedPropertyWrapperEnum", testTinyPublishedPropertyWrapperEnum)
    ]
}
