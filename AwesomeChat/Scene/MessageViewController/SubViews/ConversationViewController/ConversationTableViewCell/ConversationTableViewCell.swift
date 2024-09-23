//
//  ConversationTableViewCell.swift
//  AwesomeChat
//
//  Created by Linh Vu on 23/9/24.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    @IBOutlet weak var participantProfileImage: UIImageView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentVIew: UIView!
    
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
        participantProfileImage.layer.cornerRadius = participantProfileImage.frame.size.width / 2
        participantProfileImage.layer.borderWidth = 3
        participantProfileImage.layer.borderColor = UIColor(named: "blueColor")?.cgColor
        
        contentVIew.clipsToBounds = true
        contentVIew.layer.cornerRadius = 15
    }
    
    func loadImage(url: String) {
        if let url = URL(string: url) {
            participantProfileImage.loadImage(url: url)
        }
    }
    
    func configure(message: Message, isCurrentUser: Bool) {
        messageText.text = message.content
        timeLabel.text = formatDate(date: message.timestamp)
        
        if isCurrentUser {
            participantProfileImage.isHidden = true
            contentVIew.backgroundColor = UIColor(named: "blueColor")
            messageText.textColor = .white
        } else {
            participantProfileImage.isHidden = false
            contentVIew.backgroundColor = UIColor(named: "lightGray")
            messageText.textColor = .black
        }
    }
    
    private func formatDate(date: Date, dateFormat: String = "HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
        
    }
}
