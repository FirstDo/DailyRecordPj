//
//  moodSegmentView.swift
//  DailyRecordProject
//
//  Created by dudu on 2021/06/21.
//

import UIKit

final class MoodSegmentView: UIView {
    
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        return stackView
    }()
    
    private let happyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "happy"), for: .normal)
        
        return button
    }()
    
    private let sadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sad2"), for: .normal)
        
        return button
    }()
    
    private let sosoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "soso"), for: .normal)
        
        return button
    }()
    
    private let angryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "angry"), for: .normal)
        
        return button
    }()
    
    private let lineStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), UIView(), UIView(), UIView()])
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    var selectedValue: Int {
        return 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubViews()
        layout()
    }
    
    private func addSubViews() {
        addSubview(baseStackView)
        baseStackView.addArrangedSubviews(buttonStackView, lineStackView)
        buttonStackView.addArrangedSubviews(happyButton, sadButton, sosoButton, angryButton)
    }

    private func layout() {
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        happyButton.snp.makeConstraints {
            $0.width.equalTo(happyButton.snp.height)
        }
    }
}
