//
//  String Extension.swift
//  ioszone
//
//  Created by Mayra on 29/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    func sha512() -> String {
        let data = self.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
    func getDate(temp: String) -> String {
        let tdate = temp.dropLast(14) //14
        let res = String(tdate)
        return res
    }
    
    func getTime(temp: String) -> String {
        let ttime = temp.dropFirst(11)
        let ti = ttime.dropLast(8)
        let res = String(ti)
        return res
    }
}
