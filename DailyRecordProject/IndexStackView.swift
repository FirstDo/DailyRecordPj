//
//  IndexStackView.swift
//
//

import UIKit

class IndexStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        axis = .horizontal
        
        let nameList = ["happy", "sad", "soso", "angry"]
        let korName = ["행복 ", "슬픔 ", "보통 ", "화남 "]

        for (idx, name) in nameList.enumerated() {
            let view = UIView()
            view.heightAnchor.constraint(equalToConstant: 16).isActive = true
            view.widthAnchor.constraint(equalToConstant: 16).isActive = true
            view.layer.cornerRadius = 8
            view.backgroundColor = colorDict[name]!
            self.addArrangedSubview(view)

            let label = UILabel()
            label.text = korName[idx]
            addArrangedSubview(label)
        }
        
        distribution = .fillProportionally
        spacing = 5
        clipsToBounds = false
    }
}
