//
//  LoginViewModel.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 28.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    let walletNameText = BehaviorSubject<String>(value: "")
    let walletAddressText = BehaviorSubject<String>(value: "")
    let didTapLoginButton = PublishSubject<Void>()
    
    var isLoginButtonValid: Observable<Bool>!
    

//    var resignKeyboardObservable: Observable<Void> {
//        return didAttemptToResignKeyboard
//            .map { _ in return }
//    }
    
    let disposeBag = DisposeBag()
    
    init() {
        isLoginButtonValid = Observable.combineLatest(self.walletNameText, self.walletAddressText) { (wallet, address) in
            return !wallet.isEmpty && !address.isEmpty
        }
    }
    
}
