//
//  THttpStatusView.swift
//  NewProject
//
//  Created by tao on 2019/8/13.
//  Copyright © 2019 tao. All rights reserved.
//

import UIKit


public enum THttpDisplayMode {
    case erro
    case nnet
    case data
    case load
    case endi
}

public class THttpStatusView: UIControl {
    
    public func show(inView view :UIView?,
                     mode :THttpDisplayMode,
                     msge :String = "",
                     note :String = "",
                     anim :Bool = true,
                     ignh :CGFloat = 0){
        guard let sview = view else {return}
        message = msge
        serverMessage = note
        if viewMode == mode && superview != nil {
            return
        }
        viewMode = mode
        DispatchQueue.main.async {
            sview.endEditing(true)
            self.removeFromSuperview()
            self.frame = CGRect(x: 0, y: ignh, width: sview.width, height: sview.height - ignh)
            self.alpha = 0
            sview.addSubview(self)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let _ = self.superview {
                self.setNeedsLayout()
                if anim {
                    UIView.animate(withDuration: 0.15) {
                        self.alpha = 1
                    }
                }else{
                    self.alpha = 1
                }
            }
        }
    }
    
    public func remove(){
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveLinear, animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
    
    var httpProtocol :THttpProtocol?
    var ignoreHeaderViewHeight :CGFloat = 0
    var httpRequestSuccessed :((_ resp :THttpResp) -> Void)?
    
    public static var loadingGif :[UIImage] = []
    public static var animationDuration :TimeInterval = 1
    
    public static var images :[THttpDisplayMode:UIImage] = [:]
    
    
    public var viewMode :THttpDisplayMode?{
        didSet{
            guard let mode = viewMode else {return}
            switch mode {
            case .erro:
                isEnabled = true
                indicatorView.isHidden = true
                indicatorView.stopAnimating()
                logoImageView.image = THttpStatusView.images[.erro]
                messageLabel.text = "加载失败"
            case .nnet:
                isEnabled = true
                indicatorView.isHidden = true
                indicatorView.stopAnimating()
                logoImageView.image = THttpStatusView.images[.nnet]
                messageLabel.text = "暂无网络"
            case .data:
                isEnabled = false
                indicatorView.isHidden = true
                indicatorView.stopAnimating()
                logoImageView.image = THttpStatusView.images[.data]
                messageLabel.text = "没有内容"
            case .load:
                isEnabled = false
                indicatorView.isHidden = false
                indicatorView.startAnimating()
                logoImageView.image = nil
            default :
                break
            }
        }
    }
    
    public var message :String = "" {
        didSet{
            messageLabel.text = message
            messageLabel.height = message.calculateSize(font: messageLabel.font, width: width - 15).height
        }
    }
    public var serverMessage :String = "" {
        didSet{
            serverMessageLabel.text = serverMessage
            serverMessageLabel.height = min(height/4, serverMessage.calculateSize(font: serverMessageLabel.font, width: width - 15).height)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        buildLayout()
    }
    func buildLayout(){
        backgroundColor = _RGB(0xf0f0f0)
        addSubview(logoImageView)
        addSubview(messageLabel)
        addSubview(serverMessageLabel)
        addSubview(indicatorView)
        addTarget(self, action: #selector(touchSelfAction(sender:)), for: .touchUpInside)
    }
    @objc func touchSelfAction(sender :UIControl){
        guard let s = httpProtocol else{return}
        viewMode = .load
        THttpClientManager.request(s, success: { [weak self] resp in
            self?.httpRequestSuccessed?(resp)
            self?.remove()
            }, fail: { [weak self] _ in
                self?.viewMode = .erro
        })
        
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.center = CGPoint(x: width/2, y: height/2 - logoImageView.height)
        if logoImageView.image == nil {
            logoImageView.center = CGPoint(x: width/2, y: 20)
        }else{
            logoImageView.center = CGPoint(x: width/2, y: height/2 - logoImageView.height + 40)
        }
        messageLabel.frame = CGRect(x: 15, y: logoImageView.bottom + 10 , width: width - 30, height: messageLabel.height)
        let offset = currentViewContrller!.hidesBottomBarWhenPushed ? 0 : _TBARH
        let y = height - serverMessageLabel.height - 20 - offset
        serverMessageLabel.frame = CGRect(x: 15, y: max(y, messageLabel.bottom + 5), width: width - 15, height: serverMessageLabel.height)
    }
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var messageLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = _RGB(0x909090)
        return view
    }()
    private lazy var serverMessageLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = _RGB(0x909090)
        return view
    }()
    private lazy var indicatorView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.contentMode = .scaleAspectFit
        view.animationDuration = THttpStatusView.animationDuration
        view.animationImages = THttpStatusView.loadingGif
        return view
    }()
}
