//
//  UIImageView+Ext.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

extension UIImageView {
    func setImage(with urlString: String?, placeholder: UIImage? = nil) {
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()

        image = placeholder
        guard let urlString = urlString else { return }

        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            image = cachedImage
            return
        }
        
        download(with: urlString)
    }
}

extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0

    private var currentTask: URLSessionTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var currentURL: URL? {
        get { objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private func download(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        currentURL = url
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil

            guard error == nil,
                  let data = data,
                  let downloadedImage = UIImage(data: data) else {
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: urlString)

            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }

        currentTask = task
        task.resume()
    }
}

extension UIImageView {
    private class ImageCache {
        private let cache = NSCache<NSString, UIImage>()
        private var observer: NSObjectProtocol?

        static let shared = ImageCache()

        private init() {
            observer = NotificationCenter.default.addObserver(
                forName: UIApplication.didReceiveMemoryWarningNotification,
                object: nil,
                queue: nil
            ) { [weak self] notification in
                self?.cache.removeAllObjects()
            }
        }

        deinit {
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }

        func image(forKey key: String) -> UIImage? {
            return cache.object(forKey: key as NSString)
        }

        func save(image: UIImage, forKey key: String) {
            cache.setObject(image, forKey: key as NSString)
        }
    }
}
