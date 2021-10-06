//
//  ListCell.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/05.
//

import UIKit

class ListCell: UITableViewCell {
    
    let goodLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let badLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    let thanksLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let highlightLabel: UILabel! = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private func setContraint() {
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .systemBlue
        contentView.addSubview(goodLabel)
        contentView.addSubview(badLabel)
        contentView.addSubview(thanksLabel)
        contentView.addSubview(highlightLabel)
        
        goodLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        goodLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        badLabel.leadingAnchor.constraint(equalTo: goodLabel.leadingAnchor).isActive = true
        badLabel.topAnchor.constraint(equalTo: goodLabel.bottomAnchor, constant: 10).isActive = true
        thanksLabel.leadingAnchor.constraint(equalTo: goodLabel.leadingAnchor).isActive = true
        thanksLabel.topAnchor.constraint(equalTo: badLabel.bottomAnchor, constant: 10).isActive = true
        
        highlightLabel.leadingAnchor.constraint(equalTo: goodLabel.leadingAnchor).isActive = true
        highlightLabel.topAnchor.constraint(equalTo: thanksLabel.bottomAnchor, constant: 10).isActive = true
        highlightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setContraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
