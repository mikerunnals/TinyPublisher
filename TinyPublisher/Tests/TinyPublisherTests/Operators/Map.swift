import XCTest
@testable import TinyPublisher
import Combine

final class MapTests: XCTestCase {
    
    func testTiny() {
        
        var s = ""
        
        let numbers = [5, 4, 3, 2, 1, 0]
        let romanNumeralDict: [Int : String] =
           [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
        
        let subject = TinyPublisher.PassthroughSubject<Int, Never>()
        let publisher = subject.eraseToAnyPublisher()
        
        _ = publisher
            .map { romanNumeralDict[$0] ?? "(unknown)" }
            .sink { s = s + "\($0)" + " " }
        
        numbers.forEach { subject.send($0) }
        
        XCTAssertEqual("V IV III II I (unknown) ", s)

        // Prints: "V IV III II I (unknown)"
    }

    
    @available(iOS 13.0.0, *)
    func testCombine() {
        
        var s = ""
        
        let numbers = [5, 4, 3, 2, 1, 0]
        let romanNumeralDict: [Int : String] =
           [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
        _ = numbers.publisher
            .map { romanNumeralDict[$0] ?? "(unknown)" }
            .sink { s = s + "\($0)" + " " }
        
        XCTAssertEqual("V IV III II I (unknown) ", s)

        // Prints: "V IV III II I (unknown)"
    }
}
