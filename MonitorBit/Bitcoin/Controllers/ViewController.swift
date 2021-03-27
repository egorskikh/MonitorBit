//
//  ViewController.swift
//  MonitorBit
//
//  Created by Егор Горских on 25.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Property
    
    let networkDataFetcher = NetworkDataFetcher()
    let btcCell = BTCCell()
    
    @IBOutlet weak var updLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Action
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        
        tableView.reloadData()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        networkDataFetcher.fetchСourse { (fetchСourse) in
            guard let course = fetchСourse else { return }
            self.eurLabel.text = String(course.EUR.buy) + " " + String(course.EUR.symbol)
            self.updLabel.text = String(course.USD.buy) + " " + String(course.USD.symbol)
            self.rubLabel.text = String(course.RUB.buy) + " " + String(course.RUB.symbol)
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      "price history"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BTCCell.reuseID, for: indexPath) as! BTCCell
        return cell
    }
    
}

// MARK: - Setup Setup Method

extension ViewController {
    
    private func setupTableView() {
        tableView.rowHeight = 91
    }
    
}
