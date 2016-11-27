//
//  DirectoryType.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

import FileSystem

public protocol DirectoryType {
  static var currentDirectory: String { get }
  static func isEmpty(directoryPath: String) -> Bool
  static func create(atPath path: String) -> Bool
  static func isValidDirectory(atPath path: String) -> Bool
  static func exists(atPath path: String) -> Bool
}

public struct FileSystemDirectory: DirectoryType {

  public static func isEmpty(directoryPath: String) -> Bool {
    guard let (files, directories) = Directory.contents(ofDirectory: directoryPath) else {
      return true
    }

    return (files.count + directories.count) == 0
  }

  public static var currentDirectory: String {
    return Path.currentDirectory
  }

  public static func create(atPath path: String) -> Bool {
    return Directory.create(atPath: path)
  }

  public static func isValidDirectory(atPath path: String) -> Bool {
    return Path.type(ofPath: path) == .directory
  }

  public static func exists(atPath path: String) -> Bool {
    return Path.exists(path)
  }
  
}
