//
//  UIViewController+Ext.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

extension UIViewController {
    func showRepeatScreen(withCancelButton: Bool = false, _ repeatCompletion: (() -> Void)?) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Что-то пошло не так...",
                                      preferredStyle: .alert)
        
        let repeatAction = UIAlertAction(title: "Повторить снова", style: .default) { _ in
            repeatCompletion?()
        }
                
        alert.addAction(repeatAction)
        
        if withCancelButton {
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true)
    }
}
