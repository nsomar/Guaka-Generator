//
//  directoryStuff.swift
//  guaka-cli
//
//  Created by Omar Abdelhafith on 12/11/2016.
//
//

import Foundation
import SwiftFile

#if os(Linux)
  @_exported import Glibc
#else
  @_exported import Darwin.C
#endif

enum Directory {
  
  @discardableResult
  static func create(path: String) -> Bool {
    return mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO) == 0
  }
  
}

import SwiftFile

extension SwiftPath {
  public static var currentDirectory: String {
    var arr: [Int8] = Array(repeating: 0, count: 1024)
    guard let curr = getcwd(&arr, 1024) else { return "" }
    
    return String(cString: curr)
  }
}
