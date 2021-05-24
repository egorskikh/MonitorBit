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
    let bv = BtcView()
    let networkDataFetcher = NetworkDataFetcher()
    var priceHistoryBtc: [BTC] = []
    
    lazy var formattedDate: String = {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        let formattedDate = formatter.string(from: time as Date)
        return formattedDate
    }()
    
    private lazy var saveToCoreDataButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add,
                                   target: self,
                                   action: #selector(saveInCoreDate))
        }()
    
    // MARK: - View Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupConstraint()
        fetchJSON()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreData()
    }
    
    // MARK: - Action
    @objc private func saveInCoreDate(sender: UIBarButtonItem) {
        
        if bv.updLbl.text == "" { return }
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let btc = BTC(context: managedContext)
        
        btc.upd = bv.updLbl.text
        btc.eur = bv.eurLbl.text
        btc.rub = bv.rubLbl.text
        btc.date = bv.dateLbl.text
        
        do {
            try managedContext.save()
            print("Successfuly SAVED Core Data")
        } catch {
            debugPrint("Could NOTE SAVE Core Data: \(error.localizedDescription)")
        }
        fetchCoreData()
        bv.tableView.reloadData()
    }
    
}

// MARK: - Setup Method
extension BtcVC {
    
    func setupConstraint() {
        view.addSubview(bv.stackView)
        view.addSubview(bv.btcEqual)
        view.addSubview(bv.dateLbl)
        view.addSubview(bv.tableView)
        
        NSLayoutConstraint.activate([
            bv.btcEqual.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36),
            bv.btcEqual.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 49.0),
            bv.btcEqual.widthAnchor.constraint(greaterThanOrEqualToConstant: 59.0),
            bv.btcEqual.heightAnchor.constraint(greaterThanOrEqualToConstant: 20.5),
            
            bv.stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bv.stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            bv.stackView.leadingAnchor.constraint(equalTo: bv.btcEqual.trailingAnchor),
            bv.stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0),
            
            bv.dateLbl.widthAnchor.constraint(greaterThanOrEqualToConstant: 74.0),
            bv.dateLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 21.0),
            bv.dateLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            bv.dateLbl.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 230),
            
            bv.tableView.topAnchor.constraint(equalTo: bv.dateLbl.bottomAnchor),
            bv.tableView.topAnchor.constraint(equalTo: bv.stackView.bottomAnchor, constant: 28.5),
            bv.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bv.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bv.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        bv.tableView.delegate = self
        bv.tableView.dataSource = self
        title = "1 BTC"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [ saveToCoreDataButtonItem ]
    }
    
    private func fetchJSON() {
        
        networkDataFetcher.fetchExchangeRate { [self] (exchangeRate) in
            guard let exchangeRate = exchangeRate else { return }
            bv.eurLbl.text = String(exchangeRate.EUR.buy) + " " + String(exchangeRate.EUR.symbol)
            bv.updLbl.text = String(exchangeRate.USD.buy) + " " + String(exchangeRate.USD.symbol)
            bv.rubLbl.text = String(exchangeRate.RUB.buy) + " " + String(exchangeRate.RUB.symbol)
            bv.btcEqual.text = "1 BTC ="
            bv.dateLbl.text = self.formattedDate
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BtcVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
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
