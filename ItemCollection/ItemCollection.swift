//
//  ItemCollection.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 8/16/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

public protocol ItemCollectionDelegate: AnyObject {
    func isValidItem(text: String) -> Bool
}

extension ItemCollectionDelegate {
    func isValidItem(text: String) -> Bool {
       return true
    }
}

public protocol ItemColletionAnimations: AnyObject {
//    func insertItem(item: UIView)
//    func deleteItem(item: UIView)
}

public class ItemCollection: UIView {
    public enum Order {
        case ascending
        case descending
    }
    public enum TextFieldState {
        case inline
        case newLine
    }
    public enum ScrollAnimationType {
        case standard
    }
    public enum CollectionState {
        case compressed
        case decompressed
    }
    public enum InsertItemMethod {
        case space
        case enter
    }
    public enum DoneButtonActions {
        case dismissKeyboard
        case compress
        case deselectAllCells
        case destroyDoneButton
    }
    public enum CellTapOptions {
        case showKeyboard
        case decompress
        case delete
    }

    var maximumNumberOfCharacters: Int = 50
    var compressNumberOfLines: UInt = 1
    var counter: Int = -1
    var tempoIndex: Int = 0
    var curWidth: CGFloat = 0
    var remainingSpace : CGFloat = 0
    var compressToNumberOfRows: UInt = 1
    
    var itemCellDesign = ItemCellDesign()
    var models = [ItemCollectionCell.CellModel]()
    var doneButtonActions = Set<DoneButtonActions>()
    var tapCellActions = Set<CellTapOptions>()
    
    var textField = ItemTextField()
    var plusLabel = UILabel()
    var collectionView: UICollectionView?
    var sectionInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    var autoArrangeEnable = false
    var tempo = String()
    var order: Order = .ascending
    var collectionState: CollectionState = .decompressed
    var textFieldState: TextFieldState = .inline
    var insertItemMethod: InsertItemMethod = .enter
    
    var collectionViewHeightConstraint: NSLayoutConstraint?
    var textFieldHorizontalOffsetConstraint: NSLayoutConstraint?
    var textFieldHeightConstraint: NSLayoutConstraint?
    var plusLabelHeightConstraint: NSLayoutConstraint?
    
