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
  guard let name = args.first,
    args.count == 1 else {
      addCommand.fail(statusCode: 1, errorMessage: "New command name was not passed")
  }

  do {
    let parent = flags.get(name: "parent", type: String.self)

    let paths = Paths.currentPaths
    
    guard paths.isGuakaDirectory else {
      addCommand.fail(statusCode: 1, errorMessage: "This command can only be executed in a Guaka project.\nThe following directory does not contain guaka files")
    }

    let commandFile = GeneratorParts.commandFile(forVarName: name, commandName: name)
    let setupFile = try GeneratorParts.updateSetupFile(
      atPath: paths.setupSwiftFile,
      byAddingCommand: "\(name)Command",
      withParent: parent)

    if let created = try? commandFile.write(toFile: paths.path(forSwiftFile: name)),
      created == false {
      throw GuakaError.cannotCreateFile("\(name) swift")
    }

    if let created = try? setupFile.write(toFile: paths.setupSwiftFile),
      created == false {
      throw GuakaError.cannotCreateFile("root swift")
    }

  } catch let error as GuakaError {
    newCommand.fail(statusCode: 1, errorMessage: error.error)
  } catch {
    newCommand.fail(statusCode: 1, errorMessage: "General error occured")
  }
}
