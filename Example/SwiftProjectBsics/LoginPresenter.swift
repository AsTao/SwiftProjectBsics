//
//  LoginPresenter.swift
//  SwiftProjectBsics_Example
//
//  Created by Tao on 2018/6/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftProjectBsics

class LoginPresenter: HttpPresenter<FirstViewController> {

    deinit {
        print("login presenter release")
    }
    

    
    func login(){
      
        self.request(url: "/member/login/account", parameters: ["mobileNo":"18005007063","password":"1234567".md5()]).responseObject {
            [weak self]
            (response: HttpDataResponse<ObjectModel>) in

             //  print(response.data?.mobileNo)
               

            self?.testLeak()
            }.responseFail {
                [weak self]
                (a, b, c, d) in
                print(self?.viewController)
                 self?.testLeak()
        }

    }
    
    func testLeak(){
      
    }
}


//extension HttpPresenter{
//    func unifyProcessingFailed(_ statusCode :Int,_ message :String){
//        print("yyyy")
//    }
//}
