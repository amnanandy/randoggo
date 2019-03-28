//
//  DogAPI.swift
//  Randoggo
//
//  Created by Anna Mandy on 3/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation
import UIKit

/*
 */
class DogAPI {
    
    /*
    */
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            }
        }
    }
    
    /*
    */
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) {
        let listAllBreedsEndpoint = DogAPI.Endpoint.listAllBreeds.url
        
        let listAllBreedsTask = URLSession.shared.dataTask(with: listAllBreedsEndpoint) {(data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                //parse json objects
                let breedResponse = try decoder.decode(BreedsList.self, from: data)
                let list = breedResponse.message.keys.map({$0})
                completionHandler(list, nil)
            } catch {
                print(error)
            }
        }
        listAllBreedsTask.resume()
    }
    
    /*
    */
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
       // let randomImageEndpoint = DogAPI.Endpoint.randomImageFromAllDogsCollection.url
        let randomImageForBreedEndpoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        
        let randomImageTask = URLSession.shared.dataTask(with: randomImageForBreedEndpoint) { (data, response, error) in
            guard let data = data else {
                // data not received. exit.
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData, nil)
        }
        randomImageTask.resume()
    }
    
    /*
    */
    class func requestImageFile(imageURL: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let urlTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        urlTask.resume()
    }
}
