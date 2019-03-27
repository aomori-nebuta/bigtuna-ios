//
//  LoginButtonViewBuilder.swift
//  BigTuna
//
//  Created by Christine Tsou on 3/24/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class LoginButtonViewBuilder: NSObject {

    private let container = UIView()
    private let signInButton = UIButton()
    private let signUpButton = UIButton()
    
    override init() {
        super.init()
        self.setupView()
        self.setViewProperties()
    }
    
    func getView() -> UIView {
        return container
    }
    
    func setSignInButtonTarget(target: Any, targetAction: Selector) {
        signInButton.addTarget(target, action: targetAction, for: .touchUpInside)
    }
    
    func setSignUpButtonTarget(target: Any, targetAction: Selector) {
        signUpButton.addTarget(target, action: targetAction, for: .touchUpInside)
    }
    
    func showSignInButton() {
        signInButton.fadeIn()
        signUpButton.fadeOut()
    }
    
    func showSignUpButton() {
        signUpButton.fadeIn()
        signInButton.fadeOut()
    }
    
    private func setupView() {
        container.addSubview(signInButton)
        container.addSubview(signUpButton)
    }
    
    private func setViewProperties() {
        setContainerProperties()
        setButtonViewProperties()
    }
    
    private func setContainerProperties() {
        container.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setButtonViewProperties() {
        setButtonProperties(button: signInButton, buttonText: "sign in")
        setButtonProperties(button: signUpButton, buttonText: "sign up")
        
        signUpButton.alpha = 0.0
    }
    
    private func setButtonProperties(button: UIButton, buttonText: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(buttonText, for: .normal)
        button.anchorTo(container)
    }
    
}

extension UIButton {
    func anchorTo(_ view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
    }
}
