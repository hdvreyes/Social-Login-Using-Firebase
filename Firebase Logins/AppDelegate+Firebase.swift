//
//  AppDelegate+Firebase.swift
//  Firebase Logins
//
//  Created by dev on 24/11/2017.
//  Copyright © 2017 Hajji Reyes. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin
import TwitterKit
extension AppDelegate {
    
    func initFirebaseConfig(){
        // Use Firebase library to configure APIs
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            let googleDidhandle = GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
            let twitterDidHandle = Twitter.sharedInstance().application(app, open: url, options: options)
            //let facebookDidHandle = SDKApplicationDelegate.shared.application(app, open: url, options: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! [UIApplicationOpenURLOptionsKey : Any])
            let facebookDidHandle = SDKApplicationDelegate.shared.application(app, open: url, options: options)
            return googleDidhandle || twitterDidHandle || facebookDidHandle
    }
    
    @available(iOS 9.0, *)
    func application(app: UIApplication, openURL url: NSURL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let googleDidhandle = GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication:sourceApplication, annotation: [:])
        let twitterDidHandle = Twitter.sharedInstance().application(app, open: url as URL, options: options)
        let facebookDidHandle = SDKApplicationDelegate.shared.application(app, open: url as URL, options: options)
        return googleDidhandle || twitterDidHandle || facebookDidHandle
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let googleDidhandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: UIApplicationOpenURLOptionsKey.sourceApplication.rawValue, annotation: [:])
        let facebookDidHandle = SDKApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        let twitterDidHandle = Twitter.sharedInstance().application(application, open: url, options: annotation as! [AnyHashable : Any])
        return googleDidhandle || twitterDidHandle || facebookDidHandle
    }

    
    
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
//        -> Bool {
////            return GIDSignIn.sharedInstance().handle(url,
////                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
////                                                     annotation: [:])
//            return Twitter.sharedInstance().application(application, open: url, options: options)
////            let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
////
////            let googleDidhandle = GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
////
////            let twitterDidHandle = Twitter.sharedInstance().application(app, open: url, options: options)
//
//    }

    
//    @available(iOS 8.0, *)
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url,
//                                                 sourceApplication: UIApplicationOpenURLOptionsKey.sourceApplication.rawValue,
//                                                 annotation: [:])
//    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return Twitter.sharedInstance().application(app, open: url, options: options)
//    }
}
