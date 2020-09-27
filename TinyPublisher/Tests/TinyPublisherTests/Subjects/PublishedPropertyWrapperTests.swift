import XCTest

#if TEST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

final class PublishedPropertyWrapperTests: XCTestCase {
    
    func testPropertyWrapperBool() {
        var cancellables: [TinyPublisher.AnyCancellable] = []
        
        class Test {
            @TinyPublisher.Published var property = false
        }
                
        let test = Test()

        let es: [(value: Bool, expectation: XCTestExpectation)] =
            [(value: false, expectation: expectation(description: "Expect initial sink event")),
             (value: true, expectation: expectation(description: "Expect sink event"))]
        var things = es.enumerated().makeIterator()
        
        test.$property.sink { value in
            guard let (_, thing) = things.next() else { XCTFail(); return }

            XCTAssertEqual(thing.value, value, "Expected value to be true")
            thing.expectation.fulfill()
        }.store(in: &cancellables)

        test.property = true

        waitForExpectations(timeout: 1)
    }

//    @available(iOS 13.0, *)
//    func testCombinePropertyWrapperBool() {
//        var cancellables: [Combine.AnyCancellable] = []
//        
//        class Test {
//            @Combine.Published var property = false
//        }
//                
//        let test = Test()
//
//        let es: [(value: Bool, expectation: XCTestExpectation)] =
//            [(value: false, expectation: expectation(description: "Expect initial sink event")),
//             (value: true, expectation: expectation(description: "Expect sink event"))]
//        var things = es.enumerated().makeIterator()
//        
//        test.$property.sink { value in
//            guard let (_, thing) = things.next() else { XCTFail(); return }
//
//            XCTAssertEqual(thing.value, value, "Expected value to be true")
//            thing.expectation.fulfill()
//        }.store(in: &cancellables)
//
//        test.property = true
//
//        waitForExpectations(timeout: 1)
//    }
    
    static var allTests = [
        ("testPropertyWrapperBool", testPropertyWrapperBool)
    ]
}
