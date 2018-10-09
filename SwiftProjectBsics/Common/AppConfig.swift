//
//  AppConfig.swift
//  Alamofire
//
//  Created by Tao on 2018/6/20.
//

import UIKit
import Alamofire

public enum NetworkStatus {
    case unknown
    case noNetwork
    case wifi
    case wwan
}


public typealias GlobalFailedRequestCallback = (Int,Any?) -> Bool
public class AppConfig: NSObject {
    
    public static var server_url :String = ""
    public static var server_usl_url :String = ""
    public static var server_file_url :String = ""
  
    public static let shared : AppConfig = {
        let instance = AppConfig()
        instance.ini()
        return instance
    }()
    
    public var uuid :String = ""
    public var bundleID :String = ""
    public var version :String = ""
    public var bundleVersion :String = ""
    public var isFirstBoot :Bool = true
    public var isReachable :Bool = false
    public var reachabilityStatus :NetworkStatus = .unknown
    
    public var sign :[String:String] = [:]
    
    public var navigationTitleColor :UIColor = UIColor.white
    
    public var unifyProcessingFailed :GlobalFailedRequestCallback?
    
    private func ini(){
        self.uuid = getUuid()
        self.bundleID = getBundleID()
        self.version = getVersion()
        self.bundleVersion = getBundleVersion()
        if UserDefaults.standard.bool(forKey: "firstBoot") == false{
            UserDefaults.standard.set(true, forKey: "firstBoot")
        }else{
            self.isFirstBoot = false
        }
    }
    
    public let networkReachabilityManager = NetworkReachabilityManager(host: "https://www.baidu.com")
    public func startNetworkListening (){
        networkReachabilityManager?.listener = {
            [weak self]
            status in
            if status == .unknown {
                self?.isReachable = false
                self?.reachabilityStatus = .unknown
            }else if status == .notReachable {
                self?.isReachable = false
                self?.reachabilityStatus = .noNetwork
            }else if status == .reachable(.ethernetOrWiFi){
                self?.isReachable = true
                self?.reachabilityStatus = .wifi
            }else if status == .reachable(.wwan){
                self?.isReachable = true
                self?.reachabilityStatus = .wwan
            }
        }
        networkReachabilityManager?.startListening()
    }
}

extension AppConfig{
    
    private func getUuid() -> String{
        let bundleID = getBundleID()
        if let uuid = self.keychainValueForKey(service: bundleID, key: SwiftKeychainKeyName.UUID.rawValue)  {return uuid}
        if let uuidString = UIDevice.current.identifierForVendor?.uuidString{
            self.setKeychainValue(value: uuidString, service: bundleID, forKey: SwiftKeychainKeyName.UUID.rawValue)
            return uuidString
        }
        return ""
    }
    
    private func getBundleID() -> String{
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
        return safeString(name)
    }
    private func getVersion() -> String{
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        return safeString(name)
    }
    private func getBundleVersion() -> String{
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
        return safeString(name)
    }
 
    private enum SwiftKeychainKeyName: String {
        case UUID = "UUID"
    }
    public func keychainValueForKey(service :String, key : String) -> String? {
        let item = KeychainPasswordItem(service: service, account: key)
        let value = try? item.readPassword()
        return value
    }
    @discardableResult
    public func setKeychainValue(value: String, service :String, forKey: String) -> Bool {
        let item = KeychainPasswordItem(service: service, account: forKey)
        var success = true
        do {
            try item.savePassword(value)
        } catch {
            success = false
        }
        return success
    }
}
