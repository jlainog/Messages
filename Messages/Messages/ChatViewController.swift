//
//  ChatViewController.swift
//  Messages
//
//  Created by Stephany Lara Jimenez on 3/8/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController {
    
 // MARK: Variable Definitions
    private var messages: [Message] = []
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var user: User!
    var channel: Channel! {
        didSet {
            title = channel.name
        }
    }
    
 // MARK: DataSource & Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId =  user.identifier
        self.senderDisplayName =  user.name
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        configureObserver()
    }
    
    //TODO - Handle nils
    func configureObserver() {
        ChatFacade.observeMessages(byListingLast: 25, channelId: (channel.id!)) { message in
            guard message.isMediaMessage() else {
                self.receiveMessage(message: message)
                  return
            }
            message.locationMediaItem?.setLocation(CLLocation(latitude: message.latitude, longitude: message.longitude), withCompletionHandler: {
                self.receiveMessage(message: message)
            })
        }
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        addMessage(withId: self.senderId,
                   name: self.senderDisplayName,
                   text: text)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }

    override func didPressAccessoryButton(_ sender: UIButton!) {
        let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (alert : UIAlertAction) in }
        
        let sendLocation = UIAlertAction(title: "Send Location", style: UIAlertActionStyle.default) { (alert : UIAlertAction) in
            

            let currentLocation = LocationMonitorSingleton().currentPosition
            let message = Message(userId: self.senderId,
                                  userName: self.senderDisplayName,
                                  location: currentLocation)
            
            ChatFacade.createMessage(channelId: (self.channel.id!), message: message)
            self.finishSendingMessage(animated: true)
        }
        
        sheet.addAction(cancel)
        sheet.addAction(sendLocation)
        self.present(sheet, animated: true, completion: nil)
    }
    
    deinit {
        ChatFacade.removeAllObservers()
    }

 // MARK: Private Function
    private func addMessage(withId id: String, name: String, text: String) {
        let message = Message(userId: id, userName: name, message: text)
        
        ChatFacade.createMessage(channelId: (channel.id!), message: message)
    }
    
    private func receiveMessage(message : Message) {
        self.messages.append(message)
        JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
        self.finishReceivingMessage()
        super.collectionView.reloadData()
    }

// MARK: CollectionView Functions
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        
        if message.userId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.userId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.blue
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        guard let senderDisplayName = message.senderDisplayName() else {
            return nil
        }
        return NSAttributedString(string: senderDisplayName)
    }
    
}



