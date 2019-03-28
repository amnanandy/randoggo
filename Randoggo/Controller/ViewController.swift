//
//  ViewController.swift
//  Randoggo
//
//  Created by Anna Mandy on 3/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // fetch breed list on app launch
        DogAPI.requestBreedsList(completionHandler: handleBreedListPopulation(dogBreeds:error:))
    }

    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        // TODO fetch the image and display it in the imageView
        guard let imageURL = URL(string: imageData?.message ?? "") else {
            return
        }
        DogAPI.requestImageFile(imageURL: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        // closure is on a random thread, need to dispatch UI update to main thread
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func handleBreedListPopulation(dogBreeds: [String], error: Error?) {
        self.breeds = dogBreeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    // JSON = Javascript object notation
    // JSON objects have keys and values as properties, comma seperated.
    // process for getting data out of json object => "parsing"
    // parsing could include converting to a dictionary or sutom struct.'
    
    // 2 common methods:
    
    // JSONSerialization (traditional) - converts JSON to and from swift dictionaries
    // Codable (modern), introduced in Swift 4 - protocol used to convert data to and from Swift types, then extracting individual values.

    //Codable Protocol
     // made up of Encodable (from swift object (class or struct that conforms to the codable protocol) to JSON)
     // and Decodable (from JSON to instance of swift model object, such as struct)
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // user only eslecting one value in picker
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
    }
}
