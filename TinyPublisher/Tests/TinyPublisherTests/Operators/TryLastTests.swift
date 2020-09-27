import XCTest

#if RUN_UNIT_TESTS_AGAINST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

struct RangeError: Error {}

final class TryLastTests: XCTestCase {
    
    @available(iOS 13.0, *)
    func testTryLast() {
        let expected = "5 completion: finished"
        var actual = ""

        let numbers = [-62, 1, 6, 10, 9, 22, 41, -1, 5]
        _ = numbers.publisher
            .tryLast {
                guard $0 != 0  else {throw RangeError()}
                return true
            }
            .sink(
                receiveCompletion: {
                    actual.append("completion: \($0)")
            },
                receiveValue: {
                    actual.append("\($0) ")
            }
            )
        XCTAssertEqual(actual, expected)
    }

    @available(iOS 13.0, *)
    func testTryLastError() {
        let expected = "completion: failure(TinyPublisherTests.RangeError())"
        var actual = ""

        let numbers = [-62, 1, 6, 10, 0, 22, 41, -1, 5]
        _ = numbers.publisher
            .tryLast {
                guard $0 != 0  else {
                    throw RangeError()
                }
                return true
            }
            .sink(
                receiveCompletion: {
                    actual.append("completion: \($0)")
            },
                receiveValue: {
                    actual.append("\($0) ")
            }
            )
        XCTAssertEqual(actual, expected)
    }
}
