//
//  SettingsViewController.swift
//  TutorUp
//
//  Created by Shahir Abdul-Satar on 9/16/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter city:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let schoolLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter school:"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let cityTextField: UITextField = {
       let txt = UITextField()
        txt.placeholder = "City"
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.borderStyle = .roundedRect
        return txt
    }()
    
    let schoolTextField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "School"
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.borderStyle = .roundedRect
        return txt
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func handleSave() {
        print(cityTextField.text)
        print(schoolTextField.text)
        if cityTextField.text == "" || schoolTextField.text == "" {
            cityTextField.alpha = 1
            schoolTextField.alpha = 1
        }
        else {
        cityTextField.alpha = 0.5
        schoolTextField.alpha = 0.5
                       
            updateSaveSchoolAndCity()
        }
    }
    
    func updateSaveSchoolAndCity(){
        let currentUser = Auth.auth().currentUser
        guard let city = cityTextField.text, let school = schoolTextField.text, let uid = currentUser?.uid else {
            print("error")
            return
        }
        let ref = Database.database().reference()
        let userRef = ref.child("city/school")
        let child = userRef.child(uid)
        let values = ["user": uid, "city": city, "school": school]
        child.updateChildValues(values, withCompletionBlock:{ (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("saved data")
        })
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.title = "Settings"
        view.addSubview(cityLabel)
        view.addSubview(cityTextField)
        view.addSubview(schoolLabel)
        view.addSubview(schoolTextField)
        view.addSubview(saveButton)
        setUpTextFieldAndLabelLayout()

    }
    
    
    func setUpTextFieldAndLabelLayout(){
        //x,y,w,h
        cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cityLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        cityTextField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 0).isActive = true
        cityTextField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cityTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        cityTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        schoolLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor).isActive = true
        schoolLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        schoolLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        schoolLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        schoolTextField.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor).isActive = true
        schoolTextField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        schoolTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        schoolTextField.heightAnchor.constraint(equalToConstant:  50).isActive = true
        
        //button
        saveButton.topAnchor.constraint(equalTo: schoolTextField.bottomAnchor).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -5).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