    public weak var delegate: ItemCollectionDelegate?
    public weak var animationDelegate: ItemColletionAnimations?
    public init(frame: CGRect = .zero,
         initialTags: [String]? = nil,
         insertItemMethod: InsertItemMethod = .enter,
         cellDesign: ItemCellDesign = ItemCellDesign(),
         checkForSize: Bool = true) {
        super.init(frame: frame)
        setAllItems(items: initialTags)
        testValues()
        self.insertItemMethod = insertItemMethod
        self.itemCellDesign = cellDesign
        checkSizeNCorrect(enabled: checkForSize)
        setUpCollectionView()
        textField.itemDelegate = self
        addActionButtonOnKeyboard()
        self.clipsToBounds = false
        self.collectionView?.clipsToBounds = false
        configure()
        DispatchQueue.main.async { [weak self] in
            guard let _weakSelf = self else { return }
            _weakSelf.collectionView?.reloadData()
            _weakSelf.makeCollectionViewConstraints()
            _weakSelf.makeTextFieldConstraints()
            _weakSelf.remakePlusLabelConstraints()
            _weakSelf.setFont(font: _weakSelf.itemCellDesign.textFont)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func checkSizeNCorrect(enabled: Bool) {
        if enabled {
            if itemCellDesign.cellHeight < itemCellDesign.textFont.pointSize {
                itemCellDesign.cellHeight = itemCellDesign.textFont.pointSize + 2
            }
        }
    }
    func setUpCollectionView() {
        let layout: LeftAlignedCollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView!.backgroundColor = .white
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.register(ItemCollectionCell.self, forCellWithReuseIdentifier: ItemCollectionCell.cellId)
    }
    public func deleteAllItems() {
        models = []
        reloadData()
    }
    public func setAllItems(items: [String]? = nil, withCheck: Bool = false) {
        if items == nil {
            deleteAllItems()
            return
        }
        models = []
        for item in items! {
            if withCheck {
                if delegate?.isValidItem(text: item) ?? true {
                    let model = ItemCollectionCell.CellModel(text: item)
                    models.append(model)
                }
            } else {
                let model = ItemCollectionCell.CellModel(text: item)
                models.append(model)
            }
        }
        reloadData()
    }
    public func reloadData() {
        let group = DispatchGroup()
        group.enter()
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
        group.leave()
        group.notify(queue: .main) { [weak self] in
            self?.updateViewConstraints()
        }
    }
    
    func reloadAfterDelete() {
        let group = DispatchGroup()
        group.enter()
        collectionView?.deleteItems(at: [IndexPath(item: models.count, section: 0)])
        group.leave()
        group.notify(queue: .main) { [weak self] in
            self?.updateViewConstraints()
        }
    }
    
    public func testValues() {
        let mailsArray = ["Test", "email@cm.com", "Test", "email@cm.com", "another test", "Test", "email@cm.com", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii", "Ii@ii.ii"]
       for cont in 0..<mailsArray.count {
            let model = ItemCollectionCell.CellModel(text: mailsArray[cont])
            models.append(model)
        }
    }
    func getIndexOfLastCellOfFirstRow() -> Int {
        let label = UILabel()
        label.font = itemCellDesign.textFont
        let maxWidth = self.frame.width
        var currentWidth: CGFloat = 0
        for cont in 0..<models.count {
            label.text = "  \(models[cont].text)  "
            label.sizeToFit()
            if currentWidth + label.frame.width  + 2 * sectionInsets.left > maxWidth - plusLabel.frame.width {
                return cont
            }
            currentWidth += label.frame.width + 2 * sectionInsets.left + 2
        }
        return 0
    }
    func getSizeRecommendedForTag(text: String) -> CGSize {
        let label = UILabel()
        label.font = itemCellDesign.textFont
        label.text = "  \(text)  "
        label.sizeToFit()
        let maxWidth = self.frame.width
        if label.frame.width + 2 * sectionInsets.left  >= maxWidth {
            label.frame.size.width = maxWidth - 2 * sectionInsets.left
        }
        return label.frame.size
    }
    func getNumberOfLinesNeeded() -> (Int, CGFloat, CGFloat) {
        if models.isEmpty {
            return (1, 0, self.frame.width)
        }
        let label = UILabel()
        label.font = itemCellDesign.textFont
        var numberOfLines = 0
        let maxWidth = self.frame.width
        var xPosition: CGFloat = 0
        for cont in 0..<models.count {
            label.text = "  \(models[cont].text)  "
            label.sizeToFit()
            if label.frame.width  + 2 * sectionInsets.left >= maxWidth {
                label.frame.size.width = maxWidth - 2 * sectionInsets.left
            }
            if xPosition + label.frame.width + 2 * sectionInsets.left > maxWidth {
                numberOfLines += 1
                xPosition = 0
            }
            xPosition += label.frame.width + 2 * sectionInsets.left + 2
        }
        let widthOfItem = self.frame.width - xPosition
        label.text = textField.text
        label.sizeToFit()
        textFieldState = .inline
        if xPosition + label.frame.width >= maxWidth {
            numberOfLines += 1
            xPosition = 0
            textFieldState = .newLine
            remainingSpace = maxWidth
        }
        remainingSpace = widthOfItem
        return (numberOfLines + 1, xPosition, widthOfItem)
    }
    func getNumberOfLinesNeededForModels() -> Int {
        if models.isEmpty {
            return 0
        }
        let label = UILabel()
        label.font = itemCellDesign.textFont
        var numberOfLines = 0
        let maxWidth = self.frame.width
        var xPosition: CGFloat = 0
        for cont in 0..<models.count {
            label.text = "  \(models[cont].text)  "
            label.sizeToFit()
            if label.frame.width  + 2 * sectionInsets.left >= maxWidth {
                label.frame.size.width = maxWidth - 2 * sectionInsets.left
            }
            if xPosition + label.frame.width + 2 * sectionInsets.left > maxWidth {
                numberOfLines += 1
                xPosition = 0
            }
            xPosition += label.frame.width + 2 * sectionInsets.left + 2
        }
        return numberOfLines
    }
}
