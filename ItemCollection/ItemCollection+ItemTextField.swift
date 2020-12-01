//
//  ItemCollection+ItemTextField.swift
//  collectie
//
//  Created by Andrei Giuglea on 9/27/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

extension ItemCollection: ItemTextFieldDelegate {
    func textDidChange(_ textField: UITextField) {
        counter = textField.text!.count
        updateViewConstraints()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch insertItemMethod {
        case .space:
            if (string == " " && (delegate?.isValidItem(text: textField.text!) ?? true)) {
                let newModel = ItemCollectionCell.CellModel(text: textField.text!, wasSelected: false)
                models.append(newModel)
                if autoArrangeEnable {
                    arrangeItems(order: order)
                    textField.text = ""
                    counter = -1
                    collectionView?.reloadData()
                    updateViewConstraints()
                    return false
                }
                self.collectionView?.insertItems(at: [IndexPath(row: self.models.count - 1, section: 0)])
                textField.text = ""
                counter = -1
                updateViewConstraints()
                return false
            }
        default:
            break
        }
        if textField.text!.count + string.count < maximumNumberOfCharacters {
            return true
        }
        return false
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch insertItemMethod {
        case .enter:
            if (delegate?.isValidItem(text: textField.text!) ?? true) {
                let newModel = ItemCollectionCell.CellModel(text: textField.text!, wasSelected: false)
                models.append(newModel)
                if autoArrangeEnable {
                    arrangeItems(order: order)
                    textField.text = ""
                    counter = -1
                    collectionView?.reloadData()
                    updateViewConstraints()
                    return false
                }
                self.collectionView?.insertItems(at: [IndexPath(row: self.models.count - 1, section: 0)])
                textField.text = ""
                counter = -1
                updateViewConstraints()
                return false
            }
        default:
            break
        }
        
        return false
    }
    func itemTextFieldDidDelete() {
        if counter == -1 {
            if textField.text!.isEmpty && !models.isEmpty {
                let items = getIndexOfSelectedItems()
                if items.isEmpty {
                    models[models.count - 1].wasSelected = true
                    (collectionView?.cellForItem(at: IndexPath(item: models.count - 1, section: 0)) as? ItemCollectionCell)?.didSelectCell()
                } else {
                    removeSelectedItems()
                }
            }
        } else {
            counter -= 1
        }
    }
}

