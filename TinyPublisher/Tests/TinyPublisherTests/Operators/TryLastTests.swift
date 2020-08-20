import XCTest
@testable import TinyPublisher
//import Combine // TODO: figure out how to call both Tiny and Combine


struct RangeError: Error {}

final class TryLastTests: XCTestCase {
    
    func testTiny() {
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

    func testTinyError() {
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


//    @available(iOS 13.0, *)
//    func testCombine() {
//        var expected = "5 completion: finished"
//        var actual = ""
//
//        let numbers = [-62, 1, 6, 10, 9, 22, 41, -1, 5]
//        _ = numbers.publisher
//            .tryLast {
//                guard $0 != 0  else {throw RangeError()}
//                return true
//            }
//            .sink(
//                receiveCompletion: {
//                     actual.append("completion: \($0)")
//            },
//                receiveValue: {
//                     actual.append("\($0) ")
//            }
//            )
//        XCTAssertEqual(actual, expected)
//    }
//
//    @available(iOS 13.0, *)
//    func testTinyError() {
//        let expected = "completion: failure(TinyPublisherTests.RangeError())"
//        var actual = ""
//
//        let numbers = [-62, 1, 6, 10, 0, 22, 41, -1, 5]
//        _ = numbers.publisher
//            .tryLast {
//                guard $0 != 0  else {
//                    throw RangeError()
//                }
//                return true
//            }
//            .sink(
//                receiveCompletion: {
//                    actual.append("completion: \($0)")
//            },
//                receiveValue: {
//                    actual.append("\($0) ")
//            }
//            )
//        XCTAssertEqual(actual, expected)
//    }


}
