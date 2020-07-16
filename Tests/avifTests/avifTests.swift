import XCTest
@testable import avif

final class avifTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(avif().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
