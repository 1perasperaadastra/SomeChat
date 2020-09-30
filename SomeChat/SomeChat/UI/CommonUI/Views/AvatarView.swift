//
//  AvatarView.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal struct AvatarViewModel {
    let fullName: String
    let image: UIImage?
}

internal final class AvatarView: UIView {

    private let initalsView = InitialsView()
    private let imageView = UIImageView()
    var image: UIImage? {
        return self.imageView.image
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }

    func configure(model: AvatarViewModel) {
        self.imageView.image = model.image
        self.updateInitialsView(name: model.fullName)
        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let minimumSide = min(self.bounds.height, self.bounds.width)
        self.imageView.frame = CGRect(origin: .zero, size: CGSize(width: minimumSide, height: minimumSide))
        self.imageView.layer.cornerRadius = minimumSide / 2

        let avatarViewIsClear = self.imageView.image == nil
        if avatarViewIsClear {
            let width = self.imageView.bounds.width / 1.578
            let height = self.imageView.bounds.height / 1.7
            let xOrig = (self.imageView.bounds.width - width) / 2
            let yOrig = (self.imageView.bounds.height - height) / 2
            self.initalsView.frame = CGRect(x: xOrig, y: yOrig, width: width, height: height)
        }
        self.initalsView.isHidden = !avatarViewIsClear
    }

    private func updateInitialsView(name: String) {
        let whitespace = CharacterSet.whitespaces
        let fullName = name.split(whereSeparator: { character -> Bool in
            var result = false
            character.unicodeScalars.forEach { unicodeScalar in
                if whitespace.contains(unicodeScalar) {
                    result = true
                }
            }
            return result
        })
        if let firstChar = fullName.first?.first {
            self.initalsView.firstInitial = String(firstChar) as NSString
        } else {
            self.initalsView.firstInitial = "?"
        }
        if fullName.count == 2,
            let secondChar = fullName.last?.first {
            self.initalsView.secondInitial = String(secondChar) as NSString
        } else {
            self.initalsView.secondInitial = ""
        }
    }

    private func setupViews() {
        self.addSubview(self.imageView)
        self.addSubview(self.initalsView)
        self.initalsView.backgroundColor = .clear
        self.imageView.clipsToBounds = true
    }
}
