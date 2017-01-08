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
    let updated = try! GeneratorParts.updateSetupFile(withContent: file, byAddingCommand: "new", withParent: nil)
    XCTAssertEqual(updated, "import Guaka\n\n// Generated, dont update\nfunc setupCommands() {\n  rootCommand.add(subCommand: new)\n  // Command adding placeholder, edit this line\n}")
  }

  func testUpdatesSetupWihtParentFile() {
    let file = GeneratorParts.setupFileContent()
    let updated = try! GeneratorParts.updateSetupFile(withContent: file, byAddingCommand: "new", withParent: "root")
    XCTAssertEqual(updated, "import Guaka\n\n// Generated, dont update\nfunc setupCommands() {\n  rootCommand.add(subCommand: new)\n  // Command adding placeholder, edit this line\n}")
  }

  func testItThrowsErrorIfCannotFindThePlaceholder() {
    do {
      _ = try GeneratorParts.updateSetupFile(withContent: "abcd", byAddingCommand: "new", withParent: "root")
    } catch let e as GuakaError {
      XCTAssertEqual(e.error, "Guaka setup.swift file has been altered.\nThe placeholder used to insert commands cannot be found   // Command adding placeholder, edit this line.\nYou can try to add it yourself by updating `setup.swift` to look like\n\nimport Guaka\n\n// Generated, dont update\nfunc setupCommands() {\n  // Command adding placeholder, edit this line\n}\n\nAdding command wont be possible.")
    } catch {
      XCTFail()
    }
  }

  func testCanUpdateFileMultipleTimes() {
    let file = GeneratorParts.setupFileContent()
    var updated = try! GeneratorParts.updateSetupFile(withContent: file, byAddingCommand: "new1", withParent: "root")

    updated = try! GeneratorParts.updateSetupFile(withContent: updated, byAddingCommand: "new2")

    updated = try! GeneratorParts.updateSetupFile(withContent: updated, byAddingCommand: "new3")

    XCTAssertEqual(updated, "import Guaka\n\n// Generated, dont update\nfunc setupCommands() {\n  rootCommand.add(subCommand: new1)\n  rootCommand.add(subCommand: new2)\n  rootCommand.add(subCommand: new3)\n  // Command adding placeholder, edit this line\n}")
  }

  func testItGetsNameIfCorrect() {
    let name = try! GeneratorParts.commandName(forPassedArgs: ["name"])
    XCTAssertEqual(name, "name")
  }

  func testItThrowsErrorIfArgsIsEmpty() {
    do {
      _ = try GeneratorParts.commandName(forPassedArgs: [])
    } catch let e as GuakaError {
      XCTAssertEqual(e.error, "`guaka add` requires a command that was not given.\nCall `guaka add CommandName` to create a new command.\n")
    } catch {
      XCTFail()
    }
  }

  func testItThrowsErrorIfMoreThan1ArgsArePassed() {
    do {
      _ = try GeneratorParts.commandName(forPassedArgs: ["a", "b"])
    } catch let e as GuakaError {
      XCTAssertEqual(e.error, "Too many arguments passed to command.")
    } catch {
      XCTFail()
    }
  }

  func testItThrowsErrorIfWrongNamePassed() {
    do {
      _ = try GeneratorParts.commandName(forPassedArgs: ["abc def"])
    } catch let e as GuakaError {
      XCTAssertEqual(e.error, "The command name passed `abc def` is incorrect.\nPlease use only letters, numbers, underscodes and dashes.\n\nValid examples:\n   guaka new test\n   guaka new MyCommand\n   guaka new my-command\n   guaka new my_command\n   guaka new myCommand")
    } catch {
      XCTFail()
    }
  }

  func testItReturnsNilIfProjctNameIsEmpty() {
    let name = try! GeneratorParts.projectName(forPassedArgs: [])
    XCTAssertNil(name)
  }

  func testItReturnsNameIfProjectNameIsCorrect() {
    let name = try! GeneratorParts.projectName(forPassedArgs: ["abc"])
    XCTAssertEqual(name, "abc")
  }

  func testItThrowsErrorIfProjectNameContainsSpaces() {
    do {
      _ = try GeneratorParts.projectName(forPassedArgs: ["abc asdsa"])
    } catch GuakaError.wrongCommandNameFormat {
    } catch {
      XCTFail()
    }
  }

  func testItThrowsErrorIfProjectReceivedTooManyArgs() {
    do {
      _ = try GeneratorParts.projectName(forPassedArgs: ["abc", "asdsa"])
    } catch GuakaError.tooManyArgsPassed {
    } catch {
      XCTFail()
    }
  }
}

