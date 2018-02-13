//
//  ChatViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 12.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class ChatViewController: UICollectionViewController {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.username
        }
    }
    
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
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func addViews(){
        navigationController?.navigationBar.topItem?.title = ""
        collectionView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
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
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
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
