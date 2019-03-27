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
    
    let imageBuilder = LoginImageViewBuilder()
    let inputBuilder = LoginInputViewBuilder()
    let buttonBuilder = LoginButtonViewBuilder()
    
    var primaryStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setViewProperties()
        setTargetSelectors()

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
    
    func setupView() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebubbles")!)
        
        // Stack view wrapper
        primaryStackView = UIStackView(arrangedSubviews: [imageBuilder.getView(), inputBuilder.getView(), buttonBuilder.getView()])
        view.addSubview(primaryStackView)
    }
    
    func setViewProperties() {
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
        
        let imageContainer = imageBuilder.getView()
        imageContainer.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor).isActive = true
        imageContainer.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.45).isActive = true
        
        let inputContainer = inputBuilder.getView()
        inputContainer.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor).isActive = true
        inputContainer.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.30).isActive = true
        
        let buttonContainer = buttonBuilder.getView()
        buttonContainer.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor).isActive = true
        buttonContainer.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.25).isActive = true
    }
    
    func setTargetSelectors() {
        let segControlSelector = #selector(self.segmentedControlValueChanged(_:))
        inputBuilder.setSegmentedControlTarget(target: self, targetAction: segControlSelector)
        
        let signInSelector = #selector(self.signInButtonPressed(_:))
        buttonBuilder.setSignInButtonTarget(target: self, targetAction: signInSelector)
        
        let signUpSelector = #selector(self.signUpButtonPressed(_:))
        buttonBuilder.setSignUpButtonTarget(target: self, targetAction: signUpSelector)
    }
    
    /**
     Handle keyboard notifications.
     - Author:
     James Wu
     
     - parameters:
        - notification: The notification signaling keyboard change.
     
     Moves the entire view up on UIResponder.keyboardWillShowNotification or UIResponder.keyboardWillChangeFrameNotification notifications so
     the keyboard will not obstruct any vital view.
 
     Moves the entire view back to its original position when the user decides to close the keyboard.
     */
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
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            inputBuilder.showSignInInputs()
            buttonBuilder.showSignInButton()
            
        case 1:
            inputBuilder.showSignUpInputs()
            buttonBuilder.showSignUpButton()
            
        default:
            return
        }
    }
    
    @objc func signInButtonPressed(_ sender: UIButton) {
        guard let signInStackView = primaryStackView.viewWithTag(LoginInputViewTags.signInStackView.rawValue) as? UIStackView else { return }

        guard let emailTextField = signInStackView.viewWithTag(LoginInputViewTags.signInEmail.rawValue) as? UITextField else { return }
        guard let passwordTextField = signInStackView.viewWithTag(LoginInputViewTags.signInPassword.rawValue) as? UITextField else { return }

        guard let email = emailTextField.text, let password = passwordTextField.text,
        !email.isEmpty, !password.isEmpty else {
            self.presentAlert(message: ErrorEnum.emptyFields.rawValue)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if let error = error {
                self.presentAlert(message: error.localizedDescription)
                return
            } else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController

                self.present(mainTabBarController, animated: true, completion: nil)
            }
        }
    }

    @objc func signUpButtonPressed(_ sender: UIButton) {
        // Retrieve UI elements
        guard let signUpStackView = primaryStackView.viewWithTag(LoginInputViewTags.signUpStackView.rawValue) as? UIStackView else { return }

        guard let usernameTextField = signUpStackView.viewWithTag(LoginInputViewTags.signUpUsername.rawValue) as? UITextField else { return }
        guard let emailTextField = signUpStackView.viewWithTag(LoginInputViewTags.signUpEmail.rawValue) as? UITextField else { return }
        guard let passwordTextField = signUpStackView.viewWithTag(LoginInputViewTags.signUpPassword.rawValue) as? UITextField else { return }
        guard let confirmPasswordTextField = signUpStackView.viewWithTag(LoginInputViewTags.signUpConfirmPassword.rawValue) as? UITextField else { return }

        // Confirm all text fields are filled
        // Based on https://stackoverflow.com/a/52139394
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                presentAlert(message: ErrorEnum.emptyFields.rawValue)
                return
        }

        // Confirm passwords match
        if password != confirmPassword {
            presentAlert(message: ErrorEnum.passwordConfirmationMismatch.rawValue)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            if let error = error {
                self.presentAlert(message: error.localizedDescription)
                return
            } else {
                guard let user = authResult?.user else { return }

                // Take user to MainTabBarController
                let mainTabBarController = MainTabBarController()

                self.navigationController?.pushViewController(mainTabBarController, animated: true)
            }
        }

    }
    
    /**
     Present the sign-in/sign-up error messages, if any.
     - Author:
     James Wu
     
     - parameters:
        - message: The error message to present to the user.
     */
    func presentAlert(message alert: String) {
        let alert = UIAlertController(title: "Error!", message: alert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

enum ErrorEnum: String {
    case emptyFields = "Please fill in all fields."
    case passwordConfirmationMismatch = "Password confirmation is incorrect."
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
