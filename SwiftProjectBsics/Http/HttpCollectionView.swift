//
//  HttpCollectionView.swift
//  Alamofire
//
//  Created by Tao on 2018/9/5.
//

import UIKit
import MJRefresh

@objc public protocol HttpCollectionViewDataHandle{
    @objc func tableView(tableView :HttpCollectionView, response :[String:Any], page :Int) -> [Any]?
}

open class HttpCollectionView: UICollectionView {

    public weak var pageDelegate :HttpCollectionViewDataHandle?
    public var dataItems :[Any] = []
    public var cellReuseIdentifier :String = ""
    
    public var beginPage :Int = 0
    public var pageSize :Int = 20
    public var httpPageKey :String = "pageNo"
    public var httpPageSizeKey :String = "pageSize"
    public var isLoadPage :Bool = true
    
    public var httpClient :HttpClient = HttpClient()
    public var httpPageStrategy :HttpStrategy = BaseHttpStrategy()

    
    open lazy var refreshHeader: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshTableHeaderDidTriggerRefresh))
        return header!
    }()
    open lazy var loadMoreFooter: MJRefreshAutoNormalFooter = {
        let header = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreTableHeaderDidTriggerRefresh))
        return header!
    }()
    
    public func beginRefreshing(){
        if self.dataItems.count == 0 {
            self.httpStatusView.show(inView: self, mode: .loading)
        }
        self.refreshTableHeaderDidTriggerRefresh()
    }
    open lazy var httpStatusView: HttpStatusView = {
        let view = HttpStatusView(frame: CGRect(x: 0, y: 0, width: _SW, height: _SH))
        view.addTarget(self, action: #selector(refreshRequest), for: .touchUpInside)
        return view
    }()
    @objc open func refreshRequest(){
        self.httpClient.request()
    }
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
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
    lazy var endingView :MJRefreshFooter = {
        let view = MJRefreshFooter(frame: CGRect(x: 0, y: 0, width: _SW, height: 60))
        let endingView = HttpEndingView(frame: CGRect(x: 0, y: 0, width: _SW, height: 60))
        view.addSubview(endingView)
        return view
    }()
}
extension HttpCollectionView :HttpResponseHandle{
    public func didSuccess(response :[String:Any], statusCode :Int){
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
 
            self.httpStatusView.show(inView: self, mode: .noData, msg: "暂时无数据")
        }else{
            if isLoadPage {
                if dataCount >= pageSize {
                    self.mj_footer = loadMoreFooter
                }else{
                    self.mj_footer = nil
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
        self.httpStatusView.show(inView: self, mode: .error, msg: "请求失败了！点击空白处刷新页面", note: "")
    }
}
extension HttpCollectionView: UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataItems.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        return cell
    }
}

