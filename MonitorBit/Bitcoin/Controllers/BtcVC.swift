//
//  ViewController.swift
//  MonitorBit
//
//  Created by Егор Горских on 25.03.2021.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class BtcVC: UIViewController {
    
    // MARK: - Property
    lazy var formattedDate: String = {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        let formattedDate = formatter.string(from: time as Date)
        return formattedDate
    }()
    
    let networkDataFetcher = NetworkDataFetcher()
    
    var priceHistoryBtc: [BTC] = []
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var updLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btcEqual: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - View Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJSON()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCoreData()
    }
    
    // MARK: - Action
    @IBAction func add(_ sender: UIBarButtonItem) {
        
        if updLabel.text == "" { return }
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let btc = BTC(context: managedContext)
        
        btc.upd = updLabel.text
        btc.eur = eurLabel.text
        btc.rub = rubLabel.text
        btc.date = dateLabel.text
        
        do {
            try managedContext.save()
            print("Successfuly SAVED Core Data")
        } catch {
            debugPrint("Could NOTE SAVE Core Data: \(error.localizedDescription)")
        }
        fetchCoreData()
        self.tableView.reloadData()
    }
    
}

// MARK: - Setup Method
extension BtcVC {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 91
        title = "1 BTC"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchJSON() {
        
        networkDataFetcher.fetchExchangeRate { (exchangeRate) in
            guard let exchangeRate = exchangeRate else { return }
            self.eurLabel.text = String(exchangeRate.EUR.buy) + " " + String(exchangeRate.EUR.symbol)
            self.updLabel.text = String(exchangeRate.USD.buy) + " " + String(exchangeRate.USD.symbol)
            self.rubLabel.text = String(exchangeRate.RUB.buy) + " " + String(exchangeRate.RUB.symbol)
            self.btcEqual.text = "1 BTC ="
            self.dateLabel.text = self.formattedDate
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BtcVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "price history"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceHistoryBtc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BtcCell.reuseID, for: indexPath) as? BtcCell
        else {
            return UITableViewCell()
        }
        cell.configuratinCell(priceHistoryBtc[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        removeBTC(atIndexPath: indexPath)
        fetchCoreData()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

// MARK: - Core Data Fetch
extension BtcVC {
    
    func removeBTC(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(priceHistoryBtc[indexPath.row])
        
        do {
            try managedContext.save()
            print("Successfule REMOVED from Core Data.")
        } catch {
            debugPrint("Could DONT REMOVE from Core Data: \(error.localizedDescription)")
        }
    }
    
    func fetchCoreData() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<BTC>(entityName: "BTC")
        
        do {
            priceHistoryBtc = try managedContext.fetch(fetchRequest)
            print("Successfuly FETCHED Core Data.")
        } catch {
            debugPrint("Could NOT FETCH Core Data: \(error.localizedDescription)")
        }
    }
    
}
