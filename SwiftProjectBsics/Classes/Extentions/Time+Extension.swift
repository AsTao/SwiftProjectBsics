//
//  Time+Extension.swift
//  Alamofire
//
//  Created by tao on 2019/8/26.
//

import UIKit

extension Int{
    ///计时转换 x分x秒
    public var timeDurationString :String {
        if self < 61 {
            return String.init(format: "%d秒", self)
        }
        let minute :Int = self / 60
        let second :Int = self % 60
        let string = String.init(format: "%d分%d秒", minute, second)
        return string
    }
}



extension Double{
    ///视频时间格式 xx:xx
    public var videoTimeString :String {
        let hour = Int(self / 60 / 60)
        let minute = Int((self - Double(hour) * 60 * 60) / 60)
        let second = Int(self.truncatingRemainder(dividingBy: 60))
        var string = String(format: "%02d:%02d", minute, second)
        if hour > 0 {
            string = String(format: "%02d", Int(hour)) + string
        }
        return string
    }
    ///距离当前时间 xx-xx xx:xx
    public var distanceNowTime :String{
        let now :Double  = Date().timeIntervalSince1970
        let offset = Int(now - self)
        if offset < 60 {
            return "1m ago"
        }else if offset < 3600{
            return _S("%dm ago", args: offset/60)
        }else if offset < 86400{
            return _S("%dh ago", args: offset/3600)
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd HH:mm"
            let time = Date(timeIntervalSince1970: self)
            return formatter.string(from: time)
        }
    }
    
    ///时间格式年-月-日
    public var yearMonthDay :String{
        return dateFormat(format: "yyyy-MM-dd")
    }
    ///时间格式月-日 时:分
    public var transformDateAndTime :String{
        return dateFormat(format: "MM-dd HH:mm")
    }
    ///组装时间格式 列 yyyy-MM-dd HH:mm:ss
    public func dateFormat(format :String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let time = Date(timeIntervalSince1970: self)
        return formatter.string(from: time)
    }
}

