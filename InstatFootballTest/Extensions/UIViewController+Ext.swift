//
//  UIViewController+Ext.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

extension UIViewController {
    func showRepeatScreen(_ repeatCompletion: (() -> Void)?) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Что-то пошло не так...",
                                      preferredStyle: .alert)
        
        let repeatAction = UIAlertAction(title: "Повторить снова", style: .default) { _ in
            repeatCompletion?()
        }
                
        alert.addAction(repeatAction)        
        present(alert, animated: true)
    }
}
