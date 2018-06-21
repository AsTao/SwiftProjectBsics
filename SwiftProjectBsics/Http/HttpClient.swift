//
//  HttpClient.swift
//  Alamofire
//
//  Created by Tao on 2018/6/3.
//

import Foundation
import Alamofire

public protocol HttpStrategy{
    var url :String {get set}
    var parameters :[String: Any] {get set}
    var method :HTTPMethod {get set}
    var headers :[String: String] {get set}
    var encoding : ParameterEncoding {get set}
}

public class BaseHttpStrategy :NSObject,HttpStrategy{
    public var url: String = ""
    public var parameters: [String : Any] = [:]
    public var method: HTTPMethod = .post
    public var headers: [String : String] = SessionManager.defaultHTTPHeaders
    public var encoding : ParameterEncoding = URLEncoding.default
}

public protocol HttpResponseHandle{
    func didSuccess(response :[String:Any], statusCode :Int)
    func didFail(response :Any?, statusCode :Int, error :Error?)
    
}

open class HttpClient: NSObject {

    public var strategy :HttpStrategy?
    public var responseHandle :HttpResponseHandle?
    private var dataRequest :DataRequest?
    
    open func request(){
        guard let s = strategy  else {return;}
        self.dataRequest?.cancel()
        let url = AppConfig.assembleServerUrl(url: s.url)
        debugPrint(url)
        self.dataRequest = Alamofire.request(url, method: s.method, parameters: s.parameters, encoding: s.encoding, headers: s.headers)
            .responseJSON{ response in
                
            if let res = response.response {
                if response.result.isSuccess , let value = response.result.value as? [String:Any] {
                    self.responseHandle?.didSuccess(response: value, statusCode: res.statusCode)
                }else{
                    self.responseHandle?.didFail(response: response.result.value, statusCode: res.statusCode, error: response.error)
                }
            }else{
                self.responseHandle?.didFail(response: response.result.value, statusCode: 999, error: response.error)
            }
                
        }
    }
    


    
    
    
//    public lazy var manager :SessionManager = {
//        let headers = SessionManager.defaultHTTPHeaders
//        let conf = URLSessionConfiguration.default
//        conf.httpAdditionalHeaders = headers
//        return SessionManager(configuration: conf)
//    }()
    
    

    
}
