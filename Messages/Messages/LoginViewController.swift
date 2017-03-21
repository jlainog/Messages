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
    
    @IBOutlet weak var singInSelector: UISegmentedControl!
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
    
    @IBAction func signInSelectorChanged(_ sender: AnyObject) {
        if (singInSelector.selectedSegmentIndex == 0) {
            
            logInButton.setTitle("Go anonymously", for: .normal)
            userNameTextField.placeholder = "Enter your Nickname"
            passwordTextField.isHidden = true
           
        } else {
            if (singInSelector.selectedSegmentIndex == 1) {
                
                userNameTextField.placeholder = "Email"
                passwordTextField.isHidden = false
                passwordTextField.isSecureTextEntry = true
                passwordTextField.placeholder = "Password"
                logInButton.setTitle("Log in", for: .normal)
                
            }
        }
    }
    
    @IBAction func userLogIn(_ sender: AnyObject) {
        let userFacade = UserFacade()
        
        if (self.userNameTextField.text?.isEmpty)! {
            self.userNameTextField.shake()
            return
        }
        
        if(singInSelector.selectedSegmentIndex == 0) {
            
            userFacade.anonymousLogIn(userName: userNameTextField.text!) { (user, error) in
            guard let loggedUser = user else {
                self.alertAcctionManager()
                
                return
            }
                
            self.changeViewController(user: loggedUser)
           
            }
            
        } else {
            
            if (singInSelector.selectedSegmentIndex == 1) {
                userFacade.emailPasswordLogIn(email: userNameTextField.text!, userName: userNameTextField.text!, password: passwordTextField.text!) {(user, error) in
                    guard let loggedUser = user else {
                        self.alertAcctionManager()
                        
                        return
                    }
                    self.changeViewController(user: loggedUser)
                }
            }
        }

    }
    
    func changeViewController(user: User){
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChannelStoryboard", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        
        newViewController.user = user
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func alertAcctionManager(){
        let alert = UIAlertController(title: "Try Again", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title:  "OK", style: UIAlertActionStyle.default)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }

}
