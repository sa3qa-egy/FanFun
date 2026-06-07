//
//  TeamDetailsPresenter.swift
//  FanFun
//

import Foundation

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {

    weak var view: TeamDetailsViewProtocol?
    private let repository: SportsRepositoryProtocol
    private let detailsType: TeamDetailsType

    private var teamDetail: TeamDetail?
    private var tennisPlayer: TennisPlayerDetail?

    private enum TennisSection: Int, CaseIterable {
        case stats       = 0
        case tournaments = 1

        var title: String {
            switch self {
            case .stats:       return "Season Stats"
            case .tournaments: return "Tournaments"
            }
        }
    }

    init(repository: SportsRepositoryProtocol = SportsRepositoryImpl(),
         detailsType: TeamDetailsType) {
        self.repository   = repository
        self.detailsType  = detailsType
    }


    var headerImageURL: String? {
        switch detailsType {
        case .team:
            return teamDetail?.teamLogo
        case .tennisPlayer:
            return tennisPlayer?.playerLogo
        }
    }

    var headerName: String {
        switch detailsType {
        case .team:
            return teamDetail?.teamName ?? ""
        case .tennisPlayer:
            return tennisPlayer?.playerName ?? ""
        }
    }

    var numberOfSections: Int {
        switch detailsType {
        case .team:
            return 1
        case .tennisPlayer:
            return TennisSection.allCases.count
        }
    }

    func sectionTitle(for section: Int) -> String {
        switch detailsType {
        case .team:
            return "Players"
        case .tennisPlayer:
            return TennisSection(rawValue: section)?.title ?? ""
        }
    }

    func numberOfRows(in section: Int) -> Int {
        switch detailsType {
        case .team:
            return teamDetail?.players.count ?? 0
        case .tennisPlayer:
            guard let tennisSection = TennisSection(rawValue: section) else { return 0 }
            switch tennisSection {
            case .stats:       return tennisPlayer?.stats.count ?? 0
            case .tournaments: return tennisPlayer?.tournaments.count ?? 0
            }
        }
    }

    func isEmptySection(_ section: Int) -> Bool {
        return numberOfRows(in: section) == 0
    }

    func rowViewModel(at indexPath: IndexPath) -> TeamDetailsRowViewModel {
        switch detailsType {
        case .team:
            let player = teamDetail!.players[indexPath.row]
            return .player(
                name:     player.playerName,
                number:   nilIfEmpty(player.playerNumber),
                position: nilIfEmpty(player.playerType),
                imageURL: nilIfEmpty(player.playerImage)
            )

        case .tennisPlayer:
            guard let tennisSection = TennisSection(rawValue: indexPath.section) else {
                fatalError("Unknown section index \(indexPath.section)")
            }
            switch tennisSection {
            case .stats:
                let stat = tennisPlayer!.stats[indexPath.row]
                return .stat(
                    season:      stat.season ?? "-",
                    type:        stat.type ?? "-",
                    rank:        stat.rank ?? "-",
                    titles:      stat.titles ?? "0",
                    matchesWon:  stat.matchesWon ?? "0",
                    matchesLost: stat.matchesLost ?? "0"
                )
            case .tournaments:
                let t = tennisPlayer!.tournaments[indexPath.row]
                return .tournament(
                    name:    t.name ?? "-",
                    season:  t.season ?? "-",
                    surface: t.surface ?? "-",
                    prize:   t.prize ?? "-"
                )
            }
        }
    }

    func viewDidLoad() {
        view?.showLoading()
        switch detailsType {
        case .team(let id):
            fetchTeamDetails(teamId: id)
        case .tennisPlayer(let id):
            fetchTennisPlayerDetails(playerId: id)
        }
    }


    private func fetchTeamDetails(teamId: Int) {
        repository.getTeamDetails(teamId: teamId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.hideLoading()
                switch result {
                case .success(let detail):
                    self.teamDetail = detail
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    private func fetchTennisPlayerDetails(playerId: Int) {
        repository.getTennisPlayerDetails(playerId: playerId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.hideLoading()
                switch result {
                case .success(let detail):
                    self.tennisPlayer = detail
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    private func nilIfEmpty(_ string: String?) -> String? {
        guard let s = string, !s.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        return s
    }
}
