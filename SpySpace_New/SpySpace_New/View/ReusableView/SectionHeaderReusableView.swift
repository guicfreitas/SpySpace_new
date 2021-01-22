//
//  SectionHeaderReusableView.swift
//  SpySpace_New
//
//  Created by João Guilherme on 22/01/21.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    @IBOutlet weak var sectionLabelTitle: UILabel!
    
    var sectionTitle: String!{
        didSet{
            sectionLabelTitle.text = sectionTitle
        }
    }
}
