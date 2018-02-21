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
    
    private var shoppingItems: [ShoppingItem] = []
    private let columnCount: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                                 left: 10.0,
                                                 bottom: 10.0,
                                                 right: 10.0)

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Store.shared.subscribe(self)
        Store.shared.propagate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Store.shared.unsubscribe(self)
    }
    
    @objc func AddToBaksetTapped(_ sender: UIButton) {
        let row = sender.tag
        Store.shared.dispatch(action:Action.Increment(index: row))
    }
    
    @objc func RemoveFromBaksetTapped(_ sender: UIButton) {
        let row = sender.tag
        Store.shared.dispatch(action:Action.Decrement(index: row))
    }
}

// MARK: StoreSubscriber
extension MainViewController: StoreSubscriber {
    func newState(_ state: State) {
        shoppingItems = state.basket
        collectionView?.reloadData()
        self.title = state.totalPriceString
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

// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return shoppingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let item =  shoppingItems[safe:indexPath.row],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListerCell.identifier,
                                                          for: indexPath) as? ProductListerCell else {
                                                            
                return UICollectionViewCell()
        }
        
        cell.item = item
        cell.removeFromBasket.tag = indexPath.row
        cell.removeFromBasket.addTarget(self, action: #selector(RemoveFromBaksetTapped(_:)), for: .touchUpInside)
        cell.addToBasket.tag = indexPath.row
        cell.addToBasket.addTarget(self, action: #selector(AddToBaksetTapped(_:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding = sectionInsets.left * (columnCount + 1)
        let contentWidth = view.frame.width - padding
        let width = contentWidth / columnCount
        
        return CGSize(width: width, height: 2 * width)
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
