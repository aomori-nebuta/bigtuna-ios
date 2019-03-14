//
//  User.swift
//  BigTuna
//
//  Created by James Wu on 1/7/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var userName: String
    var fullName: String
    
    var profilePicture: UIImage
    
    var followers: [User]
    var posts: [Post]
    
    var description: String

}
