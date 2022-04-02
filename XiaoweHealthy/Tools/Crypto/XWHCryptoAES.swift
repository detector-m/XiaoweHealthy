//
//  XWHCryptoAES.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/2.
//

import Foundation

import CryptoSwift

class XWHCryptoAES {
    
    static let base64Key = "EUaIBFQcCS0rEUUs8YAEww=="
//    static let bytesKey: [Int8] = [17, 70, -120, 4, 84, 28, 9, 45, 43, 17, 69, 44, -15, -128, 4, -61]
    
//     加密后的
//    let testStr = "VHn5WXeXswWKN3wRs9bG3w=="
    
    private class func getAES() -> AES? {
        do {
            let bytesKey = [UInt8](base64: base64Key)
            
            let cAES = try AES(key: bytesKey, blockMode: ECB(), padding: .pkcs5)
            
            return cAES
        } catch let e {
            log.error(e)
            
            return nil
        }
    }

    class func encrypt(oString: String) -> String? {
        guard let aes = getAES() else {
            return nil
        }
        
        do {
            let encryptBase64Str = try oString.encryptToBase64(cipher: aes)
            
            return encryptBase64Str
        } catch let e {
            log.error(e)
            
            return nil
        }
    }
    
    class func decrypt(oString: String) -> String? {
        guard let aes = getAES() else {
            return nil
        }
        
        do {
            let decryptBase64Str = try oString.decryptBase64ToString(cipher: aes)
            
            return decryptBase64Str
        } catch let e {
            log.error(e)
            
            return nil
        }
    }
    
    class func test() {
//        do {
//            let key = Data(base64Encoded: keyStr)!
//            let keyBytes = [UInt8](key)
//
//            let aes = try AES(key: keyBytes, blockMode: ECB(), padding: .pkcs5)
//
//            let aStr = try str.decryptBase64ToString(cipher: aes)
//
//            log.info(aStr)
//        } catch let e {
//            log.error(e)
//            return nil
//        }
        
        let oString = "hello"
        log.info(oString)
        
        let eString = oString.aesEncrypt()
        log.info(eString)
        
        let dString = eString?.aesDecrypt()
        log.info(dString)
        
        let eString1 = "VHn5WXeXswWKN3wRs9bG3w=="
        let dString1 = eString1.aesDecrypt()
        log.info(dString1)
    }
    
}

extension String {
    
    func aesEncrypt() -> String? {
        return XWHCryptoAES.encrypt(oString: self)
    }
    
    func aesDecrypt() -> String? {
        return XWHCryptoAES.decrypt(oString: self)
    }
    
}
