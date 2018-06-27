//
//  BaseView.swift
//  Alamofire
//
//  Created by Tao on 2018/6/27.
//

import UIKit

open class BaseView<T :BasePresenter>: UIView {

    open var httpPresenter :T = T()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        httpPresenter.bindView(view: self)
    }

        
    override open func removeFromSuperview() {
        httpPresenter.unbind()
        super.removeFromSuperview()
    }
    
}
