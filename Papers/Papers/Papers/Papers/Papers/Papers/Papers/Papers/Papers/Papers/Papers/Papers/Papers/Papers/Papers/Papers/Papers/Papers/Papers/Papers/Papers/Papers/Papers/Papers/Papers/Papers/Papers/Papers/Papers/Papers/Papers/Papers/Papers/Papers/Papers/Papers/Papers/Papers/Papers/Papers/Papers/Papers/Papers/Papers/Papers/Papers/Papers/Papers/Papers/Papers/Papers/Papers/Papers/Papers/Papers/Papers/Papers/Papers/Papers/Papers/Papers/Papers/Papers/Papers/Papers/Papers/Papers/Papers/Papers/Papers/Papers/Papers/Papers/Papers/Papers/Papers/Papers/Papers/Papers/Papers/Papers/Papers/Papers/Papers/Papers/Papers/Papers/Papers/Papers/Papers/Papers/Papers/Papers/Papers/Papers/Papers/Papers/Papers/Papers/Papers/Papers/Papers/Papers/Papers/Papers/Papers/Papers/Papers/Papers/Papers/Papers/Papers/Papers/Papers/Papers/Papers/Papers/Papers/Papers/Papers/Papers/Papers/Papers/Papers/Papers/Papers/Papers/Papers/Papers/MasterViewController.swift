//
//  MasterViewController.swift
//  Papers
//
//  Created by Ronald Hernandez on 1/1/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {

    //MARK:
    private var papersDataSource = PapersDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setUpCellLayout()
    }

    func setUpCellLayout(){
        //get with of fram

        let width = CGRectGetWidth((collectionView?.frame)!) / 3

        //get reference to collection view layout .

        let layout = collectionViewLayout as! UICollectionViewFlowLayout

        layout.itemSize = CGSize(width: width, height: width)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark: UICollectionViewDataSource Delegates 

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return papersDataSource.numberOfSections
    }

    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return papersDataSource.numberOfPapersInSection(section)
    }



    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PaperCell", forIndexPath: indexPath) as! PaperCollectionViewCell

        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {

            cell.paper = paper
        }


    return cell

    }


    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        let sectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as!
        SectionHeader

        if let title = papersDataSource.titleForSectionAtIndexPath(indexPath){

            sectionHeaderView.title = title
        }

        return sectionHeaderView

    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if let paper = self.papersDataSource.paperForItemAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("MasterToDetail", sender: paper)
        }
    }
    

    @IBAction func addButtonTapped(sender: AnyObject) {

        //1. Insert item to data source 

        let indexPath = papersDataSource.indexPathForNewRandomPaper()

        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.collectionView?.insertItemsAtIndexPaths([indexPath])

            }, completion: nil)


    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

     //first check the identifer.

        if segue.identifier == "MasterToDetail" {

    //get the indexPath for cell selected. 

                let detailViewController = segue.destinationViewController as! DetailViewController


            detailViewController.paper = sender as? Paper

                }
        }

}

