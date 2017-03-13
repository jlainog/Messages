//
//  ViewController.swift
//  Messages
//
//  Created by Jaime Laino on 3/6/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var tableViewMessages: UITableView!
    
    var userId : String = "123"
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        loadDataToTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func loadDataToTable() {
        ChatFacade.retrieveChat(channelId: "12334") { response in
            self.messages = response
            self.tableViewMessages.reloadData()
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        let date = Date().timeIntervalSince1970
        
        let messageDictionary = ["userId": userId, "userName": "Lucho", "message" : messageTextField.text!, "messageType" : MessageType.text, "timestamp" : date] as NSDictionary
        let message = Message(json: messageDictionary)
        
        ChatFacade.createMessage(channelId: "12334", message: message)
        loadDataToTable()
        
        messageTextField.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cellIdentifier = "messageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) 
        
        cell.textLabel?.text = message.message
        
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
}

extension ViewController {
    func keyboardWillShow(notification: NSNotification) {        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
