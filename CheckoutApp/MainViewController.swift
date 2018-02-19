//
//  MainViewController.swift
//  CheckoutApp
//
//  Created by Klaudyna Marciniak on 10/02/2018.
//  Copyright © 2018 Klaudyna Marciniak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!

    fileprivate let columnCount: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0,
                                                 left: 10.0,
                                                 bottom: 10.0,
                                                 right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    /**
     store = Store()
     viewController.dispatch = store.dispatch
     store.registerObserver(viewController.render)
     
    */

}

extension MainViewController: StoreSubscriber {
    func newState(_ state: State) {

    }
}

// MARK: Collection view helper methods
extension MainViewController {
    func setupCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ProductListerCell.nib,
                                forCellWithReuseIdentifier: ProductListerCell.identifier)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return ProductLister.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let item =  ProductLister.items[safe:indexPath.row],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListerCell.identifier,
                                                          for: indexPath) as? ProductListerCell else {
                                                            
                return UICollectionViewCell()
        }
        
        cell.item = item
        return cell
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding = sectionInsets.left * (columnCount + 1)
        let contentWidth = view.frame.width - padding
        let width = contentWidth / columnCount
        
        return CGSize(width: width, height: 1.8 * width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
