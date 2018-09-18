//
//  UIImage+Extension.swift
//  StrategyDemo
//
//  Created by Tao on 15/10/16.
//  Copyright © 2015年 Tao. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func stretchableImage(_ leftCap :CGFloat = 0.5,_ topCap :CGFloat = 0.5) -> UIImage{
        let leftCapWidth = Int(self.size.width * leftCap)
        let topCapHeight = Int(self.size.height * topCap)
        let newImage = self.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
        return newImage;
    }
    
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
    
    public func resizeImage(resize :CGSize, scale :CGFloat = UIScreen.main.scale)-> UIImage {
        UIGraphicsBeginImageContextWithOptions(resize,false,scale)
        self.draw(in: CGRect(x: 0, y: 0, width: resize.width, height: resize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
    public func scaleImage(scale :CGFloat) -> UIImage {
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        return resizeImage(resize: size)
    }
    
    public static func createPlaceholderImage(size :CGSize) -> UIImage{
        let rect : CGRect! = CGRect(x: 0.0, y: 0.0, width: size.width*_scale, height: size.height*_scale)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext! = UIGraphicsGetCurrentContext()
        context.setFillColor(_RGB(0xe0e0e0).cgColor)
        context.fill(rect)
        if let img =  UIImage(named: "jj_placeholder"){
            img.draw(in: CGRect(x: (rect.size.width-(74*_scale))/2, y: (rect.size.height-(98*_scale))/2, width: 74*_scale, height: 98*_scale))
        }
        let theImage : UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return theImage
    }
    

    internal static func libBundleImage(_ named :String) -> UIImage?{
        guard let bundle = Bundle(for: BaseAppDelegate.self).path(forResource: "SwiftResource", ofType: "bundle") else {return nil}
        guard let resource = Bundle(path: bundle) else {return nil}
        let fix = UIScreen.main.scale > 2 ?  "@3x" : "@2x"
        if let file = resource.path(forResource: "\(named)\(fix)", ofType: "png") {
            return UIImage(contentsOfFile: file)
        }else if fix == "@3x" {
            if let file = resource.path(forResource: "\(named)@2x", ofType: "png") {
                return UIImage(contentsOfFile: file)
            }
        }else if fix == "@2x" {
            if let file = resource.path(forResource: "\(named)@3x", ofType: "png") {
                return UIImage(contentsOfFile: file)
            }
        }
        return nil
    }
    
}
