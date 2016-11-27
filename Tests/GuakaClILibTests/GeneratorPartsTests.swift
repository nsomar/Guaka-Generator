//
//  GeneratorPartsTests.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

import XCTest
@testable import GuakaClILib

class GeneratorPartsTests: XCTestCase {


  func testGeneratesCommandFile() {
    let file = GeneratorParts.commandFile(forVarName: "test", commandName: "testit")
    XCTAssertEqual(file, "import Guaka\n\nvar testCommand = Command(\n  usage: \"testit\", configuration: configuration, run: execute)\n\n\nprivate func configuration(command: Command) {\n\n  command.add(flags: [\n    // Add your flags here\n    ]\n  )\n\n  // Other configurations\n}\n\nprivate func execute(flags: Flags, args: [String]) {\n  // Execute code here\n  print(\"testit called\")\n}")
  }

  func testGeneratesPackageFile() {
    let file = GeneratorParts.packageFile(forCommandName: "test")
    XCTAssertEqual(file, "import PackageDescription\nlet package = Package(\n  name: \"test\",\n  dependencies: [\n    .Package(url: \"https://github.com/oarrabi/Guaka.git\", majorVersion: 0),\n    ]\n)")
  }

  func testGeneratesMainFile() {
    let file = GeneratorParts.mainSwiftFileContent()
    XCTAssertEqual(file, "import Guaka\n\nsetupCommands()\n\nrootCommand.execute()")
  }

  func testGeneratesSetupFile() {
    let file = GeneratorParts.setupFileContent()
    XCTAssertEqual(file, "import Guaka\n\n// Generated, dont update\nfunc setupCommands() {\n  // Command adding placeholder, edit this line\n}")
  }

  func testUpdatesSetupWihtoutParentFile() {
    let file = GeneratorParts.setupFileContent()
    let updated = GeneratorParts.updateSetupFile(withContent: file, byAddingCommand: "new", withParent: nil)
    XCTAssertEqual(updated, "import Guaka\n\n// Generated, dont update\nfunc setupCommands() {\n  rootCommand.add(subCommand: new)\n  // Command adding placeholder, edit this line\n}")
  }

  func testUpdatesSetupWihtParentFile() {
    let file = GeneratorParts.setupFileContent()
    let updated = GeneratorParts.updateSetupFile(withContent: file, byAddingCommand: "new", withParent: "root")
    XCTAssertEqual(updated, "import Guaka\n\n// Generated, dont update\nfunc setupCommands() {\n  rootCommand.add(subCommand: new)\n  // Command adding placeholder, edit this line\n}")
  }

  func testCanUpdateFileMultipleTimes() {
    let file = GeneratorParts.setupFileContent()
    var updated = GeneratorParts.updateSetupFile(withContent: file, byAddingCommand: "new1", withParent: "root")

    updated = GeneratorParts.updateSetupFile(withContent: updated, byAddingCommand: "new2")

    updated = GeneratorParts.updateSetupFile(withContent: updated, byAddingCommand: "new3")

    XCTAssertEqual(updated, "import Guaka\n\n// Generated, dont update\nfunc setupCommands() {\n  rootCommand.add(subCommand: new1)\n  rootCommand.add(subCommand: new2)\n  rootCommand.add(subCommand: new3)\n  // Command adding placeholder, edit this line\n}")
  }
}

