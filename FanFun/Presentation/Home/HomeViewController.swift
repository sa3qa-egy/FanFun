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
            
            presenter = HomePresenter(view: self)
            
            setupCollectionView()
            presenter.viewDidLoad()
        }
        
        private func setupCollectionView() {
            sportCollectionView.dataSource = self
            sportCollectionView.delegate = self
            
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
    }
