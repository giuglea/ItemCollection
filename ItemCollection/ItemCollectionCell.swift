//
//  ItemCollectionCell.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 8/16/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

protocol ItemCollectionCellDelegate: AnyObject {
    func tapAction()
}

public class ItemCollectionCell: UICollectionViewCell {
    public struct CellModel {
        var text: String
        var wasSelected: Bool
        init(text: String = "", wasSelected: Bool = false) {
            self.text = text
            self.wasSelected = wasSelected
        }
    }
    static let cellId = "EmailCollectionCell"
    var wasSelected: Bool = false
    var cellDesign = ItemCellDesign()
    var autoScrollLabel = AutoScrollLabel()
    let textLabel = UILabel()
    var gotSelected: (() -> Void)?
    var shouldScroll: Bool = false
    weak var delegate: ItemCollectionCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func configure(model: CellModel, cellDesign: ItemCellDesign, shouldScroll: Bool) {
        self.wasSelected = model.wasSelected
        self.cellDesign = cellDesign
        self.shouldScroll = shouldScroll
        if shouldScroll {
            autoScrollLabel.setText(text: model.text)
        } else {
            textLabel.text = model.text
        }
        initialConfigure()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override var reuseIdentifier: String? {
        return ItemCollectionCell.cellId
    }
    func gotSelected(action: @escaping () -> Void) {
        self.gotSelected = action
    }
    @objc func didSelectCell() {
        tapAnimation()
        wasSelected = !wasSelected
        if wasSelected {
            backgroundColor = cellDesign.selectedBackgroundColor
        } else {
            backgroundColor = cellDesign.normalBackgroundColor
        }
        delegate?.tapAction()
        gotSelected?()
    }
    @objc func deselectCell() {
        wasSelected = false
        backgroundColor = cellDesign.normalBackgroundColor
    }
    
    public override func prepareForReuse() {
        autoScrollLabel.stopTimer()
        removeSubviews()
    }
    func tapAnimation() {
        let tap = CASpringAnimation(keyPath: "transform.scale")
        tap.duration = 0.5
        tap.fromValue = 0.97
        tap.toValue = 1
        tap.initialVelocity = 0.5
        tap.damping = 5
        self.layer.add(tap, forKey: nil)
    }
    func removeSubviews() {
        for view in self.subviews where view.tag == 1000 {
            view.removeFromSuperview()
        }
    }
}

