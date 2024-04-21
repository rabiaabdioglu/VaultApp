//
//  InApp.swift
//  NeonSDK1
//
//  Created by Rabia Abdioğlu on 27.03.2024.
//

import Foundation
import UIKit
import NeonSDK
class InAppVC: NeonViewController ,AdaptyManagerDelegate{
    
    //Custom Purchase buttons
    var weeklyButton = PurchaseButton(price: "", productTitle: "")
    var monthlyButton = PurchaseButton(price: "", productTitle: "")
    var annualButton = PurchaseButton(price: "", productTitle: "")
    
    var selectedPackage : SelectedPackage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdaptyManager.delegate = self
        packageFetched()
        
        view.backgroundColor = .white
        mainStack.addSpacer(50)
        mainStack.alignment = .center
        
        // InApp Image
        let inAppImageView = NeonImageView()
        inAppImageView.image = UIImage(named: "inApp")
        mainStack.addArrangedSubview(inAppImageView)
        inAppImageView.snp.makeConstraints { make in
            make.width.height.equalTo(view.snp.width).multipliedBy(0.54)
            make.centerX.equalToSuperview()
            
        }
        
        let verticalStack = NeonVStack(width: mainStack.frame.width , block: { vStack in
            
            let labelVStack = NeonVStack(width: mainStack.frame.width , block: { labelStack in
                let headerLabel = UILabel()
                headerLabel.text = "Upgrade to Premium"
                headerLabel.textColor = .styledGray4
                headerLabel.textAlignment = .center
                headerLabel.font = Font.custom(size: 28, fontWeight: .SemiBold)
                labelStack.addSubview(headerLabel)
                
                let subTitleLabel = UILabel()
                subTitleLabel.text = "Get premium now and have unlimited safe vault area for your private media and info."
                subTitleLabel.textColor = .styledGray4
                subTitleLabel.textAlignment = .center
                subTitleLabel.numberOfLines = 0
                subTitleLabel.font = Font.custom(size: 19, fontWeight: .Light)
                labelStack.addSubview(subTitleLabel)
                
            })
            vStack.addArrangedSubview(labelVStack)
            labelVStack.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.height.equalTo(vStack.snp.height).multipliedBy(0.25)
                make.width.equalToSuperview()
                make.top.equalTo(20)
                
            }
            let packageButtonsVStack = NeonVStack(width: mainStack.frame.width , block: { buttonStack in
                
                weeklyButton.checkIcon.isHidden = true
                weeklyButton.purchaseButton.addTarget(self, action: #selector(weeklyButtonTapped), for: .touchUpInside)
                buttonStack.addSubview(weeklyButton)
                weeklyButton.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.height.equalTo(buttonStack.snp.height).multipliedBy(0.25)
                    make.width.equalToSuperview().multipliedBy(0.85)
                }
                monthlyButton.checkIcon.isHidden = true
                monthlyButton.purchaseButton.addTarget(self, action: #selector(monthlyButtonTapped), for: .touchUpInside)
                buttonStack.addSubview(monthlyButton)
                monthlyButton.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.height.equalTo(buttonStack.snp.height).multipliedBy(0.25)
                    make.width.equalToSuperview().multipliedBy(0.85)
                }
                annualButton.checkIcon.isHidden = true
                annualButton.purchaseButton.addTarget(self, action: #selector(annualButtonTapped), for: .touchUpInside)
                buttonStack.addSubview(annualButton)
                annualButton.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.height.equalTo(buttonStack.snp.height).multipliedBy(0.25)
                    make.width.equalToSuperview().multipliedBy(0.85)
                }
                
                
                
            })
            packageButtonsVStack.alignment = .center
            vStack.addArrangedSubview(packageButtonsVStack)
            packageButtonsVStack.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.height.equalTo(vStack.snp.height).multipliedBy(0.4)
                make.width.equalToSuperview()
                
            }
            
