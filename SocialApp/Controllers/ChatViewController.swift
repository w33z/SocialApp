//
//  ChatViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 12.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.username
        }
    }
    
    var messages = [Message]()
    
    private let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Bg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.bindToKeyboard()
        
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1)
        view.layer.addSublayer(border)
        
        return view
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.bindToKeyboard()
        return button
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Type a message..."
        textView.font = AVENIR_MEDIUM
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 8, bottom: 0, right: 8)
        textView.textColor = UIColor.lightGray
        textView.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.layer.borderColor = #colorLiteral(red: 0.7670402351, green: 0.7670402351, blue: 0.7670402351, alpha: 1)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.bindToKeyboard()
        return textView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "sendButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.bindToKeyboard()
        button.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setUpConstraints()
        
        self.collectionView!.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: CHAT_COLLECTIONVIEW_CELL)
        
        if let userID = user?.userID {
            DataService.instance.fetchMessages(userID) { (messages) in
                self.messages = messages
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func addViews(){
        navigationController?.navigationBar.topItem?.title = ""
        collectionView?.backgroundView = bgImage
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        view.addSubview(backView)
        view.addSubview(addButton)
        view.addSubview(messageTextView)
        view.addSubview(sendButton)
    }
    
    fileprivate func setUpConstraints(){
        
        backView.addConstraints([
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor),
            equal(view, \.bottomAnchor),
            equal(\.heightAnchor, to: 50)
            ])
        
        addButton.addConstraints([
            equal(backView,\.leadingAnchor,constant: 15),
            equal(backView,\.centerYAnchor),
            equal(\.heightAnchor, to: 20),
            equal(\.widthAnchor, to: 20)
            ])
        
        sendButton.addConstraints([
            equal(messageTextView, \.centerYAnchor),
            equal(backView, \.trailingAnchor,constant: -10),
            equal(\.heightAnchor, to: 80),
            equal(\.widthAnchor, to: 95)
            ])
        
        messageTextView.addConstraints([
            equal(addButton,\.leftAnchor, \.rightAnchor, constant: 15),
            equal(backView,\.centerYAnchor),
            equal(sendButton, \.rightAnchor,\.leftAnchor, constant: -5),
            equal(\.heightAnchor, to: 40),
            ])
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CHAT_COLLECTIONVIEW_CELL, for: indexPath) as! ChatCollectionViewCell
        
        let message = messages[indexPath.item]
        if let userProfileImageURL = user?.profileImageURL {
            cell.messageBGWidthAnchor?.constant = estimateFrameForTest(text: message.text!).width + 64
            cell.configureCell(message, userProfileImageURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].text {
            height = estimateFrameForTest(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    fileprivate func estimateFrameForTest(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: AVENIR_MEDIUM], context: nil)
    }
    
    @objc fileprivate func sendMessage(_ sender: UIButton) {
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let messageData: [String : Any] = ["text": messageTextView.text, "fromID": Auth.auth().currentUser?.uid as Any, "toID": user?.userID as Any, "timestamp": timestamp]
        
        DataService.instance.sendMessege(withGroupKey: nil, messageData: messageData as Dictionary<String, AnyObject>) { (complete) in
            if complete {
                print("message sent")
            } else {
                let alert = UIAlertController(title: "Error", message: "The message can't be sent right now. Please try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            }
        }
        
        messageTextView.text = nil
        messageTextView.endEditing(true)
    }

}

extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.black
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type a message..."
            textView.textColor = UIColor.lightGray
        }
    }
}
