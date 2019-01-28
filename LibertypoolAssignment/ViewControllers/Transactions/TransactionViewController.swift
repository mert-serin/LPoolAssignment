//
//  TransactionViewController.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 24.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Charts

class TransactionViewController: UIViewController {
    
    var wallet:Variable<UserModel>!{
        get{
            return (UIApplication.shared.delegate as! AppDelegate).wallet
        }set{
            
        }
    }
    
    @IBOutlet weak var chartsView: LineChartView!
    @IBOutlet weak var transactionTableView: UITableView!
    //MARK: Dispose bag
    private let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<CustomSectionModel>(
        configureCell: { (temp, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "TransactionListCell") as! TransactionListCell
            cell.backgroundColor = UIColor.getColor(240, 240, 240)
            cell.viewModel = temp[indexPath.section].items[indexPath.row]
            print(element)
            return cell
    },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].header
        }
    )
    
    var isBinded = false
    var sectionModel:BehaviorSubject<[CustomSectionModel]>! = BehaviorSubject.init(value: [CustomSectionModel(items: [], header: "")])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionTableView.register(UINib(nibName: "TransactionListCell", bundle: nil), forCellReuseIdentifier: "TransactionListCell")
        transactionTableView.rowHeight = 140
        transactionTableView.separatorColor = .clear
        
        wallet.asObservable().subscribe(onNext: { (wallet) in
            APIClient.getTransaction(address: wallet.walletAddress).observeOn(MainScheduler.instance).subscribe(onNext: { (model) in
                let model = self.changeModels(items: model.result)
                BehaviorSubject.init(value: model).bind(to: self.sectionModel).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        sectionModel.bind(to: self.transactionTableView.rx.items(dataSource: self.dataSource)).disposed(by: self.disposeBag)
    }

    private func changeModels(items:[TransactionModel]) -> [CustomSectionModel]{
        
        var sectionArray = [CustomSectionModel]()
        var lastAddedItem:TransactionModel?
        var lastAddedArray:[TransactionModel]! = []
        for item in items{
            if lastAddedItem == nil{
                lastAddedArray.append(item)
                lastAddedItem = item
                continue
            }
            if lastAddedItem != nil && lastAddedItem!.date!.isInSameMonth(date: item.date!) && lastAddedItem!.date!.isInSameYear(date: item.date!){
                lastAddedArray.append(item)
            }else{
                sectionArray.append(CustomSectionModel(items: lastAddedArray, header: lastAddedItem!.date!.formatToDate(dateFormat: "MMM yyyy")))
                lastAddedArray = [item]
            }
            
            lastAddedItem = item
        }
        
        return sectionArray
    }
}

extension TransactionViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !dataSource.sectionModels.isEmpty{
            let view:TransactionHeaderCell = TransactionHeaderCell.fromNib()
            view.headerTitleLabel.text = dataSource[section].header
            return view
        }
        return nil
    }
}

extension TransactionViewController:TransactionViewControllerDelegate{
    func refresh() {

    }
}
