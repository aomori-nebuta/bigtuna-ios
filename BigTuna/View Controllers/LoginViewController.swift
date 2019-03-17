//
//  LoginViewController.swift
//  BigTuna
//
//  Created by James Wu on 1/17/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var signInTextFieldContainer: UIView?
    var signUpTextFieldContainer: UIView?
    
    lazy var segmentedControl = UISegmentedControl(items: ["sign in", "sign up"])

    
    struct Errors {
        static let missingFields: String = "Please enter all fields."
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()


        // Observers that listen for keyboard change events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        // Remove the keyboard observers on deallocation
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setupLayout() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebubbles")!)
        
        // Upper third partition of screen contains the image
        let imageContainer: UIView = {
            // Image
            let image = UIImage(named: "bigtunalogo2")
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            
            let container = UIView()
            container.backgroundColor = .blue
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5).isActive = true
            imageView.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5).isActive = true
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            
            return container
        }()
        
        // Middle third partition of screen contains the segmented control and text fields
        let inputContainer: UIView = {
            let container = UIView()
            container.backgroundColor = .yellow
            container.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(segmentedControl)
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            segmentedControl.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true;
            segmentedControl.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.3).isActive = true;
            segmentedControl.topAnchor.constraint(equalTo: container.topAnchor).isActive = true;
            
            // 'sign in' is initially selected
            segmentedControl.selectedSegmentIndex = 0
            
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
            
            signInTextFieldContainer = {
                let signInContainer = UIView()
                signInContainer.translatesAutoresizingMaskIntoConstraints = false
                
                let signInStackView: UIStackView = {
                    let emailTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signInContainer.frame.width, height: signInContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "email"
                        textField.stylizedTextField()
                        return textField
                    }()
                    
                    let passwordTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signInContainer.frame.width, height: signInContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "password"
                        textField.stylizedTextField()
                        return textField
                    }()
                    
                    let signInStack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
                    signInStack.translatesAutoresizingMaskIntoConstraints = false
                    signInStack.axis = .vertical
                    signInStack.distribution = .fillEqually
                    signInStack.alignment = .center
                    
                    emailTextField.anchorTo(signInStack)
                    passwordTextField.anchorTo(signInStack)
                    
                    signInStack.spacing = 10

                    return signInStack
                }()
                
                signInContainer.addSubview(signInStackView)
                
                signInStackView.centerXAnchor.constraint(equalTo: signInContainer.centerXAnchor).isActive = true
                signInStackView.centerYAnchor.constraint(equalTo: signInContainer.centerYAnchor).isActive = true
                signInStackView.widthAnchor.constraint(equalTo: signInContainer.widthAnchor).isActive = true

                return signInContainer
            }()
            
            signUpTextFieldContainer = {
                let signUpContainer = UIView()
                signUpContainer.translatesAutoresizingMaskIntoConstraints = false
                
                let signUpStackView: UIStackView = {
                    let usernameTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signUpContainer.frame.width, height: signUpContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "username"
                        textField.stylizedTextField()
                        return textField
                    }()
                    
                    let emailTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signUpContainer.frame.width, height: signUpContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "email"
                        textField.stylizedTextField()
                        return textField
                    }()
                    
                    let passwordTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signUpContainer.frame.width, height: signUpContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "password"
                        textField.stylizedTextField()
                        textField.isSecureTextEntry = true
                        return textField
                    }()
                    
                    let confirmPasswordTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signUpContainer.frame.width, height: signUpContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "confirm password"
                        textField.stylizedTextField()
                        textField.isSecureTextEntry = true
                        return textField
                    }()
                    
                    let signUpStack = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField])
                    signUpStack.translatesAutoresizingMaskIntoConstraints = false
                    signUpStack.axis = .vertical
                    signUpStack.distribution = .fillEqually
                    signUpStack.alignment = .center
                    
                    usernameTextField.anchorTo(signUpStack)
                    emailTextField.anchorTo(signUpStack)
                    passwordTextField.anchorTo(signUpStack)
                    confirmPasswordTextField.anchorTo(signUpStack)
                    
                    signUpStack.spacing = 10
                    
                    return signUpStack
                }()
                
                signUpContainer.addSubview(signUpStackView)
                
                signUpStackView.centerXAnchor.constraint(equalTo: signUpContainer.centerXAnchor).isActive = true
                signUpStackView.centerYAnchor.constraint(equalTo: signUpContainer.centerYAnchor).isActive = true
                signUpStackView.widthAnchor.constraint(equalTo: signUpContainer.widthAnchor).isActive = true
                
                signUpContainer.alpha = 0.0
                
                return signUpContainer
            }()
            
            container.addSubview(signInTextFieldContainer!)
            container.addSubview(signUpTextFieldContainer!)

            signInTextFieldContainer?.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            signInTextFieldContainer?.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
            signInTextFieldContainer?.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            signInTextFieldContainer?.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor).isActive = true
            
            signUpTextFieldContainer?.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            signUpTextFieldContainer?.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
            signUpTextFieldContainer?.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            signUpTextFieldContainer?.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor).isActive = true

            return container
        }()

        // Bottom third of screen contains buttons
        let buttonContainer: UIView = {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false

            container.backgroundColor = .green

            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(button)
            button.backgroundColor = .green

            button.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            button.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5).isActive = true
            button.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5).isActive = true
            
            return container
        }()
        
        // Stack view wrapper
        let primaryStackView = UIStackView(arrangedSubviews: [imageContainer, inputContainer, buttonContainer])
        view.addSubview(primaryStackView)
        primaryStackView.translatesAutoresizingMaskIntoConstraints = false
        primaryStackView.axis = .vertical
        primaryStackView.alignment = .center
        primaryStackView.distribution = .fillProportionally
        primaryStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        primaryStackView.heightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.heightAnchor).isActive = true
        primaryStackView.widthAnchor.constraint(equalTo:view.safeAreaLayoutGuide.widthAnchor).isActive = true
        primaryStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        primaryStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        primaryStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        primaryStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
       
        imageContainer.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor).isActive = true
        imageContainer.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.45).isActive = true
        
        inputContainer.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor).isActive = true
        inputContainer.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.30).isActive = true
        
        buttonContainer.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor).isActive = true
        buttonContainer.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.25).isActive = true
        
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            signUpTextFieldContainer!.fadeOut()
            signInTextFieldContainer!.fadeIn()
            
        case 1:
            signInTextFieldContainer!.fadeOut()
            signUpTextFieldContainer!.fadeIn()

        default:
            return
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        // Moves keyboard up
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            // Moves keyboard down
            view.frame.origin.y = 0
        }
    }
}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        })
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
