//
//  SectionHeader.swift
//  Papers
//
//  Created by Ronald Hernandez on 1/2/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    @IBOutlet weak var seasonImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String? {

        didSet{
         seasonImageView.image = UIImage(named: title!)
        titleLabel.text = title

        }
    }
        
}
