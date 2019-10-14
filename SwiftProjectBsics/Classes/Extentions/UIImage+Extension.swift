//
//  UIImage+Extension.swift
//  StrategyDemo
//
//  Created by Tao on 15/10/16.
//  Copyright © 2015年 Tao. All rights reserved.
//

import UIKit

extension UIImage {
    ///以中心点拉升图片
    public func stretchableImage(_ leftCap :CGFloat = 0.5,_ topCap :CGFloat = 0.5) -> UIImage{
        let leftCapWidth = Int(self.size.width * leftCap)
        let topCapHeight = Int(self.size.height * topCap)
        let newImage = self.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
        return newImage;
    }
    ///旋转图片
    public func rotateImage(angle: Double) -> UIImage? {
        if angle.truncatingRemainder(dividingBy: 360) == 0 { return self }
        let imageRect = CGRect(origin: .zero, size: self.size)
        let radian = CGFloat(angle / 180 * Double.pi)
        let rotatedTransform = CGAffineTransform.identity.rotated(by: radian)
        var rotatedRect = imageRect.applying(rotatedTransform)
        rotatedRect.origin.x = 0
        rotatedRect.origin.y = 0
        
        UIGraphicsBeginImageContextWithOptions(rotatedRect.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: rotatedRect.width / 2, y: rotatedRect.height / 2)
        context.rotate(by: radian)
        context.translateBy(x: -self.size.width / 2, y: -self.size.height / 2)
        self.draw(at: .zero)
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
    ///裁剪图片大小
    public func resizeImage(resize :CGSize, scale :CGFloat = UIScreen.main.scale)-> UIImage {
        UIGraphicsBeginImageContextWithOptions(resize,false,scale)
        self.draw(in: CGRect(x: 0, y: 0, width: resize.width, height: resize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    ///按百分比裁剪图片
    public func scaleImage(scale :CGFloat) -> UIImage {
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        return resizeImage(resize: size)
    }
    

}
