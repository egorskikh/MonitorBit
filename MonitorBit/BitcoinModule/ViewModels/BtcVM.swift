//
//  BtcVCVM.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 28.05.2021.
//

import UIKit
import CoreData

class BtcVM: BtcViewModelType {
    
    let networkManager = NetworkDataFetcher()
    let coreDataManager = CoreDataStack(modelName: "Model")
    var currentBtc: BTC?
    
    func saveToCoreDate(usd: UILabel,
                        eur: UILabel,
                        rub: UILabel,
                        date: UILabel) {
        let history = History(context: coreDataManager.managedContext)
        
        history.date = date.text
        history.usd = usd.text
        history.eur = eur.text
        history.rub = rub.text
        currentBtc?.addToHistory(history)
        coreDataManager.saveContext()
    }
    
    func deleteFromCoreData(_ historyToRemove: History) {
        coreDataManager.managedContext.delete(historyToRemove)
        coreDataManager.saveContext()
    }
    
    func fetchFromCoreData() {
        let user = "user"
        let btcFetch: NSFetchRequest<BTC> = BTC.fetchRequest()
        btcFetch.predicate = NSPredicate(format: "%K == %@",
                                         #keyPath(BTC.user),
                                         user)
        do {
            let results = try coreDataManager.managedContext.fetch(btcFetch)
            if results.isEmpty {
                currentBtc = BTC(context: coreDataManager.managedContext)
                currentBtc?.user = user
                coreDataManager.saveContext()
            } else {
                currentBtc = results.first
            }
        } catch let error as NSError {
            print("Fetch CORE DATA error: \(error), \(error.userInfo)")
          }
    }
    
    func numberOfRows() -> Int {
        return currentBtc?.history?.count ?? 0
    }
      
}
