//
//  LoginViewController.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/8/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextField.delegate = self
        logInButton.layer.cornerRadius = 5
        passwordTextField.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    //SignIn Selector State

    enum SignInSelectorState: Int {
        case anonymousLogIng = 0, emailLogIn = 1, register = 2
        
    }

    @IBAction func signInSelectorChanged(_ sender: AnyObject) {
        
        let signInSelector: SignInSelectorState = SignInSelectorState(rawValue: self.signInSelector.selectedSegmentIndex)!
        
        switch signInSelector {
        case .anonymousLogIng:
            logInButton.setTitle("Go anonymously", for: .normal)
            userNameTextField.placeholder = "Enter your Nickname"
            passwordTextField.isHidden = true
            break
            
        case .emailLogIn:
            userNameTextField.placeholder = "Email"
            passwordTextField.isHidden = false
            passwordTextField.isSecureTextEntry = true
            passwordTextField.placeholder = "Password"
            logInButton.setTitle("Log in", for: .normal)
            break
            
        case .register:
            userNameTextField.placeholder = "Email"
            passwordTextField.isHidden = false
            passwordTextField.isSecureTextEntry = true
            passwordTextField.placeholder = "Password"
            logInButton.setTitle("Register", for: .normal)
            break
        }
    }
    
    //Log In button management
    
    @IBAction func userLogIn(_ sender: AnyObject) {
        let userFacade = UserFacade()
        
        let signInSelector: SignInSelectorState = SignInSelectorState(rawValue: self.signInSelector.selectedSegmentIndex)!
        
        if (self.userNameTextField.text?.isEmpty)! {
            self.userNameTextField.shake()
    
            return
        }
        
        switch signInSelector {
        case .anonymousLogIng:
            userFacade.anonymousLogIn(userName: userNameTextField.text!) { (user, error) in
                guard let loggedUser = user else {
                    self.alertActionManager()
                    
                    return
                }
                self.presentNextViewController(user: loggedUser)
            }
            break
            
        case .emailLogIn:
            userFacade.emailPasswordLogIn(email: userNameTextField.text!, userName: userNameTextField.text!, password: passwordTextField.text!) {(user, error) in
                guard let loggedUser = user else {
                    self.alertActionManager()
                    
                    return
                }
                self.presentNextViewController(user: loggedUser)
            }
            break
        case .register:
            userFacade.userSignIn(email: userNameTextField.text!, password: passwordTextField.text!, userName: userNameTextField.text!) {(user, error) in
                guard let loggedUser = user else {
                    self.alertActionManager()
                    
                    return
                }
                self.presentNextViewController(user: loggedUser)
            }
            break
        }
        
    }
    
    
    func presentNextViewController(user: User){
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChannelStoryboard", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        
        newViewController.user = user
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func alertActionManager(){
        let alert = UIAlertController(title: "Try Again", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.default)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}
