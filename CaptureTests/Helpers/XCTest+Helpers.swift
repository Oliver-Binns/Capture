import XCTest

extension XCTestCase {
    func wait(for predicate: @autoclosure @escaping () -> Bool,
              timeout: TimeInterval = 3) {
        let exp = expectation(for: .init { _,_ in
            predicate()
        }, evaluatedWith: nil)
        
        wait(for: [exp], timeout: timeout)
    }
}
