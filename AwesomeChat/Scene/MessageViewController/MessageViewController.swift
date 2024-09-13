//
//  MessageViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 19/8/24.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var searchMessage: UITextField!
    @IBOutlet weak var allMessage: UITableView!
    
    let cell = AllMessageTableViewCell.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        searchMessage.setupLeftSideImage(imageName: "seach-icon")
        searchMessage.clipsToBounds = true
        searchMessage.layer.cornerRadius = 15
        searchMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        allMessage.clipsToBounds = true
        allMessage.layer.cornerRadius = 30
        allMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        allMessage.delegate = self
        allMessage.dataSource = self
        allMessage.regsiterCell(ofType: cell)
    }
    
    @IBAction func addMessage(_ sender: Any) {
        print("Search Message")
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allMessage.dequeueReusableCell(withIdentifier: String.convertToString(cell), for: indexPath) as! AllMessageTableViewCell
        return cell
    }
}
