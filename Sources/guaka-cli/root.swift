//
//  git.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka

var rootCommand = try! Command(
  usage: "guaka", configuration: configuration, run: execute)


private func configuration(command: Command) {
  
  command.add(flags: [
    try! Flag(longName: "version", value: false, inheritable: false,
              description: "Prints the version"),
    ]
  )
  
  command.inheritablePreRun = { flags, args in
    if
      let version = flags["version"]?.value as? Bool,
      version {
      print("Version \(Constants.version)")
      return false
    } 
    return true
  }

  command.longMessage = [
    "Guaka is a command line application and Swift library to help you create your command line apps.",
    "",
    "You can use `guaka` app to generate your Guaka project strucuter.",
    "The project generate will be a Swift Package Manager application.",
    "",
    "Use `guaka new --help` to read more on how to generate your project."
    ].joined(separator: "\n")
}

private func execute(flags: Flags, args: [String]) {
  print(rootCommand.helpMessage)
}
