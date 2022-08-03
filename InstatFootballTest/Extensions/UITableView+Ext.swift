//
//  UITableView+Ext.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation
import UIKit

extension UITableView {
    func register(_ cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    /// Делает dequeueReusableCell(withIdentifier:for:) и сразу кастит возвращаемую ячейку в нужный тип.
    /// В качестве идентификатора используется название класса. Для задания своего идентификатора нужно переопределить
    /// static var reuseIdentifier в классе ячейки.
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Не удалось сделать dequeue ячейки с типом \(T.self) " +
                    "и reuseIdentifier \(T.reuseIdentifier). " +
                    "Убедитесь, что вы зарегистировали ячейку"
            )
        }
        
        return cell
    }
}

private extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
