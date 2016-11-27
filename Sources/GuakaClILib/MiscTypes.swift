//
//  File.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

public struct GuakaCliConfig {
  public static var dir: DirectoryType.Type = FileSystemDirectory.self
  public static var file: FileType.Type = FileSystemFile.self
}


public enum GuakaError: Error {
  case wrongDirectoryGiven(String)
  case triedToCreateProjectInNonEmptyDirectory(String)
  case failedCreatingFolder(String)
  case cannotCreateFile(String)
  case cannotReadFile(String)

  public var error: String {
    switch self {
    case .wrongDirectoryGiven(let path):
      return "The path given cannot be used \(path)"
    case .triedToCreateProjectInNonEmptyDirectory(let path):
      return "Cannot create project in non empty directory \(path)"
    case .failedCreatingFolder(let path):
      return "Failed creating directory \(path)"
    case .cannotCreateFile (let name):
      return "Cannot generate \(name) file"
    case .cannotReadFile(let path):
      return "Cannot read contents of file \(path)"
    }
  }
}
