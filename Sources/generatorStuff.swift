//
//  generatorStuff.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 12/11/2016.
//
//

import Foundation

let comamndAddingPlaceholder = "  // Command adding placeholder, edit this line"

func setupFile() -> String {
  return [
    "import Guaka",
    "",
    "// Generated, dont update",
    "func setupCommands() {",
    comamndAddingPlaceholder,
    "}"
    ].joined(separator: "\n")
}


func mainSwift() -> String {
  return [
    "import Guaka",
    "",
    "setupCommands()",
    "",
    "rootCommand.execute()",
    ].joined(separator: "\n")
}

func commandFile(varName: String, commandName: String) -> String {
  return [
    "import Guaka",
    "" ,
    "var \(varName)Command = Command(",
    "  name: \"\(commandName)\", configuration: configuration, run: execute)",
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
    ].joined(separator: "\n")
}

func updateSetup(path: String, command: String, parent: String?) -> String {
  let s = String.read(contentsOfFile: path)!
  let x = s.find(string: comamndAddingPlaceholder)!
  
  var line = ""
  if let parent = parent {
    line = "  \(parent)Command.add(subCommand: \(command))"
  } else {
    line = "  rootCommand.add(subCommand: \(command))"
  }
  
  let end = s.index(x, offsetBy: comamndAddingPlaceholder.characters.count)
  
  let part1 = s[s.startIndex..<x]
  let part2 = s[end..<s.endIndex]
  
  return part1 + line + "\n\(comamndAddingPlaceholder)" + part2
}
