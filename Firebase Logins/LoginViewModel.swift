//
//  LoginViewModel.swift
//  Firebase Logins
//
//  Created by dev on 27/11/2017.
//  Copyright © 2017 Hajji Reyes. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin
import TwitterKit

protocol LoginViewProtocol {
    func loginViaFacebook(_ view: UIViewController, completion:() -> Void)
    func loginViaGoogle(completion:() -> Void)
    func loginViaTwitter(completion: () -> Void)
    var error: Bind<Error?> { get }
    var userInfo: Bind<User?> { get }
}

class LoginViewModel: NSObject, LoginViewProtocol {
    var loginManager: LoginManager!
    let error: Bind<Error?>
    var userInfo: Bind<User?>
    
    override init() {
        self.error = Bind(nil)
        self.userInfo = Bind(nil)
        super.init()
        
        // Initialize and configure Firebase SDK
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Initialize Twitter SDK
        Twitter.sharedInstance().start(withConsumerKey:"N1CDyvQMGNsgbLqY73FxeK4e4", consumerSecret:"zVJ4ba9DTEt3ICirVn6cs4WKZHJhMReHdEdoeezH1qc64crvUz")
        
        // Initialize Facebook SDK
        loginManager = LoginManager()
    }
    
    func loginViaTwitter(completion: () -> Void) {
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                // Get credentials, authorized by session
                let creds = TwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
                
                // Sign-in account to Firebase
                self.signInAfterAuthentication(creds, linkAccount: false)
            } else {
                print("Error Outside")
                self.error.value = error
            }
        })
        
    }
    
    func loginViaFacebook(_ view: UIViewController, completion: () -> Void) {
        
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: view) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.error.value = error
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                if let auth = AccessToken.current?.authenticationToken {
                    // Get credentials if the auth token is not nil
                    let creds = FacebookAuthProvider.credential(withAccessToken: auth)
                    
                    // Sign-in account to Firebase, [OPTIONAL] linkAccount - if you wish add new login to existing,
                    // else it will be unlinked and a new one will be created
                    self.signInAfterAuthentication(creds, linkAccount: true)
                }
                print("Logged in!")
            }
        }
    }
    
    func loginViaGoogle(completion:() -> Void) {
        // Calling signIn method will trigger sign(_ signIn: ) delegate
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    //MARK: ~ This method will sign/register authenticated credentials on Firebase
    fileprivate func signInAfterAuthentication(_ credentials: AuthCredential?, linkAccount: Bool? = nil){
        guard let credentials = credentials else { return }
        // Get current provider if exist/logged-in
        let user = Auth.auth().currentUser?.providerID ?? ""

        // Check if option to link account is true
        if let link = linkAccount, link == true {
            if user.isEmpty {
                self.registerAccount(credentials)
            }
            // Check if current user exist to link the new account
            Auth.auth().currentUser?.link(with: credentials){ user, error in
                // Fail to link accounts
                if let error = error {
                    print("Error at Linking")
                    self.error.value = error
                    return
                }
            }
        }else{
            // Register as new account
            self.registerAccount(credentials)
        }
    }
    
    fileprivate func registerAccount(_ credentials: AuthCredential?) {
        guard let credentials = credentials else { return }
        // Sign/Register Social login as new user, unless previously logged-in
        Auth.auth().signIn(with: credentials) { (user, error) in
            // Fail to sign in to Firebase account
            if let error = error {
                print("Error at SignInAfter")
                self.error.value = error
                return
            }
            // Assign current user to userInfo
            self.userInfo.value = Auth.auth().currentUser
        }
    }
    
//    fileprivate func linkAccountAfterAuthentication(_ credentials: AuthCredential?, completion:(Bool) -> ()) {
//        var status:Bool = false
//        guard let credentials = credentials else { return status }
//        guard let current = Auth.auth().currentUser else {
//            return status
//        }
//        current.link(with: credentials) { user, error in
//            // Fail to link accounts
//            if let error = error {
//                print("Error at Linking")
//                self.error.value = error
//            }else{
//                status = true
//            }
//        }
//        return status
//        //        Auth.auth().currentUser?.link(with: credentials){ user, error in
//        //            // Fail to link accounts
//        //            if let error = error {
//        //                print("Error at Linking")
//        //
//        //                self.error.value = error
//        //                return
//        //            }
//        //        }
//    }
    
}

extension LoginViewModel: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.error.value = error
            return
        }
        
        guard let authentication = user.authentication else { return }
        let creds = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                  accessToken: authentication.accessToken)
        // Sign-in account to Firebase
        self.signInAfterAuthentication(creds, linkAccount: true)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        if let error = error {
            self.error.value = error
            return
        }
    }
    
}

extension LoginViewModel: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        //        if let error = result {
        //            print(error.localizedDescription)
        //            return
        //        }
        print("Login Result => \(result)")
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("LOGOUT")
    }
    
}