            let startButton = UIButton()
            startButton.backgroundColor = .styledBlue
            startButton.tintColor = .white
            startButton.setTitle("Start", for: .normal)
            startButton.titleLabel?.font = Font.custom(size: 16, fontWeight: .Light)
            startButton.layer.cornerRadius = 10
            startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            vStack.addSubview(startButton)
            startButton.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.4)
                make.height.equalToSuperview().multipliedBy(0.09)
                make.centerX.equalToSuperview()
                
            }
            
        })
        verticalStack.alignment = .center
        verticalStack.backgroundColor = .styledWhite1
        verticalStack.layer.cornerRadius = 30
        verticalStack.addSpacer(10)
        mainStack.addArrangedSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.66)
            make.width.equalToSuperview()
        }
        
        
    }
    
    
    @objc func startButtonTapped(){
        AdaptyManager.selectPackage(id: selectedPackage!.rawValue)
        print(selectedPackage!.rawValue)
        print(AdaptyManager.selectedPackage!)
        initiatePurchase()
        
    }
    
    @objc func weeklyButtonTapped(){
        selectedPackage = .weekly
        monthlyButton.isSelected = false
        annualButton.isSelected = false
        weeklyButton.isSelected = true

        selectedPackage = .weekly
    }
    @objc func monthlyButtonTapped(){
        selectedPackage = .monthly
        monthlyButton.isSelected = true
        annualButton.isSelected = false
        weeklyButton.isSelected = false
        selectedPackage = .monthly

    }
    @objc func annualButtonTapped(){
        selectedPackage = .annual
        monthlyButton.isSelected = false
        annualButton.isSelected = true
        weeklyButton.isSelected = false
        selectedPackage = .annual

        
    }
    @objc func goHome(){
        
        Neon.activatePremiumTest()
        
        let homeVC   = HomeVC()
        self.present(destinationVC: homeVC, slideDirection: .up)
        
        
    }
    
    // MARK: - Get packages and uppdate buttons
    func packageFetched() {
        // Weekly
        let weeklyPrice = AdaptyManager.getPackagePrice(id: SelectedPackage.weekly.rawValue)
        let weeklyPackagePrice = weeklyPrice
        weeklyButton.priceLabel.text = weeklyPackagePrice
        
        if let weeklyPackage = AdaptyManager.getPackage(id: SelectedPackage.weekly.rawValue){
            weeklyButton.productTitleLabel.text = "\(weeklyPackage.localizedDescription)"
 
        }
        
        // Monthly
        let monthlyPrice = AdaptyManager.getPackagePrice(id: SelectedPackage.monthly.rawValue)
        let monthlyPackagePrice = monthlyPrice
        monthlyButton.priceLabel.text = monthlyPackagePrice
        
        if let monthlyPackage = AdaptyManager.getPackage(id: SelectedPackage.monthly.rawValue){
            monthlyButton.productTitleLabel.text = "\(monthlyPackage.localizedDescription)"
        }
        
        // Annual
        let annualPrice = AdaptyManager.getPackagePrice(id: SelectedPackage.annual.rawValue)
        let annualPackagePrice = annualPrice
        annualButton.priceLabel.text = annualPackagePrice
        
        if let annualPackage = AdaptyManager.getPackage(id: SelectedPackage.annual.rawValue){
            annualButton.productTitleLabel.text = "\(annualPackage.localizedDescription)"
        }
        
        
        
    }
    func initiatePurchase() {
        AdaptyManager.purchase(animation: .loadingCircle2) {
            self.showAlert(title: "Payment Success", message: "Your purchase was successful.")
            Neon.activatePremiumTest()
            self.goHome()
            
        } completionFailure: {
            self.showAlert(title: "Payment Failed", message: "Your purchase was not successful.")
            
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
enum SelectedPackage: String {
    case weekly = "va_999_1w"
    case monthly = "va_1999_1m"
    case annual = "va_12999_1y"
}
