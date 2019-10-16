//
//  BaseNavigationController.swift
//  Alamofire
//
//  Created by Tao on 2018/6/14.
//

import UIKit


open class BaseNavigationController: UINavigationController {
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        modalPresentationStyle = .fullScreen
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .fullScreen
    }
    
    
    let baseNaviagtionBar = UIView(frame: CGRect(x: 0, y: 0, width: _SW, height: _SH))
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.white
        navigationBar.setBackgroundImage(_RGB(0x37ABEB).image, for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18),
                                             NSAttributedString.Key.foregroundColor:UIColor.white]
    }

    ///进入2级页面隐藏tabbar
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
    
    ///返回时如果是最上层页面显示tabbar
    override open func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count <= 2 {
            viewControllers[0].hidesBottomBarWhenPushed = false
        }
        return super.popViewController(animated: animated)
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle{
        if let vc = topViewController{
            return vc.preferredStatusBarStyle
        }
        return .lightContent
    }
    
    
}

