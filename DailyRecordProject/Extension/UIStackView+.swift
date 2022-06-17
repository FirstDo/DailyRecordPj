//
//  UIStackView+.swift
//  DailyRecordProject
//
//  Created by dudu on 2022/06/17.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
