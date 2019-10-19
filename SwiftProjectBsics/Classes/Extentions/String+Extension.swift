//
//  String+Extension.swift
//  StrategyDemo
//
//  Created by Tao on 15/12/21.
//  Copyright © 2015年 Tao. All rights reserved.
//

import UIKit
import CommonCrypto


extension String {
    
    public var urlEncoded :String{
        guard let url = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return self}
        return url
    }

    ///计算字符串大小
    public func calculateSize(font: UIFont, width: CGFloat = CGFloat(MAXFLOAT)) -> CGSize{
        
        let rect = self.boundingRect(with: CGSize(width: width,height: CGFloat(MAXFLOAT)), options:[.usesLineFragmentOrigin,.usesFontLeading],
                                     attributes:[NSAttributedString.Key.font: font], context: nil);
        
        return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
    }
    
    ///去空格
    public func trimString() -> String{
        if self.count == 0 {return self}
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    public var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }


    
    
    public func numberOfChars() -> Int {
        var number = 0
        guard self.count > 0 else {return 0}
        for i in 0..<self.count {
            let c: unichar = (self as NSString).character(at: i)
            if (c >= 0x4E00) {
                number += 3
            }else {
                number += 1
            }
        }
        return number
    }
    
    public static func toString<T :Codable>(model :T) -> String?{
        guard let data = try? JSONEncoder().encode(model) else{return nil}
        return String(data: data, encoding: .utf8)
    }
}






