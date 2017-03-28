//
//  UserListViewController.swift
//  Messages
//
//  Created by Luis Ramirez on 3/21/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    var users : [User]? = []
    @IBOutlet var tableViewUsers: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
    }

    func loadUsers() {
        UserListFacade.observeUsers() {
            users in
            self.users?.append(users)
            self.tableViewUsers.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        UserListFacade.removeObservers()
    }
    
    deinit {
        UserListFacade.removeObservers()
    }
}

extension UserListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users?[indexPath.row]
        let cell = tableViewUsers.dequeueReusableCell(withIdentifier:"userCell",for: indexPath) 
        
        cell.textLabel?.text = user?.name
        return cell
    }
}
