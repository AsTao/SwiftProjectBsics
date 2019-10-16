//
//  UITextField+Extension.swift
//  AIS
//
//  Created by Tao on 2017/8/11.
//  Copyright © 2017年 Tao. All rights reserved.
//

import UIKit

extension UITextField{

    public func addToolBar(title :String = ""){
        let toolView = UIToolbar(frame: CGRect(x: 0, y: 0, width: _SW, height: 40))
        toolView.barTintColor = _RGB(0xb0b0b0)
        
        let spce = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let hide = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyBoard))
        let title = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        title.tintColor = UIColor.white
        hide.tintColor = _RGB(0x00A0E9)
        toolView.items = [spce,title,spce,hide]
        
        self.inputAccessoryView = toolView
    }

    @objc public func dismissKeyBoard(){
        self.resignFirstResponder()
    }

    
    public func addTextFieldLeftIcon(icon :UIImage?, target: Any? = nil, action: Selector? = nil, space :CGFloat = 20){
        guard let img = icon else{return}
        let iconWidth :CGFloat = img.size.width + space
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: iconWidth, height: height))
        let imageView =  UIImageView(frame: CGRect(x: space/2, y: 0, width: iconWidth - space, height: img.size.height))
        imageView.center = CGPoint(x: view.width/2, y: view.height/2)
        imageView.image = icon
        imageView.tag = 123
        view.addSubview(imageView)
        view.backgroundColor = backgroundColor
        leftView = view
        leftViewMode = .always
        guard let ac = action else {return}
        view.addTarget(target, action: ac, for: .touchUpInside)
    }
    
    public func addTextFieldRightIcon(icon :UIImage?, target: Any? = nil, action: Selector? = nil, space :CGFloat = 20){
        guard let img = icon else{return}
        let iconWidth :CGFloat = img.size.width + space
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: iconWidth, height: height))
        let imageView =  UIImageView(frame: CGRect(x: space/2, y: 0, width: iconWidth - space, height: img.size.height))
        imageView.center = CGPoint(x: view.width/2, y: view.height/2)
        imageView.image = icon
        imageView.tag = 123
        view.addSubview(imageView)
        view.backgroundColor = backgroundColor
        rightView = view
        rightViewMode = .always
        guard let ac = action else {return}
        view.addTarget(target, action: ac, for: .touchUpInside)
    }
    
    public func addTextFieldLeftSpace(_ w :CGFloat = 10){
        let view = UIView(frame: _RECT(w,height) )
        view.backgroundColor =  backgroundColor
        leftView = view
        leftViewMode = .always
    }
    
    public func addTextFieldRightSpace(_ w :CGFloat = 10){
        let view = UIView(frame: _RECT(w,height))
        view.backgroundColor =  backgroundColor
        rightView = view
        rightViewMode = .always
    }
    
    public func setPlaceholder(text :String, color :UIColor){
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor:color])
    }
}

extension UITextField: UITextFieldDelegate{
    public func autoDoneButton(){
        self.returnKeyType = .done
        self.delegate = self
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.resignFirstResponder()
        return true
    }
}
