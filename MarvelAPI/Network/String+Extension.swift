//
//  String+Extension.swift
//  MarvelAPI
//
//  Created by Victor Luni on 26/02/24.
//

import Foundation
import CommonCrypto

extension String {
    var md5: String {
        let data = self.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
