//
//  AutoScrollLabel.swift
//  ItemCollection
//
//  Created by Andrei Giuglea on 9/4/20.
//  Copyright © 2020 Andrei Giuglea. All rights reserved.
//

import UIKit

class AutoScrollLabel: UIScrollView {
    let label = UILabel()
    weak var timer: Timer?
    
    init(frame: CGRect = .zero, text: String = "", autoScroll: Bool = true, isUserScrollEnabled: Bool = false) {
        super.init(frame: frame)
        configure()
        label.text = text
        label.sizeToFit()
        self.isScrollEnabled = isUserScrollEnabled
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func checkIfShouldScroll() {
        let labelTest = UILabel()
        labelTest.text = label.text
        labelTest.sizeToFit()
        if self.frame.width > labelTest.frame.width {
            setAutoScroll(enable: true)
        }
    }
    func configure() {
        addSubview(label)
        makeLabelConstraints()
    }
    func makeLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    func stopTimer() {
        timer?.invalidate()
    }
    func setAutoScroll(enable: Bool) {
        if enable {
            timer?.invalidate()
            let time = Double(0.5 * (self.contentSize.width - self.frame.width) / 10) + 4
            timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    func setText(text: String) {
        label.text = text
        label.sizeToFit()
    }
    func setScroll(enable: Bool) {
        self.isScrollEnabled = enable
    }
    @objc func animate() {
        let timeToScroll = Double(0.5 * (self.contentSize.width - self.frame.width) / 10)
        UIView.animate(withDuration: timeToScroll,
                       delay: 0,
                       options: .curveLinear) {
            self.contentOffset = CGPoint(x: (self.contentSize.width - self.frame.width), y: 0.0)
        } completion: { _ in
            UIView.animate(withDuration: 0,
                           delay: 2) {
                self.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
}
