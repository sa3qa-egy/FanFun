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
    override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
        }
        
        private func setupUI() {
            containerView.layer.cornerRadius = 16
            containerView.clipsToBounds = true
            containerView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            let blurView = UIVisualEffectView(effect: blurEffect)
            
            blurView.frame = containerView.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            containerView.insertSubview(blurView, at: 0)
        }
        
        func configure(with sport: Sport) {
            sportName.text = sport.name
            SportImage.image = sport.image
        }
}
