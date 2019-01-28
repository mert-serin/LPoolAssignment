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
    
    var wallet:Variable<UserModel>!
    
    @IBOutlet weak var chartView: LineChartView!
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
        
        transactionTableView.rowHeight = 140
        transactionTableView.separatorColor = .clear
        wallet = (UIApplication.shared.delegate as! AppDelegate).wallet
        wallet.asObservable().subscribe(onNext: { (wallet) in
            APIClient.getTransaction(address: wallet.walletAddress).observeOn(MainScheduler.instance).subscribe(onNext: { (model) in
                let model = self.changeModels(items: model.result)
                BehaviorSubject.init(value: model).bind(to: self.sectionModel).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        sectionModel.bind(to: self.transactionTableView.rx.items(dataSource: self.dataSource)).disposed(by: self.disposeBag)
        
        setupChartUI()
    }

    private func changeModels(items:[TransactionModel]) -> [CustomSectionModel]{
        
        var sectionArray = [CustomSectionModel]()
        var balanceArray = [ChartDataEntry]()
        var lastAddedItem:TransactionModel?
        var lastAddedArray:[TransactionModel]! = []
        var monthlyBalance:Double = 0.0
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
        
        let temp = sectionArray.reversed()
        
        for (index,elements) in temp.enumerated(){
            let items = elements.items
            for item in items{
                if item.from != wallet.value.walletAddress{
                    monthlyBalance += Double(item.value)! / 10E+17
                }else{
                    monthlyBalance -= Double(item.value)! / 10E+17
                }
            }
            balanceArray.append(ChartDataEntry(x: Double(index), y: monthlyBalance))
        }
        
        setupChartValues(values: balanceArray)
        
        return sectionArray
    }
    
    private func setupChartUI(){

        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0

        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMinimum = -50
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        
        chartView.rightAxis.enabled = false
        
        chartView.legend.form = .line
    }
    
    private func setupChartValues(values:[ChartDataEntry]){
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        set1.drawIconsEnabled = false
        
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
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
