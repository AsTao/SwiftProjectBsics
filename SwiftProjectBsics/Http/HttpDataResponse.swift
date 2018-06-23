//
//  HttpDataResponse.swift
//  Alamofire
//
//  Created by Tao on 2018/6/20.
//

import UIKit

public struct HttpDataResponse<Value>  {
    
    
    public var data :Value?
    public var statusCode :Int
    public var result : String //failure  //success
    public var messages :[String]
    public var exceptionType :String
    
    public var success :Bool{
        get{
            if result == "success" {
                return true
            }
            return false
        }
    }
    
}

