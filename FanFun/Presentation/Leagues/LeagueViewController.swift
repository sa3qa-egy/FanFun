//
//  LeagueViewController.swift
//  FanFun
//
//  Created by yassen on 30/05/2026.
//

import UIKit

class LeagueViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: LeaguePresenterProtocol!
        
        private let activityIndicator = UIActivityIndicatorView(style: .large)
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "leagues"
            setupUI()
            presenter.viewDidLoad()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
        
        private func setupUI() {
            
            title = "Leagues"
                
                tableView.dataSource = self
                tableView.delegate = self
                searchBar.delegate = self
            tableView.register(LeagueTableViewCell.self, forCellReuseIdentifier: "LeagueCell")

            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 90
                tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = 90
            
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
            
            tableView.keyboardDismissMode = .onDrag
        }
    }

    extension LeagueViewController: LeagueViewProtocol {
        func showLoading() {
            DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        }
        
        func hideLoading() {
            DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
        }
        
        func reloadTableView() {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        
        func showError(message: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    extension LeagueViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return presenter.numberOfLeagues
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueTableViewCell else {
                fatalError("Could not dequeue LeagueTableViewCell. Check Storyboard identifier.")
            }
            
            let league = presenter.getLeague(at: indexPath.row)
            cell.configure(with: league)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    extension LeagueViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            presenter.filterLeagues(with: searchText)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }

}
