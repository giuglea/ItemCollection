//
//  ItemCollection+CollectionView.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 8/16/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

extension ItemCollection: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionCell.cellId,
                                                            for: indexPath) as? ItemCollectionCell else { return UICollectionViewCell() }
        let width = getSizeRecommendedForTag(text: models[indexPath.item].text).width
        let maxWidth = self.frame.width - 2 * sectionInsets.left
        var shouldScroll = false
        if width >= maxWidth {
           shouldScroll = true
        }
        cell.configure(model: models[indexPath.row], cellDesign: itemCellDesign, shouldScroll: shouldScroll)
        cell.gotSelected { [weak self] in
            guard let _weakSelf = self else { return }
            _weakSelf.models[indexPath.row].wasSelected = cell.wasSelected
        }
        cell.delegate = self
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == tempoIndex && collectionState == .compressed {
            if indexPath.row == 0 {
                let width = self.frame.width - (2 * sectionInsets.left + plusLabel.frame.width)
                return CGSize(width: width, height: itemCellDesign.cellHeight)
            }
            let width = self.frame.width - 2 * sectionInsets.left
            return CGSize(width: width, height: itemCellDesign.cellHeight)
        }
        if indexPath.row == 1 && tempoIndex == 0 && collectionState == .compressed {
            let width = self.frame.width - 2 * sectionInsets.left
            return CGSize(width: width, height: itemCellDesign.cellHeight)
        }
        let width = getSizeRecommendedForTag(text: models[indexPath.item].text).width
        return CGSize(width: width, height: itemCellDesign.cellHeight)
    }
}

extension ItemCollection: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
}

extension ItemCollection: ItemCollectionCellDelegate {
    func tapAction() {
        for action in self.tapCellActions {
            switch action {
            case .decompress:
                self.decompress()
            case .delete:
                break
            case .showKeyboard:
                self.textField.becomeFirstResponder()
            }
        }
    }
    
    
}
