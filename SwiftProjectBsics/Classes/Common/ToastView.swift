//
//  ToastView.swift
//  Pods-TProjectKit_Example
//
//  Created by EasyfunDev on 2019/3/18.
//

import UIKit

public func ToastViewMessage(_ message :String){
    ToastView.shared.makeToast(text: message)
}

public class ToastView: UIView {

    public static let shared : ToastView = {
        let instance = ToastView()
        instance.config()
        return instance
    }()

    var duration :TimeInterval = 1.2
    
    func config(){
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.addSubview(label)
    }

    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override public func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }

    var content :String = ""{
        didSet{
            let size = content.calculateSize(font: label.font, width: _SW - 40)
            if UIDevice.current.orientation.isLandscape {
                let realHeight = min((size.height + 16), (_SW - 80))
                frame = CGRect(x: 0, y: 0, width:  (size.width + 16), height: (size.height+16))
                center = CGPoint(x: _SH/2, y: (_SW - realHeight - 40))
            }else{
                let realHeight = min((size.height + 16), (_SH - 80))
                frame = CGRect(x: 0, y: 0, width:  (size.width + 16), height: (size.height+16))
                center = CGPoint(x: _SW/2, y: (_SH - realHeight - 40))
            }
            label.text = content
        }
    }

    public func makeToast(text :String ){
        content = text
        if superview == nil {
            alpha = 0
//            return UIApplication.shared.windows.reversed().filter { window -> Bool in
//                return window.screen == UIScreen.main &&
//                !window.isHidden && window.alpha > 0 &&
//                window.windowLevel >= .normal &&
//                !window.description.hasPrefix("<UIRemoteKeyboardWindow")
//            
//            }.first
            let window = UIApplication.shared.windows.count > 1 ? UIApplication.shared.windows.last : UIApplication.shared.keyWindow
            window?.addSubview(self)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
            }, completion: { finished in
                self.perform(#selector(self.remove), with: nil, afterDelay: self.duration)
            })
        }else{
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(remove), object: nil)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { finished in
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 1
                }, completion: { finished in
                    self.perform(#selector(self.remove), with: nil, afterDelay: self.duration)
                })
            })
        }
    }
    @objc func remove(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.remove), object: nil)
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }



}
