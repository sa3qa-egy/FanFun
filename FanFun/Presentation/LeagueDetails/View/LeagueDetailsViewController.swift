//
//  LeagueDetailsViewController.swift
//  FanFun
//

import UIKit

class LeagueDetailsViewController: UIViewController {
    
    let presenter: LeagueDetailsPresenterProtocol
    private let leagueName: String
    let sportType: String
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
    
    // MARK: - Programmatic empty-state views
    
    lazy var upcomingEmptyView = makeEmptyView(
        icon: "calendar.badge.exclamationmark",
        title: "No Upcoming Matches",
        subtitle: "Check back later for scheduled fixtures"
    )
    lazy var previousEmptyView = makeEmptyView(
        icon: "clock.arrow.circlepath",
        title: "No Recent Results",
        subtitle: "Match results will appear here"
    )
    lazy var teamsEmptyView = makeEmptyView(
        icon: "person.3.slash",
        title: "No Teams Found",
        subtitle: "Teams for this league are unavailable"
    )
    
    private var previousCollectionHeightConstraint: NSLayoutConstraint?
    
    let offlineBannerView: UIView = {
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
        setupEmptyViews()
        presenter.viewDidLoad(sportType: sportType, leagueId: leagueId, leagueName: leagueName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        view.backgroundColor = UIColor(named: "ff_background")
        activityIndicator.color = UIColor(named: "ff_primary")
        
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc private func favoriteButtonTapped() {
        presenter.toggleFavorite()
    }
    
    
    private func makeEmptyView(icon: String, title: String, subtitle: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(named: "ff_surfuce")
        container.layer.cornerRadius = 16
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.08
        container.layer.shadowOffset = CGSize(width: 0, height: 3)
        container.layer.shadowRadius = 6
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isHidden = true

        let iconConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
        let iconView = UIImageView(image: UIImage(systemName: icon, withConfiguration: iconConfig))
        iconView.tintColor = UIColor(named: "ff_primary")?.withAlphaComponent(0.65)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = UIColor(named: "ff_primary_text")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = UIColor(named: "ff_primary_text")?.withAlphaComponent(0.5)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -16),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            container.heightAnchor.constraint(equalToConstant: 110)
        ])
        return container
    }
    
    private func setupEmptyViews() {
        upcomingEmptyLabel.isHidden = true
        previousEmptyLabel.isHidden = true
        teamsEmptyLabel.isHidden = true
        
        let pairs: [(UIView, UIView)] = [
            (upcomingEmptyView, upcomingCollectionView),
            (previousEmptyView, previousCollectionView),
            (teamsEmptyView,    teamsCollectionView)
        ]
        for (emptyView, collectionView) in pairs {
            guard let superview = collectionView.superview else { continue }
            superview.addSubview(emptyView)
            NSLayoutConstraint.activate([
                emptyView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 16),
                emptyView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -16),
                emptyView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
            ])
        }
    }
    
    private func setupCollectionViews() {
        upcomingCollectionView.register(UINib(nibName: "UpcomingMatchCell", bundle: nil), forCellWithReuseIdentifier: UpcomingMatchCell.reuseIdentifier)
        previousCollectionView.register(UINib(nibName: "PreviousMatchCell", bundle: nil), forCellWithReuseIdentifier: PreviousMatchCell.reuseIdentifier)
        teamsCollectionView.register(UINib(nibName: "TeamCell", bundle: nil), forCellWithReuseIdentifier: TeamCell.reuseIdentifier)
        
        for constraint in previousCollectionView.constraints {
            if constraint.firstAttribute == .height {
                previousCollectionHeightConstraint = constraint
                break
            }
        }
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
    
    func updatePreviousCollectionHeight() {
        let itemCount = presenter.numberOfPreviousMatches
        let itemHeight: CGFloat = 88
        let totalHeight = max(CGFloat(itemCount) * itemHeight, 100)
        previousCollectionHeightConstraint?.constant = totalHeight
        view.layoutIfNeeded()
    }
}
