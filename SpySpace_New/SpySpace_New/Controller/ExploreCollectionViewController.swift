//
//  ExploreCollectionViewController.swift
//  SpySpace_New
//
//  Created by João Guilherme on 19/01/21.
//

import UIKit

private let reuseIdentifier = "Cell"


class ExploreCollectionViewController: UICollectionViewController, ExpandedCellDelegate {
   
    
    
    var cellWidth: CGFloat{
        return collectionView.frame.size.width - 40
    }
   
    var expandedHeight: CGFloat = 0
    var notExpanded: CGFloat = 128
    
    var dataSource = ["data0","data1"]
    var isExpanded = [Bool]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isExpanded = Array(repeating: false, count: dataSource.count)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ExploreCollectionViewCell
        
        cell.backImage.image = UIImage(named: "1")
        // Configure the cell
        cell.backgroundColor = .red
        cell.layer.cornerRadius = 10
        
        expandedHeight = cell.hiddenTitle.frame.height + cell.textView.frame.height + 306
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        if(isExpanded[indexPath.row]){
            cell.heightImage.constant = 256
            cell.gradientView.isHidden = true
            cell.mainTitle.isHidden = true
        }else{
            cell.heightImage.constant = 128
            cell.gradientView.isHidden = false
            cell.mainTitle.isHidden = false
        }

        
        
        return cell
    }
    func didTouchOpen(indexPath: IndexPath) {
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                      self.collectionView.reloadItems(at: [indexPath])
            self.collectionView.layoutIfNeeded()
                    }, completion: { success in
                        print("success")
                })
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


extension ExploreCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isExpanded[indexPath.row] == true{
                    return CGSize(width: cellWidth, height: expandedHeight)
               }else{
                   return CGSize(width: cellWidth, height: notExpanded)
               }
    }
}
