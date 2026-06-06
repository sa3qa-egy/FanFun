import UIKit

class LeagueViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private let presenter: LeaguePresenterProtocol
    private let sportType: String

    init?(coder: NSCoder, presenter: LeaguePresenterProtocol, sportType: String) {
        self.presenter = presenter
        self.sportType = sportType
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(coder:presenter:sportType:) to instantiate LeagueViewController")
    }

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let offlineBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ff_primary")?.withAlphaComponent(0.92) ?? UIColor.systemOrange.withAlphaComponent(0.92)
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

    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor(named: "ff_primary")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No leagues found"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(named: "ff_primary_text") ?? .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"
        setupUI()
        presenter.viewDidLoad(sportType: sportType)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.reloadData()
        emptyStateView.isHidden = presenter.numberOfLeagues > 0
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "ff_background")
        tableView.backgroundColor = UIColor(named: "ff_background")
        activityIndicator.color = UIColor(named: "ff_primary")
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
        setupOfflineBanner()
        setupEmptyState()
    }

    
    private func setupSearchBar() {
        // Match search bar background to screen background
        searchBar.barTintColor = UIColor(named: "ff_background")
        searchBar.backgroundColor = UIColor(named: "ff_background")
        searchBar.tintColor = UIColor(named: "ff_primary")
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(named: "ff_surfuce")
            textField.textColor = UIColor(named: "ff_primary_text")
            textField.tintColor = UIColor(named: "ff_primary")
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search leagues…",
                attributes: [.foregroundColor: (UIColor(named: "ff_primary_text") ?? UIColor.secondaryLabel).withAlphaComponent(0.5)]
            )
        }
        
        searchBar.backgroundImage = UIImage()
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
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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

    private func setupEmptyState() {
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 60),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
}

extension LeagueViewController: LeagueViewProtocol {

    func showLoading() {
        DispatchQueue.main.async { 
            self.activityIndicator.startAnimating()
            self.emptyStateView.isHidden = true
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }

    func reloadTableView() {
        DispatchQueue.main.async { 
            self.tableView.reloadData()
            self.emptyStateView.isHidden = self.presenter.numberOfLeagues > 0
        }
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

    func updateFavoriteStatus(at index: Int, isFavorite: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as? LeagueTableViewCell {
                cell.configureFavorite(isFavorite: isFavorite)
            }
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
        cell.configureFavorite(isFavorite: presenter.isFavorite(at: indexPath.row))
        cell.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            if self.presenter.isFavorite(at: indexPath.row) {
                let alert = UIAlertController(title: "Remove from Favorites", message: "Are you sure you want to remove this league from favorites?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
                    self.presenter.toggleFavorite(at: indexPath.row)
                })
                self.present(alert, animated: true)
            } else {
                self.presenter.toggleFavorite(at: indexPath.row)
            }
        }
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
