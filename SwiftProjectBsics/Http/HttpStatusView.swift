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

    public var viewMode :HttpStatusViewDisplayMode?{
        didSet{
            guard let mode = viewMode  else {return }
            switch mode {
            case .noData:
                self.indicatorView.isHidden = false
                self.indicatorView.startAnimating()
                self.logoImageView.image = nil
            case .error:
                self.indicatorView.isHidden = true
                self.indicatorView.stopAnimating()
                self.logoImageView.image = UIImage.libBundleImage("project_fail")
            case .loading:
                self.indicatorView.isHidden = true
                self.indicatorView.stopAnimating()
                self.logoImageView.image = UIImage.libBundleImage("project_nodata")
            }
        }
    }
    public var message :String = "" {
        didSet{
            self.messageLabel.text = message
            self.messageLabel.height = message.compatibleSizeFont(messageLabel.font, width: self.width - 40).height
        }
    }
    public var serverMessage :String = "" {
        didSet{
            self.serverMessageLabel.text = serverMessage
            self.serverMessageLabel.height = serverMessage.compatibleSizeFont(serverMessageLabel.font, width: self.width - 40).height
        }
    }
    public func show(inView view :UIView, mode :HttpStatusViewDisplayMode, msg :String = "", note :String = "", animate :Bool = true){
        self.message = msg
        self.serverMessage = note
        if self.viewMode == mode && self.superview != nil {
            return
        }
        view.endEditing(true)
        self.removeFromSuperview()
        self.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        self.viewMode = mode
        view.addSubview(self)
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
        self.logoImageView.addSubview(self.indicatorView)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.indicatorView.center = CGPoint(x: 125, y: 125)
        self.logoImageView.frame = CGRect(x: self.width/2-125, y: self.height/2-250, width: 250, height: 250)
        self.messageLabel.frame = CGRect(x: 20, y: logoImageView.bottom + 30 , width: self.width - 40, height: messageLabel.height)
        let offset = AppDelegateInstance.currentViewController!.hidesBottomBarWhenPushed ? 0 : _BARH
        self.serverMessageLabel.frame = CGRect(x: 20, y: self.height - serverMessageLabel.height - 20 - offset, width: self.width - 40, height: serverMessageLabel.height)
    }
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
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
