//
//
//  HomeViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 06.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    var users = [User]()
    var messages = [Message]()
    
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
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        setUpNavigationBar()
        setUpView()
        setUpConstrains()
        
        DataService.instance.fetchDBUsers { (users) in
            self.users = users
        }
        DataService.instance.fetchUserMessages { (messages,newMessagesCounter) in
            self.messages = messages.reversed()
            self.newMessageCounterLabel.text = "\(newMessagesCounter) New Messages"

            //To reduce profile image bugs
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Messages"
    }

    fileprivate func setUpConstrains() {
        
        menuButton.addConstraints([
            equal(\.heightAnchor, to: 15),
            equal(\.widthAnchor, to: 15)
            ])
                
        backgroundView.addConstraints([
            equal(view, \.safeAreaLayoutGuide.topAnchor),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor),
            equal(\.heightAnchor, to: 125)
            ])
        
        newMessageCounterLabel.addConstraints([
            equal(backgroundView, \.topAnchor, \.topAnchor, constant: 35),
            equal(backgroundView, \.leadingAnchor, constant: 45),
            equal(\.widthAnchor, to: 200),
            ])
        
        allChatsLabel.addConstraints([
            equal(newMessageCounterLabel, \.topAnchor, \.bottomAnchor, constant: 15),
            equal(view, \.leadingAnchor, constant: 45)
            ])
        
        messagesTableView.addConstraints([
            equal(allChatsLabel, \.topAnchor, \.bottomAnchor, constant: 0),
            equal(view, \.leadingAnchor),
            equal(view, \.trailingAnchor),
            equal(view, \.bottomAnchor, constant: -70)
            ])
        
        newMessageButton.addConstraints([
            equal(view, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            equal(view, \.centerXAnchor),
            equal(\.heightAnchor, to: 80),
            equal(\.widthAnchor, to: 100)
            ])
    }
    
    fileprivate func setUpView() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpNavigationBar()
        
        view.addSubview(backgroundView)
        view.addSubview(newMessageCounterLabel)
        view.addSubview(allChatsLabel)
        view.addSubview(messagesTableView)
        view.addSubview(newMessageButton)
    }
 
    fileprivate func setUpNavigationBar() {
        let menuButtonNavigation = UIBarButtonItem(customView: menuButton)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(menuButtonAction))
//        menuButtonNavigation.customView?.addGestureRecognizer(tap)
        navigationItem.setLeftBarButton(menuButtonNavigation, animated: true)
    }
    
    func showTypingMessageVC(_ user: User){
        let chatVC = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.user = user     
        navigationController?.pushViewController(chatVC, animated: true)
        newMessageCounterLabel.text = "0 New Messages"
    }
    
    @objc fileprivate func newMessageButtonAction(_ sender: UIButton) {
        let newMessageVC = ChooseUserTableViewController()
        newMessageVC.homeVC = self
        let navController = UINavigationController(rootViewController: newMessageVC)
        present(navController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleTimer(){
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
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
