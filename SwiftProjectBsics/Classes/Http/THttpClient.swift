//
//  THttpClient.swift
//  NewProject
//
//  Created by tao on 2019/8/13.
//  Copyright © 2019 tao. All rights reserved.
//

import UIKit
import Alamofire

public class THttpClient {
    
    public static var ckey :String = "code"
    public static var mkey :String = "msg"
    public static var dkey :String = "data"
    public static var lkey :String = "list"
    
    public static var globalDataRequests :[String:DataRequest] = [:]
    
    public static let sharedSessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.Session(configuration: configuration)
    }()
    
    public var manage :Session = THttpClient.sharedSessionManager
    
    public func request(_ s :THttpProtocol, success :@escaping ((_ resp :THttpResp) -> Void), fail :((_ resp :THttpResp) -> Void)?){
        
        THttpClient.globalDataRequests[s.identifier]?.cancel()
        TURLHook.shared.urlEventHandel?(s.url)
        
        let dataRequest = manage.request(s.url, method: s.method, parameters: s.parameters, encoding: s.parameterEncoding, headers: HTTPHeaders(s.headers)).responseString{
            response in
            let statusCode = response.response?.statusCode ?? 0
            if (200...299).contains(statusCode) {
                
                let json = response.value?.toJson() as? [String:Any] ?? [:]
                let data = json[THttpClient.dkey] as? [String:Any] ?? [:]
                let list = data[THttpClient.lkey] as? [Any] ?? []
                let code = json[THttpClient.ckey] as? Int ?? 0
                let msge = json[THttpClient.mkey] as? String ?? ""
      
                let model = THttpResp(data: data, list: list, code: code, msge: msge, originalValue: response.value)
                success(model)
                
                debugPrint()
                debugPrint("############################请求rl###############################")
                debugPrint(s.url)
                debugPrint("---------------------------请求参数-------------------------------")
                debugPrint(s.parameters)
                debugPrint("~~~~~~~~~~~~~~~~~~~~~~~~~~~返回json~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                debugPrint(response.value^ as NSString)
                debugPrint("****************************************************************")
            }else{
                let error = response.error?.localizedDescription ?? ""
                let model = THttpResp(data: nil, list: nil, code: statusCode, msge: error, originalValue: nil)
                fail?(model)
            }
        }
        
        THttpClient.globalDataRequests[s.identifier] = dataRequest
    }
    
    
    public var didSuccess :((THttpResp) -> Void)?
    public var didFailed :((THttpResp) -> Void)?
    
    @discardableResult
    public func responseData<T :Decodable>(completion :@escaping (T) -> Void) -> THttpClient{
        didSuccess = {
            resp in
            
            if let object :T =  resp.decodeData() {
                completion(object)
            }
        }
        return self
    }
    
    @discardableResult
    public func responseList<T :Decodable>(completion :@escaping (T) -> Void) -> THttpClient{
        didSuccess = {
            resp in
            
            if let object :T =  resp.decodeList() {
                completion(object)
            }
        }
        return self
    }
    
    @discardableResult
    public func responseResp(completion :@escaping (THttpResp) -> Void) -> THttpClient{
        didSuccess = {
            resp in
            completion(resp)
        }
        return self
    }

}

class TURLHook: NSObject {

    public static let shared : TURLHook = {
        let instance = TURLHook()
        return instance
    }()
    
    var urlEventHandel :((_ url :String) -> Void)?

}
