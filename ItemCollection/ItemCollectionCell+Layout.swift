//
//  ItemCollectionCell+Layout.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 8/16/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

extension ItemCollectionCell {
    func initialConfigure() {
        self.layer.cornerRadius = cellDesign.cornerRadius
        let cellTap = UITapGestureRecognizer(target: self, action: #selector(didSelectCell))
        if shouldScroll {
            let tappedView = UIView()
            tappedView.translatesAutoresizingMaskIntoConstraints = false
            autoScrollLabel.translatesAutoresizingMaskIntoConstraints = false
            tappedView.tag = 1000
            textLabel.isHidden = true
            autoScrollLabel.isHidden = false
            autoScrollLabel.tag = 1000
            autoScrollLabel.configure()
            autoScrollLabel.label.textAlignment = .center
            autoScrollLabel.label.font = cellDesign.textFont
            autoScrollLabel.label.textColor = cellDesign.textColor
            autoScrollLabel.sizeToFit()
            self.addSubview(autoScrollLabel)
            self.addSubview(tappedView)
            tappedView.addGestureRecognizer(cellTap)
            
            autoScrollLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            autoScrollLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
            autoScrollLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
            autoScrollLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            tappedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            tappedView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            tappedView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            tappedView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            DispatchQueue.main.async {
                self.autoScrollLabel.setAutoScroll(enable: self.shouldScroll)
            }
        } else {
            self.addGestureRecognizer(cellTap)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            autoScrollLabel.isHidden = true
            textLabel.tag = 1000
            textLabel.isHidden = false
            textLabel.textAlignment = .center
            textLabel.textColor = cellDesign.textColor
            textLabel.font = cellDesign.textFont
            textLabel.sizeToFit()
            self.addSubview(textLabel)
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        self.layer.borderColor = cellDesign.borderColor.cgColor
        self.layer.borderWidth = cellDesign.borderWidth
        self.layer.cornerRadius = cellDesign.cornerRadius
        if wasSelected {
            backgroundColor = cellDesign.selectedBackgroundColor
        } else {
            backgroundColor = cellDesign.normalBackgroundColor
        }
        
    }
}
