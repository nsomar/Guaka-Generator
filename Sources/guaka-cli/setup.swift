//
//  setup.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 12/11/2016.
//
//

import Guaka


func setupCommands() {
  rootCommand.add(subCommand: newCommand)
  rootCommand.add(subCommand: addCommand)
}
