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

class TransactionViewController: BaseViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    //Dispose bag

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionTableView.register(UINib(nibName: "TransactionListCell", bundle: nil), forCellReuseIdentifier: "TransactionListCell")
        transactionTableView.rowHeight = 140
        transactionTableView.separatorColor = .clear
        APIClient.getTransaction(address: "0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a").observeOn(MainScheduler.instance).subscribe(onNext: { (model) in
            self.changeModels(items: model.result).bind(to: self.transactionTableView.rx.items(dataSource: self.dataSource))
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        transactionTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }

    private func changeModels(items:[TransactionModel]) -> Observable<[CustomSectionModel]>{
        
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
        
        return Observable.just(sectionArray)
    }
}

extension TransactionViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:TransactionHeaderCell = TransactionHeaderCell.fromNib()
        if !dataSource.sectionModels.isEmpty{
            view.headerTitleLabel.text = dataSource[section].header
        }
        return view
    }
}
