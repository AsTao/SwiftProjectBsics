//
//  HttpViewController.swift
//  Alamofire
//
//  Created by Tao on 2018/7/1.
//

import UIKit

open class HttpViewController<T :BasePresenter> : BaseViewController {

    open var httpPresenter :T = T()
    
    override open func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        httpPresenter.bindViewController(viewController: self)
 
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        httpPresenter.unbind()
    }
}
