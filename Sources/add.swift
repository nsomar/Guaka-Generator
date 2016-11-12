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
  name: "add", configuration: configuration, run: execute)


private func configuration(command: Command) {
  
  command.add(flags: [
    Flag(longName: "parent", type: String.self, required: false),
    ]
  )
  
  // Other configurations
}

private func execute(flags: Flags, args: [String]) {
  if args.count != 1 {
    print(newCommand.helpMessage)
    return
  }
  
  //FIXME: we should test that we are inside a guaka thing
  let name = args.first!
  let currentDir = "/Users/oabdelhafith/Desktop" //SwiftPath.currentDirectory
  let rootPath = "\(currentDir)/test"
  let sourcesPath = rootPath + "/Sources"
  
  let parent = flags.get(name: "parent", type: String.self)
  _ = commandFile(varName: name, commandName: name).write(toFile: sourcesPath + "/\(name).swift")
  let s = updateSetup(path: sourcesPath + "/setup.swift", command: "\(name)Command", parent: parent)
  s.write(toFile: sourcesPath + "/setup.swift")
}
