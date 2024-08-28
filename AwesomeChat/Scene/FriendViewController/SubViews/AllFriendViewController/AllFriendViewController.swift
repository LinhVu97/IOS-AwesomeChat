//
//  AllFriendViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 22/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AllFriendViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var usersFriend: [UserFriend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.regsiterCell(ofType: AllFriendTableViewCell.self)
    }
}

extension AllFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.convertToString(AllFriendTableViewCell.self),
                                                 for: indexPath) as! AllFriendTableViewCell

        let user = usersFriend[indexPath.row]
        cell.bindingData(userFriend: user)
        return cell
    }
}
