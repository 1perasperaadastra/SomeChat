//
//  InitialsView.swift
//  SomeChat
//
//  Created by Алексей Махутин on 23.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class InitialsView: UIView {
    private enum Constants {
        static let spacingCoefficent: CGFloat = 4.75
    }

    var firstInitial: NSString = "M" {
        didSet { self.setNeedsDisplay() }
    }
    var secondInitial: NSString = "D" {
        didSet { self.setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        if secondInitial.length == 0 {
            self.drawFirst()
        } else {
            self.drawBoth()
        }
    }

    private func drawBoth() {
        let width = (self.bounds.width / 2) + (self.bounds.width / Constants.spacingCoefficent)
        let firstRect = CGRect(x: 0, y: 0, width: width, height: self.bounds.height)
        let secondRect = CGRect(x: self.bounds.width - width, y: 0, width: width, height: self.bounds.height)
        self.firstInitial.draw(in: firstRect, withAttributes: self.createAttributes(with: .left))
        self.secondInitial.draw(in: secondRect, withAttributes: self.createAttributes(with: .right))
    }

    private func drawFirst() {
        let firstRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.firstInitial.draw(in: firstRect, withAttributes: self.createAttributes(with: .center))
    }

    private func createAttributes(with alignment: NSTextAlignment) -> [NSAttributedString.Key: Any] {
        let pointSize = self.bounds.height / UIFont.systemFont(ofSize: 1).lineHeight
        let font = UIFont.systemFont(ofSize: pointSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.maximumLineHeight = self.bounds.height
        let attributes = [
            NSAttributedString.Key.font: font,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        return attributes
    }
}
