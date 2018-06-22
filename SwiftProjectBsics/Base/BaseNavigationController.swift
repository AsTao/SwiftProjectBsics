//
//  BaseNavigationController.swift
//  Alamofire
//
//  Created by Tao on 2018/6/14.
//

import UIKit

public class BaseNavigationController: UINavigationController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.navigationBarBackgroundImage(){
            self.setNavigationBarImage(image)
        }else{
            self.navigationBar.barTintColor = self.navigationBarTintColor()
        }
    }

    public func setNavigationBarImage(_ image :UIImage){
        let leftCapWidth = Int(image.size.width * 0.5)
        let topCapHeight = Int(image.size.height * 0.5)
        let newImage = image.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
        self.navigationBar.setBackgroundImage(newImage, for: .top, barMetrics: .default)
    }

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = viewControllers.count > 0
        super.pushViewController(viewController, animated: animated)
    }
    
    override public func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count == 1 {
            viewControllers[0].hidesBottomBarWhenPushed = false
        }
        return super.popViewController(animated: animated)
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    open func navigationBarTintColor() -> UIColor{
        return UIColor.lightGray
    }

    open func navigationBarBackgroundImage() -> UIImage?{
        return UIImage.libBundleImage("nav_background")
    }
}
