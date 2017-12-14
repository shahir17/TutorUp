//
//  LoginViewController.swift
//  TutorUp
//
//  Created by Shahir Abdul-Satar on 9/15/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    func handleLoginRegister(){
        if  self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter a username, email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)

                return
            }
            //successfully logged in user
            guard let userid = user?.uid
             else {
                return
            }
            
            let vc = TabBarController()
           self.present(vc, animated: true, completion: nil)
                
            
        }
    }
    
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion:  { (user, error) in
            if error != nil {
                print(error)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)

                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            //successful authenticated user
            let ref = Database.database().reference()
            let usersRef = ref.child("users")
            var child = usersRef
            if self.studentOrTutorSwitch.isOn {
                 child = usersRef.child("tutors").child(uid)
            }
            else {
             child = usersRef.child("students").child(uid)
            }
            let values = ["name": name, "email": email]
            child.updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err)
                    let alertController = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)

                    return
                }
                    //self.dismiss(animated: true, completion: nil)
                    let registerVC = TabBarController()
                self.present(registerVC, animated: true, completion: nil)
                                
            })
            
            
        })
    }
    
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let passwordTextField: UITextField = {
        let pass = UITextField()
        pass.placeholder = "Password"
        pass.isSecureTextEntry = true
        pass.translatesAutoresizingMaskIntoConstraints = false
        return pass
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    let tutorUpLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Tutor Up"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        
        return lbl
    }()
    
    let studentOrTutorSwitch: UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    let studentSwitchLeft: UILabel = {
        let studentSwitch = UILabel()
        studentSwitch.text = "Student"
        studentSwitch.translatesAutoresizingMaskIntoConstraints = false
        studentSwitch.textColor = UIColor.white
        return studentSwitch
    }()
    
    let tutorSwitchRight: UILabel = {
        let tutor = UILabel()
        tutor.text = "Tutor"
        tutor.translatesAutoresizingMaskIntoConstraints = false
        tutor.textColor = UIColor.white
        return tutor
    }()

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(nameTextField)
        view.addSubview(nameSeparatorView)
        view.addSubview(emailTextField)
        view.addSubview(emailSeparatorView)
        view.addSubview(passwordTextField)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(tutorUpLabel)
        view.addSubview(studentOrTutorSwitch)
        view.addSubview(studentSwitchLeft)
        view.addSubview(tutorSwitchRight)
        setupInputsContainerView()
        setUpLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
        setupLabel()
        setupStudentOrTutorSwitch()
        
    }
    
    func setupLabel(){
        //Welcome label need x,y,w,h
        tutorUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tutorUpLabel.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -20).isActive = true
        tutorUpLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        tutorUpLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //switches 
        studentSwitchLeft.rightAnchor.constraint(equalTo: studentOrTutorSwitch.leftAnchor, constant: -12).isActive = true
        studentSwitchLeft.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 7).isActive = true
        studentSwitchLeft.widthAnchor.constraint(equalToConstant: 70).isActive = true
        studentSwitchLeft.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tutorSwitchRight.leftAnchor.constraint(equalTo: studentOrTutorSwitch.rightAnchor, constant: 12).isActive = true
        tutorSwitchRight.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 7).isActive = true
        tutorSwitchRight.widthAnchor.constraint(equalToConstant: 70).isActive = true
        tutorSwitchRight.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func setupStudentOrTutorSwitch() {
        studentOrTutorSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        studentOrTutorSwitch.centerYAnchor.constraint(equalTo: loginRegisterButton.topAnchor, constant: -12).isActive = true
        studentOrTutorSwitch.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        studentOrTutorSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        studentOrTutorSwitch.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100: 150
        //get rid of switch labels
        studentSwitchLeft.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true: false
        tutorSwitchRight.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true: false

        
        
        ///get rid of name field
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //get rid of switch
        studentOrTutorSwitch.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true: false

        //bring button back up
        loginRegisterButton.topAnchor.constraint(equalTo: studentOrTutorSwitch.bottomAnchor, constant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0: -24)
        
        
        //email tf change size
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //password tf change size 
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setupLoginRegisterSegmentedControl() {
        //need x,y,w,h
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
        
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setUpLoginRegisterButton(){
         //need x,y,w,h
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: studentOrTutorSwitch.bottomAnchor, constant: -24).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        //need x,y,w,h constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
            inputsContainerViewHeightAnchor?.isActive = true
        
        
        
        //name textfield
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        //name separator
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //email tf
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            emailTextFieldHeightAnchor?.isActive = true
        //email separator
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //password tf
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    
    }
    
        
    

   

}
