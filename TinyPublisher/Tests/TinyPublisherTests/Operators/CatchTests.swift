import XCTest
//@testable import TinyPublisher
import Combine // TODO: figure out how to call both Tiny and Combine

final class CatchTests: XCTestCase {
    
    func testTiny() {
        struct SimpleError: Error {}
        let numbers = [5, 4, 3, 2, 1, 0, 9, 8, 7, 6]
        var result: Int? = nil
        _ = numbers.publisher
            .tryLast {
                guard $0 != 0 else {throw SimpleError()}
                return true
            }
            .catch { _ in
                Just(-1)
            }
            .sink { result = $0 }
        
        XCTAssertEqual(-1, result)
    }

    @available(iOS 13.0.0, *)
    func testCombine() {
        struct SimpleError: Error {}
        let numbers = [5, 4, 3, 2, 1, 0, 9, 8, 7, 6]
        var result: Int? = nil
        _ = numbers.publisher
            .tryLast(where: {
                guard $0 != 0 else {throw SimpleError()}
                return true
            })
            .catch({ (error) in
                Just(-1)
            })
            .sink { result = $0 }

        XCTAssertEqual(-1, result)
    }
}
