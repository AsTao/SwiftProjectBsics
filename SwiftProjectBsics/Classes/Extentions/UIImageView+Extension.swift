//
//  UIImageView+Extension.swift
//  CProjectBasics
//
//  Created by tao on 2019/9/4.
//

import UIKit
import Kingfisher

extension UIImageView{
    
    public func setImage(url: String, placeholder :UIImage? = nil ,radius :CGFloat = 0){
        contentMode = .scaleAspectFill
        image = placeholder
        kf.setImage(with: _URL(url)) {
            [weak self] result in
            switch result {
            case .success( _):
                if radius > 0 {
                    self?.drawRectWithRoundedCorner(radius: radius)
                }
            case .failure(_):
                self?.image = placeholder
            }
        }
    }

}
