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
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    @IBAction func updateLoginSegmentedControl(_ sender: UISegmentedControl) {
        updateUI()
    }
    
    func updateUI() {
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
    
    @IBAction func signUp() {
        guard let username = usernameTextField.text,
        let email = emailTextField.text,
        let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {
                // TODO: Display message to user
                print("Did not save user!")
                return
        }
        
        // TODO: Validate password here...

        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            guard let user = authResult?.user else { return }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
