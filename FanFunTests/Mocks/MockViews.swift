import Foundation
@testable import FanFun

class MockFavoritesView: FavoritesViewProtocol {
    var reloadDataCallCount = 0
    var showEmptyStateCallCount = 0
    var hideEmptyStateCallCount = 0

    func reloadData() { reloadDataCallCount += 1 }
    func showEmptyState() { showEmptyStateCallCount += 1 }
    func hideEmptyState() { hideEmptyStateCallCount += 1 }
}

class MockHomeView: HomeViewProtocol {
    var reloadCollectionViewCallCount = 0
    func reloadCollectionView() { reloadCollectionViewCallCount += 1 }
}

class MockLeagueView: LeagueViewProtocol {
    var showLoadingCallCount = 0
    var hideLoadingCallCount = 0
    var reloadTableViewCallCount = 0
    var showOfflineNoticeCallCount = 0
    var hideOfflineNoticeCallCount = 0
    var lastErrorMessage: String?
    var lastFavoriteStatusIndex: Int?
    var lastFavoriteStatus: Bool?

    func showLoading() { showLoadingCallCount += 1 }
    func hideLoading() { hideLoadingCallCount += 1 }
    func reloadTableView() { reloadTableViewCallCount += 1 }
    func showError(message: String) { lastErrorMessage = message }
    func showOfflineNotice() { showOfflineNoticeCallCount += 1 }
    func hideOfflineNotice() { hideOfflineNoticeCallCount += 1 }
    func updateFavoriteStatus(at index: Int, isFavorite: Bool) {
        lastFavoriteStatusIndex = index
        lastFavoriteStatus = isFavorite
    }
}

class MockLeagueDetailsView: LeagueDetailsViewProtocol {
    var showLoadingCallCount = 0
    var hideLoadingCallCount = 0
    var reloadUpcomingMatchesCallCount = 0
    var reloadPreviousMatchesCallCount = 0
    var reloadTeamsCallCount = 0
    var showOfflineBannerCallCount = 0
    var hideOfflineBannerCallCount = 0
    var lastErrorMessage: String?

    func showLoading() { showLoadingCallCount += 1 }
    func hideLoading() { hideLoadingCallCount += 1 }
    func reloadUpcomingMatches() { reloadUpcomingMatchesCallCount += 1 }
    func reloadPreviousMatches() { reloadPreviousMatchesCallCount += 1 }
    func reloadTeams() { reloadTeamsCallCount += 1 }
    func showError(message: String) { lastErrorMessage = message }
    func showOfflineBanner() { showOfflineBannerCallCount += 1 }
    func hideOfflineBanner() { hideOfflineBannerCallCount += 1 }
}

class MockTeamDetailsView: TeamDetailsViewProtocol {
    var showLoadingCallCount = 0
    var hideLoadingCallCount = 0
    var reloadDataCallCount = 0
    var lastErrorMessage: String?

    func showLoading() { showLoadingCallCount += 1 }
    func hideLoading() { hideLoadingCallCount += 1 }
    func reloadData() { reloadDataCallCount += 1 }
    func showError(message: String) { lastErrorMessage = message }
}
