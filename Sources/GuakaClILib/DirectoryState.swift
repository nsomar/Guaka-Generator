//
//  DirectoryState.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

enum DirectoryState {
  case empty
  case hasContent
  case nonExisting

  static func state(forDirectory directory: String) -> DirectoryState {
    if GuakaCliConfig.dir.exists(atPath: directory) == false {
      return .nonExisting
    }

    if GuakaCliConfig.dir.isEmpty(directoryPath: directory) {
      return .empty
    } else {
      return .hasContent
    }
  }
}
