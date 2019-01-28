//
//  TransactionListCell.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 26.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import UIKit

class TransactionListCell: UITableViewCell {

    
    @IBOutlet weak var transactionWalletLabel: UILabel!{
        didSet{
            print(1)
        }
    }
    @IBOutlet weak var transactionAmountLabel: UILabel!{
        didSet{
            print(2)
        }
    }
    @IBOutlet weak var transactionDateLabel: UILabel!{
        didSet{
            print(3)
        }
    }
    @IBOutlet weak var transactionTypeView: UIView!{
        didSet{
            print(4)
        }
    }
    var viewModel:TransactionModel!{
        didSet{
            let wallet = (UIApplication.shared.delegate as! AppDelegate).wallet.value
            if viewModel.direction{
                transactionTypeView.backgroundColor = UIColor.green
                transactionWalletLabel.text = "to \(wallet.walletName)"
                transactionAmountLabel.text = "+ \(Double(viewModel.value)! / 10E+17) ETH"
            }else{
                transactionTypeView.backgroundColor = UIColor.red
                transactionWalletLabel.text = "from \(wallet.walletName)"
                transactionAmountLabel.text = "- \(Double(viewModel.value)! / 10E+17) ETH"
            }
            transactionDateLabel.text = viewModel.date!.formatToDate(dateFormat: "MMM DD")
        }
    }
    

    override func prepareForReuse() {
        transactionTypeView.backgroundColor = UIColor.green
        transactionDateLabel.text = ""
        transactionWalletLabel.text = ""
        transactionAmountLabel.text = ""
    }

}
