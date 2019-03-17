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
    
    struct Errors {
        static let missingFields: String = "Please enter all fields."
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()


        // Observers that listen for keyboard change events
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        // Remove the keyboard observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setupLayout() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebubbles")!)
        
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
        
        let inputContainer: UIView = {
            let container = UIView()
            container.backgroundColor = .yellow
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let segmentedControl = UISegmentedControl(items: ["sign in", "sign up"])
            container.addSubview(segmentedControl)
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            segmentedControl.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true;
            segmentedControl.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.3).isActive = true;
            segmentedControl.topAnchor.constraint(equalTo: container.topAnchor).isActive = true;
            
            // 'sign in' is initially selected
            segmentedControl.selectedSegmentIndex = 0
            
            let signInTextFieldContainer: UIView = {
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
            
//            let signUpTextFieldContainer: UIView = {
//                let signUpContainer = UIView()
//                signUpContainer.isHidden = true
//                return signUpContainer
//            }()
            
            container.addSubview(signInTextFieldContainer)
//            container.addSubview(signUpTextFieldContainer)
            
            signInTextFieldContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            signInTextFieldContainer.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
            signInTextFieldContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            signInTextFieldContainer.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor).isActive = true

            return container
        }()

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


//        imageView.contentMode = .scaleAspectFit
        //        view.addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        imageView.centerXAnchor.constraint(equalTo: primaryStackView.centerXAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: primaryStackView.topAnchor, constant: 50).isActive = true
        
        
//        imageView.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor, multiplier: 0.5).isActive = true
//        imageView.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.5).isActive = true
//        imageView.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.9).isActive = true

        
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
