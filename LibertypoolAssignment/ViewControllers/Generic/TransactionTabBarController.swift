//
//  TransactionTabBarController.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import UIKit
import RxSwift
class TransactionTabBarController: UITabBarController {

    let disposeBag = DisposeBag()
    var wallet:Variable<UserModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wallet = (UIApplication.shared.delegate as! AppDelegate).wallet

        wallet.asObservable().subscribe(onNext: { (wallet) in
            print("asd")
            if let transactionViewController = (self.viewControllers![0] as! UINavigationController).topViewController as? TransactionViewController{
                transactionViewController.wallet = Variable.init(wallet)
            }
        }, onError: { (error) in
            print(2)
        }, onCompleted: {
            print(3)
        }) {
            print(4)
        }.disposed(by: disposeBag)

    }
    
}
