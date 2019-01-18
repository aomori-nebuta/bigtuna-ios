//
//  Restaurant.swift
//  BigTuna
//
//  Created by James Wu on 1/7/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import Foundation
import UIKit

struct Restaurant {
    var distance: String
    var address: String
    
    var phoneNumber: String
    var website: String
    
    var ratings: [String: Float]
    
    var tags: [String]
    
    var images: [UIImage]
    
    var uploadDate: Date
    var lastEdited: Date
}
