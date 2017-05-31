import XCTest
@testable import Storage

class StorageTests : XCTestCase {
    
    func testStorage() {
        guard let storage = try? Storage() else { return }
        XCTAssertNotNil(storage)
        
        XCTAssertNoThrow( try storage.store("foo","bar") )
    
        guard let results = try? storage.fetch("foo") else { return }
        XCTAssertNotNil(results)
        
        XCTAssertNoThrow( try storage.delete("foo") )
    }
}
