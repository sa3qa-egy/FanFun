import UIKit

extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    
    func showLoading() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    func reloadUpcomingMatches() {
        DispatchQueue.main.async {
            self.upcomingCollectionView.reloadData()
            self.upcomingEmptyView.isHidden = self.presenter.numberOfUpcomingMatches > 0
        }
    }
    
    func reloadPreviousMatches() {
        DispatchQueue.main.async {
            self.previousCollectionView.reloadData()
            self.previousEmptyView.isHidden = self.presenter.numberOfPreviousMatches > 0
            self.updatePreviousCollectionHeight()
        }
    }
    
    func reloadTeams() {
        DispatchQueue.main.async {
            self.teamsCollectionView.reloadData()
            self.teamsEmptyView.isHidden = self.presenter.numberOfTeams > 0
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showOfflineBanner() {
        DispatchQueue.main.async {
            self.offlineBannerView.isHidden = false
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut) {
                self.offlineBannerView.alpha = 1
            }
        }
    }
    
    func hideOfflineBanner() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.offlineBannerView.alpha = 0
            }, completion: { _ in
                self.offlineBannerView.isHidden = true
            })
        }
    }
    
    func updateFavoriteIcon(isFavorite: Bool) {
        DispatchQueue.main.async {
            let iconName = isFavorite ? "star.fill" : "star"
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: iconName)
        }
    }
}
