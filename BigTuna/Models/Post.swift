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
    var postImageLink: URL?
    
    var priceRange: PriceRange?
    
    var menuItems: Array<String>
    var tags: Array<String>
    
    var rating: Rating?
    
    var description: String
    
    var uploadDate: Date?
    var lastEdited: Date?
    
    init(uploader: User, recommended: Bool, postImageLink: URL?, priceRange: PriceRange?, menuItems: Array<String>, tags: Array<String>, rating: Rating?, description: String, uploadDate: Date?, lastEdited: Date?) {
        self.uploader = uploader;
        self.recommended = recommended;
        self.postImageLink = postImageLink!;
        self.priceRange = priceRange;
        self.menuItems = menuItems;
        self.tags = tags;
        self.rating = rating;
        self.description = description;
        self.uploadDate = uploadDate;
        self.lastEdited = lastEdited;
    }
}

enum PriceRange: Int {
    case cheap = 1, moderate, costly, expensive
}

enum Rating: Int {
    case worst = 1, bland, satisfactory, great, best
}
