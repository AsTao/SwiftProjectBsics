//
//  BaseView.swift
//  Alamofire
//
//  Created by Tao on 2018/6/27.
//

import UIKit

open class BaseView<T :BasePresenter>: UIView {

    open var httpPresenter :T = T()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        httpPresenter.bindView(view: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func removeFromSuperview() {
        httpPresenter.unbind()
        super.removeFromSuperview()
    }
    
}
