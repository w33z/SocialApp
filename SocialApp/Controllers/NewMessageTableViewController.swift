//
//  NewMessageTableViewController.swift
//  SocialApp
//
//  Created by Bartosz Pawełczyk on 12.02.2018.
//  Copyright © 2018 Bartosz Pawełczyk. All rights reserved.
//

import UIKit

class NewMessageTableViewController: UITableViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        tableView.tableFooterView = UIView()
        
        DataService.instance.fetchDBUsers { (users) in
            self.users = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: TABLEVIEW_USER_CELL)
        
    }
    
    @objc fileprivate func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setUpNavigationBar() {
        self.navigationItem.title = "Choose user"
        let dismissButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissView))
        dismissButton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor : UIColor.white
            ], for: .normal)
        self.navigationItem.rightBarButtonItem = dismissButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_USER_CELL, for: indexPath) as! UserTableViewCell
        
        let user = users[indexPath.row]
        cell.configureCell(user)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    var homeVC: HomeViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.homeVC?.showTypingMessageVC(user)
        }
    }

}
