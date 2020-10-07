//
//  ImageSource.swift
//  SomeChat
//
//  Created by Алексей Махутин on 23.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

protocol ImageSourceContainer {
    var imageSource: ImageSource { get }
}

internal final class ImageSource {

    @discardableResult
    func saveImage(_ image: UIImage, name: String) -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 1),
            let imageURL = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first?.appendingPathComponent(name)
            else { return nil }

        do {

            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            return nil
        }
    }

    func loadImage(withName name: String) -> UIImage? {
        guard let imageURL = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask).first?.appendingPathComponent(name)
            else { return nil }

        return UIImage(contentsOfFile: imageURL.path)
    }
}
