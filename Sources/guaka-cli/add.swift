//
//  remote.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka
import FileSystem
import GuakaClILib

var addCommand = Command(
  usage: "add", configuration: configuration, run: execute)


private func configuration(command: Command) {

  command.add(flags: [
    Flag(longName: "parent", shortName: "p", value: "root", description: "Adds a new command to the Guaka project")
    ]
  )

  command.longMessage = [
    "Adds a new Guaka command to your Guaka project.",
    "",
    "By default the command will be added as a sub command to the root command.",
    "You can pass a different parent command by using the `--parent name` flag."
    ].joined(separator: "\n")

  command.shortMessage = "Add a new Guaka command to the Guaka project"

  command.aliases = ["command", "append"]

  command.example = [
    "  Add a new command to the root command:",
    "    guaka add new-command",
    "",
    "  Add a new command to a different parent command:",
    "    guaka add new-command --parent other-command",
    "    guaka add new-command -p other-command",
    ].joined(separator: "\n")
}

private func execute(flags: Flags, args: [String]) {
  do {
    let name = try GeneratorParts.commandName(forPassedArgs: args)

    let paths = Paths.currentPaths

    guard paths.isGuakaDirectory else {
      throw GuakaError.notAGuakaProject
    }

    let parent = flags.get(name: "parent", type: String.self)
    try FileOperations.newCommandOperations(paths: paths, commandName: name, parent: parent)
      .perform()

  } catch let error as GuakaError {
    newCommand.fail(statusCode: 1, errorMessage: error.error)
  } catch {
    newCommand.fail(statusCode: 1, errorMessage: "General error occured")
  }
}
