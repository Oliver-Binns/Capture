import Foundation

extension Photo: Comparable {
    static func < (lhs: Photo, rhs: Photo) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}
