//
//  Paths.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

import FileUtils

public struct Paths {

  public let rootDirectory: String

  public static var currentPaths: Paths {
    let path = GuakaCliConfig.dir.currentDirectory
    return Paths(rootDirectory: path)
  }

  public var sourcesDirectoryPath: String {
    return "\(rootDirectory)/Sources"
  }

  public var packagesFile: String {
    return "\(rootDirectory)/Package.swift"
  }

  public var mainSwiftFile: String {
    return "\(sourcesDirectoryPath)/main.swift"
  }

  public var setupSwiftFile: String {
    return "\(sourcesDirectoryPath)/setup.swift"
  }

  public func path(forSwiftFile name: String) -> String {
    return "\(sourcesDirectoryPath)/\(name).swift"
  }

  public var projectName: String {
    return Path.baseName(forPath: rootDirectory)
  }

  public var isGuakaDirectory: Bool {
    if GuakaCliConfig.file.exists(atPath: sourcesDirectoryPath) &&
      GuakaCliConfig.file.exists(atPath: packagesFile) &&
      GuakaCliConfig.file.exists(atPath: mainSwiftFile) &&
      GuakaCliConfig.file.exists(atPath: setupSwiftFile) {
      return true
    }

    return false
  }

  public func isNewCommand(commandName: String) -> Bool {
    return GuakaCliConfig.file.exists(atPath: path(forSwiftFile: commandName)) == false
  }
  
}
