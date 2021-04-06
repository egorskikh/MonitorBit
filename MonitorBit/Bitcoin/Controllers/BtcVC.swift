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
        formatter.dateFormat = "MM/dd/YY"
        let formattedDate = formatter.string(from: time as Date)
        return formattedDate
    }()
    
    let networkDataFetcher = NetworkDataFetcher()
    
    
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
        
        fetchDataBTC()
        setupTableView()
    }
    
    // MARK: - Action
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        // CoreDataStack
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let btc = BTC(context: managedContext)
        
        btc.upd = updLabel.text
        btc.eur = eurLabel.text
        btc.rub = rubLabel.text
        btc.date = dateLabel.text
        
        do {
            try managedContext.save()
            print("ееее")
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            print("неееет...")
        }
        
        tableView.reloadData()
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
    
    private func fetchDataBTC() {
        
        networkDataFetcher.fetchСourse { (fetchСourse) in
            guard let course = fetchСourse else { return }
            self.eurLabel.text = String(course.EUR.buy) + " " + String(course.EUR.symbol)
            self.updLabel.text = String(course.USD.buy) + " " + String(course.USD.symbol)
            self.rubLabel.text = String(course.RUB.buy) + " " + String(course.RUB.symbol)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BtcCell.reuseID, for: indexPath) as? BtcCell
        else {
            return UITableViewCell()
        }
        cell.configuratinCell(upd: updLabel.text ?? " ",
                              eur: eurLabel.text ?? " ",
                              rub: rubLabel.text ?? " ",
                              date: dateLabel.text ?? " ")
        return cell
    }
    
}
