//
//  HttpToastView.swift
//  Alamofire
//
//  Created by Tao on 2018/7/25.
//

import UIKit

public func ToastViewMessage(_ message :String){
    HttpToastView.shared.makeToast(text: message)
}
public func ToastViewEditMessage(_ message :String){
    HttpToastView.shared.makeToast(text: message, editing: true)
}

public class HttpToastView: UIView {

    public static let shared : HttpToastView = {
        let instance = HttpToastView()
        instance.config()
        return instance
    }()
    
    func config(){
        self.backgroundColor =  _ARGB(0x000000, a: 0.7)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.addSubview(self.titleLabel)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
    
    var content :String = ""{
        didSet{
            let size = content.compatibleSizeFont(titleLabel.font, width: _SW - 40)
            if UIDevice.current.orientation.isLandscape {
                let realHeight = min((size.height + 16), (_SW - 80))
                self.frame = CGRect(x: 0, y: 0, width:  (size.width + 16), height: (size.height+16))
                self.center = CGPoint(x: _SH/2, y: (_SW - realHeight - 40))
            }else{
                let realHeight = min((size.height + 16), (_SH - 80))
                self.frame = CGRect(x: 0, y: 0, width:  (size.width + 16), height: (size.height+16))
                self.center = CGPoint(x: _SW/2, y: (_SH - realHeight - 40))
            }
            self.titleLabel.text = content
        }
    }
    
    public func makeToast(text :String ,editing :Bool = false){
        self.content = text
        if self.superview == nil {
            self.alpha = 0
            var keyboardWindow :UIWindow!
            if UIApplication.shared.windows.count > 1 {
                keyboardWindow = UIApplication.shared.windows.last
            }else{
                keyboardWindow = UIApplication.shared.keyWindow
            }
            let window = editing ? keyboardWindow : UIApplication.shared.keyWindow
            window?.addSubview(self)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
            }, completion: { finished in
                self.perform(#selector(self.remove), with: nil, afterDelay: 2.2)
            })
        }else{
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.remove), object: nil)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { finished in
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 1
                }, completion: { finished in
                    self.perform(#selector(self.remove), with: nil, afterDelay: 2.2)
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
