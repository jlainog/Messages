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

 class ChatViewController: JSQMessagesViewController {
    
 // MARK: Variable Definitions
    fileprivate var messages: [Message] = []
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var lastMessage: String?
    let imagePicker = ChatImagePickeViewController()
    let photoPicker = ChatPhotoPickeViewController()
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
        imagePicker.delegate = self
        photoPicker.delegate = self
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        configureObserver()
        super.collectionView.reloadData()
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
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (alert : UIAlertAction) in }
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default) { alert in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.present(self.photoPicker, animated: true, completion: nil)
            } else {
                self.detectCameraInDevice()
            }
        }
        
        let selectImageAction = UIAlertAction(title: "Select Image", style: UIAlertActionStyle.default) { alert in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        sheet.addAction(takePhotoAction)
        sheet.addAction(selectImageAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true){
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
        }
    }
   
 // MARK: Private Function
    private func addMessage(withId id: String, name: String, text: String) {
        let message = Message(userId: id, userName: name, message: text)
        
        ChatFacade.createMessage(channelId: (channel.id!), message: message)
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
            
            switch (message.messageType) {
            case .text:
                self?.messages.append(message)
                JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
                self?.finishReceivingMessage()
            case .media:
                self?.configureMediaImage(message)
            }
        }
    }
    
    deinit {
        ChatFacade.removeAllObservers()
    }
    
    func configureMediaImage(_ message: Message) {
        message.mediaItem = JSQPhotoMediaItemCustom(withURL: message.mediaUrl!, isIncomingBubble: message.userId == self.senderId)
        self.messages.append(message)
        JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
        self.finishReceivingMessage()
    }

// MARK: CollectionView Functions
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let detailImageController = ChatDetailViewController(nibName: "ChatdetailView", bundle: nil)
        let message = messages[indexPath.item]
        
        if let imageView = message.mediaItem?.mediaView() as? UIImageView {
            detailImageController.image = imageView.image
        }
        
        detailImageController.messageType = message.messageType
        detailImageController.URLImage = URL(string: message.mediaUrl!)
        self.navigationController?.pushViewController(detailImageController, animated: true)
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        addMessageWithPhoto(withId: user.identifier, userName: user.name, media: chosenImage.fixedOrientation())
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        
        guard let senderDisplayName = message.senderDisplayName() else {
            return nil
        }
        return NSAttributedString(string: senderDisplayName)
    }
    
}
