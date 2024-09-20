//
//  AllMessageTableViewCell.swift
//  AwesomeChat
//
//  Created by Linh Vu on 13/9/24.
//

import UIKit

class AllMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var nameMessage: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var timeMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(conversation: Conversation) {
        lastMessage.text = conversation.lastMessage
        timeMessage.text = formatDate(date: conversation.timestamp)
        nameMessage.text = conversation.participantUsername
    }
    
    private func formatDate(date: Date, dateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
        
    }
}
