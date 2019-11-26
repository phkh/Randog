//
//  DogAPI.swift
//  Randog
//
//  Created by Philip on 11/26/19.
//  Copyright © 2019 Philip Khegay. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
                
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
                
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
        class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage : UIImage = UIImage(data: data)!
            completionHandler(downloadedImage, nil)
        }
        task.resume()
    }
    
        class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndPoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndPoint) { (data, response, error) in
        guard let data = data else {
            completionHandler(nil, error)
            return
        }
        let decoder = JSONDecoder()
        let imageData = try! decoder.decode(DogImage.self, from: data)
        completionHandler(imageData, nil)
        print(imageData)
        
        }
        task.resume()
    }
    
    class func requestAllBreeds(completionHandler: @escaping ([String], Error?) -> Void) {
        let allBreedsEndPoint = DogAPI.Endpoint.listAllBreeds.url
        let task = URLSession.shared.dataTask(with: allBreedsEndPoint) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            let list = try! decoder.decode(BreedsListResponse.self, from: data)
            let breeds = list.message.keys.map({$0})
            completionHandler(breeds, nil)
        }
        task.resume()
        
    }
}


