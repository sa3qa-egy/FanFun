//
//  LeagueDetailsViewController.swift
//  FanFun
//

import UIKit

class LeagueDetailsViewController: UIViewController {
    
    private let presenter: LeagueDetailsPresenterProtocol
    private let leagueName: String
    private let sportType: String
    private let leagueId: Int
    
    init?(coder: NSCoder, presenter: LeagueDetailsPresenterProtocol, leagueName: String, sportType: String, leagueId: Int) {
        self.presenter = presenter
        self.leagueName = leagueName
        self.sportType = sportType
        self.leagueId = leagueId
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(coder:presenter:leagueName:sportType:leagueId:) to instantiate LeagueDetailsViewController")
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingEmptyLabel: UILabel!
    @IBOutlet weak var previousCollectionView: UICollectionView!
    @IBOutlet weak var previousEmptyLabel: UILabel!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    @IBOutlet weak var teamsEmptyLabel: UILabel!
    
    /// Dynamic height constraint for the previous matches collection view
    private var previousCollectionHeightConstraint: NSLayoutConstraint?
    
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

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = leagueName
        setupNavigationBar()
        setupCollectionViews()
        setupOfflineBanner()
        presenter.viewDidLoad(sportType: sportType, leagueId: leagueId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.08, green: 0.09, blue: 0.12, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupCollectionViews() {
        // Register NIBs for all collection views
        upcomingCollectionView.register(UINib(nibName: "UpcomingMatchCell", bundle: nil), forCellWithReuseIdentifier: UpcomingMatchCell.reuseIdentifier)
        previousCollectionView.register(UINib(nibName: "PreviousMatchCell", bundle: nil), forCellWithReuseIdentifier: PreviousMatchCell.reuseIdentifier)
        teamsCollectionView.register(UINib(nibName: "TeamCell", bundle: nil), forCellWithReuseIdentifier: TeamCell.reuseIdentifier)
        
        // Set up the dynamic height constraint for previous matches
        for constraint in previousCollectionView.constraints {
            if constraint.firstAttribute == .height {
                previousCollectionHeightConstraint = constraint
                break
            }
        }
        // If no height constraint from storyboard, create one
        if previousCollectionHeightConstraint == nil {
            previousCollectionHeightConstraint = previousCollectionView.heightAnchor.constraint(equalToConstant: 100)
            previousCollectionHeightConstraint?.isActive = true
        }
    }
    
    private func setupOfflineBanner() {
        offlineBannerView.addSubview(offlineBannerLabel)
        view.addSubview(offlineBannerView)
        
        NSLayoutConstraint.activate([
            offlineBannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            offlineBannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineBannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offlineBannerView.heightAnchor.constraint(equalToConstant: 36),
            
            offlineBannerLabel.centerXAnchor.constraint(equalTo: offlineBannerView.centerXAnchor),
            offlineBannerLabel.centerYAnchor.constraint(equalTo: offlineBannerView.centerYAnchor)
        ])
    }
    
    private func updatePreviousCollectionHeight() {
        let itemCount = presenter.numberOfPreviousMatches
        let itemHeight: CGFloat = 88 // 80pt cell + 8pt spacing
        let totalHeight = max(CGFloat(itemCount) * itemHeight, 100)
        previousCollectionHeightConstraint?.constant = totalHeight
        view.layoutIfNeeded()
    }
}

// MARK: - LeagueDetailsViewProtocol

extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    
    func showLoading() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    func reloadUpcomingMatches() {
        DispatchQueue.main.async {
            self.upcomingCollectionView.reloadData()
            self.upcomingEmptyLabel.isHidden = self.presenter.numberOfUpcomingMatches > 0
        }
    }
    
    func reloadPreviousMatches() {
        DispatchQueue.main.async {
            self.previousCollectionView.reloadData()
            self.previousEmptyLabel.isHidden = self.presenter.numberOfPreviousMatches > 0
            self.updatePreviousCollectionHeight()
        }
    }
    
    func reloadTeams() {
        DispatchQueue.main.async {
            self.teamsCollectionView.reloadData()
            self.teamsEmptyLabel.isHidden = self.presenter.numberOfTeams > 0
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showOfflineBanner() {
        DispatchQueue.main.async {
            self.offlineBannerView.isHidden = false
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut) {
                self.offlineBannerView.alpha = 1
            }
        }
    }
    
    func hideOfflineBanner() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.offlineBannerView.alpha = 0
            }, completion: { _ in
                self.offlineBannerView.isHidden = true
            })
        }
    }
}

// MARK: - UICollectionView DataSource & DelegateFlowLayout

extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: return presenter.numberOfUpcomingMatches
        case 1: return presenter.numberOfPreviousMatches
        case 2: return presenter.numberOfTeams
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMatchCell.reuseIdentifier, for: indexPath) as? UpcomingMatchCell else {
                fatalError("Could not dequeue UpcomingMatchCell")
            }
            let fixture = presenter.getUpcomingMatch(at: indexPath.item)
            cell.configure(with: fixture)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviousMatchCell.reuseIdentifier, for: indexPath) as? PreviousMatchCell else {
                fatalError("Could not dequeue PreviousMatchCell")
            }
            let fixture = presenter.getPreviousMatch(at: indexPath.item)
            cell.configure(with: fixture)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCell.reuseIdentifier, for: indexPath) as? TeamCell else {
                fatalError("Could not dequeue TeamCell")
            }
            let team = presenter.getTeam(at: indexPath.item)
            cell.configure(with: team)
            return cell
            
        default:
            fatalError("Unknown collection view tag")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            return CGSize(width: 280, height: 180)
        case 1:
            let width = collectionView.bounds.width - 16
            return CGSize(width: width, height: 80)
        case 2:
            return CGSize(width: 100, height: 130)
        default:
            return CGSize(width: 100, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Only the teams collection view (tag == 2) is tappable
        guard collectionView.tag == 2 else { return }

        let team = presenter.getTeam(at: indexPath.item)

        if sportType.lowercased() == "tennis" {
            // In tennis leagues the "team" cards are actually players
            AppRouter.shared.navigateToTennisPlayerDetails(
                from: self,
                playerId: team.teamKey,
                playerName: team.teamName
            )
        } else {
            AppRouter.shared.navigateToTeamDetails(
                from: self,
                teamId: team.teamKey,
                teamName: team.teamName
            )
        }
    }
}
