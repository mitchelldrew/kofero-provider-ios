//
//  Provider.swift
//  provider
//
//  Created by Mitchell Drew on 1/4/21.
//

import Foundation
import presenter

open class Provider<O:ModelObj>: IProvider {
    private let restManager: IRestManager
    private let fileManager: IFileManager
    private let userDefaults: IUserDefaults
    private let encoder:IDataEncoder<[Int32]>
    private let mapper:IDataMapper<[O]>
    private let jsonFilename: String
    private let url:URL
    
    private var isDiskPulled = false
    private var listeners = [IProviderListener]()
    private var requests = [[KotlinInt]:IRestTask]()
    private var elements = [O]()
    
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
            if(!elements.contains(where: {element in return element.uid == id.int32Value})){ return false }
        }
        return true
    }
    
    public func get(ids: [KotlinInt]) {
        if(!isDiskPulled){ pullFromDisk(ids: ids) }
        else{
            if(isSatisfiable(request: ids)){ informListeners(ids: ids, elements: retrieve(ids: ids)) }
            else{
                send(ids: ids)
            }
        }
    }
    
    private func send(ids: [KotlinInt]){
        let task = restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids))
        requests.updateValue(task, forKey: ids)
        task.resume()
    }
    
    private func add(new:[O]){
        for element in new {
            elements.removeAll(where: {existingElement in return element.uid == existingElement.uid})
            elements.append(element)
        }
        saveToDisk()
        for request in requests.keys {
            if(isSatisfiable(request: request)){
                informListeners(ids: request, elements: retrieve(ids: request))
                requests.removeValue(forKey: request)?.cancel()
            }
        }
    }
    
    private func makeUrl(string:String) -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(string.hashValue)")
    }
    
    
    private func saveToDisk(){
        do{
            try mapper.map(data: elements).write(to: makeUrl(string: jsonFilename), options: .atomic)
        }
        catch {
            informListenersError(ids: [], error: KotlinException(error: error))
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
        if(ids.isEmpty){ return elements }
        var ret = [O]()
        for id in ids {
            ret.append(elements.first(where: {element in return element.uid == id.int32Value})!)
        }
        return ret
    }
    
    private func pullFromDisk(ids: [KotlinInt]) {
        isDiskPulled = true
        let url = makeUrl(string: jsonFilename)
            do {
                elements = try mapper.map(data: Data(contentsOf: url))
            }
            catch {
                informListenersError(ids: ids, error: KotlinException(message: "couldnt pull from disk"))
                pullFromBundledJson(ids:ids)
            }
        if(isSatisfiable(request: ids)){
            informListeners(ids: ids, elements: retrieve(ids: ids))
        }
        else{
            send(ids: ids)
        }
    }
    
    private func pullFromBundledJson(ids:[KotlinInt]) {
        if let path = Bundle.main.path(forResource: jsonFilename, ofType: "json") {
            do {
                elements = try mapper.map(data: Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped))
            }
            catch let error { informListenersError(ids: ids, error: KotlinException(error: error)) }
        } else {
            informListenersError(ids: ids, error: KotlinException(message: "invalid json filename: \(jsonFilename)"))
        }
    }
    
    
    public func addListener(listener__ listener: IProviderListener) {
        listeners.append(listener)
    }
    
    public func removeListener(listener__ listener: IProviderListener) {
        listeners.removeAll{existingListener in return listener === existingListener}
    }
    
    private func informListeners(ids: [KotlinInt], elements: [O]) {
        for listener in listeners{
            listener.onReceive(ids: ids, elements: elements)
        }
    }
    
    private func informListenersError(ids: [KotlinInt], error: KotlinException) {
        for listener in self.listeners {
            listener.onError(ids: ids, error: error)
        }
    }
}
