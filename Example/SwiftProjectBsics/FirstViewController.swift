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




class FirstViewController: BaseViewController<LoginPresenter> {

    var testView :TestView =  TestView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        
        print(testView.httpPresenter.view)
        self.view.addSubview(testView)
        print(testView.httpPresenter.view)
       // testView.removeFromSuperview()
        print(testView.httpPresenter.view)
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(self.httpPresenter.viewController)
//        self.httpPresenter.login()
    }


}
