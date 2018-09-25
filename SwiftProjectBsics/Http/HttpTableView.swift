//
//  HttpTableView.swift
//  Alamofire
//
//  Created by Tao on 2018/6/20.
//

import UIKit
import MJRefresh

@objc public protocol HttpTableViewDataHandle{
    @objc func tableView(tableView :HttpTableView, response :[String:Any], page :Int) -> [Any]?
}


open class HttpTableView: UITableView {
    
    public weak var pageDelegate :HttpTableViewDataHandle?
    
    public var dataItems :[Any] = []
    public var cellReuseIdentifier :String = ""
    
    public var beginPage :Int = 0
    public var pageSize :Int = 20
    public var totalCount :Int = 0
    public var httpPageKey :String = "pageNo"
    public var httpPageSizeKey :String = "pageSize"
    public var isLoadPage :Bool = true
    
    public var httpClient :HttpClient = HttpClient()
    public var httpPageStrategy :HttpStrategy = BaseHttpStrategy()
    
    public var customMessage :String = ""
    public var noDataMessage :String = "暂时无数据"
    
    public var ignoreHeaderViewHeightForStatusView :Bool = false
    private var ignoreHeaderViewHeight :CGFloat {
        if ignoreHeaderViewHeightForStatusView {
            return self.tableHeaderView?.height ?? 0
        }
        return 0
    }
    public func beginRefreshing(){
        if self.dataItems.count == 0 {
            self.httpStatusView.show(inView: self, mode: .loading, ignoreHeight: ignoreHeaderViewHeight)
        }
        self.refreshTableHeaderDidTriggerRefresh()
    }
    
    
    open lazy var refreshHeader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshTableHeaderDidTriggerRefresh))
        return header!
    }()
    
    open lazy var loadMoreFooter: MJRefreshAutoNormalFooter = {
        let header = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreTableHeaderDidTriggerRefresh))
        return header!
    }()
    
    private var _page :Int = 0
    @objc func refreshTableHeaderDidTriggerRefresh(){
        self._page = self.beginPage
        if isLoadPage {
            self.httpPageStrategy.parameters[httpPageKey] = _page
            self.httpPageStrategy.parameters[httpPageSizeKey] = pageSize
        }
        for key in AppConfig.shared.sign.keys{
            self.httpPageStrategy.headers[key] = AppConfig.shared.sign[key]
        }
        self.httpClient.strategy = httpPageStrategy
        self.httpClient.request()
    }
    @objc func loadMoreTableHeaderDidTriggerRefresh(){
        if isLoadPage {
            self.httpPageStrategy.parameters[httpPageKey] = _page
            self.httpPageStrategy.parameters[httpPageSizeKey] = pageSize
        }
        for key in AppConfig.shared.sign.keys{
            self.httpPageStrategy.headers[key] = AppConfig.shared.sign[key]
        }
        self.httpClient.strategy = httpPageStrategy
        self.httpClient.request()
    }
    
    open lazy var httpStatusView: HttpStatusView = {
        let view = HttpStatusView(frame: CGRect(x: 0, y: 0, width: _SW, height: _SH))
        view.addTarget(self, action: #selector(refreshRequest), for: .touchUpInside)
        return view
    }()
    
    @objc open func refreshRequest(){
        self.httpClient.request()
    }
    public init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        config()
    }
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        config()
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    private func config(){
        self.dataSource = self
        self.httpClient.responseHandle = self
        for key in AppConfig.shared.sign.keys{
            self.httpPageStrategy.headers[key] = AppConfig.shared.sign[key]
        }
        self.refreshHeader.mj_h = 60
        self.loadMoreFooter.mj_h = 60
        self.refreshHeader.lastUpdatedTimeLabel.isHidden = true
        self.refreshHeader.backgroundColor = self.backgroundColor
        self.loadMoreFooter.backgroundColor = self.backgroundColor
        self.mj_header = refreshHeader
    }
    public func endRefreshing(){
        self.refreshHeader.endRefreshing()
        self.loadMoreFooter.endRefreshing()
    }
    override open func reloadData() {
        super.reloadData()
        self.endRefreshing()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    lazy var endingView :HttpEndingView = {
        let view = HttpEndingView(frame: CGRect(x: 0, y: 0, width: self.width, height: 60))
        return view
    }()
}
extension HttpTableView: HttpResponseHandle{
    public func didSuccess(response :[String:Any], statusCode :Int){
        
        if statusCode != 200, customMessage.count > 0, dataItems.count == 0 {
            self.httpStatusView.show(inView: self, mode: .custom, msg: customMessage, ignoreHeight: ignoreHeaderViewHeight)
            self.reloadData()
            return
        }
    
        if _page == beginPage {
            self.dataItems.removeAll()
        }
        
        _page += 1
        var dataCount :Int = 0
        if let list = self.pageDelegate?.tableView(tableView: self, response: response, page: _page) {
            dataCount = list.count
            self.dataItems.append(contentsOf: list)
        }else{
            if let list = response["data"] as? [Any]{
                dataCount = list.count
                self.dataItems.append(contentsOf: list)
            }
        }
        if self.dataItems.count == 0 {
            self.mj_footer = nil
            self.reloadData()
            self.httpStatusView.show(inView: self, mode: .noData, msg: noDataMessage, ignoreHeight: ignoreHeaderViewHeight)
        }else{
            if isLoadPage {
                if dataCount >= pageSize {
                    self.tableFooterView = nil
                    self.mj_footer = loadMoreFooter
                }else{
                    self.mj_footer = nil
                    self.tableFooterView = self.endingView
                }
            }
            self.httpStatusView.remove()
            self.reloadData()
        }
    }
    public func didFail(response :Any?, statusCode :Int, error :Error?){
        if statusCode == -999 {
            self.httpStatusView.remove()
            return
        }
        self.reloadData()
        self.httpStatusView.show(inView: self, mode: .error, msg: "请求失败了！点击空白处刷新页面",ignoreHeight: ignoreHeaderViewHeight)
    }
}

extension HttpTableView: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataItems.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        return cell
    }
}


open class HttpEndingView :UIView{
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = CGRect(x: (self.frame.size.width - 105)/2, y: 30, width: 105, height: 24)
    }
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 105, height: 24))
        view.image = UIImage.libBundleImage("project_ending")
        return view
    }()
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


