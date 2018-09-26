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
    var host :String {get set}
    var path :String {get set}
    var parameters :[String: Any] {get set}
    var method :HTTPMethod {get set}
    var headers :[String: String] {get set}
    var encoding : ParameterEncoding {get set}
}

public class BaseHttpStrategy :NSObject,HttpStrategy{
    public var url: String = ""
    public var host: String = AppConfig.shared.server_url
    public var path: String = ""{
        didSet{
            self.url = host + path
        }
    }
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
    
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    public var manage :SessionManager = HttpClient.sharedSessionManager
    
    open func request(){
        guard let s = strategy else {return;}
        self.dataRequest?.cancel()
        debugPrint(s.url)
        self.dataRequest = manage.request(s.url, method: s.method, parameters: s.parameters, encoding: s.encoding, headers: s.headers).responseJSON{ response in
            if let res = response.response {
                if AppConfig.shared.unifyProcessingFailed!(res.statusCode,response.result.value) {
                    if response.result.isSuccess , let value = response.result.value as? [String:Any] {
                        self.responseHandle?.didSuccess(response: value, statusCode: res.statusCode)
                    }else{
                        self.responseHandle?.didFail(response: response.result.value, statusCode: res.statusCode, error: response.error)
                    }
                }else{
                    self.responseHandle?.didFail(response: response.result.value, statusCode: -999, error: response.error)
                }
            }else{
                debugPrint("request fail =\(s.url)")
                let err = response.error as NSError?
                self.responseHandle?.didFail(response: response.result.value, statusCode: err?.code ?? 0, error: response.error)
            }
        }
    }
    
}

