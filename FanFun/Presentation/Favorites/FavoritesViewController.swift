import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!

    var presenter: FavoritesPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        setupNavigationBar()
        setupTableView()
        
        if presenter == nil {
            let defaultPresenter = FavoritesPresenter()
            defaultPresenter.view = self
            self.presenter = defaultPresenter
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        presenter.viewWillAppear()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemBlue
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LeagueTableViewCell.self, forCellReuseIdentifier: "FavoriteLeagueCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.keyboardDismissMode = .onDrag
    }
}

extension FavoritesViewController: FavoritesViewProtocol {
    func reloadData() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }

    func showEmptyState() {
        DispatchQueue.main.async {
            self.emptyStateLabel.isHidden = false
            self.tableView.isHidden = true
        }
    }

    func hideEmptyState() {
        DispatchQueue.main.async {
            self.emptyStateLabel.isHidden = true
            self.tableView.isHidden = false
        }
    }

    private func confirmRemoval(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Remove from Favorites", message: "Are you sure you want to remove this league from favorites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in completion() })
        present(alert, animated: true)
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfLeagues(in: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.sectionTitle(for: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        if #available(iOS 14.0, *) {
            var content = header.defaultContentConfiguration()
            content.text = presenter.sectionTitle(for: section)
            content.textProperties.font = .systemFont(ofSize: 18, weight: .bold)
            content.textProperties.color = .label
            header.contentConfiguration = content
        } else {
            header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            header.textLabel?.textColor = .label
            header.textLabel?.numberOfLines = 0
            header.textLabel?.lineBreakMode = .byWordWrapping
            header.textLabel?.sizeToFit()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteLeagueCell", for: indexPath) as? LeagueTableViewCell else {
            fatalError("Could not dequeue FavoriteLeagueCell.")
        }
        let league = presenter.getLeague(at: indexPath)
        cell.configure(with: league)
        cell.configureFavorite(isFavorite: true)
        
        cell.onFavoriteTapped = { [weak self] in
            self?.confirmRemoval {
                self?.presenter.removeFavorite(at: indexPath)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmRemoval { [weak self] in
                self?.presenter.removeFavorite(at: indexPath)
            }
        }
    }
}
