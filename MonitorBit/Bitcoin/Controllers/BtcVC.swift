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
    private let bv = BtcView()
    private let networkDataFetcher = NetworkDataFetcher()
    private var priceHistoryBtc: [BTC] = []
    
    // MARK: - Bar Button Items
    private lazy var saveToCoreDataButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(saveInCoreDate))
        return buttonItem
    }()
    
    private lazy var fetchJSONButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                         target: self,
                                         action: #selector(fetchJSONTapped))
        return buttonItem
    }()
    
    // MARK: - View Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupConstraint()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreData()
    }
    
    // MARK: - Action
    @objc private func fetchJSONTapped(sender: UIBarButtonItem) {
        fetchJSON()
    }
    
    @objc private func saveInCoreDate(sender: UIBarButtonItem) {
        
        if bv.updLbl.text == "" { return }
        
        saveCoreDate()
        fetchCoreData()
        bv.tableView.reloadData()
    }
    
}


extension BtcVC {
    
    // MARK: - Setup Constraint
    private func setupConstraint() {
        view.addSubview(bv.stackView)
        view.addSubview(bv.dateLbl)
        view.addSubview(bv.tableView)
        
        NSLayoutConstraint.activate([      
            bv.stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bv.stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            bv.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bv.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
    
    // MARK: Delegates TableView
    private func setupTableView() {
        bv.tableView.delegate = self
        bv.tableView.dataSource = self
    }
    
    // MARK: Setup NavigationController
    private func setupNavigationController() {
        title = "BTC"
        view.backgroundColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [ saveToCoreDataButtonItem,
                                               fetchJSONButtonItem]
    }
    
    // MARK: - Setup UI via JSON
    private func fetchJSON() {
        
        networkDataFetcher.fetchExchangeRate { [self] (exchangeRate) in
            
            guard let exchangeRate = exchangeRate else { return }
            
            bv.eurLbl.attributedText = NSMutableAttributedString()
                .bold(String(exchangeRate.EUR.buy) + " " + String(exchangeRate.EUR.symbol))
            bv.updLbl.attributedText = NSMutableAttributedString()
                .bold(String(exchangeRate.USD.buy) + " " + String(exchangeRate.USD.symbol))
            bv.rubLbl.attributedText = NSMutableAttributedString()
                .bold(String(exchangeRate.RUB.buy) + " " + String(exchangeRate.RUB.symbol))
            
            // O(1)
            if bv.updLbl.text?.last == "$" {
                title = "1 BTC ="
                bv.dateLbl.isHidden = false
            }
            
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BtcVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "price history"
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
        
        removeCoreData(atIndexPath: indexPath)
        fetchCoreData()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

// MARK: - Core Data
extension BtcVC {
    
    private func saveCoreDate() {
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
    }
    
    private func removeCoreData(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(priceHistoryBtc[indexPath.row])
        
        do {
            try managedContext.save()
            print("Successfule REMOVED from Core Data.")
        } catch {
            debugPrint("Could DONT REMOVE from Core Data: \(error.localizedDescription)")
        }
    }
    
    private func fetchCoreData() {
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

