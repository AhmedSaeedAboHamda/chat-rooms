//
//  ViewController.swift
//  CodeZilaChatProject
//
//  Created by AhmedSaeed on 4/14/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController ,UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
 
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as! FormCell
        
        if indexPath.row == 0
        {
            cell.userNameContainer.isHidden = true
            cell.slidButton.setTitle("Register 👉🏼", for: .normal)
            cell.actionButton.setTitle("Login", for: .normal)
            cell.slidButton.addTarget(self, action: #selector(moveToSignUp(_sender:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(signInButtonClick(_sender:)), for: .touchUpInside)
        }
        else if indexPath.row == 1
        {
            cell.userNameContainer.isHidden = false
            cell.slidButton.setTitle("👈🏼 SignIn", for: .normal)
            cell.actionButton.setTitle("SignUp", for: .normal)
            cell.slidButton.addTarget(self, action: #selector(moveToSignIn(_sender:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(signUpButtonClick(_sender: )), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 2
    }
    
    
    // functions for sliding form registering form
    @objc func moveToSignUp(_sender: UIButton)
    {
        let indexPath = IndexPath(row: 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    @objc func moveToSignIn(_sender: UIButton)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    
    }
    
//    function used for make register autontacation
    @objc func signUpButtonClick(_sender:UIButton)
    {
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as! FormCell
        guard let userName = cell.userNameTF.text , let email = cell.EmailTF.text ,let password = cell.passwordTF.text else {
                    return
                }
        if userName.isEmpty || password.isEmpty || userName.isEmpty
        {
            self.AlertForError (error : "enter it correctly")
        }
        Auth.auth().createUser(withEmail: email, password: password)
        { (result, error) in
            if error == nil
            {
                guard let userID = result?.user.uid else{return}
                self.dismiss(animated: true, completion: nil)
                
                let refrance = Database.database().reference().child("users").child(userID)
                let userNameArray:[String:Any] = ["userName" : userName]
                refrance.setValue(userNameArray)
            
            }
            else
            {
                self.AlertForError (error : "error")
            }
     }
    }
    
//    function used for sign in autontication
 
    @objc func signInButtonClick(_sender : UIButton)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as! FormCell
        
        guard  let email = cell.EmailTF.text ,let password = cell.passwordTF.text else {
            return
        }
        if email.isEmpty || password.isEmpty
        {
            self.AlertForError (error : "enter it correctly")
        }
        
        Auth.auth().signIn(withEmail: email, password:password) { (result, error) in
            if error == nil
            {
                self.dismiss(animated: true, completion: nil)
                
            }else
            {
                self.AlertForError (error : "error has found will you login")
            }
        }
    }
    
    
    // function for error
    func AlertForError (error : String)
    {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismiss)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

