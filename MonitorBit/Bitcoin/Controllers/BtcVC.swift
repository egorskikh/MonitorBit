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
    lazy var coreDataStack = CoreDataStack(modelName: "Model")
    private var currentBtc: BTC?
    
    // MARK: - Bar Button Items
    private lazy var saveToCoreDataButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(saveCoreDate))
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
        findOrCreate()
    }
    
    // MARK: - Action
    @objc private func fetchJSONTapped(sender: UIBarButtonItem) {
        fetchJSON()
    }
    
    @objc private func saveCoreDate() {
        
        if bv.updLbl.text == "" { return }
        
        let history = History(context: coreDataStack.managedContext)
        history.date = bv.dateLbl.text
        history.upd = bv.updLbl.text
        history.eur = bv.eurLbl.text
        history.rub = bv.rubLbl.text
        
        currentBtc?.addToHistory(history)
        coreDataStack.saveContext()
        
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
        return currentBtc?.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BtcCell.reuseID, for: indexPath) as? BtcCell,
            let btcHistory = currentBtc?.history?[indexPath.row] as? History
        else {
            return UITableViewCell()
        }
        cell.configuratinCell(btcHistory)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard
            let historyToRemove = currentBtc?.history?[indexPath.row] as? History
        else {
            return
        }
        coreDataStack.managedContext.delete(historyToRemove)
        coreDataStack.saveContext()
        bv.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}


// MARK: -  Core Data Stack
extension BtcVC {
    
    private func findOrCreate() {
        
        let user = "user"
        
        let btcFetch: NSFetchRequest<BTC> = BTC.fetchRequest()
        
        btcFetch.predicate = NSPredicate(format: "%K == %@",
                                         #keyPath(BTC.user),
                                         user)
        // pattern "Find or Create"
        do {
            let results = try coreDataStack.managedContext.fetch(btcFetch)
            
            if results.isEmpty {
                currentBtc = BTC(context: coreDataStack.managedContext)
                currentBtc?.user = user
                coreDataStack.saveContext()
            } else {
                currentBtc = results.first
            }
        } catch let error as NSError {
            print("Fetch CORE DATA error: \(error), \(error.userInfo)")
          }
        
    }
    
}

