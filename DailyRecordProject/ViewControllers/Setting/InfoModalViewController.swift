//
//  InfoModalViewController.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/11/16.
//

import UIKit
import SnapKit

final class InfoModalViewController: UIViewController {
    
    var infoTitle: String?
    var content: String?
    
    private lazy var infoView: UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.textContainer.lineBreakMode = .byWordWrapping
        textview.font = UIFont.systemFont(ofSize: 15)
        textview.dataDetectorTypes = .link
        textview.text = content
        return textview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = infoTitle
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraint()
    }
    
    private func setConstraint() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalToSuperview().offset(20)
        }
        
        view.addSubview(infoView)
        infoView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
