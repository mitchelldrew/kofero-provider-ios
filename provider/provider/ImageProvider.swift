//
//  ImageProvider.swift
//  provider
//
//  Created by Mitchell Drew on 26/2/21.
//

import Foundation
import presenter

open class ImageProvider: IImageProvider {
    private var listeners = [IImageProviderListener]()
    public let restManager:IRestManager
    public let fileManager:IFileManager
    
    public init(core:ProviderCore){
        self.restManager = core.restManager
        self.fileManager = core.fileManager
    }
    
    private func informListenersNon200(url:String, response:HTTPURLResponse){
        for listener in listeners {
            listener.onError(url: url, error: KotlinException(message: "status code: \(response.statusCode), response: \(response)"))
        }
    }
    
    private func informListenersUnexpectedError(url:String){
        for listener in listeners {
            listener.onError(url: url, error: KotlinException(message: "unexpected error"))
        }
    }
    
    private func informListeners(data:Data, url:String){
        for listener in listeners {
            listener.onReceive(url: url+"", imgBase64: data.base64EncodedString())
        }
    }
    
    private func makeUrl(string:String) -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(string.hashValue)")
    }
    
    private func saveToDisk(data: Data, url: String){
        let path = makeUrl(string: url)
        do {
            try data.write(to: path, options: .atomic)
            
            let uData = try! Data(contentsOf: path)
            informListeners(data: uData, url: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getRestClosure(url:String) -> RestClosure {
        return {[self] data,response,error in
            if let uResponse = response as? HTTPURLResponse {
                if let uData = data {
                    if(uResponse.statusCode == 200) {
                        saveToDisk(data: uData, url: url + "")
                    }
                    else { informListenersNon200(url: url, response: uResponse)}
                }
                else{informListenersUnexpectedError(url: url)}
            }
            else{informListenersUnexpectedError(url: url)}
        }
    }
    
    public func get(url: String) {
        let lUrl = makeUrl(string: url)
        let newUrl = url + ""
        do{
            informListeners(data: try Data(contentsOf: lUrl), url: newUrl)
            print("hello")
        }
        catch {
            //print(error.localizedDescription)
            if let uRL = URL(string: newUrl) {
                restManager.dataTask(with: URLRequest(url: uRL), completionHandler: getRestClosure(url:newUrl)).resume()
            }
        }
    }
    
    public func removeListener(imgListener: IImageProviderListener) {
        listeners.removeAll(where: {listener in return imgListener === listener})
    }
    
    public func addListener(imgListener: IImageProviderListener) {
        listeners.append(imgListener)
    }
}
