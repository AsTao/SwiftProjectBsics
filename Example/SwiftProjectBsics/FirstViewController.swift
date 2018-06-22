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

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.httpPresenter.viewController)
        self.httpPresenter.login()
    }


}
