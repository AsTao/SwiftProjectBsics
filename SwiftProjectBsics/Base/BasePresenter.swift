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
    private(set) var view : UIView!{
        didSet{self.didBind()}
    }
    private(set) var viewController : UIViewController!{
        didSet{self.didBind()}
    }
    public func bindView(view :UIView){
        self.view = view;
    }
    public func bindViewController(viewController :UIViewController){
        self.viewController = viewController
    }
    public func unbind(){
        self.willUnbind()
        self.view = nil
        self.viewController = nil
    }
    open func didBind(){}
    open func willUnbind(){}
}
