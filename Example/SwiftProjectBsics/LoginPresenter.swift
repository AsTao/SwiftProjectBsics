//
//  LoginPresenter.swift
//  SwiftProjectBsics_Example
//
//  Created by Tao on 2018/6/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftProjectBsics

class LoginPresenter: HttpPresenter {

    
    func login(){
       // server_url = "http://39.108.9.243:8081"
//        self.request(url: "/member/login/account", parameters: ["mobileNo":"18005007063","password":"1234567".md5()]).responseObject { (response: HttpDataResponse<ObjectModel>) in
//
//                print(response.data?.mobileNo)
//                
//
//
//        }

    }
    
    
}


extension HttpPresenter{
    func unifyProcessingFailed(_ statusCode :Int,_ message :String){
        print("yyyy")
    }
}
