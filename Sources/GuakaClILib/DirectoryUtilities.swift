//
//  Directory.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

import FileSystem


public enum DirectoryUtilities {

  public static func paths(forName name: String?) throws -> Paths {
    let directory = try currentDirectory(forName: name)
    return Paths(rootDirectory: directory)
  }

  public static func createDirectoryStrucutre(forName name: String?) throws {
    let directory = try currentDirectory(forName: name)
    let paths = Paths(rootDirectory: directory)

    let directoryState = DirectoryState.state(forDirectory: directory)

    try createDirectoryStructure(paths: paths, directoryState: directoryState)
  }

  static func currentDirectory(forName name: String?) throws -> String {
    let currentPath = GuakaCliConfig.dir.currentDirectory

    guard let name = name else {
      return currentPath
    }

    var path = ""

    if
      let firstChar = name.characters.first,
      firstChar == "/" {
      path = name
    } else {
      path = currentPath + "/" + name
    }

    if GuakaCliConfig.dir.isValidDirectory(atPath: path) &&
      GuakaCliConfig.dir.isEmpty(directoryPath: path) == false {
      throw GuakaError.wrongDirectoryGiven(path)
    }

    return path
  }

  static func createDirectoryStructure(paths: Paths, directoryState: DirectoryState) throws {

    if directoryState == .hasContent {
      throw GuakaError.triedToCreateProjectInNonEmptyDirectory(paths.rootDirectory)
    }

    if directoryState == .nonExisting &&
      GuakaCliConfig.dir.create(atPath: paths.rootDirectory) == false {
      throw GuakaError.failedCreatingFolder(paths.rootDirectory)
    }

    if GuakaCliConfig.dir.create(atPath: paths.sourcesDirectoryPath) == false {
      throw GuakaError.failedCreatingFolder(paths.sourcesDirectoryPath)
    }
  }
  
  
}
