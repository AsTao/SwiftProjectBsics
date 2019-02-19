//
//  HttpPresenter.swift
//  Alamofire
//
//  Created by Tao on 2018/6/14.
//

import UIKit
import Alamofire


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
    func responseDecoding<T :Decodable>(httpCode :Int,response :[String:Any], completionHandler: (HttpDataResponse<T>) -> Void) -> Bool
}

open class DefaultRequestResponseDecoder :RequestResponseDecoder{
    public var dataKey: String = "data"
    public var otherDataKeys: [String] = ["messages","result","exceptionType"]
    public var httpCodeRange: CountableClosedRange<Int> = 200...299
    public var originalModel :Any?
    
    open func responseDecoding<T :Decodable>(httpCode :Int,response :[String:Any], completionHandler: (HttpDataResponse<T>) -> Void) -> Bool{
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
        guard object != nil else {return false}
        var dic :[String:Any] = [:]
        otherDataKeys.forEach { key in
            if let v = response[key]{dic[key] = v}
        }
        let model = HttpDataResponse<T>(data: object, statusCode: httpCode, otherData: dic)
        self.originalModel = model
        completionHandler(model)
        return true
    }
    
    open func responseFailDecoding(httpCode :Int,response :[String:Any]) -> (Bool,Int,String,Any){
        var success = httpCodeRange.contains(httpCode)
        let result = response["result"] as? String
        var message = ""
        if let list = response["messages"] as? [String]{
            message = list.first~~
        }
        if result == "failure"{
            success = false
        }
        return (success,httpCode,message,response)
    }
}

open class HttpPresenter<T :BaseViewController>: BasePresenter<T>,HttpResponseHandle {
    
    public var httpClient :HttpClient = HttpClient()
    public var mode :HttpPresenterMode = .def
    
    private var requestFailed :((Bool,Int,String,Any) -> Void)?
    private var requestCompleted :(([String:Any],Int) -> Void)?
    
    open var requestResponseDecoder: DefaultRequestResponseDecoder = DefaultRequestResponseDecoder()
    
    public required init() {
        super.init()
        self.httpClient.responseHandle = self
        self.httpClient.strategy = BaseHttpStrategy()
    }
        
    open weak var bindViewController :T? {
        didSet{
            bindViewController?.viewWillAppearHandel = {
                [weak self] in
                if let vc =  self?.bindViewController {
                    self?.bindViewController(viewController: vc)
                }
            }
            bindViewController?.viewWillDisappearHandel = {
                [weak self] in
                self?.unbind()
            }
        }
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
        self.httpClient.strategy?.path = url
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
            
            let decodeingSuccess = self?.requestResponseDecoder.responseDecoding(httpCode: statusCode, response: response) { (model :HttpDataResponse<T>) in
                completionHandler(model)
                } ?? false
            if decodeingSuccess == false {
                if let dic = self?.requestResponseDecoder.responseFailDecoding(httpCode: statusCode, response: response){
                    if let handler = self?.requestFailed {
                        handler(dic.0,dic.1,dic.2,dic.3)
                    }else{
                        if self?.mode != .sil, dic.2.count > 0 {
                            ToastViewMessage(dic.2)
                        }
                    }
                }
            }
        }
        return self
    }
    
    @discardableResult
    open func responseOriginalJson(completionHandler: @escaping ([String:Any]) -> Void ) -> Self{
        self.requestCompleted = {
            [weak self]
            response,statusCode in
            self?.statusView.remove()
            completionHandler(response)
        }
        return self
    }
    
    @discardableResult
    open func responseFail(completionHandler: ((Bool,Int,String,Any) -> Void)? ) -> Self{
        self.requestFailed = {
            success,code,message,response in
            completionHandler?(success,code,message,response)
        }
        return self
    }
    
    
    public func didSuccess(response :[String:Any], statusCode :Int){
        self.requestCompleted?(response,statusCode)
        self.statusView.remove()
    }
    public func didFail(response :Any?, statusCode :Int, error :Error?){
        self.requestFailed?(false, statusCode, error?.localizedDescription ?? "", error ?? "")
        if statusCode == -999 {
            self.statusView.remove()
            return
        }
        if mode == .def {
            self.statusView.show(inView:self.viewController?.view, mode: .error, msg: "SORRY~ \n请求失败了！点击空白处刷新页面", note: "")
        }else if mode == .qui {
            self.statusView.remove()
            guard safeString(response).count > 0 else {return}
            ToastViewMessage(safeString(response))
        }else if mode == .sil{
            self.statusView.remove()
        }
    }
    
    
    
}

