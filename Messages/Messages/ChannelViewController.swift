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
    
    fileprivate var channels: [Channel]?
    var user: User! = SessionCache.sharedInstance.user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelsTable.delegate = self
        newItemTxtField.delegate = self
        channelsTable.dataSource = self
        channelsTable.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: "cell")
        channels = [Channel]()
        
        //TODO - Handle nils
        ChannelFacade.listAndObserveChannels() {
            [weak self] channel in
            self?.channels!.append(channel)
            self?.channelsTable.reloadData()
        }
        
        //TODO - Handle nils
        ChannelFacade.didRemoveChannel() {
            [weak self] channel in
            if let channels = self?.channels {
                self?.channels = channels.filter() { $0.id != channel.id }
                self?.channelsTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newItemTxtField.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
    }
    
    deinit {
        ChannelFacade.dismmissChannelObservers()
    }
    
    @IBAction func createChannel(_ sender: UIButton) {
        guard newItemTxtField.text != "" else { return newItemTxtField.shake() }
        
        ChannelFacade.create(channel: Channel(name: newItemTxtField.text!))
        textFieldClear(newItemTxtField)
        channelsTable.reloadData()
    }
}

extension ChannelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Public Channels"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels?.count ?? 0
    }
    
    private func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = channels?[indexPath.row]
        let cell = channelsTable.dequeueReusableCell(withIdentifier:"cell",for: indexPath) as! ChannelCell
        
        cell.titleLbl.text = channel?.name as String?
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = channels?[indexPath.row]
            
            ChannelFacade.delete(channel: channel!)
            ChatFacade.removeMessages(channelId: channel!.id!)
        }
    }
    
}

extension ChannelViewController:  UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        chatViewController.user = self.user
        chatViewController.channel = channels?[indexPath.row]
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
