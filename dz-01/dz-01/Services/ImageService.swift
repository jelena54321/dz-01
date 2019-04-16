//
//  ImageService.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 04/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import UIKit

/// Class which provides acquiring image from server.
class ImageService {
    
    /**
     Fetches image using provided url source.
     
     - Parameters:
        - urlString: string representation of url source
        - onComplete: action which will be executed once fetch is finished
     */
    func fetchImage(urlString: String, onComplete: @escaping ((UIImage?) -> Void)) {
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let unwrappedData = data {
                    onComplete(UIImage(data: unwrappedData))
                } else {
                    onComplete(nil)
                }
            }
            
            dataTask.resume()
        } else {
            onComplete(nil)
        }
    }
}
