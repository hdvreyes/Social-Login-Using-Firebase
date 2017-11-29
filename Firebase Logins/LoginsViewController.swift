//
//  ViewController.swift
//  Firebase Logins
//
//  Created by dev on 24/11/2017.
//  Copyright © 2017 Hajji Reyes. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookLogin
import FacebookCore


class LoginsViewController: UIViewController, GIDSignInUIDelegate {

    fileprivate var loginViewModel: LoginViewModel!
    
    let googleSignInBtn: UIButton! = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("Sign in with Google", for: .normal)
        button.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        return button
    }()
    
    let facebookSignInBtn: UIButton! = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Login via Facebook", for: .normal)
        button.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        return button
    }()

    let twitSignInBtn: UIButton! = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Login via Twitter", for: .normal)
        button.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 3
        return button
    }()

    var error:Error? {
        didSet { showAlert() }
    }
    var userInfo:User? {
        didSet{
            updateUserInformation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
//        GIDSignIn.sharedInstance().signInSilently()
//        let auth = Auth.auth()
//        auth.addStateDidChangeListener { _, user in
//            print("Changed")
//            if let user = user {
//                // user is already logged in
//                print("User => \(user.displayName)")
//            } else {
//                // user is not logged in
//            }
//        }
//
//
//        // TODO(developer) Configure the sign-in button look/feel
//        // ...
        initializeUI()

//
        if Auth.auth().currentUser != nil {
            print("NOT NIL")
            // User is signed in.
            // ...
            let currentUser = Auth.auth().currentUser
            print("\(currentUser?.displayName)")
            print("Provider => \(currentUser?.providerData.count)")
            for item in (currentUser?.providerData)! {
                print("-> \(item.providerID)")
                print("-> \(item.displayName)")

            }
            
            
        } else {
            print("NIL")
            // No user is signed in.
            // ...
        }
//        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
//
//            print("Has a key")
//            let userID = Auth.auth().currentUser?.email
//            print("ID ==> \(userID)")
//        }else{
//            print("No key")
//
//        }
        
    }

    fileprivate func updateUserInformation(){
        guard let userInfo = self.userInfo else {
            return
        }
        for item in userInfo.providerData {
            print("---> \(item.providerID)")
            print("---> \(item.displayName)")
        }
    }
    
    fileprivate func showAlert(){
        print("ERROR ALERT => \(error)")
    }
    
    fileprivate func initializeUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(googleSignInBtn)
        self.view.addSubview(facebookSignInBtn)
        self.view.addSubview(twitSignInBtn)

        addGoogleButton()
    }
    
    fileprivate func addGoogleButton(){
        googleSignInBtn.addConstraints(Anchor.XAnchor, from: self.view)
        googleSignInBtn.addConstraints(Anchor.YAnchor, from: self.view)
        googleSignInBtn.addConstraints(Anchor.Lead, from: self.view, constant: 20)
        googleSignInBtn.addConstraints(Anchor.Trail, from: self.view, constant: -20)
        googleSignInBtn.addConstraints(Anchor.Height, from: self.view, constant: 50)
        
        facebookSignInBtn.addConstraints(Anchor.XAnchor, from: self.view)
        facebookSignInBtn.addConstraints(Anchor.Top, from: googleSignInBtn, constant: 70)
        facebookSignInBtn.addConstraints(Anchor.Lead, from: self.view, constant: 20)
        facebookSignInBtn.addConstraints(Anchor.Trail, from: self.view, constant: -20)
        facebookSignInBtn.addConstraints(Anchor.Height, from: self.view, constant: 50)

        twitSignInBtn.addConstraints(Anchor.XAnchor, from: self.view)
        twitSignInBtn.addConstraints(Anchor.Top, from: facebookSignInBtn, constant: 70)
        twitSignInBtn.addConstraints(Anchor.Lead, from: self.view, constant: 20)
        twitSignInBtn.addConstraints(Anchor.Trail, from: self.view, constant: -20)
        twitSignInBtn.addConstraints(Anchor.Height, from: self.view, constant: 50)

    }
    
    @objc fileprivate func authenticate(_ sender: UIButton){
        print(sender)
        switch sender.tag {
        case AuthType.Google.rawValue:
            loginViewModel.loginViaGoogle {
                
            }
            break
        case AuthType.Facebook.rawValue:
            loginViewModel.loginViaFacebook(self) {
                
            }
            break
        case AuthType.Twitter.rawValue:
            loginViewModel.loginViaTwitter { }
            break
        default:
            break
        }
        // Fires error if any on the method closure above fails
        self.loginViewModel.error.fire { [weak self] in
            self?.error = $0
        }
        
        self.loginViewModel.userInfo.fire { [weak self] in
            self?.userInfo = $0
        }
    }
    
    

}

enum AuthType: Int {
    case Google = 1
    case Facebook = 2
    case Twitter = 3
}

