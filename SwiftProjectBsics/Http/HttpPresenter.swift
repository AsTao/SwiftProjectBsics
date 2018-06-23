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


typealias RequestCompletedHandle = ([String:Any],Int) -> Void
typealias RequestFailedHandle = (Int,String) -> Void

open class HttpPresenter: BasePresenter,HttpResponseHandle {
    
    public var httpClient :HttpClient = HttpClient()
    public var mode :HttpPresenterMode = .def
    
    private var requestFailed :RequestFailedHandle?
    private var requestCompleted :RequestCompletedHandle?
    
    public var originalModel :Any?
    
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
        //self.httpClient.strategy?.headers["Accept"] = "application/json"
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
            var object :T?
            if statusCode == 200, let responseData = response["data"] as? [String:Any]{
                do {
                    let data = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    object = try decoder.decode(T.self, from: data)
                }
                catch  {
                    debugPrint(error)
                }
            }
            var messages :[String] = []
            if let list = response["messages"] as? [String] {
                messages = list
            }
        
            let model = HttpDataResponse<T>(data: object,
                                            statusCode: statusCode,
                                            result: safeString(response["result"]),
                                            messages: messages,
                                            exceptionType: safeString(response["exceptionType"]))
            self?.originalModel = model
            if  model.success == false {
                if self?.requestFailed == nil {
                    self?.showFailView(messages.first~~)
                }else{
                    self?.requestFailed?(statusCode,messages.first~~)
                }
            }else{
                completionHandler(model)
                self?.statusView.remove()
            }
        }
        return self
    }
    
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
    
    open func responseFail(completionHandler: @escaping (Int,String) -> Void ) -> Self{
        self.requestFailed = {
            statusCode,message in
            completionHandler(statusCode,message)
        }
        return self
    }
    
    
    public func didSuccess(response :[String:Any], statusCode :Int){
        self.requestCompleted?(response,statusCode)
    }
    public func didFail(response :Any?, statusCode :Int, error :Error?){
        self.statusView.show(inView: self.viewController?.view, mode: .error, msg: "SORRY~ \n请求失败了！点击空白处刷新页面", note: safeString(response))
    }
    
    private func showFailView(_ message :String){
        if mode == .def {
            self.statusView.show(inView: self.viewController?.view, mode: .error, msg: "SORRY~ \n请求失败了！点击空白处刷新页面", note: message)
        } else if mode == .qui {
            AppDelegateInstance.window?.makeToast(message)
        }
    }
    
}

