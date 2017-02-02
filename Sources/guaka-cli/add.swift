//
//  add.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka
import FileUtils
import GuakaClILib

var addCommand = Command(
  usage: "add CommandName", configuration: configuration, run: execute)


private func configuration(command: Command) {

  command.add(flags: [
    Flag(shortName: "p", longName: "parent", value: "root", description: "Adds a new command to the Guaka project")
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
    "",
    "  Adding a command creates a new swift file under `Sources` folder",
    "    `guaka add sub-command` creates `Sources/sub-command.swift`"
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
    try FileOperations.addCommandOperations(paths: paths, commandName: name, parent: parent)
      .perform()

    printAddSuccess(
      setupFile: paths.setupSwiftFile,
      commandFile: paths.path(forSwiftFile: name),
      projectName: paths.projectName,
      commandName: name
    )

  } catch let error as GuakaError {
    addCommand.fail(statusCode: 1, errorMessage: error.error)
  } catch {
    addCommand.fail(statusCode: 1, errorMessage: "General error occured")
  }
}

private func printAddSuccess(setupFile: String, commandFile: String, projectName: String, commandName: String) {
  let message = [
    "A new Command has been created at:",
    "  \(commandFile)".f.green,
    "",
    "Setup file has been updated at:",
    "  \(setupFile)".f.green,
    "",
    "Next steps:",
    "  - Build the project with `\("swift build".s.italic)`",
    "    The binary built will be placed under `\(".build/[debug|release]/\(projectName)".s.underline)`",
    "",
    "  - Test the command added, you can run it with:",
    "    .build/debug/\(projectName) \(commandName)".s.italic,
    ]

  print(message.joined(separator: "\n"))
}
