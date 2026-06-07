//
//  TeamDetailsViewController.swift
//  FanFun
//

import UIKit
import SDWebImage

class TeamDetailsViewController: UIViewController {


    private let presenter: TeamDetailsPresenterProtocol

    init?(coder: NSCoder, presenter: TeamDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(coder:presenter:) to instantiate TeamDetailsViewController")
    }


    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var tabelView: UITableView!


    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        styleHeaderElements()
        setupActivityIndicator()
        setupTableView()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        teamImage.layer.cornerRadius = teamImage.frame.height / 2
        teamImage.clipsToBounds = true
    }


    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "ff_background")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ff_primary_text") ?? .label]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(named: "ff_primary")
    }

    private func styleHeaderElements() {
        view.backgroundColor = UIColor(named: "ff_background")
        teamImage.contentMode = .scaleAspectFill
        teamImage.backgroundColor = UIColor(named: "ff_surfuce")
        teamImage.layer.borderColor = UIColor(named: "ff_primary")?.withAlphaComponent(0.3).cgColor
        teamImage.layer.borderWidth = 2

        teamName.font = .systemFont(ofSize: 22, weight: .bold)
        teamName.textColor = UIColor(named: "ff_primary_text")
        teamName.textAlignment = .center
        teamName.numberOfLines = 2
        teamName.text = ""

        tabelView.backgroundColor = UIColor(named: "ff_background")
        tabelView.separatorStyle = .none
        tabelView.rowHeight = UITableView.automaticDimension
        tabelView.estimatedRowHeight = 74
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        tabelView.register(PlayerTableViewCell.self,
                           forCellReuseIdentifier: PlayerTableViewCell.reuseIdentifier)
        tabelView.register(EmptyStateTableViewCell.self,
                           forCellReuseIdentifier: EmptyStateTableViewCell.reuseIdentifier)
        tabelView.delegate   = self
        tabelView.dataSource = self
    }
}


extension TeamDetailsViewController: TeamDetailsViewProtocol {

    func showLoading() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }

    func hideLoading() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.title = self.presenter.headerName
            self.teamName.text = self.presenter.headerName

            if let urlString = self.presenter.headerImageURL, let url = URL(string: urlString) {
                self.teamImage.sd_imageTransition = .fade(duration: 0.3)
                self.teamImage.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(systemName: "person.crop.circle.fill")
                )
            } else {
                self.teamImage.image = UIImage(systemName: "person.crop.circle.fill")
                self.teamImage.tintColor = UIColor(named: "ff_primary")?.withAlphaComponent(0.4)
            }

            self.tabelView.reloadData()
        }
    }

    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}


extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.isEmptySection(section) ? 1 : presenter.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.sectionTitle(for: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        header.textLabel?.textColor = UIColor(named: "ff_primary")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.isEmptySection(indexPath.section) {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: EmptyStateTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? EmptyStateTableViewCell else {
                fatalError("Could not dequeue EmptyStateTableViewCell")
            }
            let message = emptyMessage(for: indexPath.section)
            cell.configure(message: message)
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlayerTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? PlayerTableViewCell else {
            fatalError("Could not dequeue PlayerTableViewCell")
        }

        switch presenter.rowViewModel(at: indexPath) {
        case .player(let name, let number, let position, let imageURL):
            cell.configureAsPlayer(name: name, number: number, position: position, imageURL: imageURL)

        case .stat(let season, let type, let rank, let titles, let won, let lost):
            cell.configureAsStat(season: season, type: type, rank: rank,
                                 titles: titles, matchesWon: won, matchesLost: lost)

        case .tournament(let name, let season, let surface, let prize):
            cell.configureAsTournament(name: name, season: season, surface: surface, prize: prize)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


    private func emptyMessage(for section: Int) -> String {
        let title = presenter.sectionTitle(for: section)
        switch title {
        case "Players":     return "No players available for this team."
        case "Season Stats": return "No season stats available for this player."
        case "Tournaments": return "No tournament data available for this player."
        default:            return "No data available."
        }
    }
}
