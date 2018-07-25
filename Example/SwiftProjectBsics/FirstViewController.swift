//
//  FirstViewController.swift
//  SwiftProjectBsics_Example
//
//  Created by Tao on 2018/6/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftProjectBsics




class FirstViewController: HttpViewController<LoginPresenter> {


    let httpStatusView = HttpStatusView(frame: CGRect(x: 0, y: 0, width: _SW, height: _SH))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    
        
      //  print(httpPresenter.bindView)


        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(self.httpPresenter.viewController)
//        self.httpPresenter.login()
         //print(httpPresenter.bindView)
        //self.httpStatusView.show(inView: self.view, mode: .loading)
    }

    @IBAction func testAction(_ sender: Any) {
    //    ToastViewMessage("谁离开多久啊拉开绝世独立看")
    }
    @IBAction func test2Action(_ sender: Any) {
      //  ToastViewEditMessage("手机电话卡还是看见的")
    }
}
