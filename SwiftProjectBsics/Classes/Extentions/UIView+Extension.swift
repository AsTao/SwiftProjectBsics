//
//  UIView+Extension.swift
//  StrategyDemo
//
//  Created by Tao on 15/10/7.
//  Copyright © 2015年 Tao. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib() -> AnyObject?{
        if NSStringFromClass(self).components(separatedBy: ".").count > 0 {
            return Bundle.main.loadNibNamed(NSStringFromClass(self).components(separatedBy: ".").last!, owner: nil, options: nil)?.first as AnyObject?
        }
        return Bundle.main.loadNibNamed(NSStringFromClass(self), owner: nil, options: nil)?.first as AnyObject?
    }

    public var top : CGFloat {
        get{
           return self.frame.origin.y
        }
        set{
            var frame : CGRect = self.frame
            frame.origin.y = newValue
            self.frame  = frame
        }
    }
    
    public var bottom : CGFloat {
        get{
            return self.frame.origin.y + self.frame.height
        }
        set{
            var frame : CGRect = self.frame
            frame.origin.y = frame.origin.y + newValue
            self.frame  = frame
        }
    }
    
    
    public var left : CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            var frame : CGRect = self.frame
            frame.origin.x = newValue
            self.frame  = frame
        }
    }
    
    public var right : CGFloat {
        get{
            return self.frame.origin.x + self.frame.width
        }
    }

    public var width : CGFloat! {
        get{
            return self.frame.width
        }
        set{
            var frame : CGRect = self.frame
            frame.size.width = newValue
            self.frame  = frame
        }
        
    }
    
    public var height : CGFloat! {
        get{
            return self.frame.size.height
        }
        set{
            var frame : CGRect = self.frame
            frame.size.height = newValue
            self.frame  = frame
        }
    }
    

    
    
}



