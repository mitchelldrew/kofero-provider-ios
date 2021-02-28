//
//  Extension.swift
//  provider
//
//  Created by Mitchell Drew on 28/2/21.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

protocol IRestTask {
  func resume()
  func cancel()
}

protocol IRestManager {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession : IRestManager{}
extension URLSessionDataTask : IRestTask{}

protocol IFileManager {
    var currentDirectoryPath: String {get}
    func fileExists(atPath:String) -> Bool
    func contents(atPath:String) -> Data?
}

extension FileManager: IFileManager{}

