//
//  Provider.swift
//  provider
//
//  Created by Mitchell Drew on 1/4/21.
//

import Foundation
import presenter

open class Provider<O:ModelObj>: IProvider {
    private var listeners = [IProviderListener]()
    private let restManager: IRestManager
    private let fileManager: IFileManager
    private let userDefaults: IUserDefaults
    private let encoder:IDataEncoder<[Int32]>
    private var elements = [O]()
    private let url:URL
    private let mapper:IDataMapper<[O]>
    private var isDiskPulled = false
    private var requests = [[KotlinInt]]()
    private var jsonFilename: String
    
    public init(core:ProviderCore, url:URL, mapper:IDataMapper<[O]>, jsonFilename:String){
        self.fileManager = core.fileManager
        self.restManager = core.restManager
        self.userDefaults = core.userDefaults
        self.encoder = core.requestEncoder
        self.url = url
        self.mapper = mapper
        self.jsonFilename = jsonFilename
    }
    
    private func isResponseGood(data:Data?, response:URLResponse?, error:Error?) -> Bool {
        return data != nil && (response as! HTTPURLResponse).statusCode == 200 && error == nil
    }
    
    private func isSatisfiable(request: [KotlinInt]) -> Bool {
        for id in request {
            if(!elements.contains(where: {element in return element.id == id.int32Value})){ return false }
        }
        return true
    }
    
    public func get(ids: [KotlinInt]) {
        if(!isDiskPulled){ pullFromDisk(ids: ids) }
        else{
            if(isSatisfiable(request: ids)){ informListeners(ids: ids, elements: retrieve(ids: ids)) }
            else{
                requests.append(ids)
                restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids)).resume()
            }
        }
    }
    
    private func add(new:[O]){
        for element in new {
            elements.removeAll(where: {existingElement in return element.id == existingElement.id})
            elements.append(element)
        }
    }
    
    private func getRestClosure(ids: [KotlinInt]) -> RestClosure {
        return {[self] data, response, error in
            if(isResponseGood(data:data, response:response, error:error)){
                do{ add(new: try mapper.map(data: data!)) }
                catch { informListenersError(ids: ids, error: KotlinException(message: error.localizedDescription)) }
            }
            else{
                informListenersError(ids: ids, error: KotlinException(message: "error:\(error.debugDescription), response: \(response.debugDescription)"))
            }
        }
    }
    
    private func createRequest(ids: [KotlinInt]) -> URLRequest {
        var ret = URLRequest(url: url)
        var ids32 = [Int32]()
        for id in ids{ ids32.append(id.int32Value) }
        do{
            try ret.httpBody = encoder.encode(ids32)
        }
        catch {
            informListenersError(ids: ids, error: KotlinException(message: "request body encoding failed"))
        }
        return ret
    }
    
    
    private func retrieve(ids: [KotlinInt]) -> [O] {
        var ret = [O]()
        for id in ids {
            ret.append(elements.first(where: {element in return element.id == id.int32Value})!)
        }
        return ret
    }
    
    private func pullFromDisk(ids: [KotlinInt]) {
        isDiskPulled = true
        requests.append(ids)
        if let path = Bundle.main.path(forResource: jsonFilename, ofType: "json") {
            do {
                elements = try mapper.map(data: Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped))
            } catch let error { informListenersError(ids: ids, error: KotlinException(error: error)) }
        } else {
            informListenersError(ids: ids, error: KotlinException(message: "invalid json filename: \(jsonFilename)"))
        }
        if let json = fileManager.contents(atPath: fileManager.currentDirectoryPath + jsonFilename) {
            do{
                elements = try mapper.map(data: json)
            }
            catch {
                informListenersError(ids: ids, error: KotlinException(message: "serialization error"))
            }
        }
        restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids)).resume()
    }
    
    
    public func addListener(listener: IProviderListener) {
        listeners.append(listener)
    }
    
    public func removeListener(listener: IProviderListener) {
        listeners.removeAll{compListener in return listener === compListener}
    }
    
    private func informListeners(ids: [KotlinInt], elements: [O]) {
        for listener in listeners{
            listener.onReceive(ids: ids, elements: elements)
        }
    }
    
    private func informListenersError(ids: [KotlinInt], error: KotlinException) {
        for listener in listeners {
            listener.onError(ids: ids, error: error)
        }
    }
}
