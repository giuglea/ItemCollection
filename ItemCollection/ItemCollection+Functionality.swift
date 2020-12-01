//
//  ItemCollection+Functionality.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 8/17/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

extension ItemCollection {
    public func getItemList() -> [String] {
        var tagArray = [String]()
        for cont in 0..<models.count {
            tagArray.append(models[cont].text)
        }
        return tagArray
    }
    public func getIndexOfSelectedItems() -> [Int] {
        var selectedTagIndex = [Int]()
        for cont in 0..<models.count {
            if models[cont].wasSelected == true {
                selectedTagIndex.append(cont)
            }
        }
        return selectedTagIndex
    }
    public func getSelectedItems() -> [ItemCollectionCell.CellModel] {
        models.filter {
            return ($0.wasSelected == true)
        }
    }
    public func getNumberOfSelectedItems() -> Int {
        var counter = 0
        for cont in 0..<models.count {
            if models[cont].wasSelected == true {
                counter += 1
            }
        }
        return counter
    }
    public func removeSelectedItems() {
        models = models.filter {
            $0.wasSelected == false
        }
        reloadData()
    }
    public func popLastItem() {
        _ = models.popLast()
        reloadData()
    }
    public func arrangeItems(reload: Bool = true, order: Order = .ascending) {
        switch order {
        case .ascending:
            models = models.sorted {
                $0.text.lowercased() < $1.text.lowercased()
            }
        case .descending:
            models = models.sorted {
                $0.text.lowercased() > $1.text.lowercased()
            }
        }
        if reload {
            reloadData()
        }
    }
    public func setAutoArrangeItems(enable: Bool = true, order: Order = .ascending) {
        self.autoArrangeEnable = enable
        self.order = order
        arrangeItems(order: self.order)
    }
    public func setMaximumNumberOfCharacters(max: Int) {
        maximumNumberOfCharacters = max
    }
    public func setKeyboardType(type: UIKeyboardType) {
        textField.keyboardType = type
    }
    public func setScrollOnCollectionView(enable: Bool) {
        collectionView?.isScrollEnabled = enable
    }
    public func setItemInsertMethod(by method: InsertItemMethod) {
        insertItemMethod = method
    }
    @objc func rotated() {
        updateViewConstraints()
    }
    public func setUserInteraction(_ enable: Bool) {
        collectionView?.isUserInteractionEnabled = enable
        textField.isUserInteractionEnabled = enable
    }
    public func tapOnViewToBeginTyping(enable: Bool) {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(beginTyping))
        if enable {
            collectionView?.addGestureRecognizer(tap)
        } else {
            removeAllGestures()
        }
    }
    public func removeAllGestures() {
        for gesture in collectionView?.gestureRecognizers ?? [] {
            collectionView?.removeGestureRecognizer(gesture)
        }
    }
    @objc public func beginTyping() {
        if !textField.isFirstResponder && collectionState == .decompressed {
            textField.becomeFirstResponder()
            return
        }
        textField.resignFirstResponder()
    }
    
    public func setNumberOfRowsForCompressedState(numberOfRows: UInt = 1) {
        compressNumberOfLines = numberOfRows
    }
    
    public func setDoneActions(actions: DoneButtonActions...) {
        doneButtonActions.removeAll()
        for action in actions {
            doneButtonActions.insert(action)
        }
        addActionButtonOnKeyboard()
    }
    
    public func addActionButtonOnKeyboard(){
        destroyDoneButton()
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doAllActions))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc public func dismissKeyboard(){
        textField.resignFirstResponder()
    }
    
    @objc public func destroyDoneButton() {
        textField.inputAccessoryView = nil
    }
    
    @objc public func deselectAllCells() {
        for counter in 0..<models.count {
            models[counter].wasSelected = false;
        }
        for cell in collectionView!.visibleCells {
            (cell as? ItemCollectionCell)?.deselectCell()
        }
    }
    
    @objc func doAllActions() {
        for action in doneButtonActions {
            DispatchQueue.main.async { [weak self] in
                switch action {
                case .compress:
                    self?.compress()
                case .deselectAllCells:
                    self?.deselectAllCells()
                case .dismissKeyboard:
                    self?.dismissKeyboard()
                case .destroyDoneButton:
                    self?.destroyDoneButton()
                }
            }
        }
    }
    public func setTapActions(reload: Bool = true, actions: CellTapOptions...) {
        tapCellActions.removeAll()
        for action in actions {
            tapCellActions.insert(action)
        }
        if reload {
            reloadData()
        }
    }
}
