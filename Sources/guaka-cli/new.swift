//
//  rebase.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka
import FileSystem
import GuakaClILib

var newCommand = Command(
  usage: "new [name or path]", configuration: configuration, run: execute)


private func configuration(command: Command) {
  command.longMessage = [
    "guaka new [name or path]: creates a new guaka command line project.",
    "",
    "The name defines the creation behavior.",
    "If name is not given:",
    "- If the current folder is empty it will be used as the project name",
    "- If the current folder has contents, a guaka project wont be created",
    "",
    "If name or path is given:",
    "- If the name is a relative or absolute path, the project will be created at that path",
    "- If the name is a relative path, the project will be created at that path",
    "- If the name is not a path, a project will be created with that name",
    ].joined(separator: "\n")

  command.shortMessage = "generates a new guaka command line project"

  command.aliases = ["create", "init", "start", "initialize", "generate"]

  command.example = [
    "  Create a guaka project with a name:",
    "    guaka new mycommand",
    "",
    "  Create a guaka project with a name:",
    "    guaka new some/path",
    "    guaka new ~/Desktop/some/path"
    ].joined(separator: "\n")
}

private func execute(flags: Flags, args: [String]) {
  guard args.count <= 1 else {
    newCommand.fail(statusCode: 1, errorMessage: "Received more than 1 argument")
  }

  do {
    let paths = try DirectoryUtilities.paths(forName: args.first)
    try DirectoryUtilities.createDirectoryStrucutre(forName: args.first)

    if
      let created = try? GeneratorParts.packageFile(forCommandName: paths.projectName)
        .write(toFile: paths.packagesFile),
      created == false {
      newCommand.fail(statusCode: 1, errorMessage: "Cannot generate the package file")
    }

    if
      let created = try? GeneratorParts.mainSwiftFileContent()
        .write(toFile: paths.mainSwiftFile),
      created == false {
      newCommand.fail(statusCode: 1, errorMessage: "Cannot generate main swift file")
    }

    if
      let created = try? GeneratorParts.commandFile(forVarName: "root", commandName: paths.projectName)
        .write(toFile: paths.path(forSwiftFile: "root")),
      created == false {
      newCommand.fail(statusCode: 1, errorMessage: "Cannot generate root swift file")
    }

    if
      let created = try? GeneratorParts.setupFileContent()
        .write(toFile: paths.setupSwiftFile),
      created == false {
      newCommand.fail(statusCode: 1, errorMessage: "Cannot generate root swift file")
    }

  } catch let error as GuakaError {
    newCommand.fail(statusCode: 1, errorMessage: error.error)
  } catch {
    newCommand.fail(statusCode: 1, errorMessage: "General error occured")
  }
  
}

