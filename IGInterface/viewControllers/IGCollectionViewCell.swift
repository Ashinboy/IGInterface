//
//  IGCollectionViewCell.swift
//  IGInterface
//
//  Created by Ashin Wang on 2022/4/27.
//

import UIKit

class IGCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imageWidthConstraints: NSLayoutConstraint!
    
    static let width = floor((UIScreen.main.bounds.width - 3 * 2) / 3)
   
    
}
