import XCTest
@testable import TinyPublisher
import Combine

final class TinyPublishedTests: XCTestCase {
    
    
    func testPropertyWrapperBool() {
        var cancellables: [TinyPublisher.AnyCancellable] = []
        
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
    
    @available(iOS 13.0, *)
    func testCombinePropertyWrapperBool() {
        var cancellables: [Combine.AnyCancellable] = []
        
        class Test {
            @Published var property = false
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
    
    func testPropertyWrapperEnum() {
        var cancellables: [TinyPublisher.AnyCancellable] = []
        
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
    
    @available(iOS 13.0, *)
    func testCombinePropertyWrapperEnum() {
        var cancellables: [Combine.AnyCancellable] = []
        
        enum TestEnum {
            case Case1
            case Case2
        }

        class Test {
            @Published var property = TestEnum.Case1
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
        ("testPropertyWrapperBool", testPropertyWrapperBool),
        ("testPropertyWrapperEnum", testPropertyWrapperEnum)
    ]
}
