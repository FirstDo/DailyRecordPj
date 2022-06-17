//
//  EmotionIndexView.swift
//  DailyRecordProject
//
//  Created by dudu on 2022/06/17.
//

import UIKit
import SnapKit

final class EmotionIndexView: UIStackView {
    private let happyStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.spacing = 5
        
        return stackview
    }()
    
    private let sadStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.spacing = 5
        
        return stackview
    }()
    
    private let sosoStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.spacing = 5
        
        return stackview
    }()
    
    private let angryStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.spacing = 5
        
        return stackview
    }()
    
    private lazy var emotionViews = [happyStackView, sadStackView, sosoStackView, angryStackView]
    private lazy var emotions = ["😀", "🥲", "😐", "🤬"]
    private lazy var colors: [UIColor] = [.systemGreen, .systemBlue, .systemGray4, .systemRed]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAttribute() {
        spacing = 15
    }
    
    func configureLayout() {
        addArrangedSubviews(happyStackView, sadStackView, sosoStackView, angryStackView)
        
        for index in 0..<4 {
            let label = UILabel()
            label.text = emotions[index]
            
            let view = UIView()
            view.backgroundColor = colors[index]
            view.layer.cornerRadius = 10
            
            emotionViews[index].addArrangedSubviews(view, label)
            
            view.snp.makeConstraints {
                $0.width.equalTo(view.snp.height)
            }
        }
    }
}
