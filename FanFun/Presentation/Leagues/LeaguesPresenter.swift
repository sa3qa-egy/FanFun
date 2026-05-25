import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayLeagues(jsonString: String)
    func showError(message: String)
}

class LeaguesPresenter {
    private weak var view: LeaguesViewProtocol?
    private let repository: LeagueRepositoryProtocol
    
    init(view: LeaguesViewProtocol, repository: LeagueRepositoryProtocol = LeagueRepository()) {
        self.view = view
        self.repository = repository
    }
    
    func viewDidLoad() {
        view?.showLoading()
        repository.getLeagues { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success(let leagues):
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(leagues),
                   let jsonString = String(data: data, encoding: .utf8) {
                    self?.view?.displayLeagues(jsonString: jsonString)
                }
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }
}
