//
//  BaseNiblessView.swift
//  Pods-TProjectKit_Example
//
//  Created by EasyfunDev on 2019/3/14.
//

import UIKit

///frame 布局的View
open class BaseNiblessView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable,message: "loading this view from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("loading this view from a nib is unsupported")
    }
}
open class BaseNiblessControl: UIControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable,message: "loading this view from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("loading this view from a nib is unsupported")
    }
}
open class BaseNiblessCollectionView: UICollectionView {
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    @available(*, unavailable,message: "loading this view from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("loading this view from a nib is unsupported")
    }
}

open class BaseNiblessCollectionViewCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable,message: "loading this view from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("loading this view from a nib is unsupported")
    }
}

open class BaseNiblessTableView: UITableView {
    public init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        self.separatorStyle = .none
    }
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
    }
    @available(*, unavailable,message: "loading this view from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("loading this view from a nib is unsupported")
    }
}

open class BaseNiblessTableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
    }
    @available(*, unavailable,message: "loading this view from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("loading this view from a nib is unsupported")
    }
}

