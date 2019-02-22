//
//  BasePresenter.swift
//  Alamofire
//
//  Created by Tao on 2018/6/13.
//

import UIKit


public protocol BasePresenterProtocol {
    func didBind()
    func willUnbind()
}

open class BasePresenter<T :BaseViewController>: NSObject,BasePresenterProtocol {
    
    
    required public override init() {
        super.init()
    }
    private var _viewController :T?{
        didSet{self.didBind()}
    }
   
    public var viewController : T?{
        set{}
        get{return _viewController}
    }
    internal func bindViewController(viewController :T){
        self._viewController = viewController
    }

    public func unbind(){
        self.willUnbind()
        self._viewController = nil
    }
    open func didBind(){}
    open func willUnbind(){}
}
