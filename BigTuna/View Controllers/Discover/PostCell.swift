//
//  PostCell.swift
//  BigTuna
//
//  Created by James Wu on 3/24/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required init not implemented for PostCell!")
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .brown
        addSubview(label)
        
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func setData(text:String) {
        label.text = text
    }
}
