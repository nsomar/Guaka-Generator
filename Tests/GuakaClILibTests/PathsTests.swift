//
//  PathsTests.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

import XCTest
@testable import GuakaClILib

class PathsTests: XCTestCase {

  override func setUp() {
    super.setUp()
    MockDirectoryType.clear()
    MockFileType.clear()
  }

  func testGenerateSourcePathExample() {
    let p = Paths(rootDirectory: "root")
    XCTAssertEqual(p.rootDirectory, "root")
    XCTAssertEqual(p.sourcesDirectoryPath, "root/Sources")
  }

  func testGetsPackagesFile() {
    let p = Paths(rootDirectory: "root")
    XCTAssertEqual(p.packagesFile, "root/Package.swift")
  }

  func testGetsMainSwiftFile() {
    let p = Paths(rootDirectory: "root")
    XCTAssertEqual(p.mainSwiftFile, "root/Sources/main.swift")
  }

  func testGetsSetupSwiftFile() {
    let p = Paths(rootDirectory: "root")
    XCTAssertEqual(p.setupSwiftFile, "root/Sources/setup.swift")
  }

  func testGetsPathForSwiftFile() {
    let p = Paths(rootDirectory: "root")
    XCTAssertEqual(p.path(forSwiftFile: "abc"), "root/Sources/abc.swift")
  }

  func testGetsProjectName() {
    let p = Paths(rootDirectory: "/root/abcd/ef")
    XCTAssertEqual(p.projectName, "ef")
  }

  func testReturnCurrentPaths() {
    MockDirectoryType.currentDirectory = "/root"

    GuakaCliConfig.dir = MockDirectoryType.self

    let p = Paths.currentPaths
    XCTAssertEqual(p.rootDirectory, "/root")
  }

  func testItChecksIfCurrentIsGuaka() {
    MockDirectoryType.currentDirectory = "/root"
    MockFileType.fileExistanceValue = [
      "/root/Sources": true,
      "/root/Package.swift": true,
      "/root/Sources/main.swift": true,
      "/root/Sources/setup.swift": true,
    ]

    GuakaCliConfig.dir = MockDirectoryType.self
    GuakaCliConfig.file = MockFileType.self

    let p = Paths.currentPaths
    XCTAssertEqual(p.isGuakaDirectory, true)
  }

  func testReturnFalseForGuakaIfSourcesNotThere() {
    MockDirectoryType.currentDirectory = "/root"
    MockFileType.fileExistanceValue = [
      "/root/Sources": false,
      "/root/Package.swift": true,
      "/root/Sources/main.swift": true,
      "/root/Sources/setup.swift": true,
    ]

    GuakaCliConfig.dir = MockDirectoryType.self
    GuakaCliConfig.file = MockFileType.self

    let p = Paths.currentPaths
    XCTAssertEqual(p.isGuakaDirectory, false)
  }

  func testReturnFalseForGuakaIfPackageNotThere() {
    MockDirectoryType.currentDirectory = "/root"
    MockFileType.fileExistanceValue = [
      "/root/Sources": true,
      "/root/Package.swift": false,
      "/root/Sources/main.swift": true,
      "/root/Sources/setup.swift": true,
    ]

    GuakaCliConfig.dir = MockDirectoryType.self
    GuakaCliConfig.file = MockFileType.self

    let p = Paths.currentPaths
    XCTAssertEqual(p.isGuakaDirectory, false)
  }

  func testReturnFalseForGuakaIfSetupNotThere() {
    MockDirectoryType.currentDirectory = "/root"
    MockFileType.fileExistanceValue = [
      "/root/Sources": true,
      "/root/Package.swift": true,
      "/root/Sources/main.swift": true,
      "/root/Sources/setup.swift": false,
    ]

    GuakaCliConfig.dir = MockDirectoryType.self
    GuakaCliConfig.file = MockFileType.self

    let p = Paths.currentPaths
    XCTAssertEqual(p.isGuakaDirectory, false)
  }

  func testReturnFalseForGuakaIfMainNotThere() {
    MockDirectoryType.currentDirectory = "/root"
    MockFileType.fileExistanceValue = [
      "/root/Sources": true,
      "/root/Package.swift": true,
      "/root/Sources/main.swift": false,
      "/root/Sources/setup.swift": true,
    ]

    GuakaCliConfig.dir = MockDirectoryType.self
    GuakaCliConfig.file = MockFileType.self

    let p = Paths.currentPaths
    XCTAssertEqual(p.isGuakaDirectory, false)
  }
  
}
