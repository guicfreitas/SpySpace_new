//
//  ExploreCollectionViewCell.swift
//  SpySpace_New
//
//  Created by João Guilherme on 20/01/21.
//

import UIKit
protocol ExpandedCellDelegate: NSObjectProtocol{
    func didTouchOpen(indexPath:IndexPath)
    func didTouchSave(indexPath:IndexPath)
}

   


class ExploreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var heightImage: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var hiddenTitle: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    weak var delegate:ExpandedCellDelegate?
    
    public var indexPath:IndexPath!
    
    
    override func layoutSubviews() {
        backImage.contentMode = .scaleAspectFill
       
        
    }
    
    @IBAction func didTouchOpen(_ sender: UIButton) {
        print("entrou")
        
        if let delegate = self.delegate{
            delegate.didTouchOpen(indexPath: indexPath)
              
           
        }
        
    }
    
    @IBAction func didTouchSave(_ sender: Any){
        if let delegate = self.delegate{
            delegate.didTouchSave(indexPath: indexPath)
              
           
        }
        
    }
}
