//
//  ViewController.swift
//  SwiftProjectBsics
//
//  Created by ssTaoz on 05/27/2018.
//  Copyright (c) 2018 ssTaoz. All rights reserved.
//

import UIKit
import SwiftProjectBsics

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let presenter = LoginPresenter()
        presenter.login()
        
        
        
       let client = HttpTableView(frame: CGRect.zero)
        
    }

    @IBAction func buttonAction(_ sender: Any) {
        
        
        
//        let str = BaseHttpStrategy()
//        str.url = ""
//        str.parameters = [:]
//        client.strategy = str
//        client.request()
        
        
    }

    
    
    

}



