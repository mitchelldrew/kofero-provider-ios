//
//  IEncoder.swift
//  provider
//
//  Created by Mitchell Drew on 1/4/21.
//

import Foundation


public protocol IEncoder{
    associatedtype I:Encodable
    associatedtype O
    func encode(_ value: I) throws -> O
}
