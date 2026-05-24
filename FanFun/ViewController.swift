//
//  ViewController.swift
//  FanFun
//
//  Created by yassen on 21/05/2026.
//

import UIKit

class ViewController: UIViewController, LeaguesViewProtocol {

    private var presenter: LeaguesPresenter!
    private let jsonTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        presenter = LeaguesPresenter(view: self)
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        jsonTextView.translatesAutoresizingMaskIntoConstraints = false
        jsonTextView.isEditable = false
        jsonTextView.font = .systemFont(ofSize: 14)
        view.addSubview(jsonTextView)
        
        NSLayoutConstraint.activate([
            jsonTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            jsonTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            jsonTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            jsonTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    func showLoading() {
        jsonTextView.text = "Loading data from AllSportsAPI..."
    }
    
    func hideLoading() {
        // Stop any loading indicator if any
    }
    
    func displayLeagues(jsonString: String) {
        jsonTextView.text = jsonString
        print("Success: Loaded leagues JSON:\n\(jsonString)")
    }
    
    func showError(message: String) {
        jsonTextView.text = "Error: \(message)"
        print("Error: \(message)")
    }
}
