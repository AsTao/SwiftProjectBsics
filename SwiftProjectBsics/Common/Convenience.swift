//
//  Constants.swift
//  StrategyDemo
//
//  Created by Tao on 15/10/16.
//  Copyright © 2015年 Tao. All rights reserved.
//

import UIKit

public func print(items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}

#if arch(i386) || arch(x86_64)
public let isSimulator = true
#else
public let isSimulator = false
#endif

public let AppDelegateInstance : BaseAppDelegate = UIApplication.shared.delegate as! BaseAppDelegate
public let DocumentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

public let _scale = UIScreen.main.scale
public let _SW :CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
public let _SH :CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

public let isIpad = UIDevice.current.userInterfaceIdiom == .pad
public let isIphone = UIDevice.current.userInterfaceIdiom == .phone
public let systemVersion = UIDevice.current.systemVersion

public let iPhone4  = (_SH == 480.0)
public let iPhone5  = (_SH == 568.0)
public let iPhone6  = (_SH == 667.0)
public let iPhonePlus = (_SH == 736.0)
public let iPhoneX  = (_SH == 812.0 || _SH == 896.0)

public let _TOP :CGFloat = (iPhoneX) ? 88 : 64
public let _SBARH :CGFloat = (iPhoneX) ? 44 : 20
public let _BARH :CGFloat = (iPhoneX) ? 83 : 49

public func _scaleMiddle(_ v: CGFloat) -> CGFloat{return (v * (_SW/375))}
public func _S(_ format: String, args: CVarArg...) -> String {return String.init(format: format, args)}

public func _FURL(_ str: String) -> URL {return URL.init(fileURLWithPath: str)}
public func _URL(_ str: String) -> URL {if let i = URL.init(string: str) {return i};return URL(string: "a")!}
public func _IMG(_ str: String) -> UIImage? {return UIImage(named: str)}
public func _RGB(_ rgb: UInt) -> UIColor {return UIColor.init(rgb: rgb)}
public func _ARGB(_ rgb: UInt,a: CGFloat) -> UIColor {return UIColor.init(rgb: rgb, al: a)}

postfix operator ~~
postfix public func ~~(i: Int?) -> Int {return i ?? 0}
postfix public func ~~(i: Int32?) -> Int32 {return i ?? 0}
postfix public func ~~(i: Int64?) -> Int64 {return i ?? 0}
postfix public func ~~(i: UInt?) -> UInt {return i ?? 0}
postfix public func ~~(i: UInt32?) -> UInt32 {return i ?? 0}
postfix public func ~~(i: UInt64?) -> UInt64 {return i ?? 0}
postfix public func ~~(i: Bool?) -> Bool {return i ?? false}
postfix public func ~~(i: CGFloat?) -> CGFloat {return i ?? 0}
postfix public func ~~(i: Float?) -> Float {return i ?? 0}
postfix public func ~~(i: Double?) -> Double {return i ?? 0}
postfix public func ~~(i: String?) -> String {return i ?? ""}
postfix public func ~~(i: CGColor?) -> CGColor {return i ?? UIColor.white.cgColor}
postfix public func ~~(i: URL?) -> URL {return i ?? URL.init(string: "url=nil")!}
postfix public func ~~(i: Any?) -> Any {
    switch i {
    case let v as Int:return v
    case let v as Double:return v
    case let v as String:return v
    default:return ""}
}
public func safeString(_ s :Any?) -> String{
    if let str = s as? String {return str}
    return ""
}
extension String{
    public var safeInt :Int{return Int(self) ?? 0}
    public var safeInt32 :Int32{return Int32(self) ?? 0}
    public var safeInt64 :Int64{return Int64(self) ?? 0}
    public var safeUInt :UInt{return UInt(self) ?? 0}
    public var safeUInt32 :UInt32{return UInt32(self) ?? 0}
    public var safeUInt64 :UInt64{return UInt64(self) ?? 0}
    public var safeBool :Bool{return Bool(self) ?? false}
    public var safeFloat :Float{return Float(self) ?? 0}
    public var safeDouble :Double{return Double(self) ?? 0}
}
extension Int{var str :String{return "\(self)"}}
extension Int32{var str :String{return "\(self)"}}
extension Int64{var str :String{return "\(self)"}}
extension CGFloat{var str :String{return "\(self)"}}
extension Float{var str :String{return "\(self)"}}
extension Double{var str :String{return "\(self)"}}

public func delay(_ delay: Double,handel : @escaping () -> Void ){
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {handel()}
}

@IBDesignable
extension UIView{
    @IBInspectable var borderColor: UIColor{
        set{
            self.layer.borderColor = newValue.cgColor;
        }
        get{
            return UIColor(cgColor: self.layer.borderColor~~)
        }
    }
    @IBInspectable var cornerRadius: CGFloat{
        set{
            self.layer.cornerRadius = newValue;
        }
        get{
            return self.layer.cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat{
        set{
            self.layer.borderWidth = newValue;
        }
        get{
            return self.layer.borderWidth
        }
    }
}

public func modelWithJSON<T :Decodable>(_ json :Any) -> T?{
    var object :T?
    do {
        var data :Data?
        if let jsonString = json as? String {
            data = jsonString.data(using: String.Encoding.utf8)
        }else if let jsonDic = json as? [String:Any] {
            data = try JSONSerialization.data(withJSONObject: jsonDic, options: .prettyPrinted)
        }
        guard let d = data else{return object}
        let decoder = JSONDecoder()
        object = try decoder.decode(T.self, from: d)
    }
    catch  {
        debugPrint(error)
    }
    return object
}
public func modelArrayWithClass<T :Decodable>(_ json :[Any]) -> [T]?{
    var object :[T]?
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoder = JSONDecoder()
        object = try decoder.decode([T].self, from: data)
    }
    catch  {
        debugPrint(error)
    }
    return object
}

public func modelToJSONString<T :Encodable>(model :T) -> String{
    var object :String = ""
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(model)
        object = String(data: data, encoding: .utf8)~~
    }
    catch  {
        debugPrint(error)
    }
    return object
}



