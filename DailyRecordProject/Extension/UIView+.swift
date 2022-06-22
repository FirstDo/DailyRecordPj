//
//  UIView+.swift
//  DailyRecordProject
//
//  Created by dudu on 2022/06/17.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
