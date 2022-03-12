//
//  ListCell.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/10/05.
//

import UIKit
import SnapKit

final class ListCell: UITableViewCell {
    let goodLabel = UILabel()
    let badLabel = UILabel()
    let thanksLabel = UILabel()
    let highlightLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttribute()
        setContraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setAttribute() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemGray6
    }
    
    private func setContraint() {
        contentView.addSubview(goodLabel)
        contentView.addSubview(badLabel)
        contentView.addSubview(thanksLabel)
        contentView.addSubview(highlightLabel)
        
        goodLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(20)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
        }
        badLabel.snp.makeConstraints { make in
            make.leading.equalTo(goodLabel.snp.leading)
            make.top.equalTo(goodLabel.snp.bottom).offset(10)
        }
        thanksLabel.snp.makeConstraints { make in
            make.leading.equalTo(goodLabel.snp.leading)
            make.top.equalTo(badLabel.snp.bottom).offset(10)
        }
        highlightLabel.snp.makeConstraints { make in
            make.leading.equalTo(goodLabel.snp.leading)
            make.top.equalTo(thanksLabel.snp.bottom).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }


}
