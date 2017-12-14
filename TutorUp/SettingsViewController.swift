//
//  SettingsViewController.swift
//  TutorUp
//
//  Created by Shahir Abdul-Satar on 9/16/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    let editProfileButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        //button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
       // button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)

        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let logoutButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
       // button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        //button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor.black.cgColor
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleImagePicker))
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
        
    }()
    
    var userNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " "
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
        
    }()
    
    let userSchool: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
        
    }()
    let userCity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
        
    }()

    let userBio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
        
    }()


    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            let alertController = UIAlertController(title: "Error", message: logoutError.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
        
    

    }
    
    func editProfile(){
        let controller = ProfileViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleImagePicker(){
        print("123")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
     var selectedImageFromPicker: UIImage?
     
     if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
     selectedImageFromPicker = editedImage
     }
     else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
     selectedImageFromPicker = originalImage
     }
     if let selectedImage = selectedImageFromPicker {
     profileImageView.image = selectedImage
     }
     dismiss(animated: true, completion: nil)
     let storage = Storage.storage().reference().child("myImage.png")
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
            storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                guard let userId = Auth.auth().currentUser?.uid else {
                    return
                }
                let ref = Database.database().reference().child("profileImage")
                let userRef = ref.child(userId)
                let profileImageUrl = metadata?.downloadURL()?.absoluteString
                let values = ["profileImageUrl": profileImageUrl]
                userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    
                    
                })
                
            })

        }
     
     
     }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func getStudentName() {
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("users")
        ref.child("students").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.name = dictionary["name"] as? String
                self.userNameLabel.text = user.name
                print(user.name!)
            }
            
            
            
        }, withCancel: nil)
            
            
            
       
        
        

    }
    
    func getTutorName() {
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("users")
        ref.child("tutors").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.name = dictionary["name"] as? String
                self.userNameLabel.text = user.name
                print(user.name!)
            }
            
            
            
        }, withCancel: nil)
        
    }
    
    func fetchUserInfo() {
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("info")
        ref.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.bio = dict["bio"] as? String
                user.city = dict["city"] as? String
                user.school = dict["school"] as? String
                
                self.userBio.text = user.bio
                self.userCity.text = user.city
                self.userSchool.text = user.school
            }
        }, withCancel: nil)
        
        
    }

    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.title = "Settings"
       

        view.addSubview(profileImageView)
        view.addSubview(editProfileButton)
        view.addSubview(logoutButton)
        view.addSubview(userNameLabel)
        view.addSubview(userBio)
        view.addSubview(userSchool)
        view.addSubview(userCity)
        
        setupSettingsLayout()
        getStudentName()
        getTutorName()
        fetchUserInfo()

    }
    
    
    
    func setupSettingsLayout(){
        //profile button
        editProfileButton.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -10).isActive = true
        editProfileButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editProfileButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        
        //logoutbutton
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        
        //profileImageView
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //usernameLabel
        userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //userschool
        userSchool.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5).isActive = true
        userSchool.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userSchool.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userSchool.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //usercity
        userCity.topAnchor.constraint(equalTo: userSchool.bottomAnchor, constant: 5).isActive = true
        userCity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userCity.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userCity.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //userbio
        userBio.topAnchor.constraint(equalTo: userCity.bottomAnchor, constant: 5).isActive = true
        userBio.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userBio.heightAnchor.constraint(equalToConstant: 150).isActive = true
        userBio.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true

        
    }
    
    /*
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
        saveButton.topAnchor.constraint(equalTo: schoolTextField.bottomAnchor, constant: 5).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
 */
    
}
