//
//  UITextField+Extension.swift
//  AIS
//
//  Created by Tao on 2017/8/11.
//  Copyright © 2017年 Tao. All rights reserved.
//

import UIKit

extension UITextField{

    public func textFieldLeftLabel(text :String, labelWidth :CGFloat = 60){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: labelWidth, height: self.height))
        if (labelWidth - 20) > 0 {
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: labelWidth-20, height: self.height))
            view.addSubview(label)
            label.font = self.font
            label.textColor = UIColor.black
            label.textAlignment = .left
            label.text = text
        }
        view.backgroundColor =  self.backgroundColor
        self.leftView = view
        self.leftViewMode = .always
    }
    
    public func toolBar(title :String = ""){
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

    
    public func textFieldLeftText(text :String){
        let labelWidth :CGFloat = CGFloat(text.count) * 8 + 30
        let view = UIView(frame: CGRect(x: 0, y: 0, width: labelWidth, height: self.height))
        let label =  UILabel(frame: CGRect(x: 10, y: 0, width: labelWidth-20, height: 16))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = _RGB(0x333333)
        label.text = text
        label.center = CGPoint(x: view.width/2, y: view.height/2)
        view.addSubview(label)
        view.backgroundColor =  UIColor.white
        let line = UIView(frame: CGRect(x: labelWidth-5, y: 8, width: 1.5, height: self.height-16))
        line.backgroundColor = _RGB(0xe5e5e5)
        view.addSubview(line)
        self.leftView = view
        self.leftViewMode = .always
    }
    
    
    public func textFieldLeftIcon(name :String){
        guard let img = _IMG(name) else {return}
        let iconWidth :CGFloat = img.size.width + 20
        let view = UIView(frame: CGRect(x: 0, y: 0, width: iconWidth, height: self.height))
        let imageView =  UIImageView(frame: CGRect(x: 10, y: 0, width: iconWidth-20, height: img.size.height))
        imageView.image = img
        imageView.center = CGPoint(x: view.width/2, y: view.height/2)
        view.addSubview(imageView)
        view.backgroundColor =  UIColor.clear
        self.leftView = view
        self.leftViewMode = .always
    }
    
    public func textFieldRightIcon(name :String, target: Any? = nil, action: Selector? = nil){
        guard let img = _IMG(name) else {return}
        let iconWidth :CGFloat = img.size.width + 20
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: iconWidth, height: self.height))
        let imageView =  UIImageView(frame: CGRect(x: 10, y: 0, width: iconWidth-20, height: img.size.height))
        imageView.tag = 123
        imageView.image = img
        imageView.center = CGPoint(x: view.width/2, y: view.height/2)
        view.addSubview(imageView)
        view.backgroundColor =  UIColor.clear
        self.rightView = view
        self.rightViewMode = .always
        guard let ac = action else {return}
        view.addTarget(target, action: ac, for: .touchUpInside)
    }
    
    @discardableResult
    public func textFieldRightButton(name :String, target: Any? = nil, action: Selector? = nil) -> UILabel{
        
        let labelWidth :CGFloat = 73 + 32
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: labelWidth, height: self.height))
        let label = UILabel(frame: CGRect(x: 16, y: 11, width: labelWidth-32, height: self.height-22))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = name
        label.textColor = _RGB(0x106198)
        label.layer.cornerRadius = 3
        label.tag = 1
        label.layer.borderColor = _RGB(0x106198).cgColor
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        label.backgroundColor = UIColor.white
        view.addSubview(label)
        view.backgroundColor =   UIColor.white
        self.rightView = view
        self.rightViewMode = .always
        if let ac = action {
            view.addTarget(target, action: ac, for: .touchUpInside)
        }
        return label
    }
    
    public func addTextFieldLeftSpace(_ width :CGFloat = 10){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.height))
        view.backgroundColor =  self.backgroundColor
        self.leftView = view
        self.leftViewMode = .always
    }
    
    public func placeholderLabelColor(_ color :UIColor){
        self.setValue(color, forKey: "_placeholderLabel.textColor")
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
