//
//  DogImage.swift
//  Randoggo
//
//  Created by Anna Mandy on 3/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation

/*
 * Response from DogAPI consists of two values, included below.
 */
struct DogImage: Codable {
    let status: String
    let message: String //string containing URL of image
}
