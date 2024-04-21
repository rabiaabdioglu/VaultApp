//
//  Onboarding1VC.swift
//  NeonSDK1
//
//  Created by Rabia Abdioğlu on 27.03.2024.
//

import UIKit
import NeonSDK

class OnboardingVC: NeonOnboardingController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureButton(
            title: "Next",
            titleColor: .styledWhite4,
            font: Font.custom(size: 16, fontWeight: .Light),
            cornerRadious: 10,
            height: 51,
            horizontalPadding: 120,
            bottomPadding: 0,
            backgroundColor: .styledBlue,
            borderColor: nil,
            borderWidth: nil
        )
        self.configureBackground(
                  type: .halfBackgroundImage(
                  backgroundColor: .styledWhite1,
                  offset: 50,
                  isFaded: false)
        )
        self.configureText(
            titleColor: .styledGray4,
            titleFont: Font.custom(size: 28, fontWeight: .Bold),
            subtitleColor: .styledGray4,
            subtitleFont: Font.custom(size: 18, fontWeight: .Light)
        )
        self.configurePageControl(
            type: .V4,
            currentPageTintColor: .styledBlue,
            tintColor: .styledGray3,
            radius: 7,
            padding: 8
        )
        self.addPage(
            title: "Lock Private Items",
            subtitle: "Safely store your private photos, videos, passwords, credit card information and notes in this app.",
            image: UIImage(named: "onboarding1")!.withRenderingMode(.alwaysOriginal)
        )
        self.addPage(
            title: "Browse Secretly",
            subtitle: "With Private browser, you can surf the Internet privately and your browser history never saved.",
            image: UIImage(named: "onboarding2")!.withRenderingMode(.alwaysOriginal)
        )
        
  
    }
    
    override func onboardingCompleted() {
        super.onboardingCompleted()
        let paywallVC = InAppVC()
        self.present(destinationVC: paywallVC, slideDirection: .right)
        
        
    }
    
}
