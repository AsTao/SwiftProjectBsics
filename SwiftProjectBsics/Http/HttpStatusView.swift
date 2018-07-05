//
//  HttpStatusView.swift
//  Alamofire
//
//  Created by Tao on 2018/6/20.
//

import UIKit
import NVActivityIndicatorView

public enum HttpStatusViewDisplayMode {
    case noData
    case error
    case loading
}
public class HttpStatusView: UIControl {

    public var ignoreHeight :CGFloat = 0
    
    public var viewMode :HttpStatusViewDisplayMode?{
        didSet{
            guard let mode = viewMode  else {return }
            switch mode {
            case .loading:
                self.indicatorView.isHidden = false
                self.indicatorView.startAnimating()
                self.logoImageView.image = nil
            case .error:
                self.indicatorView.isHidden = true
                self.indicatorView.stopAnimating()
                self.logoImageView.image = UIImage.libBundleImage("project_fail")
            case .noData:
                self.indicatorView.isHidden = true
                self.indicatorView.stopAnimating()
                self.logoImageView.image = UIImage.libBundleImage("project_nodata")
            }
        }
    }
    public var message :String = "" {
        didSet{
            self.messageLabel.text = message
            self.messageLabel.height = message.compatibleSizeFont(messageLabel.font, width: self.width - 15).height
        }
    }
    public var serverMessage :String = "" {
        didSet{
            self.serverMessageLabel.text = serverMessage
            self.serverMessageLabel.height = min(self.height/4, serverMessage.compatibleSizeFont(serverMessageLabel.font, width: self.width - 15).height)
        }
    }
    public func show(inView view :UIView?, mode :HttpStatusViewDisplayMode, msg :String = "", note :String = "", animate :Bool = true){
        guard  let sview = view else {return}
        self.message = msg
        self.serverMessage = note
        if self.viewMode == mode && self.superview != nil {
            return
        }
        sview.endEditing(true)
        self.removeFromSuperview()
        self.frame = CGRect(x: 0, y: ignoreHeight, width: sview.width, height: sview.height-ignoreHeight)
        self.viewMode = mode
        sview.addSubview(self)
        self.alpha = 0
        if animate {
            UIView.animate(withDuration: 0.25) {
                self.alpha = 1
            }
        }else{
            self.alpha = 1
        }
    }
    public func remove(){
        self.indicatorView.stopAnimating()
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildLayout()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.buildLayout()
    }
    func buildLayout(){
        self.backgroundColor = _RGB(0xeaeaea)
        self.addSubview(self.logoImageView)
        self.addSubview(self.messageLabel)
        self.addSubview(self.serverMessageLabel)
        self.addSubview(self.indicatorView)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.indicatorView.center = CGPoint(x: self.width/2, y: self.height/2)
        self.logoImageView.center = CGPoint(x: self.width/2, y: self.height/2)
        self.messageLabel.frame = CGRect(x: 15, y: logoImageView.bottom + 30 , width: self.width - 15, height: messageLabel.height)
        let offset = AppDelegateInstance.currentViewController!.hidesBottomBarWhenPushed ? 0 : _BARH
        let y = self.height - serverMessageLabel.height - 20 - offset
        self.serverMessageLabel.frame = CGRect(x: 15, y: max(y, messageLabel.bottom + 5), width: self.width - 15, height: serverMessageLabel.height)
    }
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 62, height: 62))
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var messageLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = _RGB(0x6d6d6d)
        return view
    }()
    private lazy var serverMessageLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = _RGB(0x6d6d6d)
        return view
    }()
    private lazy var indicatorView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballSpinFadeLoader, color: _RGB(0x00a0e9), padding: 0)
        return view
    }()
}
