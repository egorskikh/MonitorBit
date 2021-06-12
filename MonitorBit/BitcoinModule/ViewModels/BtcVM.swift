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
    
    func numberOfRowsTableView() -> Int {
        return currentBtc?.history?.count ?? 0
    }
    
    func getArray(_ response: BitcoinResponse) -> [Details] {
        let array = [
            Details(buy: response.USD.buy, symbol: response.USD.symbol),
            Details(buy: response.EUR.buy, symbol: response.EUR.symbol),
            Details(buy: response.RUB.buy, symbol: response.RUB.symbol),
            Details(buy: response.AUD.buy, symbol: response.AUD.symbol),
            Details(buy: response.BRL.buy, symbol: response.BRL.symbol),
            Details(buy: response.CAD.buy, symbol: response.CAD.symbol),
            Details(buy: response.CHF.buy, symbol: response.CHF.symbol),
            Details(buy: response.CLP.buy, symbol: response.CLP.symbol),
            Details(buy: response.CNY.buy, symbol: response.CNY.symbol),
            Details(buy: response.DKK.buy, symbol: response.DKK.symbol),
            Details(buy: response.GBP.buy, symbol: response.GBP.symbol),
            Details(buy: response.HKD.buy, symbol: response.HKD.symbol),
            Details(buy: response.INR.buy, symbol: response.INR.symbol),
            Details(buy: response.ISK.buy, symbol: response.ISK.symbol),
            Details(buy: response.JPY.buy, symbol: response.JPY.symbol),
            Details(buy: response.KRW.buy, symbol: response.KRW.symbol),
            Details(buy: response.NZD.buy, symbol: response.NZD.symbol),
            Details(buy: response.PLN.buy, symbol: response.PLN.symbol),
            Details(buy: response.SEK.buy, symbol: response.SEK.symbol),
            Details(buy: response.SGD.buy, symbol: response.SGD.symbol),
            Details(buy: response.THB.buy, symbol: response.THB.symbol),
            Details(buy: response.TRY.buy, symbol: response.TRY.symbol),
            Details(buy: response.TWD.buy, symbol: response.TWD.symbol)
        ]
        
        return array
    }
    
}
