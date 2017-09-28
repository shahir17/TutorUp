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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let ref = Database.database().reference()
     
        view.backgroundColor = UIColor.white
        
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
        
        
    }
    
    private func createDummyNavControllerWithTitle(title: String, controller: UIViewController) -> UINavigationController {
        let viewController = controller
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.visibleViewController?.title = title
        //navController.tabBarItem.image = UIImage(cgImage: )
        return navController
    }
    
    
    
   
    
    
   

   

}

