
import Foundation

struct CombineIdentifier : CustomStringConvertible, Equatable, Hashable {
    
    var description: String {
        identifier.description
    }
    
    private let identifier: UUID
    
    public init() {
        identifier = UUID()
    }
    
    public init(_ object: AnyObject) {
        // TODO: hash AnyObject to a UUID
        identifier = UUID()
    }
}
