import UIKit
import SDWebImage

class LeagueTableViewCell: UITableViewCell {

    var onFavoriteTapped: (() -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ff_surfuce")
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let leagueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "ff_primary_text")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = UIColor(red: 0.28, green: 0.73, blue: 0.19, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
        backgroundColor = .clear
        selectionStyle = .none
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leagueImageView.layer.cornerRadius = leagueImageView.frame.height / 2
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 12).cgPath
    }

    private func setupHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(leagueImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(favoriteButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            leagueImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            leagueImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            leagueImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            leagueImageView.widthAnchor.constraint(equalToConstant: 50),

            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            favoriteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 34),
            favoriteButton.heightAnchor.constraint(equalToConstant: 34),

            nameLabel.leadingAnchor.constraint(equalTo: leagueImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        let heightConstraint = leagueImageView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.priority = .init(999)
        heightConstraint.isActive = true
    }

    @objc private func favoriteTapped() {
        onFavoriteTapped?()
    }

    func configure(with league: League) {
        nameLabel.text = league.leagueName
        let placeholder = UIImage(named: "leauge_placeholder")
        if let logoString = league.leagueLogo, let url = URL(string: logoString) {
            leagueImageView.sd_imageTransition = .fade(duration: 0.3)
            leagueImageView.sd_setImage(with: url, placeholderImage: placeholder, options: [])
        } else {
            leagueImageView.image = placeholder
        }
    }

    func configureFavorite(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
