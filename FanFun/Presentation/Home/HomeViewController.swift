//
//  ViewController.swift
//  FanFun
//
//  Created by yassen on 21/05/2026.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sportCollectionView:UICollectionView!
        var presenter: HomePresenterProtocol!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Home"
            
            if presenter == nil {
                let defaultPresenter = HomePresenter()
                defaultPresenter.view = self
                self.presenter = defaultPresenter
            }
            
            setupCollectionView()
            setupNavigationBar()
            presenter.viewDidLoad()
        }
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "ff_background")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ff_primary_text") ?? .label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = UIColor(named: "ff_primary")
    }
        
        private func setupCollectionView() {
            sportCollectionView.dataSource = self
            sportCollectionView.delegate = self
            sportCollectionView.backgroundColor = UIColor(named: "ff_background")
            view.backgroundColor = UIColor(named: "ff_background")
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            
            sportCollectionView.collectionViewLayout = layout
        }
    }

    extension HomeViewController: HomeViewProtocol {
        func reloadCollectionView() {
            DispatchQueue.main.async {
                self.sportCollectionView.reloadData()
            }
        }
    }

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfSports
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportCollectionViewCell", for: indexPath) as? SportCellCollectionViewCell else {
            fatalError("Could not dequeue SportCollectionViewCell.")
        }
        
        let sport = presenter.getSport(at: indexPath.row)
        cell.configure(with: sport)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalPadding: CGFloat = 8 + 8 + 8
        let availableWidth = collectionView.bounds.width - totalHorizontalPadding
        let cellWidth = availableWidth / 2
        let cellHeight = cellWidth * 1.2
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectSport(at: indexPath.row)
    }
}
