//
//  TableViewController.swift
//  TutorUp
//
//  Created by Shahir Abdul-Satar on 10/2/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit
import Firebase



class ShowTutorsViewController: UITableViewController {

    
    var tutors = [User]()
    let cellId = "cellId"
    var tutorIds = [String]()
    var oneTutor = ""
    var searchVC = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tutors"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelShowTutors))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchTutorsIds()
        
    }
    
    func fetchTutorsIds() {
        
        
        
        
        
        
       Database.database().reference().child("users").child("tutors").observe(.childAdded, with: { (snapshot) in
           // print(snapshot.key)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                
                let user = User()
                user.setValuesForKeys(dictionary)
                
                
                self.tutors.append(user)
                self.tableView.reloadData()
 
                    }
                    

            
            
        }, withCancel: nil)
        
        
        
        
        
    }
    
   
 
    
    
    
    func handleCancelShowTutors(){
        dismiss(animated: true, completion: nil)
    }

    

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tutors.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = tutors[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        cell.imageView?.image = UIImage(named: "userIcon")
        cell.imageView?.contentMode = .scaleAspectFill
        
        
    
        
      
        
        return cell
    }
    
}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
