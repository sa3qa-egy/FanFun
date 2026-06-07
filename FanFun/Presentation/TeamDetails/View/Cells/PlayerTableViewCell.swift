//
//  PlayerTableViewCell.swift
//  FanFun
//

import UIKit
import SDWebImage


class PlayerTableViewCell: UITableViewCell {

    static let reuseIdentifier = "PlayerTableViewCell"


    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let playerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        playerImageView.layer.cornerRadius = playerImageView.frame.height / 2
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds, cornerRadius: 12
        ).cgPath
    }

    private func setupHierarchy() {
        contentView.addSubview(containerView)
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)
        containerView.addSubview(playerImageView)
        containerView.addSubview(textStack)
        containerView.addSubview(badgeLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            playerImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            playerImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            playerImageView.widthAnchor.constraint(equalToConstant: 46),
            playerImageView.heightAnchor.constraint(equalToConstant: 46),

            textStack.leadingAnchor.constraint(equalTo: playerImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: badgeLabel.leadingAnchor, constant: -8),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textStack.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 10),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),

            badgeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            badgeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 36),
            badgeLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }


    func configureAsPlayer(name: String,
                           number: String?,
                           position: String?,
                           imageURL: String?) {
        titleLabel.text    = name
        subtitleLabel.text = position ?? "—"
        badgeLabel.text    = number.map { "#\($0)" } ?? "—"
        badgeLabel.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1)
        subtitleLabel.isHidden = false

        setImage(urlString: imageURL)
        playerImageView.isHidden = false
    }

    func configureAsStat(season: String,
                         type: String,
                         rank: String,
                         titles: String,
                         matchesWon: String,
                         matchesLost: String) {
        titleLabel.text    = "\(season)  •  \(type.capitalized)"
        subtitleLabel.text = "Won \(matchesWon)  ·  Lost \(matchesLost)  ·  Titles \(titles)"
        badgeLabel.text    = "Rank \(rank)"
        badgeLabel.backgroundColor = UIColor(red: 0.85, green: 0.5, blue: 0.0, alpha: 1)
        subtitleLabel.isHidden = false

        playerImageView.image = UIImage(systemName: "chart.bar.fill")
        playerImageView.tintColor = UIColor(red: 0.85, green: 0.5, blue: 0.0, alpha: 1)
        playerImageView.isHidden = false
    }

    func configureAsTournament(name: String,
                               season: String,
                               surface: String,
                               prize: String) {
        titleLabel.text    = "\(name)  (\(season))"
        subtitleLabel.text = surface.capitalized
        badgeLabel.text    = prize
        badgeLabel.backgroundColor = UIColor(red: 0.15, green: 0.65, blue: 0.35, alpha: 1)
        subtitleLabel.isHidden = false

        playerImageView.image = UIImage(systemName: "trophy.fill")
        playerImageView.tintColor = UIColor(red: 0.9, green: 0.7, blue: 0.1, alpha: 1)
        playerImageView.isHidden = false
    }


    private func setImage(urlString: String?) {
        let placeholder = UIImage(named: "football")
        if let str = urlString, let url = URL(string: str) {
            playerImageView.sd_imageTransition = .fade(duration: 0.3)
            playerImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            playerImageView.image = placeholder
        }
    }
}
