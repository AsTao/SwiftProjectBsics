//
//  Rounded+Extension.swift
//  Alamofire
//
//  Created by tao on 2019/8/20.
//

import UIKit

extension UIView{
    
    public func drawRectWithRoundedCorner(radius :CGFloat ,
                                          bgColor :UIColor? = nil ,
                                          borderWidth :CGFloat = 0 ,
                                          borderColor :UIColor = .white){
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, _SCALE)
        guard let context = UIGraphicsGetCurrentContext() else {return}

        context.setLineWidth(borderWidth)
        context.setStrokeColor(borderColor.cgColor)
        
        let bc = bgColor ?? backgroundColor ?? UIColor.white
        context.setFillColor(bc.cgColor)
        
        let halfBorderWidth :CGFloat = borderWidth / 2
        
        context.move(to: _POINT(width - halfBorderWidth, radius + halfBorderWidth))
        context.addArc(tangent1End: _POINT(width - halfBorderWidth, height - halfBorderWidth),
                       tangent2End: _POINT(width - radius - halfBorderWidth, height - halfBorderWidth),
                       radius: radius)
        context.addArc(tangent1End: _POINT(halfBorderWidth, height - halfBorderWidth),
                       tangent2End: _POINT(halfBorderWidth, height - radius - halfBorderWidth),
                       radius: radius)
        context.addArc(tangent1End: _POINT(halfBorderWidth, halfBorderWidth),
                       tangent2End: _POINT(width - halfBorderWidth, halfBorderWidth),
                       radius: radius)
        context.addArc(tangent1End: _POINT(width - halfBorderWidth, halfBorderWidth),
                       tangent2End: _POINT(width - halfBorderWidth, radius + halfBorderWidth),
                       radius: radius)
        
        context.drawPath(using: .fillStroke)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        layer.contents = image?.cgImage
        
        backgroundColor = superview?.backgroundColor ?? .clear
    }
    
}


extension UIImageView {
    public func drawRectWithRoundedCorner(radius :CGFloat){
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, _SCALE)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        backgroundColor = superview?.backgroundColor ?? .white
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: _SIZE(radius, radius))
        context.addPath(path.cgPath)
        context.clip()
        draw(bounds)
        context.drawPath(using: .fillStroke)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = img
    }
}





