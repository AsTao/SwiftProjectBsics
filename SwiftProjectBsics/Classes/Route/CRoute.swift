//
//  CRoute.swift
//  Alamofire
//
//  Created by tao on 2019/9/16.
//

import UIKit

public class CRoute {

    //CRoute.routeURL(url: "colg://colg.app/bbs/list/detail?url=\(post.url^)")
    
    public static let global : CRoute = {
        let instance = CRoute()
        return instance
    }()
    
    public typealias CRouteHandeler = ([String:String]) -> Void
    
    private var routeControllersMap :[String:CRouteHandeler] = [:]
    
    @discardableResult
    public class func handleOpenURL(url: URL) -> Bool{
        guard url.scheme == "colg" else {return false}
        
        if let range = url.absoluteString.range(of: "?u=") {
            let u = String(url.absoluteString[range.upperBound..<url.absoluteString.endIndex])
            global.routeControllersMap["\(url.scheme^)://\(url.host^)\(url.path)"]?(["u":u])
            return true
        }
        
        let param = url.query?.components(separatedBy: "&").map{
            s -> [String : String] in
            if let range = s.range(of: "=") {
                let k = String(s[s.startIndex..<range.lowerBound])
                let v = String(s[range.upperBound..<s.endIndex])
                return [k:v]
            }
            return [:]
        }.reduce(into: [String:String](), { (dic, person)  in
            dic[person.keys.first^] = person.values.first^
        }) ?? [:]
                
        global.routeControllersMap["\(url.scheme^)://\(url.host^)\(url.path)"]?(param)
        return true
    }
    
    
    public class func addRoute(routePattern :String, handler :@escaping CRouteHandeler){
        global.routeControllersMap[routePattern] = handler
    }
    
    public class func routeURL(url :String){
        UIApplication.shared.open(_URL(url), options: [:], completionHandler: nil)
    }
    
}
