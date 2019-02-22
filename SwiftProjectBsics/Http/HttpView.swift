//
//  HttpView.swift
//  Alamofire
//
//  Created by Tao on 2019/2/22.
//

import UIKit
import Alamofire

open class HttpView: UIView {

    public var httpClient :HttpClient = HttpClient()
    public var mode :HttpRequestMode = .def
    
    private var requestFailed :((Bool,Int,String,Any) -> Void)?
    private var requestCompleted :(([String:Any],Int) -> Void)?
    
    open var requestResponseDecoder: DefaultRequestResponseDecoder = DefaultRequestResponseDecoder()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.config()
    }
    private func config(){
        self.httpClient.responseHandle = self
        self.httpClient.strategy = BaseHttpStrategy()
    }
    
    private lazy var httpStatusView: HttpStatusView = {
        let view = HttpStatusView(frame: CGRect(x: 0, y: 0, width: _SW, height: _SH))
        view.addTarget(self, action: #selector(refreshRequest), for: .touchUpInside)
        return view
    }()
    
    @objc open func refreshRequest(){
        self.httpClient.request()
    }
    
//    open override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//    }
    

}


extension HttpView :HttpResponseHandle{
    @discardableResult
    open func request(url :String, parameters :[String :Any] = [:], method :HTTPMethod = .post) -> Self{
        if self.mode != .sil{
            self.httpStatusView.show(inView:self, mode: .loading)
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
        if self.mode != .sil {
            self.httpStatusView.show(inView:self, mode: .loading)
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
            self?.httpStatusView.remove()
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
        self.httpStatusView.remove()
    }
    public func didFail(response :Any?, statusCode :Int, error :Error?){
        self.requestFailed?(false, statusCode, error?.localizedDescription ?? "", error ?? "")
        self.httpStatusView.remove()
        guard safeString(response).count > 0 else {return}
        ToastViewMessage(safeString(response))
    }
}
