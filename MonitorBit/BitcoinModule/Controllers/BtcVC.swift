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
    
    // TODO
    private var bitcoinResponse = [Details]()
    
    var isCollectionOpen = false
    var visibleConstraint: NSLayoutConstraint?
    
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
        setupUIConstraint()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFromCoreData()
    }
    
    // MARK: - Action
    @objc private func fetchJSONTapped(sender: UIBarButtonItem) {
        
        if !isCollectionOpen {
            visibleConstraint?.isActive = true
            isCollectionOpen = true
        } else {
            visibleConstraint?.isActive = false
            isCollectionOpen = false
            return
        }
        
        viewModel.networkManager.fetchExchangeRate { [self] (exchangeRate) in
            
            guard let exchangeRate = exchangeRate else { return }
            
            bitcoinResponse = viewModel.getArray(exchangeRate)
            btcView.fillCellWithText(exchangeRate)
            btcView.collectionView.reloadData()
            
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
        btcView.collectionView.delegate = self
        btcView.collectionView.dataSource = self
    }
    
    // MARK: Setup NavigationController
    private func setupController() {
        title = "BTC"
        view.backgroundColor = .lightGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [ saveToCoreDataButtonItem,
                                               fetchJSONButtonItem ]
    }
    
    // MARK: - Setup Constraint
    
    private func setupUIConstraint() {
        view.addSubview(btcView.dateLbl)
        view.addSubview(btcView.collectionView)
        view.addSubview(btcView.tableView)
        
        // For animation
        let hiddenConstraint = btcView.collectionView.heightAnchor.constraint(equalToConstant: 0)
        hiddenConstraint.priority = UILayoutPriority.required - 1
        visibleConstraint = btcView.collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 4)
        
        
        NSLayoutConstraint.activate([
            
            btcView.dateLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            btcView.dateLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            btcView.dateLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            btcView.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            btcView.collectionView.topAnchor.constraint(equalTo: btcView.dateLbl.bottomAnchor),
            btcView.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            btcView.collectionView.heightAnchor.constraint(equalToConstant: hiddenConstraint.constant),
            
            btcView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            btcView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            btcView.tableView.topAnchor.constraint(equalTo: btcView.collectionView.bottomAnchor),
            btcView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        return viewModel.numberOfRowsTableView()
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension BtcVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bitcoinResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BtcCollectionViewCell.reuseID,
                                                      for: indexPath) as! BtcCollectionViewCell
        let btc = bitcoinResponse[indexPath.item]
        cell.fillCell(btc)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (btcView.collectionView.frame.width / 2.5),
                      height: (btcView.collectionView.frame.width / 5.0) )
    }
    
}


