import UIKit

extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: return presenter.numberOfUpcomingMatches
        case 1: return presenter.numberOfPreviousMatches
        case 2: return presenter.numberOfTeams
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMatchCell.reuseIdentifier, for: indexPath) as? UpcomingMatchCell else {
                fatalError("Could not dequeue UpcomingMatchCell")
            }
            let fixture = presenter.getUpcomingMatch(at: indexPath.item)
            cell.configure(with: fixture)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviousMatchCell.reuseIdentifier, for: indexPath) as? PreviousMatchCell else {
                fatalError("Could not dequeue PreviousMatchCell")
            }
            let fixture = presenter.getPreviousMatch(at: indexPath.item)
            cell.configure(with: fixture)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCell.reuseIdentifier, for: indexPath) as? TeamCell else {
                fatalError("Could not dequeue TeamCell")
            }
            let team = presenter.getTeam(at: indexPath.item)
            cell.configure(with: team)
            return cell
            
        default:
            fatalError("Unknown collection view tag")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            return CGSize(width: 280, height: 180)
        case 1:
            let width = collectionView.bounds.width - 16
            return CGSize(width: width, height: 80)
        case 2:
            return CGSize(width: 100, height: 130)
        default:
            return CGSize(width: 100, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.tag == 2 else { return }

        if !NetworkMonitor.shared.isConnected {
            showError(message: "No internet connection. Cannot navigate to details.")
            return
        }

        let team = presenter.getTeam(at: indexPath.item)

        if sportType.lowercased() == "tennis" {
            AppRouter.shared.navigateToTennisPlayerDetails(
                from: self,
                playerId: team.teamKey,
                playerName: team.teamName
            )
        } else {
            AppRouter.shared.navigateToTeamDetails(
                from: self,
                teamId: team.teamKey,
                teamName: team.teamName
            )
        }
    }
}
