//
//  PapersFlowLayOut.swift
//  Papers
//
//  Created by Ronald Hernandez on 1/2/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PapersFlowLayOut: UICollectionViewFlowLayout {

    var appearingIndexPath: NSIndexPath?


    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)


        if let indexPath = appearingIndexPath {
            if let attributes = attributes {
                if indexPath == itemIndexPath {
                    attributes.alpha = 1.0

                    attributes.center = CGPoint(x: CGRectGetWidth(collectionView!.frame) - 23.5, y: -24.5)
                    attributes.transform = CGAffineTransformMakeScale(0.15, 0.15)

                    attributes.zIndex = 99
                }
            }
        }
        return attributes
    }
}
