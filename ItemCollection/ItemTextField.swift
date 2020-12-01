//
//  ItemTextField.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 9/27/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

protocol ItemTextFieldDelegate: UITextFieldDelegate {
    func itemTextFieldDidDelete()
    func textDidChange(_ textField: UITextField)
}
extension ItemTextFieldDelegate {
    func tagTextViewDidDelete() { return }
    func textDidChange(_ textField: UITextField) { return }
}

class ItemTextField: UITextField, UITextFieldDelegate {
    
    weak var itemDelegate: ItemTextFieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        itemDelegate?.itemTextFieldDidDelete()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        isUserInteractionEnabled = true
        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        itemDelegate?.textDidChange(textField)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        itemDelegate?.textFieldDidBeginEditing?(textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        itemDelegate?.textFieldDidEndEditing?(textField)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if #available(iOS 13.0, *) {
            itemDelegate?.textFieldDidChangeSelection?(textField)
        } else {
            // Fallback on earlier versions
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return itemDelegate?.textFieldShouldClear?(textField) ?? true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return itemDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return itemDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return itemDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return itemDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
