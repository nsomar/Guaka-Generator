//
//  generatorStuff.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 12/11/2016.
//
//

import StringScanner
import FileUtils


public enum GeneratorParts {

  public static let comamndAddingPlaceholder = "  // Command adding placeholder, edit this line"

  public static let importGuaka = "import Guaka"
  public static let importPackageDescription = "import PackageDescription"

  public static let guakaURL = "https://github.com/oarrabi/Guaka.git"
  public static let guakaVersion = "0"

  public static let generatedComment = "// Generated, dont update"

  public static func setupFileContent() -> String {
    return [
      importGuaka,
      "",
      generatedComment,
      "func setupCommands() {",
      comamndAddingPlaceholder,
      "}",
      ""
      ].joined(separator: "\n")
  }


  public static func mainSwiftFileContent() -> String {
    return [
      importGuaka,
      "",
      "setupCommands()",
      "",
      "rootCommand.execute()",
      ""
      ].joined(separator: "\n")
  }

  public static func commandFile(forVarName varName: String, commandName: String) -> String {
    return [
      importGuaka,
      "" ,
      "var \(varName)Command = Command(",
      "  usage: \"\(commandName)\", configuration: configuration, run: execute)",
      "",
      "",
      "private func configuration(command: Command) {",
      "" ,
      "  command.add(flags: [",
      "    // Add your flags here",
      "    ]",
      "  )",
      ""  ,
      "  // Other configurations",
      "}",
      "",
      "private func execute(flags: Flags, args: [String]) {",
      "  // Execute code here",
      "  print(\"\(commandName) called\")",
      "}",
      ""
      ].joined(separator: "\n")
  }

  public static func packageFile(forCommandName name: String) -> String {
    return [
      importPackageDescription,
      "let package = Package(",
      "  name: \"\(name)\",",
      "  dependencies: [",
      "    .Package(url: \"\(guakaURL)\", majorVersion: \(guakaVersion)),",
      "    ]",
      ")",
      ""
      ].joined(separator: "\n")
  }

  public static func updateSetupFile(withContent content: String,
                                     byAddingCommand command: String,
                                     withParent parent: String? = nil) throws -> String {

    guard let indexFound = content.find(string: comamndAddingPlaceholder) else {
      throw GuakaError.setupFileAltered
    }

    var line = ""
    if let parent = parent {
      line = "  \(parent)Command.add(subCommand: \(command))"
    } else {
      line = "  rootCommand.add(subCommand: \(command))"
    }

    let end = content.index(indexFound, offsetBy: comamndAddingPlaceholder.characters.count)

    let part1 = content[content.startIndex..<indexFound]
    let part2 = content[end..<content.endIndex]

    return part1 + line + "\n\(comamndAddingPlaceholder)" + part2
  }

  public static func commandName(forPassedArgs args: [String]) throws -> String {
    guard let name = args.first else {
      throw GuakaError.missingCommandName
    }

    guard args.count == 1 else {
      throw GuakaError.tooManyArgsPassed
    }

    if name.characters.contains(" ") {
      throw GuakaError.wrongCommandNameFormat(name)
    }

    return name
  }

  public static func projectName(forPassedArgs args: [String]) throws -> String? {
    switch args.count {
    case 0:
      return nil

    case 1:
      let name = args.first!
      if name.characters.contains(" ") {
        throw GuakaError.wrongCommandNameFormat(name)
      }
      return name

    default:
      throw GuakaError.tooManyArgsPassed
    }
  }
}
