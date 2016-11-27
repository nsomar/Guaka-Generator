//
//  DirectoryTests.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

import XCTest
@testable import GuakaClILib

class DirectoryStateTests: XCTestCase {

  override func setUp() {
    super.setUp()
    MockDirectoryType.clear()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testReturnNonExistanceDirectories() {
    MockDirectoryType.pathsExistanceValue = ["path": false]
    GuakaCliConfig.dir = MockDirectoryType.self

    let val = DirectoryState.state(forDirectory: "path")
    XCTAssertEqual(val, DirectoryState.nonExisting)
  }

  func testReturnEmptyDirectories() {
    MockDirectoryType.pathsExistanceValue = ["path": true]
    MockDirectoryType.pathsEmptyValue = ["path": true]

    GuakaCliConfig.dir = MockDirectoryType.self

    let val = DirectoryState.state(forDirectory: "path")
    XCTAssertEqual(val, DirectoryState.empty)
  }

  func testReturnHasContentDirectories() {
    MockDirectoryType.pathsExistanceValue = ["path": true]
    MockDirectoryType.pathsEmptyValue = ["path": false]

    GuakaCliConfig.dir = MockDirectoryType.self

    let val = DirectoryState.state(forDirectory: "path")
    XCTAssertEqual(val, DirectoryState.hasContent)
  }

}
