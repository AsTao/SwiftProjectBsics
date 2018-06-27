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
    private var _view :UIView?{
        didSet{self.didBind()}
    }
    public var bindView :UIView{
        get{
            if let v = view {
                return v
            }
            if let vc = viewController{
                return vc.view
            }
            return UIView()
        }
    }
    
    public var view :UIView?{
        get{return _view}
    }
    public var viewController : UIViewController?{
        get{return _viewController}
    }
    public func bindViewController(viewController :UIViewController){
        self._viewController = viewController
    }
    public func bindView(view :UIView){
        self._view = view
    }
    public func unbind(){
        self.willUnbind()
        self._view = nil;
        self._viewController = nil
    }
    open func didBind(){}
    open func willUnbind(){}
}
