//
//  MJRefreshableTool.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/5/22.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation

enum RefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    case beginFooterRefresh
    case endFooterRefresh
    case noMoreData
}

protocol RefreshProtocol {
    // 告诉外界的tableView当前的刷新状态
    var refreshStatus : Variable<RefreshStatus>{get}
}

extension RefreshProtocol {
    
    func autoSetRefreshControlStatus(header: MJRefreshHeader?, footer: MJRefreshFooter?) -> Disposable {
        return refreshStatus.asObservable().subscribe(onNext: { (status) in
            switch status {
            case .beginHeaderRefresh:
                header?.beginRefreshing()
            case .endHeaderRefresh:
                header?.endRefreshing()
            case .beginFooterRefresh:
                footer?.beginRefreshing()
            case .endFooterRefresh:
                footer?.endRefreshing()
            case .noMoreData:
                footer?.endRefreshingWithNoMoreData()
            default:
                break
            }
        })
    }
}

/* ============================ Refreshable ================================ */
// 需要使用 MJExtension 的控制器使用
protocol Refreshable {
    
}
extension Refreshable where Self : UIViewController {
    func initRefreshHeader(_ scrollView: UIScrollView, _ action: @escaping () -> Void) -> MJRefreshHeader {
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { action() })
        return scrollView.mj_header
    }
    
    func initRefreshFooter(_ scrollView: UIScrollView, _ action: @escaping () -> Void) -> MJRefreshFooter {
        scrollView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { action() })
        return scrollView.mj_footer
    }
}

extension Refreshable where Self : UIScrollView {
    func initRefreshHeader(_ action: @escaping () -> Void) -> MJRefreshHeader {
        mj_header = MJRefreshNormalHeader(refreshingBlock: { action() })
        return mj_header
    }
    
    func initRefreshFooter(_ action: @escaping () -> Void) -> MJRefreshFooter {
        mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { action()})
        return mj_footer
    }
}
