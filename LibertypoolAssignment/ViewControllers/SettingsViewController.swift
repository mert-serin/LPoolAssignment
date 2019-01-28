
//
//  SettingsViewController.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import UIKit
import RxSwift

class SettingsViewController: UIViewController {
    
    var wallet:Variable<UserModel>!{
        get{
            return (UIApplication.shared.delegate as! AppDelegate).wallet
        }set{
            
        }
    }

    //MARK: Outlets
    @IBOutlet weak var walletNameTextField: UITextField!
    @IBOutlet weak var walletAddressTextField: UITextField!
    @IBOutlet weak var addWalletButton: UIButton!
    
    //MARK: Delegate
    var delegate:TransactionViewControllerDelegate!
    
    //MARK: Models
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI(){
        
        wallet.asObservable().subscribe(onNext: { (wallet) in
            self.walletNameTextField.text = wallet.walletName
            self.walletAddressTextField.text = wallet.walletAddress
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        walletNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.walletNameText)
            .disposed(by: disposeBag)
        
        walletAddressTextField.rx.text
            .orEmpty
            .bind(to: viewModel.walletAddressText)
            .disposed(by: disposeBag)
        
        viewModel.isLoginButtonValid.map { $0 }
            .bind(to: addWalletButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @IBAction func addWalletButtonAction(_ sender: UIButton) {
        let walletName = walletNameTextField.text!
        let walletAddress = walletAddressTextField.text!
        
        let wallet = UserModel(walletName: walletName, walletAddress: walletAddress)
        if KeychainManager().saveUser(model: wallet){
            if let tabBar = parent?.parent as? TransactionTabBarController{
                Observable.just(wallet).bind(to: tabBar.wallet)
            }
        }else{
            
        }
    }
    
}
