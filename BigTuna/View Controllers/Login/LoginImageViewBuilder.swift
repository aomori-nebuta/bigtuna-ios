//
//  LoginViewBuilder.swift
//  BigTuna
//
//  Created by Christine Tsou on 3/19/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class LoginImageViewBuilder: NSObject {
    
    private let container = UIView()
    private let imageView = UIImageView()
    private let logoImageName = "bigtunalogo2"
    
    override init() {
        super.init()
        self.setupView()
        self.setViewProperties()
    }
    
    func getView() -> UIView {
        return container
    }
    
    private func setupView() {
        container.addSubview(imageView)
    }
    
    private func setViewProperties() {
        container.translatesAutoresizingMaskIntoConstraints = false
        setImageViewProperties()
    }
    
    private func setImageViewProperties() {
        let image = UIImage(named: self.logoImageName)
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5).isActive = true
        imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }
}
