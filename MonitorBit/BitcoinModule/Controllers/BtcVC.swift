//
//  ViewController.swift
//  MonitorBit
//
//  Created by Егор Горских on 25.03.2021.
//

import UIKit
import CoreData

class BtcVC: UIViewController {
    
    // MARK: - Property
    private let btcView = BtcView()
    private var viewModel = BtcVM()
    
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
        setupController()
        setupConstraint()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFromCoreData()
    }
    
    // MARK: - Action
    @objc private func fetchJSONTapped(sender: UIBarButtonItem) {
        
        viewModel.networkManager.fetchExchangeRate { [self] (exchangeRate) in
            
            guard let exchangeRate = exchangeRate else { return }
            
            btcView.fillCellWithText(exchangeRate)
            
            // O(1)
            if btcView.usdLbl.text?.last == "$" {
                title = "1 BTC ="
                btcView.dateLbl.isHidden = false
            }
        }
    }
    
    @objc private func saveCoreDate() {
        if btcView.usdLbl.text == "" { return }
        viewModel.saveToCoreDate(usd: btcView.usdLbl,
                                 eur: btcView.eurLbl,
                                 rub: btcView.rubLbl,
                                 date: btcView.dateLbl)
        btcView.tableView.reloadData()
    }
    
}


// MARK: - Private method

extension BtcVC {
    
    private func setDelegates() {
        btcView.tableView.delegate = self
        btcView.tableView.dataSource = self
    }
    
    // MARK: Setup NavigationController
    private func setupController() {
        title = "BTC"
        view.backgroundColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [ saveToCoreDataButtonItem,
                                               fetchJSONButtonItem ]
    }
    
    // MARK: - Setup Constraint
    private func setupConstraint() {
        view.addSubview(btcView.stackView)
        view.addSubview(btcView.dateLbl)
        view.addSubview(btcView.tableView)
        
        NSLayoutConstraint.activate([      
            btcView.stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btcView.stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            btcView.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            btcView.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            btcView.dateLbl.widthAnchor.constraint(greaterThanOrEqualToConstant: 74.0),
            btcView.dateLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 21.0),
            btcView.dateLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            btcView.dateLbl.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 230),
            
            btcView.tableView.topAnchor.constraint(equalTo: btcView.dateLbl.bottomAnchor),
            btcView.tableView.topAnchor.constraint(equalTo: btcView.stackView.bottomAnchor, constant: 28.5),
            btcView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            btcView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            btcView.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BtcTableViewCell.reuseID,
                                                     for: indexPath) as? BtcTableViewCell,
            let btcHistory = viewModel.currentBtc?.history?[indexPath.row] as? History
        else {
            return UITableViewCell()
        }
        cell.fillCellWithText(btcHistory)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard
            let historyToRemove = viewModel.currentBtc?.history?[indexPath.row] as? History
        else {
            return
        }
        viewModel.deleteFromCoreData(historyToRemove)
        btcView.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}



