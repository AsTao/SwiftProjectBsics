//
//  BaseViewController.swift
//  ZPTvStation
//
//  Created by Tao on 2017/10/23.
//  Copyright © 2017年 Tao. All rights reserved.
//

import UIKit

open class BaseViewController : UIViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        
        view.backgroundColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.tintColor = .white
        
        guard #available(iOS 12, *) else{
            automaticallyAdjustsScrollViewInsets = false
            return
        }
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open  var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
 
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


