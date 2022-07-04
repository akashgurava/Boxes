import XCTest
import BinaryCodable
@testable import Boxes

final class BoxMetaTests: XCTestCase {
    func testBoxMetaInit() throws {
        XCTAssertNoThrow(try BoxMeta(columns: ["Hi", "Hello", "nil", "0", "TEST"]))
        XCTAssertThrowsError(
            try BoxMeta(columns: ["Hi ", "Hello", " nil", "0", "TEST"]),
            "Extra space at the end of column name should raise an error.")
        XCTAssertThrowsError(
            try BoxMeta(columns: ["Hi", "  Hello", " nil", "0", "TEST"]),
            "Extra space at the beginning of column name should raise an error.")
    }

    func testFileBsonIOCoder() throws {
        let meta = try! BoxMeta(columns: ["Hi", "Hello", "nil", "0", "TEST"])
        let box = Box(meta: meta)
        let file = BsonIOCoder(path: "/Users/akash/bajat.bson")

        XCTAssertNoThrow(try file.write(box))
        XCTAssertNoThrow(try file.readMeta())
        XCTAssertEqual(meta, try file.readMeta())
    }
}
