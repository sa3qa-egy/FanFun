//
//  EmptyStateTableViewCell.swift
//  FanFun
//

import UIKit

class EmptyStateTableViewCell: UITableViewCell {

    static let reuseIdentifier = "EmptyStateTableViewCell"


    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ff_surfuce")
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(named: "ff_primary")?.withAlphaComponent(0.5)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "ff_primary_text")?.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .center
        s.spacing = 8
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
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
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds, cornerRadius: 12
        ).cgPath
    }

    private func setupHierarchy() {
        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(messageLabel)
        containerView.addSubview(stack)
        contentView.addSubview(containerView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),

            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }


    func configure(message: String) {
        messageLabel.text = message

        if message.contains("player") || message.contains("Players") {
            iconImageView.image = UIImage(systemName: "person.2.slash")
        } else if message.contains("stat") || message.contains("Stats") {
            iconImageView.image = UIImage(systemName: "chart.bar.xaxis")
        } else if message.contains("tournament") || message.contains("Tournament") {
            iconImageView.image = UIImage(systemName: "trophy.slash")
        } else {
            iconImageView.image = UIImage(systemName: "tray")
        }
    }
}
