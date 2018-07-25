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
        let responseData = response[dataKey]
        if !(responseData is NSNull) {
            do {
                let data = try JSONSerialization.data(withJSONObject: responseData ?? "", options: .prettyPrinted)
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
        var success = httpCodeRange.contains(httpCode)
        let result = response["result"] as? String
        var message = ""
        if let list = response["messages"] as? [String]{
            message = list.first~~
        }
        if result == "failure"{
            success = false
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
        for key in AppConfig.shared.sign.keys{
            self.httpClient.strategy?.headers[key] = AppConfig.shared.sign[key]
        }
        self.httpClient.request()
        return self
    }
    @discardableResult
    open func request(strategy :BaseHttpStrategy) -> Self{
        if self.mode != .sil, self.viewController != nil {
            self.statusView.show(inView:self.bindView, mode: .loading)
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
            [weak self]
            success,code,message in
            if code != 200 ,self?.mode != .sil, message.count > 0 {
                AppDelegateInstance.window?.makeToast(message)
            }
            completionHandler(success,code,message)
        }
        return self
    }
    
    
    public func didSuccess(response :[String:Any], statusCode :Int){
        self.requestCompleted?(response,statusCode)
        self.statusView.remove()
    }
    public func didFail(response :Any?, statusCode :Int, error :Error?){
        if statusCode == -999 {
            self.statusView.remove()
        }else if mode == .def {
            self.statusView.show(inView: self.bindView, mode: .error, msg: "SORRY~ \n请求失败了！点击空白处刷新页面", note: safeString(response))
        } else if mode == .qui {
            self.statusView.remove()
            guard safeString(response).count > 0 else {return}
            AppDelegateInstance.window?.makeToast(safeString(response))
        }
    }
    


}

