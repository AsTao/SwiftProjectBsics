//
//  BasePresenter.swift
//  Alamofire
//
//  Created by Tao on 2018/6/13.
//

import UIKit


protocol BasePresenterProtocol {
    func didBind()
    func willUnbind()
}

open class BasePresenter: NSObject,BasePresenterProtocol {
    
    required public override init() {
        super.init()
    }
    private var _viewController :UIViewController?{
        didSet{self.didBind()}
    }
    public var viewController : UIViewController?{
        get{return _viewController}
    }
    public func bindViewController(viewController :UIViewController){
        self._viewController = viewController
    }
    public func unbind(){
        self.willUnbind()
        self._viewController = nil
    }
    open func didBind(){}
    open func willUnbind(){}
}
