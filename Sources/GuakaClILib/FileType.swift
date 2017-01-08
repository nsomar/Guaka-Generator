//
//  FileType.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

import FileSystem

public protocol FileType {
  static func write(string: String, toFile file: String) -> Bool
  static func read(fromFile file: String) -> String?
  static func exists(atPath path: String) -> Bool
}

public struct FileSystemFile: FileType {

  public static func write(string: String, toFile file: String) -> Bool {
    return (try? string.write(toFile: file)) ?? false
  }

  public static func read(fromFile file: String) -> String? {
    if let string = try? String.read(contentsOfFile: file) {
      return string
    }
    return nil
  }

  public static func exists(atPath path: String) -> Bool {
    return Path.exists(path)
  }
  
}
