//
//  BaseViewController.swift
//  ZPTvStation
//
//  Created by Tao on 2017/10/23.
//  Copyright © 2017年 Tao. All rights reserved.
//

import UIKit

open class BaseViewController : UIViewController {

    let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
    
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
    
    @objc func backButtonAction(){
        navigationController?.popViewController(animated: true)
    }
    
    func navigationBar(color :UIColor, backImage :UIImage?, barTintColor :UIColor ){
        guard let bar = navigationController?.navigationBar else {return}
        bar.backgroundColor = color
        bar.tintColor = barTintColor
        backButton.setImage(backImage, for: .normal)
        bar.setBackgroundImage(color.image, for: .default)
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:barTintColor,
                                   NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)]
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


