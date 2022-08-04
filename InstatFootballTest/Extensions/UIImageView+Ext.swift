//
//  UIImageView+Ext.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

extension UIImageView {
    private var imageDownloader: ImageDownloader {
        ImageDownloader.shared
    }
    
    func setImage(for url: String?, with placeHolder: UIImage? = nil) {
        image = placeHolder
        imageDownloader.downloadImage(with: url, completionHandler: { image in
            self.image = image
        }, placeholder: placeHolder)
    }
}
