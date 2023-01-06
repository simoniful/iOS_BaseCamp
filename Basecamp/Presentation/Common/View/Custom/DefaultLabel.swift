//
//  DefaultLabel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/06.
//

import UIKit.UILabel

final class DefaultLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    convenience init(font: UIFont) {
        self.init()
        self.font = font
    }

    convenience init(font: UIFont, textColor: UIColor = .label) {
        self.init()
        self.font = font
        self.textColor = textColor
        self.textAlignment = .center
    }

    convenience init(title text: String, font: UIFont, textColor: UIColor = .label) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("DefaultFillButton: fatal Error Message")
    }

    private func setConfiguration() {
        numberOfLines = 0
    }
}
