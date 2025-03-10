//
//  UIImageView+Loadable.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func downloaded(from url: URL) {
        if let cacheImage = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
//            print("Using cached image...")
            self.image = cacheImage
            return
        }        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
                  else { return }
            
            imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()        
    }
    
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}


