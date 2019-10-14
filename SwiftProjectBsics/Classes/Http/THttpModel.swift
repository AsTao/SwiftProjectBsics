//
//  THttpModel.swift
//  NewProject
//
//  Created by tao on 2019/8/13.
//  Copyright © 2019 tao. All rights reserved.
//

import UIKit

public struct THttpResp {
    public var data :[String:Any]?
    public var list :[Any]?
    public var code :Int!
    public var msge :String!
    public var originalValue :String?
    
    func decodeData<T :Decodable>() -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: data ?? [:], options: .prettyPrinted) else{
            ToastViewMessage("数据解析失败")
            return nil
        }
        guard let object = try? JSONDecoder().decode(T.self, from: data) else{
            ToastViewMessage("数据解析失败")
            return nil
        }
        return object
    }
    
    func decodeList<T :Decodable>() -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: list ?? [], options: .prettyPrinted) else{
            ToastViewMessage("数据解析失败")
            return nil
        }
        guard let object = try? JSONDecoder().decode(T.self, from: data) else{
            ToastViewMessage("数据解析失败")
            return nil
        }
        return object
    }
}

