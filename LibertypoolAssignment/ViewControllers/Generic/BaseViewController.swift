//
//  BaseViewController.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import UIKit
import RxSwift
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTap()
    }
    
    func hideKeyboardWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.didTapAnywhereOnBase))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func didTapAnywhereOnBase() {
        self.view.endEditing(true)
    }
    
}
