//
//  FontExtension.swift
//  BigTuna
//
//  Created by James Wu on 3/31/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    // Based on https://stackoverflow.com/a/47307499
    @objc var substituteFontName : String {
        get { return self.font.fontName }
        set {
            self.font = UIFont(name: newValue, size: self.font.pointSize)
            self.adjustsFontSizeToFitWidth = true
        }
    }
}
