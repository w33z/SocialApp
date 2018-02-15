//
//
//  HomeViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 06.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var users = [User]()
    var messages = [Message]()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Bg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5376499891, green: 0.9457976222, blue: 0.8239424825, alpha: 1)
        return view
    }()
    
    private let newMessageCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "0 New Messages"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = AVENIR_MEDIUM.withSize(22)
        return label
    }()
    
    private let dismissMessagesButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Dismiss"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(markAsReaded), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func markAsReaded(){

        UIView.animate(withDuration: 0.5, animations: {
            self.newMessageCollectionView.frame.origin.x = self.view.frame.width
        }) { (_) in
            UIView.animate(withDuration: 0.75, animations: {
                let height = self.messagesTableView.frame.origin.y - 160
//                print(self.allChatsLabel.frame.origin.y)
//                print(self.messagesTableView.frame.origin.y)
                self.allChatsLabel.frame.origin.y = 115
                self.messagesTableView.frame.origin.y = 160
                self.messagesTableView.frame.size.height += height
//                print(self.allChatsLabel.frame.origin.y)
//                print(self.messagesTableView.frame.origin.y)
            })
        }
    }
    
    private let newMessageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NewMessageCollectionViewCell.self, forCellWithReuseIdentifier: NEW_MESSEAGES_COLLECTIONVIEW)
        return collectionView
    }()
    
    private let allChatsLabel: UILabel = {
        let label = UILabel()
        label.font = AVENIR_MEDIUM.withSize(32)
        label.text = "All Chats"
        return label
    }()
    
    private let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
        tableView.register(AllChatsTableViewCell.self, forCellReuseIdentifier: ALL_CHAT_MESSAGES_CELL_TABLEVIEW)
        return tableView
    }()

    
    private let newMessageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "newMessage"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(newMessageButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newMessageCollectionView.delegate = self
        newMessageCollectionView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        setUpNavigationBar()
        setUpView()
        setUpConstrains()
        
        DataService.instance.fetchDBUsers { (users) in
            self.users = users
        }
        DataService.instance.fetchUserMessages { (messages) in
            self.messages = messages.reversed()
                        
            DispatchQueue.main.async {
                self.messagesTableView.reloadData()
            }
        }
    }

    fileprivate func setUpConstrains() {
        backgroundImage.addConstraints([
            equal(view, \.topAnchor),
            equal(view, \.bottomAnchor,constant: -140),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor)
            ])
        
        menuButton.addConstraints([
            equal(\.heightAnchor, to: 15),
            equal(\.widthAnchor, to: 15)
            ])
        
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        
        backgroundView.addConstraints([
            equal(view, \.topAnchor, constant: navigationBarHeight),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor),
            equal(\.heightAnchor, to: 125)
            ])
        
        newMessageCounterLabel.addConstraints([
            equal(backgroundView, \.topAnchor, \.topAnchor, constant: 35),
            equal(backgroundView, \.leadingAnchor, constant: 45),
            equal(\.widthAnchor, to: 200),
            ])
        
        dismissMessagesButton.addConstraints([
            equal(newMessageCounterLabel,\.centerYAnchor),
            equal(newMessageCounterLabel,\.topAnchor),
            equal(backgroundView,\.trailingAnchor, constant: -45),
            equal(\.heightAnchor, to: 25)
            ])
        
        newMessageCollectionView.addConstraints([
            equal(newMessageCounterLabel, \.topAnchor, \.bottomAnchor, constant: 15),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor),
            equal(\.heightAnchor, to: 200)
            ])
        
        allChatsLabel.addConstraints([
            equal(newMessageCollectionView, \.topAnchor, \.bottomAnchor, constant: -15),
            equal(view, \.leadingAnchor, constant: 45)
            ])
        
        messagesTableView.addConstraints([
            equal(allChatsLabel, \.topAnchor, \.bottomAnchor, constant: 5),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor),
            equal(view, \.bottomAnchor, constant: -70)
            ])
        
        newMessageButton.addConstraints([
            equal(view, \.bottomAnchor, \.bottomAnchor, constant: 10),
            equal(view, \.centerXAnchor),
            equal(\.heightAnchor, to: 80),
            equal(\.widthAnchor, to: 100)
            ])
    }
    
    fileprivate func setUpView() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpNavigationBar()
        
        view.addSubview(backgroundImage)
        view.addSubview(backgroundView)
        view.addSubview(newMessageCounterLabel)
        view.addSubview(dismissMessagesButton)
        view.addSubview(newMessageCollectionView)
        view.addSubview(allChatsLabel)
        view.addSubview(messagesTableView)
        view.addSubview(newMessageButton)
    }
    
    fileprivate func setUpNavigationBar() {
        navigationItem.title = "Home"
        let menuButtonNavigation = UIBarButtonItem(customView: menuButton)
        navigationItem.setLeftBarButton(menuButtonNavigation, animated: true)
    }
    
    @objc fileprivate func newMessageButtonAction(_ sender: UIButton) {
        let newMessageVC = ChooseUserTableViewController()
        newMessageVC.homeVC = self
        let navController = UINavigationController(rootViewController: newMessageVC)
        present(navController, animated: true, completion: nil)
    }
    
    func showTypingMessageVC(_ user: User){
        let chatVC = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.user = user
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NEW_MESSEAGES_COLLECTIONVIEW, for: indexPath) as! NewMessageCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 80, height: collectionView.frame.height - 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(40)
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ALL_CHAT_MESSAGES_CELL_TABLEVIEW, for: indexPath) as! AllChatsTableViewCell
        
        let message = messages[indexPath.row]
        cell.configureCell(message)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        guard let chatPartnerID = message.getChatPartnerID() else { return }
        
        DataService.instance.getUser(toID: chatPartnerID) { (user) in
            self.showTypingMessageVC(user)
        }
    }
    
}
