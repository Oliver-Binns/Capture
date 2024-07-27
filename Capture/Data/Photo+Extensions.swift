import Foundation

extension Photo: Comparable {
    static func < (lhs: Photo, rhs: Photo) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
}

