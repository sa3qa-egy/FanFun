//
//  LeagueTableViewCell.swift
//  FanFun
//
//  Created by yassen on 30/05/2026.
//

import UIKit
import SDWebImage
class LeagueTableViewCell: UITableViewCell {

    
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
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. We are not using Storyboards for this cell anymore.")
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
            
            nameLabel.leadingAnchor.constraint(equalTo: leagueImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        let heightConstraint = leagueImageView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.priority = .init(999)
        heightConstraint.isActive = true
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
}
