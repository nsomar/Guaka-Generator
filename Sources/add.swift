//
//  remote.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka

var addCommand = Command(
  name: "add", parent: rootCommand, configuration: configuration, run: execute)


private func configuration(command: Command) {
  
  command.add(flags: [
    // Add your flags here
    ]
  )
  
  // Other configurations
}

private func execute(flags: [String: Flag], args: [String]) {
  // Execute code here
}
