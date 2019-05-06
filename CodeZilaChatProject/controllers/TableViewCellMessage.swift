//
//  TableViewCellMessage.swift
//  CodeZilaChatProject
//
//  Created by AhmedSaeed on 4/16/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

class TableViewCellMessage: UITableViewCell {

    enum whoSend {
        case income
        case outcome
    }
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var messageText: UITextView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var showRealMessage: UITextView!
    
    
    
    func setMessage(message: ChatCell)
    {
        messageText.text = message.text
        senderLabel.text = message.userName
    }
    
    func describeBubble (type : whoSend)
    {
        if type == .income
        {
            stackView.alignment = .leading
            container.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
        else if type == .outcome
        {
            stackView.alignment = .trailing
            container.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
        
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        container.layer.cornerRadius = 6
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
