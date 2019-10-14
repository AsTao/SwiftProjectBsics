//
//  UIColor+Extension.swift
//  StrategyDemo
//
//  Created by Tao on 15/10/16.
//  Copyright © 2015年 Tao. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public convenience init(rgb: UInt ,al:CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: al
        )
    }
    ///创建纯色图片
    public var image :UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        let context : CGContext! = UIGraphicsGetCurrentContext()
        context.setFillColor(self.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        let theImage : UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return theImage
    }
}
