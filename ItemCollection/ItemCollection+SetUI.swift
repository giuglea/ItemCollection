//
//  ItemCollection+SetUI.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 8/18/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

public struct ItemCellDesign {
    var normalBackgroundColor: UIColor
    var selectedBackgroundColor: UIColor
    var cornerRadius: CGFloat
    var borderWidth: CGFloat
    var borderColor: UIColor
    var textColor: UIColor
    var textFont: UIFont
    var cellHeight: CGFloat
    public init(normalBackgroundColor: UIColor = .clear,
         selectedBackgroundColor: UIColor = .clear,
         cornerRadius: CGFloat = 0,
         borderWidth: CGFloat = 0,
         borderColor: UIColor = UIColor.clear,
         textColor: UIColor = .black,
         textFont: UIFont = .init(descriptor: .init(), size: 16),
         cellHeight: CGFloat = 32) {
        self.normalBackgroundColor = normalBackgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.textColor = textColor
        self.textFont = textFont
        self.cellHeight = cellHeight
    }
}
extension ItemCollection {
    public func setCellDesign(cellDesign: ItemCellDesign) {
        itemCellDesign = cellDesign
        collectionView?.reloadData()
        textField.font = cellDesign.textFont
        textField.textColor = cellDesign.textColor
        plusLabel.font = cellDesign.textFont
        plusLabel.textColor = cellDesign.textColor
        updateViewConstraints()
    }
    public func setFont(font: UIFont, check: Bool = true) {
        itemCellDesign.textFont = font
        textField.font = font
        plusLabel.font = font
        if check && (font.pointSize > itemCellDesign.cellHeight) {
            itemCellDesign.cellHeight = font.pointSize + 2
        }
        collectionView?.reloadData()
        updateViewConstraints()
    }
    public func setViewBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    public func setSelectedTagBackgroundColor(color: UIColor) {
        itemCellDesign.selectedBackgroundColor = color
        collectionView?.reloadData()
    }
    public func setNormalTagBackgroundColor(color: UIColor) {
        itemCellDesign.normalBackgroundColor = color
        collectionView?.reloadData()
    }
    public func setTextColor(color: UIColor) {
        textField.textColor = color
        itemCellDesign.textColor = color
        plusLabel.textColor = color
        collectionView?.reloadData()
    }
    public func setCellBorder(cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        itemCellDesign.cornerRadius = cornerRadius
        itemCellDesign.borderWidth = borderWidth
        itemCellDesign.borderColor = borderColor
        collectionView?.reloadData()
    }
    public func setCellHeight(height: CGFloat, check: Bool = true) {
        var checkedHeight = height
        if checkedHeight < itemCellDesign.textFont.pointSize {
            checkedHeight = itemCellDesign.textFont.pointSize + 2
        }
        itemCellDesign.cellHeight = checkedHeight
        updatePlusLabelConstraints()
        collectionView?.reloadData()
        updateViewConstraints()
    }
}


