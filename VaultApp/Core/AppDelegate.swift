//
//  AppDelegate.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 2.04.2024.
//

import UIKit
import NeonSDK
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Neon.activatePremiumTest()

        AdaptyManager.configure(withAPIKey: "public_live_BxuBlwIh.aWC7A6qhHNsRF8wAT3iT", placementIDs: ["vaultapp.paywall.placements"])
        
        FirebaseApp.configure()
        AuthManager.signInAnonymously()
        Font.configureFonts(font: .Poppins)
        Neon.configure(
            window: &window,
            onboardingVC: OnboardingVC(),
            paywallVC: InAppVC(),
            homeVC: HomeVC())

        return true
    }




}

