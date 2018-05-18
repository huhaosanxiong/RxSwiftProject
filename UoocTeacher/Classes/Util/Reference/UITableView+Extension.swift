//
//  UITableView+Extension.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/5/17.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation

protocol Reusable {
    static var reuserIdentifier: String { get }
}

extension Reusable {
    static var reuserIdentifier : String {
        return String(describing: self)
    }
}


extension UIViewController: Reusable {}
extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
//extension UICollectionViewCell: Reusable {}
//extension UICollectionReusableView: Reusable {}

extension UITableView {
    
    func cell<T: UITableViewCell>(ofType cellType: T.Type = T.self, reuserIdentifier: String = T.reuserIdentifier) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuserIdentifier) as? T else {
            fatalError()
        }
        return cell
    }
    
    func headerFooter<T: UITableViewHeaderFooterView>(ofType viewType: T.Type, reuserIdentifier: String = T.reuserIdentifier) -> T {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: T.reuserIdentifier) as? T else {
            fatalError()
        }
        return view
    }
    
    func registerCell<T :UITableViewCell>(ofType cell : T.Type) {
        register(cell, forCellReuseIdentifier: T.reuserIdentifier)
    }
}
