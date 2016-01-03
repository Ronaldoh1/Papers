//
//  PaperCollectionViewCell.swift
//  Papers
//
//  Created by Ronald Hernandez on 1/2/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PaperCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var paperImageView: UIImageView!

    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var gradientView: GradientView!

    @IBOutlet weak var checkImageView: UIImageView!

    var editing: Bool = false {

        didSet{
            caption.hidden = editing
            checkImageView.hidden = !editing
        }
    }

    override var selected: Bool {
        didSet{
            if editing  {
                checkImageView.image = UIImage(named: selected ? "Checked" : "Unchecked")
            }
        }
    }
    var paper: Paper? {
        didSet {
        if let paper = paper {
            paperImageView.image = UIImage(named: paper.imageName)
            caption.textColor = UIColor.whiteColor()
            caption.text = paper.caption

            }
        }
    }
}
