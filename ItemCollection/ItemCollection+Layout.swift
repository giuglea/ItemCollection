//
//  ItemCollection+Layout.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 8/16/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

extension ItemCollection {
    func configure() {
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        textField.backgroundColor = .clear
        collectionView?.backgroundColor = .clear
        plusLabel.backgroundColor = .clear
        plusLabel.textAlignment = .right
        plusLabel.isHidden = true
        textField.textColor = itemCellDesign.textColor
        collectionView?.isScrollEnabled = false
        textField.font = itemCellDesign.textFont
        plusLabel.font = itemCellDesign.textFont
        plusLabel.textColor = itemCellDesign.textColor
        self.addSubview(collectionView!)
        self.addSubview(textField)
        self.addSubview(plusLabel)
    }
    func remakePlusLabelConstraints() {
        plusLabel.translatesAutoresizingMaskIntoConstraints = false
        plusLabel.rightAnchor.constraint(equalTo: collectionView!.rightAnchor).isActive = true
        plusLabelHeightConstraint = plusLabel.heightAnchor.constraint(equalToConstant: itemCellDesign.cellHeight)
        plusLabelHeightConstraint?.isActive = true
        plusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: sectionInsets.top).isActive = true
    }
   public func updatePlusLabelConstraints() {
        plusLabelHeightConstraint?.constant = itemCellDesign.cellHeight
    }
    
    func makeTextFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        let offset = getNumberOfLinesNeeded().1
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textFieldHeightConstraint = textField.heightAnchor.constraint(equalToConstant: itemCellDesign.cellHeight)
        textFieldHeightConstraint?.isActive = true
        textFieldHorizontalOffsetConstraint = textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: offset)
        textFieldHorizontalOffsetConstraint?.isActive = true
    }
    public func updateTextFieldConstraints() {
        let offset = getNumberOfLinesNeeded().1
        textFieldHorizontalOffsetConstraint?.constant = offset
        textFieldHeightConstraint?.constant = itemCellDesign.cellHeight
    }
    func makeCollectionViewConstraints() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        collectionViewHeightConstraint = collectionView?.heightAnchor.constraint(equalToConstant: CGFloat(getNumberOfLinesNeeded().0) *
                                                                                    (itemCellDesign.cellHeight + sectionInsets.top))
        collectionViewHeightConstraint?.isActive = true
    }
    public func updateCollectionViewConstraints(numberOfLines: Int? = nil) {
        collectionViewHeightConstraint?.constant = CGFloat( numberOfLines ?? getNumberOfLinesNeeded().0) * (itemCellDesign.cellHeight + sectionInsets.top)
    }
    public func compress() {
        if collectionState == .compressed { return }
        compressNumberOfLines = compressToNumberOfRows
        textField.isHidden = true
        textField.resignFirstResponder()
        collectionState = .compressed
        var maxNumberOfRows = getNumberOfLinesNeeded().0
        if maxNumberOfRows > compressToNumberOfRows{
            maxNumberOfRows = Int(compressToNumberOfRows)
        }
        updateCollectionViewConstraints(numberOfLines: maxNumberOfRows)
        if getNumberOfLinesNeededForModels() < 1{
            return
        }
        plusLabel.text = " +\(models.count) "
        plusLabel.sizeToFit()
        var index = getIndexOfLastCellOfFirstRow()
        tempoIndex = index
        if index == 0 {
            index += 1
        }
        plusLabel.isHidden = false
        plusLabel.text = "+\(models.count - index)"
        plusLabel.sizeToFit()
        collectionView?.reloadData()
    }
    public func decompress(beginTypingAfter: Bool = true) {
        if collectionState == .decompressed { return }
        collectionState = .decompressed
        textField.isHidden = false
        if getNumberOfLinesNeededForModels() < 1{
            updateViewConstraints()
            return
        }
        plusLabel.isHidden = true
        collectionView?.reloadData()
        if beginTypingAfter {
            textField.becomeFirstResponder()
        }
       updateCollectionViewConstraints()
    }
    func updateViewConstraints() {
        updateCollectionViewConstraints()
        updateTextFieldConstraints()
        updatePlusLabelConstraints()
    }
}
