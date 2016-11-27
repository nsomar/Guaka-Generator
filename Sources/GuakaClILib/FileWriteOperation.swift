//
//  FileWriteOperation.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 27/11/2016.
//
//

public struct FileOperations {
  let operations: [FileOperation]

  public static func newProjectOperations(paths: Paths) -> FileOperations {
    let operations =  [
      FileWriteOperation(
        fileContent: GeneratorParts.packageFile(forCommandName: paths.projectName),
        filePath: paths.packagesFile,
        errorString: "package"),

      FileWriteOperation(
        fileContent: GeneratorParts.mainSwiftFileContent(),
        filePath: paths.mainSwiftFile,
        errorString: "main swift"),

      FileWriteOperation(
        fileContent: GeneratorParts.commandFile(forVarName: "root", commandName: paths.projectName),
        filePath: paths.path(forSwiftFile: "root"),
        errorString: "root swift"),

      FileWriteOperation(
        fileContent: GeneratorParts.setupFileContent(),
        filePath: paths.setupSwiftFile,
        errorString: "setup swift"),
      ]

    return FileOperations(operations: operations)
  }

  public static func addCommandOperations(paths: Paths,
                                          commandName name: String,
                                          parent: String?) -> FileOperations {

    let setupUpdateBlock = { content in
      try GeneratorParts.updateSetupFile(
        withContent: content,
        byAddingCommand: "\(name)Command",
        withParent: parent)
    }

    let operations: [FileOperation] =  [

      FileUpdateOperation(
        filePath: paths.setupSwiftFile,
        operation: setupUpdateBlock,
        errorString: "setup swift"),

      FileWriteOperation(
        fileContent: GeneratorParts.commandFile(forVarName: name, commandName: name),
        filePath: paths.path(forSwiftFile: name),
        errorString: "\(name) swift"),
      ]

    return FileOperations(operations: operations)
  }

  public func perform() throws {
    try operations.forEach { try $0.perform() }
  }
}

public protocol FileOperation {
  var filePath: String { get }
  var errorString: String { get }
  func perform() throws
}

public struct FileWriteOperation: FileOperation {
  let fileContent: String
  public let filePath: String
  public let errorString: String

  public func perform() throws {

    if GuakaCliConfig.file.write(string: fileContent, toFile: filePath) == false {
      throw GuakaError.cannotCreateFile(errorString)
    }
  }
}

public struct FileUpdateOperation: FileOperation {
  public let filePath: String
  let operation: (String) throws -> (String)
  public let errorString: String

  public func perform() throws {
    guard let fileContent = GuakaCliConfig.file.read(fromFile: filePath) else {
      throw GuakaError.cannotReadFile(filePath)
    }

    let newFileContent = try operation(fileContent)

    if GuakaCliConfig.file.write(string: newFileContent, toFile: filePath) == false {
      throw GuakaError.cannotCreateFile(errorString)
    }
  }
}
