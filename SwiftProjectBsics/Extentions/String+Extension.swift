//
//  String+Extension.swift
//  StrategyDemo
//
//  Created by Tao on 15/12/21.
//  Copyright © 2015年 Tao. All rights reserved.
//

import UIKit
//import CommonCrypto


///JSON
extension Data{
    public func toJson() -> Any?{
        guard let josn = try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) else {return nil}
        return josn
    }
}
extension Dictionary{
    public func toJsonString() -> String{
        guard JSONSerialization.isValidJSONObject(self) else{return ""}
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else{return ""}
        guard let json = String(data: data, encoding: String.Encoding.utf8) else{return ""}
        return json
    }
}
extension String {
    public func toJson() -> Any?{
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false) else{return nil}
        guard let josn = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {return nil}
        return josn
    }
}
/////////////////////////////////////////


extension String {
    
    public var urlEncoded :String{
        guard let url = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return self}
        return url
    }
    
//    public var md5 :String{
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_MD5(str!, strLen, result)
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deinitialize(count: digestLen)
//        return String(format: hash as String)
//    }
    
    
    ///计算字符串大小
    public func compatibleSizeWithFont( _ font: UIFont, width: CGFloat) -> CGSize{
        
        
        let rect = self.boundingRect(with: CGSize(width: width,height: CGFloat(MAXFLOAT)), options:[.usesLineFragmentOrigin,.usesFontLeading],
                                     attributes:[NSAttributedString.Key.font: font], context: nil);
        
        return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
    }
    
    
    public func compatibleSizeWithFont( _ font: UIFont,_ width: CGFloat,_ lineSpacing :CGFloat) -> CGSize{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = .byCharWrapping
        let rect = self.boundingRect(with: CGSize(width: width,height: CGFloat(MAXFLOAT)),
                                     options: [ NSStringDrawingOptions.truncatesLastVisibleLine , NSStringDrawingOptions.usesLineFragmentOrigin , NSStringDrawingOptions.usesFontLeading],
                                     attributes:[NSAttributedString.Key.font: font,NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
    }
    
    public func compatibleSizeFont( _ font: UIFont, width: CGFloat) -> CGSize{
        
        let rect = self.boundingRect(with: CGSize(width: width,height: CGFloat(MAXFLOAT)), options: [ NSStringDrawingOptions.truncatesLastVisibleLine , NSStringDrawingOptions.usesLineFragmentOrigin , NSStringDrawingOptions.usesFontLeading], attributes:[NSAttributedString.Key.font: font,
                                                                                                                                                                                                                                                             NSAttributedString.Key.paragraphStyle: NSParagraphStyle.default], context: nil)
        
        return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
        
    }
    
    ///去空格
    public func trimString() -> String{
        if self.count == 0 {return self}
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
      
    
}



