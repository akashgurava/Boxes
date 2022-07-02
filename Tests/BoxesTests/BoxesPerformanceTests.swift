//import XCTest
//@testable import Boxes
//
//final class BoxesPerformanceTests: XCTestCase {
//    var box = Box.random
//    var validIndex: String {
//        get {
//            box.one()!.key
//        }
//    }
//    
//    func testGet() throws {
//        measureBlock(label: "Get Known value", tests: 1000) {
//            _ = self.box.get(self.validIndex)
//        }
//        
//        measureBlock(label: "Get Unknown value", tests: 1000) {
//            _ = self.box.get(randomString(10))
//        }
//    }
//    
//    func testSet() throws {
//        measureBlock(label: "Set value") {
//            try! self.box.set(key: "HI", value: "k")
//        }
//    }
//}
