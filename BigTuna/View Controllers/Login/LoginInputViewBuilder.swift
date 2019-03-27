//
//  LoginInputViewBuilder.swift
//  BigTuna
//
//  Created by Christine Tsou on 3/19/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class LoginInputViewBuilder: NSObject {
    
    private let container = UIView()
    private let signInContainer = UIView()
    private let signUpContainer = UIView()
    private let segmentedControl = UISegmentedControl(items: ["sign in", "sign up"])
    
    private var signInStackView = UIStackView()
    private var signUpStackView = UIStackView()
    
    override init() {
        super.init()
        self.setupView()
        self.setViewProperties()
    }
    
    func getView() -> UIView {
        return container
    }
    
    func showSignInInputs() {
        signUpContainer.fadeOut()
        signInContainer.fadeIn()
    }
    
    func showSignUpInputs() {
        signInContainer.fadeOut()
        signUpContainer.fadeIn()
    }
    
    func setSegmentedControlTarget(target: Any, targetAction: Selector) {
        segmentedControl.addTarget(target, action: targetAction, for: .valueChanged)
    }
    
    private func setupView() {
        container.addSubview(segmentedControl)
        
        setupSignInStackView()
        signInContainer.addSubview(signInStackView)
        setupSignUpStackView()
        signUpContainer.addSubview(signUpStackView)
        
        container.addSubview(signInContainer)
        container.addSubview(signUpContainer)
    }
    
    private func setViewProperties() {
        setContainerProperties()
        setSegmentedControlProperties()
        
        setInputContainerProperties(inputContainer: signInContainer)
        setInputContainerProperties(inputContainer: signUpContainer)
        
        setStackViewProperties(stackContainer: signInContainer, stack: signInStackView, stackTag: LoginInputViewTags.signInStackView.rawValue)
        setStackViewProperties(stackContainer: signUpContainer, stack: signUpStackView, stackTag: LoginInputViewTags.signUpStackView.rawValue)
        
        // Set sign up container to not visible
        signUpContainer.alpha = 0.0
    }
    
    private func setContainerProperties() {
        container.translatesAutoresizingMaskIntoConstraints = false
        signInContainer.translatesAutoresizingMaskIntoConstraints = false
        signUpContainer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setInputContainerProperties(inputContainer: UIView) {
        inputContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        inputContainer.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        inputContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor).isActive = true
    }
    
    private func setSegmentedControlProperties() {
        segmentedControl.tintColor = .white
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true;
        segmentedControl.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5).isActive = true;
        segmentedControl.topAnchor.constraint(equalTo: container.topAnchor).isActive = true;
        
        // 'sign in' is initially selected
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func setStackViewProperties(stackContainer: UIView, stack: UIStackView, stackTag: Int) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        stack.spacing = 10
        stack.tag = stackTag
        
        stack.centerXAnchor.constraint(equalTo: stackContainer.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: stackContainer.centerYAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: stackContainer.widthAnchor).isActive = true
    }
    
    private func setupSignInStackView() {
        let emailTextField = getInputTextField(container: signInContainer, placeholder: "email", tagValue: LoginInputViewTags.signInEmail.rawValue)
        let passwordTextField = getInputTextField(container: signInContainer, placeholder: "password", tagValue: LoginInputViewTags.signInPassword.rawValue)
        
        signInStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        emailTextField.anchorTo(signInStackView)
        passwordTextField.anchorTo(signInStackView)
    }
    
    private func setupSignUpStackView() {
        let usernameTextField = getInputTextField(container: signUpContainer, placeholder: "username", tagValue: LoginInputViewTags.signUpUsername.rawValue)
        let emailTextField = getInputTextField(container: signUpContainer, placeholder: "email", tagValue: LoginInputViewTags.signUpEmail.rawValue)
        let passwordTextField = getInputTextField(container: signUpContainer, placeholder: "password", tagValue: LoginInputViewTags.signUpPassword.rawValue)
        let confirmPasswordTextField = getInputTextField(container: signUpContainer, placeholder: "confirm password", tagValue: LoginInputViewTags.signUpConfirmPassword.rawValue)
        
        signUpStackView = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField])
        usernameTextField.anchorTo(signUpStackView)
        emailTextField.anchorTo(signUpStackView)
        passwordTextField.anchorTo(signUpStackView)
        confirmPasswordTextField.anchorTo(signUpStackView)
    }
    
    private func getInputTextField(container: UIView, placeholder: String, tagValue: Int) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height * 0.10))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.stylizedTextField()
        textField.tag = tagValue
        return textField
    }
}

extension UITextField {
    func stylizedTextField() {
        self.backgroundColor = .white
        self.borderStyle = .roundedRect
        self.textAlignment = .left
    }
    
    func anchorTo(_ view: UIView) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
