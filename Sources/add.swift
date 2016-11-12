//
//  remote.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka
import SwiftFile

var addCommand = Command(
  name: "add", parent: rootCommand, configuration: configuration, run: execute)


private func configuration(command: Command) {
  
  command.add(flags: [
    Flag(longName: "parent", type: String.self, required: false),
    ]
  )
  
  // Other configurations
}

private func execute(flags: [String: Flag], args: [String]) {
  if args.count != 1 {
    print(newCommand.helpMessage)
    return
  }
  
  //FIXME: we should test that we are inside a guaka thing
  let name = args.first!
  let currentDir = "/Users/oabdelhafith/Desktop" //SwiftPath.currentDirectory
  let rootPath = "\(currentDir)/test"
  let sourcesPath = rootPath + "/Sources"
  
  _ = commandFile(varName: name, commandName: name).write(toFile: sourcesPath + "/\(name).swift")
  let s = updateSetup(path: sourcesPath + "/setup.swift", command: "\(name)Command", parent: flags["parent"] as? String)
  s.write(toFile: sourcesPath + "/setup.swift")
}
