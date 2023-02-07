//
//  NSMutableAttributedString.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/01.
//

import UIKit

extension NSMutableAttributedString {
    var fontSize: CGFloat {
        return 16
    }
    var boldFont: UIFont {
        return UIFont(name: AppFont.regular.rawValue, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
    }
    var normalFont: UIFont {
        return UIFont(name: AppFont.regular.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }

    func bold(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }

    func regular(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont(name: AppFont.regular.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }

    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font: normalFont,
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.main
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func brownColor(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font: normalFont,
            .foregroundColor: UIColor.brown1,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font: normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
