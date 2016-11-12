//
//  rebase.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka

var newCommand = Command(
  name: "new", configuration: configuration, run: execute)


private func configuration(command: Command) {
  command.longUsage = "guaka new Command-name\nCreates a new command"
  command.example = "guaka new my-command"
}

private func execute(flags: [String: Flag], args: [String]) {
  if args.count != 1 {
    print(newCommand.helpMessage)
    return
  }
  
  let name = args.first!
  let currentDir = "/Users/oabdelhafith/Desktop" //SwiftPath.currentDirectory
  let rootPath = "\(currentDir)/\(name)"
  let sourcesPath = rootPath + "/Sources"
  Directory.create(path: rootPath)
  Directory.create(path: sourcesPath)
  
  let swiftPackage = [
    "import PackageDescription",
    "let package = Package(",
    "  name: \"\(name)\",",
    "  dependencies: [",
    "    .Package(url: \"https://github.com/oarrabi/Guaka.git\", majorVersion: 0),",
    "    ]",
    ")"
  ]
  
  _ = swiftPackage.joined(separator: "\n").write(toFile: rootPath + "/Package.swift")
   
  mainSwift().write(toFile: sourcesPath + "/main.swift")
  
  _ = commandFile(varName: "root", commandName: name).write(toFile: sourcesPath + "/root.swift")
  setupFile().write(toFile: sourcesPath + "/setup.swift")
}
