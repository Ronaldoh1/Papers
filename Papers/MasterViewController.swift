
//
//  MasterViewController.swift
//  Papers
//
//  Created by Ronald Hernandez on 1/1/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!

    //MARK:
    private var papersDataSource = PapersDataSource()

    private var snapShot: UIView?
    private var scourceIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setUpCellLayout()

        navigationItem.leftBarButtonItem = editButtonItem()
        navigationController?.toolbarHidden = true
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")

        collectionView?.addGestureRecognizer(longPressGestureRecognizer)
    }
    //this is done to update the collectionview cells when they're already visible
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        //disable the addButton
        self.addButton.enabled = !editing

        collectionView?.allowsMultipleSelection = editing
        //get the indexPaths of all the cell selected

        let indexPathsArray = (collectionView?.indexPathsForVisibleItems())! as [NSIndexPath]

        //need to enumerate through all of these. 

        for indexPath in indexPathsArray {
            collectionView?.deselectItemAtIndexPath(indexPath, animated: animated)

            let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! PaperCollectionViewCell
            cell.editing = editing

        }

        if !editing {
            navigationController?.setToolbarHidden(true, animated: animated)
        }
    }

    func setUpCellLayout(){
        //get with of fram

        let width = CGRectGetWidth((collectionView?.frame)!) / 3

        //get reference to collection view layout .

        let layout = collectionViewLayout as! UICollectionViewFlowLayout

        layout.itemSize = CGSize(width: width, height: width)

    }

    //Utitlity Method 

    private func updateSnapShotView(center: CGPoint, transform: CGAffineTransform, alpha: CGFloat){

        if let snapShot = snapShot {
            snapShot.center = center
            snapShot.transform = transform
            snapShot.alpha = alpha

        }

    }

    func handleLongPress(recognizer: UILongPressGestureRecognizer){
        if editing {
            return
        }

        let location = recognizer.locationInView(collectionView)
        var indexPath = collectionView?.indexPathForItemAtPoint(location)
        switch recognizer.state {
        case .Began:
            if let indexPath = indexPath{
                scourceIndexPath = indexPath
                let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! PaperCollectionViewCell
                snapShot = cell.snapShot
                updateSnapShotView(cell.center, transform: CGAffineTransformIdentity, alpha: 0.0)

                collectionView?.addSubview(snapShot!)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.updateSnapShotView(cell.center, transform: CGAffineTransformMakeScale(1.05, 1.05), alpha: 0.95)

                    cell.moving = true
                })
            }

        case .Changed:

            self.snapShot?.center = location
            if let indexPath = indexPath {
                papersDataSource.movePaperAtIndexPath(scourceIndexPath!, toIndexPath: indexPath)
                collectionView?.moveItemAtIndexPath(scourceIndexPath!, toIndexPath: indexPath)
                scourceIndexPath = indexPath
            }

        default:
            let cell = collectionView?.cellForItemAtIndexPath(scourceIndexPath!) as! PaperCollectionViewCell
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.updateSnapShotView(cell.center, transform: CGAffineTransformIdentity, alpha: 0.0)
                cell.moving = false


                }, completion: {(finished: Bool) -> Void in

                    self.snapShot?.removeFromSuperview()
                    self.snapShot = nil

            })
        }

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
            cell.editing = editing
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

        if !editing {
            if let paper = self.papersDataSource.paperForItemAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("MasterToDetail", sender: paper)
            }
        }else{

            navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if editing  {
            if collectionView.indexPathsForSelectedItems()?.count == 0 {

                navigationController?.setToolbarHidden(true, animated: true)
            }
        }
    }
    @IBAction func addButtonTapped(sender: AnyObject) {

        //1. Insert item to data source 

        let indexPath = papersDataSource.indexPathForNewRandomPaper()

        let layout = collectionViewLayout as! PapersFlowLayOut

        layout.appearingIndexPath = indexPath

        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.collectionView?.insertItemsAtIndexPaths([indexPath])

            }, completion: { (finished: Bool) -> Void in
                layout.appearingIndexPath = nil
            })


    }
    
    @IBAction func deleteItems(sender: UIBarButtonItem) {



        let indexPaths = self.collectionView!.indexPathsForSelectedItems()!

        let layout = collectionViewLayout as! PapersFlowLayOut

        layout.disappearingItemsIndexPaths = indexPaths

        papersDataSource.deleteItemsAtIndexPaths(indexPaths)


        UIView.animateWithDuration(0.65, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in

    self.collectionView?.deleteItemsAtIndexPaths(indexPaths)
    }) { (finshed:Bool) -> Void in

        layout.disappearingItemsIndexPaths = nil
        }

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

