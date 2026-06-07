//
//  UpcomingMatchCell.swift
//  FanFun
//

import UIKit
import SDWebImage

class UpcomingMatchCell: UICollectionViewCell {
    
    static let reuseIdentifier = "UpcomingMatchCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var matchNameLabel: UILabel!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        containerView.backgroundColor = UIColor(named: "ff_surfuce")
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.clipsToBounds = false
        matchNameLabel.textColor = UIColor(named: "ff_primary")
        homeTeamNameLabel.textColor = UIColor(named: "ff_primary_text")
        awayTeamNameLabel.textColor = UIColor(named: "ff_primary_text")
        dateTimeLabel.textColor = UIColor(named: "ff_primary_text")?.withAlphaComponent(0.6)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        homeTeamImageView.layer.cornerRadius = homeTeamImageView.frame.height / 2
        awayTeamImageView.layer.cornerRadius = awayTeamImageView.frame.height / 2
    }
    
    func configure(with fixture: Fixture) {
        let roundText = fixture.leagueRound ?? "Match"
        matchNameLabel.text = roundText.isEmpty ? "Match" : roundText
        
        homeTeamNameLabel.text = fixture.eventHomeTeam
        awayTeamNameLabel.text = fixture.eventAwayTeam
        
        dateTimeLabel.text = "\(fixture.eventDate)\n\(fixture.eventTime)"
        
        let placeholder = UIImage(named: "leauge_placeholder")
        
        if let urlString = fixture.homeTeamLogo, let url = URL(string: urlString) {
            homeTeamImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            homeTeamImageView.image = placeholder
        }
        
        if let urlString = fixture.awayTeamLogo, let url = URL(string: urlString) {
            awayTeamImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            awayTeamImageView.image = placeholder
        }
    }
}
