import XCTest

#if RUN_UNIT_TESTS_AGAINST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

final class MapTests: XCTestCase {
    
    @available(iOS 13.0.0, *)
    func testMapIntToRomanNumeral() {
        
        var s = ""
        
        let numbers = [5, 4, 3, 2, 1, 0]
        let romanNumeralDict: [Int : String] =
           [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
        _ = numbers.publisher.eraseToAnyPublisher()
            .map { romanNumeralDict[$0] ?? "(unknown)" }
            .sink { s = s + "\($0)" + " " }
        
        XCTAssertEqual("V IV III II I (unknown) ", s)

        // Prints: "V IV III II I (unknown)"
    }
}
