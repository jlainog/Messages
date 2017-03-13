//
//  ChannelViewController.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/9/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
  
    @IBOutlet weak var channelsTable: UITableView!
    @IBOutlet weak var newItemTxtField: UITextField!
    
    internal var channels: [Identificable]?
    internal var service: ChannelFacade?
    internal var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelsTable.delegate = self
        newItemTxtField.delegate = self
        channelsTable.dataSource = self
        service = ChannelFacade(key: "channels")
        channelsTable.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        service?.listChannels(completionHandler: { (channelsArray) in
            self.channels = channelsArray
            self.channelsTable.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        newItemTxtField.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func createChannel(_ sender: UIButton) {
        service?.create(channel: PublicChannel(content: newItemTxtField.text!))
        guard newItemTxtField.text != "" else { return newItemTxtField.shake() }
        textFieldClear(newItemTxtField)
        channelsTable.reloadData()
    }
}

extension ChannelViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Public Channels"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = channels?[indexPath.row]
        let cell = channelsTable.dequeueReusableCell(withIdentifier:"cell",for: indexPath) as! ChannelCell
        
        cell.titleLbl.text = channel?.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = channels![indexPath.row]
            service?.delete(channel: channel)
            channelsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        chatViewController.user = self.user
        chatViewController.channel = channels?[indexPath.row] as? PublicChannel
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}

extension ChannelViewController: UITextFieldDelegate {
    
    func textFieldClear(_ textField: UITextField) {
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChannelViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
