//
//  RealChatVC.swift
//  CodeZilaChatProject
//
//  Created by AhmedSaeed on 4/15/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import Firebase

class RealChatVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {
  
    

    @IBOutlet weak var messageTextFeild: UITextField!

    var room:Rooms?
    var chatCell:[ChatCell] = []
    @IBOutlet weak var tableViewChat: UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableViewChat.delegate = self
        tableViewChat.dataSource = self
        tableViewChat.separatorStyle = .none
        tableViewChat.allowsSelection = false
    
        observedForMessage()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return chatCell.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let message = chatCell[indexPath.row]
        let cell = tableViewChat.dequeueReusableCell(withIdentifier: "goodcell") as! TableViewCellMessage
        cell.setMessage(message: message)
        if Auth.auth().currentUser?.uid == chatCell[indexPath.row].senderID
        {
            cell.describeBubble(type: .outcome)
        }
        else{
            cell.describeBubble(type: .income)
        }
        
    
        return cell
    }
    
    
    
    func observedForMessage()
    {
        if let userid = room?.roomIDInClass
        {
            let DBREF = Database.database().reference()
            DBREF.child("rooms").child(userid).child("message").observe(.childAdded) { (DataSnapshot) in
                let idForMessage = DataSnapshot.key
                
                if let dataComeBack = DataSnapshot.value as? [String : Any]
                {
                    guard let username = dataComeBack["username"] as? String ,let messagetext = dataComeBack["text"] as? String  , let senderId = dataComeBack["userid"] as? String else {return}
                    
                    let chatcell = ChatCell()
                    chatcell.text = messagetext
                    chatcell.userid = idForMessage
                    chatcell.userName = username
                    chatcell.senderID = senderId
                    self.chatCell.append(chatcell)
                    
                    
                    self.tableViewChat.reloadData()
                    
                }
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func sendButtonClicked(_ sender: Any)
    {
        guard let message = messageTextFeild.text , message.isEmpty == false , let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let DBREF = Database.database().reference()
        DBREF.child("users").child(userID).child("userName").observe(DataEventType.value)
        { (DataSnapshot) in
            if let userName = DataSnapshot.value as? String
            {
                if let userid = self.room?.roomIDInClass
                {
                    let message = DBREF.child("rooms").child(userid).child("message").childByAutoId()
                    let textMessage :[String:Any] = ["username" : userName , "text":self.messageTextFeild.text! ,"userid" : userID]
                    
                    message.setValue(textMessage, withCompletionBlock: { (error, ref) in
                        if error == nil
                        {
                            self.messageTextFeild.text = ""
                        }else{
                            print("badSave")
                        }
                    })
                }
                
            }
        }
    
        
    }
    
    
}
