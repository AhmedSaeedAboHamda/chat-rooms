//
//  ChatRoomViewController.swift
//  CodeZilaChatProject
//
//  Created by AhmedSaeed on 4/14/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate {

    @IBOutlet weak var tableViewChatRoom: UITableView!
    @IBOutlet weak var roomNameTextFeild: UITextField!
    
    var roomArray:[Rooms] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableViewChatRoom.delegate = self
        tableViewChatRoom.dataSource = self
        saveRoomNameInChatRoom()
 
    }
    
    
    
    
    // function used to logout from roomchat
    
    @IBAction func logoutButtonClick(_ sender:UIBarButtonItem)
    {
        try! Auth.auth().signOut()
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginForm") as! ViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if Auth.auth().currentUser == nil
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginForm") as! ViewController
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    
    
    // tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return roomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForTableView")!
        cell.textLabel?.text = roomArray[indexPath.row].roomNameInRoomsClass
//        cell.textLabel?.text = roomNameArray[indexPath.row].roomNameInRoomsClass
        return cell
    }
    
    // create room button
    
    @IBAction func createRoomButtonClick(_ sender: Any)
    {
        guard let roomName = roomNameTextFeild.text ,roomName != "" else {return}
        
        let DBREF = Database.database().reference()
        let roomsInDB = DBREF.child("rooms").childByAutoId()
        let roomArrayInDB : [String:Any] = ["roomName" :roomName]
        
        roomsInDB.setValue(roomArrayInDB)
        { (error, ref) in
            if error == nil
            {
                self.roomNameTextFeild.text = ""
            }
            else
            {
                print("error")
            }
        }
        
    }
    
    func saveRoomNameInChatRoom()
    {
        let DBRF = Database.database().reference()
        DBRF.child("rooms").observe(DataEventType.childAdded)
        { (DataSnapshot) in
            
            if let roomNames = DataSnapshot.value as? [String:Any]
            {
                let roomId = DataSnapshot.key
                if let roomName = roomNames["roomName"] as? String
                {
                    let room = Rooms()
                    room.roomNameInRoomsClass = roomName
                    room.roomIDInClass = roomId
                    
                    self.roomArray.append(room)
                    self.tableViewChatRoom.reloadData()
                }
            }
        }
    }
    
    
//    move to next page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let realchat = self.storyboard?.instantiateViewController(withIdentifier: "realChat") as! RealChatVC
        realchat.room = roomArray[indexPath.row]
        
        self.navigationController?.pushViewController(realchat, animated: true)
    }
    
}
