//
//  HttpPresenter.swift
//  Alamofire
//
//  Created by Tao on 2018/6/14.
//

import UIKit
import Alamofire
import Toast_Swift

public enum HttpPresenterMode {
    case def
    case qui
    case sil
}

public protocol RequestResponseDecoder {
    var dataKey :String {get set}
    var otherDataKeys :[String] {get set}
    var httpCodeRange :CountableClosedRange<Int> {get set}
    var originalModel :Any? {get set}
    func responseDecoding<T :Decodable>(httpCode :Int,response :[String:Any], completionHandler: @escaping (HttpDataResponse<T>) -> Void)
}

open class DefaultRequestResponseDecoder :RequestResponseDecoder{
    public var dataKey: String = "data"
    public var otherDataKeys: [String] = ["messages","result","exceptionType"]
    public var httpCodeRange: CountableClosedRange<Int> = 200...299
    public var originalModel :Any?
    
    open func responseDecoding<T :Decodable>(httpCode :Int,response :[String:Any], completionHandler: @escaping (HttpDataResponse<T>) -> Void){
        var object :T?
        if let responseData = response[dataKey] as? [String:Any]{
            do {
                let data = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                object = try decoder.decode(T.self, from: data)
            }
            catch  {
                debugPrint(error)
            }
        }
        guard object != nil else {return}
        var dic :[String:Any] = [:]
        otherDataKeys.forEach { key in
            if let v = response[key]{dic[key] = v}
        }
        let model = HttpDataResponse<T>(data: object, statusCode: httpCode, otherData: dic)
        self.originalModel = model
        completionHandler(model)
    }
    
    open func responseFailDecoding(httpCode :Int,response :[String:Any]) -> (Bool,Int,String){
        let success = httpCodeRange.contains(httpCode)
        var message = ""
        if let list = response["messages"] as? [String]{
            message = list.first~~
        }
        return (success,httpCode,message)
    }
}

public typealias RequestCompletedHandle = ([String:Any],Int) -> Void
public typealias RequestFailedHandle = (Bool,Int,String) -> Void

open class HttpPresenter: BasePresenter,HttpResponseHandle {
    
    public var httpClient :HttpClient = HttpClient()
    public var mode :HttpPresenterMode = .def
    
    private var requestFailed :RequestFailedHandle?
    private var requestCompleted :RequestCompletedHandle?
    
    open var requestResponseDecoder: DefaultRequestResponseDecoder = DefaultRequestResponseDecoder()
    
    required public init() {
        super.init()
        self.httpClient.responseHandle = self
        self.httpClient.strategy = BaseHttpStrategy()
    }
    
    public var statusView :HttpStatusView{
        get{
            return self.httpStatusView
        }
    }
    
    private lazy var httpStatusView: HttpStatusView = {
        let view = HttpStatusView(frame: CGRect(x: 0, y: 0, width: _SW, height: _SH))
        view.addTarget(self, action: #selector(refreshRequest), for: .touchUpInside)
        return view
    }()
    
    @objc open func refreshRequest(){
        self.httpClient.request()
    }

}

extension HttpPresenter{
    @discardableResult
    open func request(url :String, parameters :[String :Any] = [:], method :HTTPMethod = .post) -> Self{
        if self.mode != .sil, self.viewController != nil {
            self.statusView.show(inView:self.viewController?.view, mode: .loading)
        }
        self.httpClient.strategy?.url = url
        self.httpClient.strategy?.parameters = parameters
        self.httpClient.strategy?.method = method
        self.httpClient.strategy?.headers["agent"] = AppConfig.shared.sign.toJsonString()
        self.httpClient.request()
        return self
    }
    @discardableResult
    open func request(strategy :BaseHttpStrategy) -> Self{
        if self.mode != .sil, self.viewController != nil {
            self.statusView.show(inView:self.viewController?.view, mode: .loading)
        }
        self.httpClient.strategy = strategy
        self.httpClient.request()
        return self
    }
    @discardableResult
    open func responseObject<T :Decodable>(completionHandler: @escaping (HttpDataResponse<T>) -> Void ) -> Self{
        self.requestCompleted = {
            [weak self]
            response,statusCode in
            
            self?.requestResponseDecoder.responseDecoding(httpCode: statusCode, response: response) { (model :HttpDataResponse<T>) in
                completionHandler(model)
            }
            if let dic = self?.requestResponseDecoder.responseFailDecoding(httpCode: statusCode, response: response){
                self?.requestFailed?(dic.0,dic.1,dic.2)
            }
        }
        return self
    }
    
    @discardableResult
    open func responseOriginalJson(completionHandler: @escaping ([String:Any]) -> Void ) -> Self{
        self.requestCompleted = {
            [weak self]
            response,statusCode in
            debugPrint(statusCode)
            self?.statusView.remove()
            completionHandler(response)
        }
        return self
    }
    
    @discardableResult
    open func responseFail(completionHandler: @escaping (Bool,Int,String) -> Void ) -> Self{
        self.requestFailed = {
            success,code,message in
            completionHandler(success,code,message)
        }
        return self
    }
    
    
    public func didSuccess(response :[String:Any], statusCode :Int){
        self.requestCompleted?(response,statusCode)
        self.statusView.remove()
    }
    public func didFail(response :Any?, statusCode :Int, error :Error?){
        self.statusView.show(inView: self.viewController?.view, mode: .error, msg: "SORRY~ \n请求失败了！点击空白处刷新页面", note: safeString(response))
    }
    
    private func showFailView(_ message :String){
        if mode == .def {
            self.statusView.show(inView: self.viewController?.view, mode: .error, msg: "SORRY~ \n请求失败了！点击空白处刷新页面", note: message)
        } else if mode == .qui {
            self.statusView.remove()
            AppDelegateInstance.window?.makeToast(message)
        }
    }

}

