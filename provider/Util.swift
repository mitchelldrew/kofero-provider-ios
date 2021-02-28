//
//  Util.swift
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
