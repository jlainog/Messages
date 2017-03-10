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
        guard newItemTxtField.text != "" else {return newItemTxtField.shake() }
        service?.create(channel: PublicChannel(content: newItemTxtField.text!))
        if textFieldShouldClear(newItemTxtField){
            newItemTxtField.text = ""
        }
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
    
}

extension ChannelViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.newItemTxtField {
            textField.resignFirstResponder()
        }
        return true
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

extension UITextField {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

