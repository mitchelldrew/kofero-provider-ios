//
//  Extension.swift
//  provider
//
//  Created by Mitchell Drew on 28/2/21.
//

import Foundation
import presenter

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

public protocol IRestTask {
  func resume()
  func cancel()
}

public protocol IRestManager {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession : IRestManager{}
extension URLSessionDataTask : IRestTask{}

public protocol IFileManager {
    var currentDirectoryPath: String {get}
    func fileExists(atPath:String) -> Bool
    func contents(atPath:String) -> Data?
}

extension FileManager: IFileManager{}

