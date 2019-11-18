//
//  THttpClientManager.swift
//  NewProject
//
//  Created by tao on 2019/8/13.
//  Copyright © 2019 tao. All rights reserved.
//

import UIKit


public let ThttpClientRequestDidFailNotification = NSNotification.Name(rawValue: "ThttpClientRequestDidFailNotification")

public class THttpClientManager {
    
    public static let shared : THttpClientManager = {
        let instance = THttpClientManager()
        return instance
    }()
    
    public var codes :Set<Int> = [0]
    
    let cache = THttpCache()
    
    @discardableResult
    public class func request(_ s :THttpProtocol, success :((_ model :THttpResp) -> Void)?, fail : @escaping (_ model :THttpResp) -> Void ) -> THttpClient {
        let codes = THttpClientManager.shared.codes
        
        let client = THttpClient()
        
        client.request(s, success: {  resp in
            if codes.contains(resp.code) {
                (success != nil) ?  success?(resp) : client.didSuccess?(resp)
            }else{
                fail(resp)
                ToastViewMessage(resp.msge)
                NotificationCenter.default.post(name: ThttpClientRequestDidFailNotification, object: nil, userInfo: ["resp":resp])
            }
        }, fail: { resp in
            fail(resp)
        })
        
        return client
    }
    
    
    public class func get<T :Decodable>(_ s :THttpProtocol, _ dataKey :Bool = true, didCached :(T) -> Void) -> THttpClient {
        let codes = THttpClientManager.shared.codes
        let cache = THttpClientManager.shared.cache
        let client = THttpClient()
        
        let data = cache.filter(s.identifier)
        if let d = data, let object :T = dataKey ? d.decodeData() : d.decodeList() {
            didCached(object)
        }
        
        client.request(s, success: { resp in
            if codes.contains(resp.code) {
                client.didSuccess?(resp)
                if let dataString = resp.originalValue {
                    cache.add(s.identifier, dataString)
                }
            }else{
                client.didFailed?(resp)
                ToastViewMessage(resp.msge)
                NotificationCenter.default.post(name: ThttpClientRequestDidFailNotification, object: nil, userInfo: ["resp":resp])
            }
        }, fail: { resp in
            if data == nil {
                let view = THttpStatusView()
                view.httpProtocol = s
                view.show(inView: currentViewContrller?.view, mode: .erro, msge: resp.msge)
                view.httpRequestSuccessed = { model in
                    client.didSuccess?(model)
                }
            }
        })
        
        return client
    }
    
    public class func post(_ s :THttpProtocol, _ p :[String:Any] = [:] ) -> THttpClient{
        
        p.forEach{ (k,v) in s.parameters[k] = v}
        
        
        
        let client = THttpClient()
        let codes = THttpClientManager.shared.codes
        
        var view :THttpStatusView?
        DispatchQueue.main.async {
            view = THttpStatusView()
            view?.show(inView: currentViewContrller?.view, mode: .load)
        }

        client.request(s, success: { resp in
            if codes.contains(resp.code) {
                client.didSuccess?(resp)
            }else{
                client.didFailed?(resp)
                ToastViewMessage(resp.msge)
                NotificationCenter.default.post(name: ThttpClientRequestDidFailNotification, object: nil, userInfo: ["resp":resp])
            }
            view?.remove()
        }, fail: { resp in
            ToastViewMessage(resp.msge)
            view?.remove()
        })
        
        return client
    }
    
}
