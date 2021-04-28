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

extension Int32 {
    func toKotlinInt() -> KotlinInt {
        return KotlinInt(value: self)
    }
}

public protocol IUserDefaults {
    func set(_:Any?, forKey:String)
    func object(forKey:String) -> Any?
    func removeObject(forKey:String)
}

extension UserDefaults: IUserDefaults {}

public protocol IRestTask {
  func resume()
  func cancel()
}

public protocol IRestManager {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension KotlinException {
    convenience init(error:Error){
        self.init(message: error.localizedDescription)
    }
}

extension URLSession : IRestManager{}
extension URLSessionDataTask : IRestTask{}

public protocol IFileManager {
    var currentDirectoryPath: String {get}
    func contents(atPath:String) -> Data?
    func createFile(atPath: String, contents: Data?, attributes: [FileAttributeKey : Any]?) -> Bool
    func removeItem(atPath: String) throws
}

extension FileManager: IFileManager{}

protocol HasApply { }

extension HasApply {
    func apply(closure:(Self) -> ()) -> Self {
        closure(self)
        return self
    }
}

extension ModelGame{
    var charIds: [Int32] {
        var ret = [Int32]()
        for charId in self.characterIds {
            ret.append(charId.int32Value)
        }
        return ret
    }
}

extension ModelCharacter{
    var mvIds: [Int32] {
        var ret = [Int32]()
        for moveId in self.moveIds {
            ret.append(moveId.int32Value)
        }
        return ret
    }
}

extension Provider{
    func get(ids:[Int32]){
        var kIds = [KotlinInt]()
        for int in ids{
            kIds.append(int.toKotlinInt())
        }
        get(ids: kIds)
    }
}

