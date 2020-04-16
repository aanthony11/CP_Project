//
//  AppDelegate.swift
//  CP_Project
//
//  Created by Manish Rajendran on 3/25/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Parse.initialize(
                   with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                       configuration.applicationId = "Sortior"
                       configuration.server = "https://arcane-river-31190.herokuapp.com/parse"
                   })
        )
        
        // Testing if Parse is working by adding a user to the table
      //  let user = PFUser()
      //  user.username = "jamie@cse.msu.edu"
      //  user.password = "stronkPassword"
      //
      //  user["firstName"] = "Jamie"
      //  user["lastName"] = "Doe"
      //
      //  user.signUpInBackground { (success, error) in
      //      if success {
      //          print("Jackie was added to User table!")
      //      } else {
      //          print("Error: \(error?.localizedDescription)")
      //      }
      //  }
        
        
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

