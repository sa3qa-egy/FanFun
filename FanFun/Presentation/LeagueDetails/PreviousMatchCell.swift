//
//  PreviousMatchCell.swift
//  FanFun
//

import UIKit
import SDWebImage

class PreviousMatchCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PreviousMatchCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        homeTeamImageView.layer.cornerRadius = homeTeamImageView.frame.height / 2
        awayTeamImageView.layer.cornerRadius = awayTeamImageView.frame.height / 2
    }
    
    func configure(with fixture: Fixture) {
        homeTeamNameLabel.text = fixture.eventHomeTeam
        awayTeamNameLabel.text = fixture.eventAwayTeam
        
        dateLabel.text = fixture.eventDate
        timeLabel.text = fixture.eventTime
        
        let result = fixture.eventFinalResult ?? "-"
        resultLabel.text = result.isEmpty ? "-" : result
        
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
