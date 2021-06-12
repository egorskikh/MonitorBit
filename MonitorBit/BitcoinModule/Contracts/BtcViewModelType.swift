//
//  BtcViewVMType.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 28.05.2021.
//

import UIKit

protocol BtcViewModelType {
    
    var networkManager: NetworkDataFetcher { get }
    var coreDataManager: CoreDataStack { get }
    var currentBtc: BTC? { get set}
    
    func saveToCoreDate(usd: UILabel,
                      eur: UILabel,
                      rub: UILabel,
                      date: UILabel)
    
    func deleteFromCoreData(_ historyToRemove: History)
    func fetchFromCoreData()
    func numberOfRowsTableView() -> Int
}
