import XCTest
@testable import TinyPublisher
//import Combine // TODO: figure out how to call both Tiny and Combine


struct RangeError: Error {}

final class TryLastTests: XCTestCase {
    
    func testCombine() {
        let numbers = [-62, 1, 6, 10, 9, 22, 41, -1, 5]
        _ = numbers.publisher
            .tryLast {
                guard $0 != 0  else {throw RangeError()}
                return true
            }
            .sink(
                receiveCompletion: { print ("completion: \($0)", terminator: " ") },
                receiveValue: { print ("\($0)", terminator: " ") }
            )
        // Prints: "5 completion: finished"
        // If instead the numbers array had contained a `0`, the `tryLast` operator would terminate publishing with a RangeError."
    }
}
