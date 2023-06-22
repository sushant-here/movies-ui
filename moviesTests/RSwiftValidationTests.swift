//
//  RSwiftValidationTests.swift
//  moviesTests
//
//  Created by Sushant Verma on 22/6/2023.
//

import XCTest
@testable import movies

/// Recommended tests to check integrity of RSwift...
/// SEE: https://github.com/mac-cain13/R.swift/blob/main/Documentation/Examples.md#runtime-validation
final class RSwiftValidationTests: XCTestCase {

    func testCheckUnitTestTarget() throws {
        XCTAssertNoThrow(try R.validate())
    }

    func testCheckAppTestTarget() throws {
        XCTAssertNoThrow(try movies.R.validate())
    }
}
