//
//  THttpProtocol.swift
//  NewProject
//
//  Created by tao on 2019/8/13.
//  Copyright © 2019 tao. All rights reserved.
//

import Alamofire

open class THttpProtocol :NSObject{
    
    open var url :String{ return "\(scheme)://\(host)\(path)\(query)" }
    
    open var identifier :String{ return (url + parameters.toJsonString()).md5 }
    
    open var method: HTTPMethod = .post
    
    open lazy var host: String = AppConfig.host
    open lazy var path: String = AppConfig.path
    open lazy var query: String = AppConfig.query
    open lazy var scheme: String = AppConfig.scheme
    
    open var parameters: [String : Any] = [:]
    open var parameterEncoding : ParameterEncoding = URLEncoding.default
    open var headers: [String : String] = SessionManager.defaultHTTPHeaders
 
    public class func makeHttpProtocol( m :[String :Any] = [:], h :[String:String] = [:]) -> THttpProtocol{
        let httpProtocol = THttpProtocol()
        httpProtocol.parameters = m
        h.forEach { (k,v) in httpProtocol.headers[k] = v}
        return httpProtocol
    }
}




