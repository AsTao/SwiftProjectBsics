//
//  Data+Extension.swift
//  NewProject
//
//  Created by tao on 2019/8/9.
//  Copyright © 2019 tao. All rights reserved.
//

import UIKit

extension Data{
    public func toJson() -> Any?{
        guard let josn = try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves) else {return nil}
        return josn
    }
    public func toModel<T :Decodable>() -> T?{
        guard let object = try? JSONDecoder().decode(T.self, from: self) else{return nil}
        return object
    }
}
extension Dictionary{
    public func toJsonString() -> String{
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else{return ""}
        guard let json = String(data: data, encoding: String.Encoding.utf8) else{return ""}
        return json
    }
    public func toModel<T :Decodable>() -> T?{
        guard JSONSerialization.isValidJSONObject(self) else{return nil}
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else{return nil}
        guard let object = try? JSONDecoder().decode(T.self, from: data) else{return nil}
        return object
    }
}

extension Array{
    public func toJsonString() -> String{
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else{return ""}
        guard let json = String(data: data, encoding: String.Encoding.utf8) else{return ""}
        return json
    }
    
    public func toModel<T :Decodable>() -> [T]?{
        guard JSONSerialization.isValidJSONObject(self) else{return nil}
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else{return nil}
        guard let object = try? JSONDecoder().decode([T].self, from: data) else{return nil}
        return object
    }
}

extension String {
    public func toJson() -> Any?{
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false) else{return nil}
        guard let josn = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {return nil}
        return josn
    }
    public func toModel<T :Decodable>() -> T?{
        guard let data = self.data(using: .utf8) else{return nil}
        guard let object = try? JSONDecoder().decode(T.self, from: data) else{return nil}
        return object
    }
}
