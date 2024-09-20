//
//  AddMessageTableViewCell.swift
//  AwesomeChat
//
//  Created by Linh Vu on 17/9/24.
//

import UIKit

class AddMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.layer.borderWidth = 3
        avatarImage.layer.borderColor = UIColor(named: "blueColor")?.cgColor
    }
    
    func bindingData(userFriend: UserFriend) {
        if let url = URL(string: userFriend.imageProfile) {
            avatarImage.loadImage(url: url)
        }
        
        nameLabel.text = userFriend.username
    }
    
}
