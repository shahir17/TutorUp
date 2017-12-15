//
//  TutorDetailViewController.swift
//  TutorUp
//
//  Created by Shahir Abdul-Satar on 12/15/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit

class TutorDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tutor Detail"
   
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancelTutorDetailShow))
        self.view.backgroundColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func handleCancelTutorDetailShow(){
        dismiss(animated: true, completion: nil)
    }
    

   
}
