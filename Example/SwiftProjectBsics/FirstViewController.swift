//
//  FirstViewController.swift
//  SwiftProjectBsics_Example
//
//  Created by Tao on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftProjectBsics
import CryptoSwift




class FirstViewController: HttpViewController<LoginPresenter> {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
      //  print(httpPresenter.bindView)


        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(self.httpPresenter.viewController)
//        self.httpPresenter.login()
         print(httpPresenter.bindView)
    }


}
