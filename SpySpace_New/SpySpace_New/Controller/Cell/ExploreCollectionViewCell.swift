//
//  ExploreCollectionViewCell.swift
//  SpySpace_New
//
//  Created by João Guilherme on 20/01/21.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backImage: UIImageView!
    
    
    override func layoutSubviews() {
        backImage.contentMode = .scaleAspectFill
    }
}
