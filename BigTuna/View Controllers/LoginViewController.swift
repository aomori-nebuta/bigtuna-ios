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
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!

    @IBOutlet weak var errorMessageView: UIView!

    // Sign-in UI Objects
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var signInEmailTextField: UITextField!
    @IBOutlet weak var signInPasswordTextField: UITextField!

    // Sign-up UI Objects
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var signUpUsernameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpConfirmPasswordTextField: UITextField!

    @IBOutlet weak var errorMessage: UILabel!
    
    struct Errors {
        static let missingFields: String = "Please enter all fields."
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebubbles")!)
        
        updateUI()

        // Observers that listen for keyboard change events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        // Remove the keyboard observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func updateLoginSegmentedControl(_ sender: UISegmentedControl) {
        updateUI()
    }
    
    func updateUI() {
//        errorMessageView.isHidden = true

        switch(loginSegmentedControl.selectedSegmentIndex) {
        case 0:
            signInView.isHidden = false
            signUpView.isHidden = true
        case 1:
            signUpView.isHidden = false
            signInView.isHidden = true
        default:
            break;
        }
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let email = signInEmailTextField.text,
            let password = signInPasswordTextField.text else {
                self.displayErrorWithMessage(error: Errors.missingFields)
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if let error = error {
                self.displayErrorWithMessage(error: error.localizedDescription)
                return
            } else {
                guard let user = user else { return }
                self.performSegue(withIdentifier: "SignInSegue", sender: sender)
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let _ = signUpUsernameTextField.text,
            let email = signUpEmailTextField.text,
            let password = signUpPasswordTextField.text,
            let _ = signUpConfirmPasswordTextField.text else {
                self.displayErrorWithMessage(error: Errors.missingFields)
                return
        }
        
        // TODO: Validate password here...

        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            if let error = error {
                self.displayErrorWithMessage(error: error.localizedDescription)
                return
            } else {
                guard let user = authResult?.user else { return }
                self.performSegue(withIdentifier: "SignUpSegue", sender: sender)
            }
            
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Key board will show: \(notification.name.rawValue)")
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else {
                return
        }
        
        // Moves keyboard up
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            // Moves keyboard back to origin
            view.frame.origin.y = 0;
        }
    }
    
    func displayErrorWithMessage(error: String) {
        self.errorMessageView.isHidden = false
        self.errorMessage.text = error
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let _ = segue.destination as? UITabBarController else { return }
        
    }


}
