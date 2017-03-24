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
    fileprivate var messages: [Message] = []
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var user:User!
    var channel:Channel!
    var lastMessage: String?
    let imagePicker = ChatImagePickeViewController()
    
 // MARK: DataSource & Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId =  user.identifier
        self.senderDisplayName =  user.name
        imagePicker.delegate = self
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        configureObserver()
        super.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!,
                                 heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
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
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        
        return bubbleImageFactory!.incomingMessagesBubbleImage	(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        addMessage(withId: self.senderId,
                   name: self.senderDisplayName,
                   text: text)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    // TODO - Configure imagepicker in this func
    override func didPressAccessoryButton(_ sender: UIButton!) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    private func addMessage(withId id: String, name: String, text: String) {
        let message = Message(userId: id, userName: name, message:text)
        
        ChatFacade.createMessage(channelId: channel.id!, message: message)
    }
    
    fileprivate func addMessageWithPhoto(withId id: String, userName: String, media: UIImage) {
        MediaFacade.saveMediaWithProgress(id: id, userName: userName, media: media, presentIn: self){ message in
            self.lastMessage = ChatFacade.createMediaMessage(channelId: self.channel.id!, message: message)
            self.messages.append(message)
            self.finishSendingMessage()
        }
    }
    
    func configureObserver() {
        ChatFacade.observeMessages(byListingLast: 25, channelId: channel.id!) { [weak self] message in
            
            guard message.id != self?.lastMessage else { return }
            
            guard message.isMediaMessage()  else {
                self?.messages.append(message)
                JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
                self?.finishReceivingMessage()
                return
            }
            
            self?.configureMediaImage(message)
        }
    }
    
    func configureMediaImage(_ message: Message) {
        let mediaItem: JSQPhotoMediaItemCustom?
        
        if message.userId == self.senderId {
            mediaItem = JSQPhotoMediaItemCustom(withURL: message.mediaUrl!, isOperator: true)
        } else {
            mediaItem = JSQPhotoMediaItemCustom(withURL: message.mediaUrl!, isOperator: false)
        }
        
        message.mediaItem = mediaItem
        self.messages.append(message)
        JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
        self.finishReceivingMessage()
    }
    
    deinit {
        ChatFacade.removeAllObservers()
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        addMessageWithPhoto(withId: user.identifier!, userName: user.name!, media: chosenImage)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}



