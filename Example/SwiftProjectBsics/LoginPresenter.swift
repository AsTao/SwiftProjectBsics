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
        self.request(url: "", parameters: [:]).responseObject { (response: HttpDataResponse<ObjectModel>) in
                
                print(response.data?.mobileNo)
                
                
                
        }

    }
    
    
}
