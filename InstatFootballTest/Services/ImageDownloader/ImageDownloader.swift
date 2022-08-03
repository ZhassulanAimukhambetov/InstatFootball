//
//  ImageDownloader.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import UIKit

final class ImageDownloader {
    static let shared = ImageDownloader()
    
    private var imagesDownloadTasks: [String: URLSessionDataTask]
    private let serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)
    
    private init() {
        imagesDownloadTasks = [:]
    }
    
    func downloadImage(with urlString: String?,
                       completionHandler: @escaping (UIImage?) -> Void,
                       placeholder: UIImage?) {
        guard let urlString = urlString else {
            completionHandler(placeholder)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completionHandler(placeholder)
            return
        }
        
        if let _ = dataTaskFrom(urlString: urlString) {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [urlString] (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(placeholder)
                }
                return
            }
            
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler(placeholder)
                }
                return
            }
            
            let image = UIImage(data: data)
            
            _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                self.imagesDownloadTasks.removeValue(forKey: urlString)
            }
            
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
        
        self.serialQueueForDataTasks.sync(flags: .barrier) {
            imagesDownloadTasks[urlString] = task
        }
        
        task.resume()
    }
    
    private func cancelPreviousTask(with urlString: String?) {
        if let urlString = urlString, let task = dataTaskFrom(urlString: urlString) {
            task.cancel()
            _ = serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks.removeValue(forKey: urlString)
            }
        }
    }
    
    private func dataTaskFrom(urlString: String) -> URLSessionTask? {
        serialQueueForDataTasks.sync {
            return imagesDownloadTasks[urlString]
        }
    }
}



enum Identifier {
    typealias Value = UInt
    static var current: Value = 0
    static func next() -> Value {
        current += 1
        return current
    }
}
