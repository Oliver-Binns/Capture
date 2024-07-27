import SwiftUI

enum FilmSpeed: Int, Codable, CaseIterable, Identifiable {
    var id: Int {
        rawValue
    }

    case oneHundred = 100
    case twoHundred = 200
    case fourHundred = 400
    case eightHundred = 800
    case sixteenHundred = 1600
}
