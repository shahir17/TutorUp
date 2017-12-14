//
//  ViewController.swift
//  TutorUp
//
//  Created by Shahir Abdul-Satar on 9/15/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    let loginVC = LoginViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let ref = Database.database().reference()
        
       
        
        view.backgroundColor = UIColor.white
        
        

        
        setUpTabBarBasedOnTypeOfUser()
        
        
        
        
        /*
        
        //setup view controllers
        let searchController = SearchViewController()
        let searchNavController = UINavigationController(rootViewController: searchController)
        searchNavController.tabBarItem.title = "Search"
        //searchNavController.tabBarItem.image = UIImage(cgImage: )
                viewControllers = [searchNavController, createDummyNavControllerWithTitle(title: "Inbox", controller: InboxViewController()), createDummyNavControllerWithTitle(title: "MySessions", controller: MySessionsViewController()), createDummyNavControllerWithTitle(title: "Settings", controller: SettingsViewController())]
        
       let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        //navController.tabBarItem.title = "Inbox"
        //navController.tabBarItem.image = UIImage(cgImage: )
        
        */
    }
    
    func setUpTabBarBasedOnTypeOfUser(){
        let currentUser = Auth.auth().currentUser
        let userid = currentUser?.uid
        
        let ref = Database.database().reference()

        ref.child("users").child("tutors").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild(userid!) {
                let firstController = TutorHomeController()
                let nav = UINavigationController(rootViewController: firstController)
                nav.tabBarItem.title = "Home"
                self.viewControllers = [nav, self.createDummyNavControllerWithTitle(title: "Inbox", controller: InboxViewController()), self.createDummyNavControllerWithTitle(title: "MySessions", controller: MySessionsViewController()), self.createDummyNavControllerWithTitle(title: "Settings", controller: SettingsViewController())]
                
            }
            else {
                let firstController = SearchViewController()
                let nav = UINavigationController(rootViewController: firstController)
                nav.tabBarItem.title = "Search"
                self.viewControllers = [nav, self.createDummyNavControllerWithTitle(title: "Inbox", controller: InboxViewController()), self.createDummyNavControllerWithTitle(title: "MySessions", controller: MySessionsViewController()), self.createDummyNavControllerWithTitle(title: "Settings", controller: SettingsViewController())]
                
            }
        
        })
    
    }
    
     func createDummyNavControllerWithTitle(title: String, controller: UIViewController) -> UINavigationController {
        let viewController = controller
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.visibleViewController?.title = title
        //navController.tabBarItem.image = UIImage(cgImage: )
        return navController
    }
    
    
    
   
    
    
   

   

}

