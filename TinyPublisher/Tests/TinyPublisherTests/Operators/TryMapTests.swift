import XCTest

#if RUN_UNIT_TESTS_AGAINST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

struct ParseError: Error {}

func romanNumeral(from:Int) throws -> String {
    let romanNumeralDict: [Int : String] =
        [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
    guard let numeral = romanNumeralDict[from] else {
        throw ParseError()
    }
    return numeral
}

final class TryMapTests: XCTestCase {
    
    @available(iOS 13.0.0, *)
    func testTryMap() {

        var s = ""

        let numbers = [5, 4, 3, 2, 1, 0]
        _ = numbers.publisher
            .tryMap { try romanNumeral(from: $0) }
            .sink(
                receiveCompletion: {
                    s = s + "completion: \($0)"
            },
                receiveValue: { s = s + "\($0)" + " "  }
             )

        XCTAssertTrue(s.starts(with: "V IV III II I completion:"))
    }
}
