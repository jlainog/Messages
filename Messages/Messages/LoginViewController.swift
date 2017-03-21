//
//  LoginViewController.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/8/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UITabBarDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
//Manage the keyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    @IBAction func userLogIn(_ sender: AnyObject) {
        let userFacade = UserFacade()
        
        if (self.userNameTextField.text?.isEmpty)! {
            self.userNameTextField.shake()
            return
        }
        
        userFacade.anonymousLogIn(userName: userNameTextField.text!) { (user, error) in
            guard let loggedUser = user else {
                let alert = UIAlertController(title: "Try Again", message: nil, preferredStyle: .alert)
               
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabViewController") as! UITabBarController
            
            SessionCache.sharedInstance.user = loggedUser
            UserListFacade.createUser(user: loggedUser)
            //newViewController.user = loggedUser
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        
    }
}
