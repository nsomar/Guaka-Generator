//
//  git.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka

var rootCommand = Command(
  usage: "guaka", configuration: configuration, run: execute)


private func configuration(command: Command) {
  
  command.add(flags: [
    Flag(longName: "version", value: false, inheritable: false),
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
}

private func execute(flags: Flags, args: [String]) {
  print(rootCommand.helpMessage)
}
