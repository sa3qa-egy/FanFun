//
//  TeamCell.swift
//  FanFun
//

import UIKit
import SDWebImage

class TeamCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TeamCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        containerView.backgroundColor = UIColor(named: "ff_surfuce")
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.clipsToBounds = false
        teamNameLabel.textColor = UIColor(named: "ff_primary_text")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        teamImageView.layer.cornerRadius = teamImageView.frame.height / 2
    }
    
    func configure(with team: Team) {
        teamNameLabel.text = team.teamName
        
        let placeholder = UIImage(named: "leauge_placeholder")
        
        if let urlString = team.teamLogo, let url = URL(string: urlString) {
            teamImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            teamImageView.image = placeholder
        }
    }
}
