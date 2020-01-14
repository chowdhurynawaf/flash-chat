//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController  , UITableViewDataSource , UITableViewDelegate, UITextFieldDelegate{
    
    
  
    
    
    // Declare instance variables here
    
    
    var messageArray : [Message] = [Message]()
     
    
    

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        //TODO: Set yourself as the delegate and datasource here:
        
        
        
        //TODO: Set yourself as  the delegate of the text field here:

        messageTextfield.delegate = self
        
        //TODO: Set the tapGesture here:
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTextfield.addGestureRecognizer(tapGesture)
        
        

        //TODO: Register your MessageCell.xib file here:

        
        
        messageTableView.register(UINib(nibName: "MessageCell",bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        
        configureTableView()
        
        retrieveMessage()
        
        
        messageTableView.separatorStyle = .none
        
        
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        
        
        cell.messageBody.text = messageArray[indexPath.row ].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        else{
            cell.avatarImageView.backgroundColor = UIColor.flatRed()
            cell.avatarImageView.backgroundColor = UIColor.flatBlue()
        }
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    //TODO: Declare tableViewTapped here:
    
    
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    
    //TODO: Declare configureTableView here:
    
    func configureTableView(){
        messageTableView.estimatedRowHeight = 120.0
        messageTableView.rowHeight = UITableView.automaticDimension
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 300
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        
        
        messageTextfield.endEditing(true)
        
        messageTextfield.isEnabled = false
        
        sendButton.isEnabled = false
         
        
        let messageDb = Database.database().reference().child("messages")
        
        let messageDictionary = ["Sender":Auth.auth().currentUser?.email ,"messageBody":messageTextfield.text!]
        
        messageDb.childByAutoId().setValue(messageDictionary){
            (error , reference) in
            
            if error != nil{
                print(error!)
            }
            else{
                print("message saved successfully")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
                 
            }
        }
        
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    
    
    func retrieveMessage(){
        
        
        let messageDb = Database.database().reference() .child("messages")
        
        
        messageDb.observe(.childAdded ){ (snapshot) in
            
            let snapShotValue = snapshot.value as! Dictionary<String,String>
            
            let text = snapShotValue["messageBody"]!
            let sender = snapShotValue["Sender"]!
            
            
            let message = Message()
            
            message.messageBody = text
            message.sender = sender
            
            
            self.messageArray.append(message)
            
            
            self.configureTableView()

            self.messageTableView.reloadData()
             
        }
    }
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        do{
           try Auth.auth().signOut()
            
           
        }
        
        catch{
            print("error")
        }
        
        guard ( navigationController?.popViewController(animated: true)) != nil
            
            else{
                print("no view controller pooped out")
                return
            }
            
        }
        
        
    }
    



