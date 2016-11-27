//
//  MockDirectoryType.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

@testable import GuakaClILib

struct MockDirectoryType: DirectoryType {
  static var currentDirectory: String = ""
  static var pathsCreated: [String] = []

  static var pathsEmptyValue: [String: Bool] = [:]
  static var pathsCreationValue: [String: Bool] = [:]
  static var pathsValidationValue: [String: Bool] = [:]
  static var pathsExistanceValue: [String: Bool] = [:]

  static func clear() {
    currentDirectory = ""
    pathsCreated = []
    pathsEmptyValue = [:]
    pathsCreationValue = [:]
    pathsValidationValue = [:]
    pathsExistanceValue = [:]
  }

  static func isEmpty(directoryPath: String) -> Bool {
    return pathsEmptyValue[directoryPath] ?? false
  }

  static func create(atPath path: String) -> Bool {
    pathsCreated.append(path)
    return pathsCreationValue[path] ?? false
  }

  static func isValidDirectory(atPath path: String) -> Bool {
    return pathsValidationValue[path] ?? false
  }

  static func exists(atPath path: String) -> Bool {
    return pathsExistanceValue[path] ?? false
  }
}

struct MockFileType: FileType {

  static var fileExistanceValue: [String: Bool] = [:]
  static var fileReadValue: [String: String] = [:]
  static var fileWriteValue: [String: Bool] = [:]

  static var writtenFiles: [String: String] = [:]

  static func clear() {
    fileExistanceValue = [:]
    fileReadValue = [:]
    fileWriteValue = [:]
    writtenFiles = [:]
  }

  static func write(string: String, toFile file: String) -> Bool {
    writtenFiles[file] = string
    return fileWriteValue[file] ?? false
  }

  static func read(fromFile file: String) -> String? {
    return fileReadValue[file]
  }

  static func exists(atPath path: String) -> Bool {
    return fileExistanceValue[path] ?? false
  }
  
}
