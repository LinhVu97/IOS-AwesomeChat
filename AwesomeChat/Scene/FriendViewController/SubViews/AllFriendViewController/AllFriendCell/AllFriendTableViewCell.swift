//
//  AllFriendTableViewCell.swift
//  AwesomeChat
//
//  Created by Linh Vu on 27/8/24.
//

import UIKit

class AllFriendTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        addFriendButton.clipsToBounds = true
        addFriendButton.layer.cornerRadius = 20
        addFriendButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor(named: "blueColor")?.cgColor
    }
    
    func bindingData(userFriend: UserFriend) {
        nameLabel.text = userFriend.username
        
        if let url = URL(string: userFriend.imageProfile) {
            profileImage.loadImage(url: url)
        }
    }
    
    @IBAction func addFriend(_ sender: Any) {
        print("add friend")
    }
}
