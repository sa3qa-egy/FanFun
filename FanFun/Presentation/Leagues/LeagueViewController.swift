import UIKit

class LeagueViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: LeaguePresenterProtocol!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let offlineBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.92)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    private let offlineBannerLabel: UILabel = {
        let label = UILabel()
        label.text = "📡  You're offline — showing cached data"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"
        setupUI()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupUI() {
        setupTableView()
        setupActivityIndicator()
        setupOfflineBanner()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(LeagueTableViewCell.self, forCellReuseIdentifier: "LeagueCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupOfflineBanner() {
        offlineBannerView.addSubview(offlineBannerLabel)
        view.addSubview(offlineBannerView)
        
        NSLayoutConstraint.activate([
            offlineBannerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            offlineBannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineBannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offlineBannerView.heightAnchor.constraint(equalToConstant: 36),
            
            offlineBannerLabel.centerXAnchor.constraint(equalTo: offlineBannerView.centerXAnchor),
            offlineBannerLabel.centerYAnchor.constraint(equalTo: offlineBannerView.centerYAnchor)
        ])
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
    
    func showOfflineNotice() {
        DispatchQueue.main.async {
            self.offlineBannerView.isHidden = false
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut) {
                self.offlineBannerView.alpha = 1
            }
        }
    }
    
    func hideOfflineNotice() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.offlineBannerView.alpha = 0
            }, completion: { _ in
                self.offlineBannerView.isHidden = true
            })
        }
    }
    
    func navigateToLeagueDetails(sportType: String, leagueId: Int, leagueName: String) {
        let leagueDetailsVC = AppDIContainer.shared.makeLeagueDetailsViewController(
            sportType: sportType,
            leagueId: leagueId,
            leagueName: leagueName
        )
        leagueDetailsVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(leagueDetailsVC, animated: true)
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
        presenter.didSelectLeague(at: indexPath.row)
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
