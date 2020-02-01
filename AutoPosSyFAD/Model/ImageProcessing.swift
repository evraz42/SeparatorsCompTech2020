//
//  ImageProcessing.swift
//  AutoPosSyFAD
//
//  Created by Madara2hor on 01.02.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

class ImageProcessing {
    
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: urlString)
            
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
            
        dataTask.resume()
    }
    
}
