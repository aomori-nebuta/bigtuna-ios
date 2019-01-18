//
//  Post.swift
//  BigTuna
//
//  Created by James Wu on 1/7/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    var uploader: User
    var recommended: Bool
    var postImage: UIImage
    
    var priceRange: PriceRange
    
    var menuItems: [String]
    var tags: [String]
    
    var rating: Rating
    
    var comment: String
    
    var uploadDate: Date
    var lastEdited: Date
    
}

enum PriceRange: Int {
    case cheap = 1, moderate, costly, expensive
}

enum Rating: Int {
    case worst = 1, bland, satisfactory, great, best
}
