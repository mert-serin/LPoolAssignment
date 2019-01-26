//
//  CustomSectionModel.swift
//  LibertypoolAssignment
//
//  Created by Mert Serin on 26.01.2019.
//  Copyright © 2019 Mert Serin. All rights reserved.
//

import RxDataSources

struct CustomSectionModel{
    var items:[Item]
    var header:String
    
}
extension CustomSectionModel: SectionModelType {
    typealias Item = TransactionModel
    
    init(original: CustomSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
