//
//  DailyRecordView.swift
//  DailyRecordProject
//
//  Created by dudu on 2022/06/17.
//

import UIKit
import SnapKit

final class DailyRecordView: UIView {
    private let baseStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 20
        
        return stackview
    }()
    
    private let topStackView: UIStackView = {
        let stackview = UIStackView()
        
        return stackview
    }()
    
    private let titleStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .center
        
        return stackview
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    private let titleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.setContentHuggingPriority(.required, for: .vertical)
        view.snp.makeConstraints { $0.height.equalTo(1)}

        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.spacing = 10
        
        return stackview
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .label
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    private let fourRecordStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        
        return stackview
    }()
    
    private let goodWorkLabel: UILabel = {
        let label = UILabel()
        label.text = "대충좋은일"
        
        return label
    }()
    
    private let badWorkLabel: UILabel = {
        let label = UILabel()
        label.text = "대충나쁜일"
        
        return label
    }()
    
    private let thanksWorkLabel: UILabel = {
        let label = UILabel()
        label.text = "대충 감사한일"
        
        return label
    }()
    
    private let highlightLabel: UILabel = {
        let label = UILabel()
        label.text = "대충 내일의 목표"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addSubViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
    }
    
    func addSubViews() {
        addSubviews(baseStackView, buttonStackView)
        baseStackView.addArrangedSubviews(titleStackView, fourRecordStackView)
        titleStackView.addArrangedSubviews(titleLabel, titleLineView)
        buttonStackView.addArrangedSubviews(editButton, deleteButton)
        fourRecordStackView.addArrangedSubviews(goodWorkLabel, badWorkLabel, thanksWorkLabel, highlightLabel)
    }
    
    func configureLayout() {
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
        }
        
        titleLineView.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
}
