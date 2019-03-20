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
    
    var signInButton: UIButton?
    var signUpButton: UIButton?
    
    lazy var segmentedControl = UISegmentedControl(items: ["sign in", "sign up"])

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
    
    /**
     Setup the sign-in/sign-up layout.
     
     Constructs the view into three row partitions via vertical UIStackView: the image UIView, the input UIView, and the button UIView.
     
     The image UIView simply holds the logo. The input UIView holds a UISegmentedControl and the form textfield container. Lastly,
     the button UIView contains any buttons to perform sign-in.

     - Author:
     James Wu
     
     - Version:
     0.1

     */
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
            container.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(segmentedControl)
            segmentedControl.tintColor = .white
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            segmentedControl.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true;
            segmentedControl.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5).isActive = true;
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
                        textField.tag = ViewTagsEnum.signInEmail.rawValue
                        return textField
                    }()
                    
                    let passwordTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signInContainer.frame.width, height: signInContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "password"
                        textField.isSecureTextEntry = true
                        textField.stylizedTextField()
                        textField.tag = ViewTagsEnum.signInPassword.rawValue
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
                    signInStack.tag = ViewTagsEnum.signInStackView.rawValue

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
                        textField.tag = ViewTagsEnum.signUpUsername.rawValue
                        return textField
                    }()
                    
                    let emailTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signUpContainer.frame.width, height: signUpContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "email"
                        textField.stylizedTextField()
                        textField.tag = ViewTagsEnum.signUpEmail.rawValue
                        return textField
                    }()
                    
                    let passwordTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signUpContainer.frame.width, height: signUpContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "password"
                        textField.stylizedTextField()
                        textField.isSecureTextEntry = true
                        textField.tag = ViewTagsEnum.signUpPassword.rawValue
                        return textField
                    }()
                    
                    let confirmPasswordTextField: UITextField = {
                        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: signUpContainer.frame.width, height: signUpContainer.frame.height * 0.10))
                        textField.translatesAutoresizingMaskIntoConstraints = false
                        textField.placeholder = "confirm password"
                        textField.stylizedTextField()
                        textField.isSecureTextEntry = true
                        textField.tag = ViewTagsEnum.signUpConfirmPassword.rawValue
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
                    signUpStack.tag = ViewTagsEnum.signUpStackView.rawValue
                    
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

            signInButton = UIButton()
            signInButton?.translatesAutoresizingMaskIntoConstraints = false
            signInButton?.setTitle("sign in", for: .normal)
            
            signUpButton = UIButton()
            signUpButton?.translatesAutoresizingMaskIntoConstraints = false
            signUpButton?.setTitle("sign up", for: .normal)
            // Initially hide sign up button
            signUpButton?.alpha = 0.0

            signInButton?.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
            signUpButton?.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)

            container.addSubview(signInButton!)
            container.addSubview(signUpButton!)
            
            signInButton?.anchorTo(container)
            signUpButton?.anchorTo(container)
            
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
    
    /**
     Handle UISegmentedControl value change events.
     
     When the UISegmentedControl index is 0, views associated with sign-up fade out and views associated with sign-in fade in.

     Conversely, when the UISegmentedControl index is 1, views associated with sign-in fade out and views associated with sign-out fade in.

     - Author:
     James Wu
     
     - parameters:
        - sender: The UISegmentedControl that sent the event
     
     - Version:
     0.1
     */
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            signUpTextFieldContainer?.fadeOut()
            signUpButton?.fadeOut()
            signInTextFieldContainer?.fadeIn()
            signInButton?.fadeIn()
            
        case 1:
            signInTextFieldContainer?.fadeOut()
            signInButton?.fadeOut()
            signUpTextFieldContainer?.fadeIn()
            signUpButton?.fadeIn()

        default:
            return
        }
    }
    
    /**
     Handle keyboard notifications.
    
     Moves the entire view up on UIResponder.keyboardWillShowNotification or UIResponder.keyboardWillChangeFrameNotification notifications so
     the keyboard will not obstruct any vital view.
     
     Moves the entire view back to its original position when the user decides to close the keyboard.
     
     - Author:
     James Wu
     
     - parameters:
        - notification: The notification signaling keyboard change.
     
     - Version:
     0.1

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
    
    /**
     Handle the sign-in button.
     
     Programmatically retrieves the input UIView subviews, validates the inputs, and then submits the values to Firebase for login authentication.
     
     - Author:
     James Wu
     
     - parameters:
        - sender: The sign-in button pressed.
     
     - Version:
     0.1
     
     */
    @objc func signInButtonPressed(_ sender: UIButton) {
        // Retrieve UI elements
        guard let signInStackView = signInTextFieldContainer?.viewWithTag(ViewTagsEnum.signInStackView.rawValue) as? UIStackView else { return }
        
        guard let emailTextField = signInStackView.viewWithTag(ViewTagsEnum.signInEmail.rawValue) as? UITextField else { return }
        guard let passwordTextField = signInStackView.viewWithTag(ViewTagsEnum.signInPassword.rawValue) as? UITextField else { return }
        
        // Check that fields are not empty
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
    
    /**
     Handle the sign-up button.
     
     Programmatically retrieves the input UIView subviews, validates the inputs, and then submits the values to Firebase for sign-up authentication.
     
     - Author:
     James Wu
     
     - parameters:
        - sender: The sign-up button pressed.
     
     - Version:
     0.1
     
     */
    @objc func signUpButtonPressed(_ sender: UIButton) {
        // Retrieve UI elements
        guard let signUpStackView = signUpTextFieldContainer?.viewWithTag(ViewTagsEnum.signUpStackView.rawValue) as? UIStackView else { return }
        
        guard let usernameTextField = signUpStackView.viewWithTag(ViewTagsEnum.signUpUsername.rawValue) as? UITextField else { return }
        guard let emailTextField = signUpStackView.viewWithTag(ViewTagsEnum.signUpEmail.rawValue) as? UITextField else { return }
        guard let passwordTextField = signUpStackView.viewWithTag(ViewTagsEnum.signUpPassword.rawValue) as? UITextField else { return }
        guard let confirmPasswordTextField = signUpStackView.viewWithTag(ViewTagsEnum.signUpConfirmPassword.rawValue) as? UITextField else { return }
        
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
     
     Moves the entire view up on UIResponder.keyboardWillShowNotification or UIResponder.keyboardWillChangeFrameNotification notifications so
     the keyboard will not obstruct any vital view.
     
     Moves the entire view back to its original position when the user decides to close the keyboard.

     - Author:
     James Wu
     
     - parameters:
        - message: The error message to present to the user.
     
     - Version:
     0.1

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

enum ViewTagsEnum: Int {
    case signInEmail = 0, signInPassword, signUpUsername, signUpEmail, signUpPassword, signUpConfirmPassword, signInStackView, signUpStackView
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

extension UIButton {
    func anchorTo(_ view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
    }
}
