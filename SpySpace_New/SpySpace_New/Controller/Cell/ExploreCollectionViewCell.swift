//
//  ExploreCollectionViewCell.swift
//  SpySpace_New
//
//  Created by João Guilherme on 20/01/21.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var hiddenTitle: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func layoutSubviews() {
        backImage.contentMode = .scaleAspectFill
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isHidden = true
        hiddenTitle.isHidden = true
        saveButton.isHidden = true
    }
}
