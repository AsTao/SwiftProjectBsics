//
//  THttpCollectionView.swift
//  Alamofire
//
//  Created by tao on 2019/11/13.
//

import UIKit
import MJRefresh

open class THttpCollectionView: BaseNiblessCollectionView {

    public var dataItems :[Any] = []
    public var cellReuseIdentifier :String = ""

    public var beginPage :Int = 1
    public var pageSize :Int = 20
    public var httpPageKey :String = "page"
    public var httpPageSizeKey :String = "pageSize"
    public var isLoadPage :Bool = true

    public var errorMessage :String = "加载失败"
    public var noDataMessage :String = "还没有内容哦"

    public var httpParameters :[String:Any] = [:]
    public var makeHttpProtocol :(() -> THttpProtocol)?

    public var tableViewDataHandle :((_ resp :THttpResp,_ page :Int) -> [Any]?)?
    
    public var ignoreHeaderViewHeight :CGFloat = 0

    public var _page :Int = 0
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        config()
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    open func config(){
        dataSource = self
        refreshHeader?.mj_h = 60
        loadMoreFooter?.mj_h = 60
        refreshHeader?.lastUpdatedTimeLabel?.isHidden = true
        refreshHeader?.backgroundColor = backgroundColor
        loadMoreFooter?.backgroundColor = backgroundColor
        mj_header = refreshHeader
    }
    
    open lazy var refreshHeader: MJRefreshNormalHeader? = {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshTableHeaderDidTriggerRefresh))
        return header
    }()
    
    open lazy var loadMoreFooter: MJRefreshAutoNormalFooter? = {
        let header = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreTableHeaderDidTriggerRefresh))
        return header
    }()
    
    open lazy var httpStatusView: THttpStatusView = {
        let view = THttpStatusView(frame: CGRect(x: 0, y: 0, width: _SW, height: _SH))
        view.addTarget(self, action: #selector(refreshRequest), for: .touchUpInside)
        return view
    }()
    
    public func endRefreshing(){
        refreshHeader?.endRefreshing()
        loadMoreFooter?.endRefreshing()
    }
    
    override open func reloadData() {
        super.reloadData()
        endRefreshing()
    }

}

extension THttpCollectionView {
    
    public func beginRefreshing(){
        if dataItems.count == 0 {
            httpStatusView.show(inView: self, mode: .load, ignh: ignoreHeaderViewHeight)
        }
        refreshTableHeaderDidTriggerRefresh()
    }
    
    public func showNotData(){
        httpStatusView.show(inView: self, mode: .data, msge: noDataMessage, ignh: ignoreHeaderViewHeight)
        dataItems.removeAll()
        reloadData()
    }
    
    @objc func refreshTableHeaderDidTriggerRefresh(){
        _page = beginPage
        request()
    }
    @objc func loadMoreTableHeaderDidTriggerRefresh(){
        request()
    }
    

    
    @objc open func refreshRequest(){
        httpStatusView.remove()
        beginRefreshing()
    }
    
    open func request(){
        
        guard var httpProtocol = makeHttpProtocol?() else{return}
        
        httpParameters.forEach { (k,v) in
            httpProtocol.parameters[k] = v
        }
        
        if isLoadPage {
            httpProtocol.parameters[httpPageKey] = _page
            httpProtocol.parameters[httpPageSizeKey] = pageSize
        }

        if let data = THttpClientManager.shared.cache.filter(httpProtocol.identifier) {
            didSuccess(data)
        }
        
        THttpClientManager.request(httpProtocol, success: { [weak self] resp in
            self?.didSuccess(resp)
        }, fail: { [weak self] resp in
            self?.didFail(resp.msge)
        })
    
    }
    
    
    open func didSuccess(_ model :THttpResp){
        if _page == beginPage {
                dataItems.removeAll()
        }
        _page += 1
        var dataCount :Int = 0
        if let list = tableViewDataHandle?(model,_page) {
            dataCount = list.count
            dataItems.append(contentsOf: list)
        }else{
            if let list =  model.list{
                dataCount = list.count
                dataItems.append(contentsOf: list)
            }
        }

        if dataItems.count == 0 {
            mj_footer = nil
            reloadData()
            httpStatusView.show(inView: self, mode: .data, msge: noDataMessage, ignh: ignoreHeaderViewHeight)
        }else{
            if isLoadPage {
                if dataCount >= pageSize {
                    mj_footer = loadMoreFooter
                }else{
                    mj_footer = nil
                }
            }
            httpStatusView.remove()
            reloadData()
        }
    }
    open func didFail(_ message: String = "请求失败了！点击空白处刷新页面"){
        reloadData()
        httpStatusView.show(inView: self, mode: .erro, msge: errorMessage, ignh: ignoreHeaderViewHeight)
    }
}


extension THttpCollectionView :UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        return cell
    }
}
