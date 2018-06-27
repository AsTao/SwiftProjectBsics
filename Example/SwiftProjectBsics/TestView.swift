//
//  TestView.swift
//  SwiftProjectBsics_Example
//
//  Created by Tao on 2018/6/27.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftProjectBsics

class TestView: BaseView<BasePresenter> {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
