//
//  new.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka
import FileUtils
import GuakaClILib
import Swiftline

var newCommand = Command(
  usage: "new [name or path]", configuration: configuration, run: execute)


private func configuration(command: Command) {
  command.longMessage = [
    "Creates a new guaka command line project.",
    "",
    "The name defines the creation behavior.",
    "If name is not given:",
    "  - If the current folder is empty it will be used as the project name",
    "  - If the current folder has contents, a guaka project wont be created",
    "",
    "If name or path is given:",
    "  - If the name is a relative or absolute path, the project will be created at that path",
    "  - If the name is a relative path, the project will be created at that path",
    "  - If the name is not a path, a project will be created with that name",
    ].joined(separator: "\n")

  command.shortMessage = "Generate a new guaka command line project"

  command.aliases = ["create", "init", "start", "initialize", "generate"]

  command.example = [
    "  Create a guaka project with a name:",
    "    guaka new mycommand",
    "",
    "  Create a guaka project with a path:",
    "    guaka new some/path",
    "    guaka new ~/Desktop/some/path",
    "    guaka new /some/absolute/path"
    ].joined(separator: "\n")
}

private func execute(flags: Flags, args: [String]) {
  do {
    let name = try GeneratorParts.projectName(forPassedArgs: args)
    let paths = try DirectoryUtilities.paths(forName: name)
    try DirectoryUtilities.createDirectoryStrucutre(forName: name)

    try FileOperations.newProjectOperations(paths: paths).perform()

    printNewSuccess(path: paths.rootDirectory, projectName: paths.projectName)
  } catch let error as GuakaError {
    print(error.error)
    print("\nCheck the help for more info:")
    newCommand.fail(statusCode: 1)
  } catch {
    newCommand.fail(statusCode: 1, errorMessage: "General error occured".f.red)
  }

}

private func printNewSuccess(path: String, projectName: String) {
  let message = [
    "A new Guaka project was created at:",
    "  \(path)".f.green,
    "",
    "Next steps:",
    "  - Change into the created project",
    "    cd \(path)".s.italic,
    "",
    "  - Build the project with `\("swift build".s.italic)`",
    "    The binary built will be placed under `\(".build/[debug|release]/\(projectName)".s.underline)`",
    "",
    "    You can run it with:",
    "    .build/debug/\(projectName) -- help".s.italic,
    "",
    "  - Add a sub commands to your project root command using:",
    "    guaka add [command name]".s.italic
  ]

  print(message.joined(separator: "\n"))
}
