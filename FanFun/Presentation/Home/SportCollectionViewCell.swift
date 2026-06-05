//
//  SportCellCollectionViewCell.swift
//  FanFun
//
//  Created by yassen on 25/05/2026.
//

import UIKit

class SportCellCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sportName: UILabel!
    @IBOutlet weak var SportImage: UIImageView!

    private var cardView: UIView? { containerView.subviews.first }

    private let accentBorderLayer = CALayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        containerView.clipsToBounds = false

        guard let card = cardView else { return }

        card.backgroundColor = UIColor(named: "ff_surfuce")
        card.layer.cornerRadius = 16
        card.clipsToBounds = false
        card.layer.shadowColor   = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.28
        card.layer.shadowRadius  = 10
        card.layer.shadowOffset  = CGSize(width: 0, height: 4)

        let primary = UIColor(named: "ff_primary")
            ?? UIColor(red: 0.286, green: 0.725, blue: 0.192, alpha: 1)
        accentBorderLayer.borderColor  = primary.withAlphaComponent(0.30).cgColor
        accentBorderLayer.borderWidth  = 1
        accentBorderLayer.cornerRadius = 16
        card.layer.addSublayer(accentBorderLayer)

        sportName.textColor = UIColor(named: "ff_primary_text")
        sportName.font      = UIFont.systemFont(ofSize: 15, weight: .semibold)

        SportImage.contentMode = .scaleAspectFit
        if let imgSuperview = SportImage.superview {
            imgSuperview.bringSubviewToFront(SportImage)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let card = cardView else { return }
        accentBorderLayer.frame = card.bounds

        card.layer.shadowPath = UIBezierPath(
            roundedRect: card.bounds, cornerRadius: 16
        ).cgPath
    }


    func configure(with sport: Sport) {
        sportName.text   = sport.name
        SportImage.image = sport.image
    }
}
