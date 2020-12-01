//
//  ViewController.swift
//  ItemCollectionDemo
//
//  Created by Andrei Giuglea on 01/12/2020.
//

import UIKit
import ItemCollection

class ViewController: UIViewController {
    let collection = ItemCollection()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.topAnchor,constant: 50).isActive = true
        collection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        collection.setDoneActions(actions: .dismissKeyboard)
        collection.setCellDesign(cellDesign: ItemCellDesign( selectedBackgroundColor: .gray, cornerRadius: 3, borderWidth: 1, borderColor: .blue))
        // Do any additional setup after loading the view.
    }


}

