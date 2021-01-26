//
//  ExploreCollectionViewController.swift
//  SpySpace_New
//
//  Created by João Guilherme on 19/01/21.
//

import UIKit

private let reuseIdentifier = "Cell"
private let sectionHeader = "SectionHeaderReusableView"


class ExploreCollectionViewController: UICollectionViewController, ExpandedCellDelegate {
    
    
    
    
    
    var cellWidth: CGFloat{
        return collectionView.frame.size.width - 40
    }
    private let refreshControl = UIRefreshControl()
    
    
    var expandedHeight: CGFloat = 0
    var notExpanded: CGFloat = 128
    var sections = ["Explorar","Favoritos"]
    var favoritesData: [Favoritos] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var randomData: [Curiosidade] = []
    var dataSource: [Curiosidade] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.randomData.append(self.dataSource.randomElement()!)
                self.randomData.append(self.dataSource.randomElement()!)
                self.randomData.append(self.dataSource.randomElement()!)
                self.randomData.append(self.dataSource.randomElement()!)
                self.randomData.append(self.dataSource.randomElement()!)
                self.isExpanded = Array(repeating: false, count:self.randomData.count)
            }
            
        }
    }
    var isExpanded = [Bool]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        let favoritoTemp = Favoritos(title: "", content: "")
        favoritoTemp.readRecord(){
            fetchedRecords,error in
            
            guard let records = fetchedRecords,error == nil else{
                print("Error in read CloudKit", error as Any)
                return
            }
            
            self.favoritesData = records
        }
        
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // Do any additional setup after loading the view.
    }
    @objc private func didPullToRefresh(_ sender: Any){
        randomData = []
        self.randomData.append(self.dataSource.randomElement()!)
        self.randomData.append(self.dataSource.randomElement()!)
        self.randomData.append(self.dataSource.randomElement()!)
        self.randomData.append(self.dataSource.randomElement()!)
        self.randomData.append(self.dataSource.randomElement()!)
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let curiosidade = Curiosidade(title:"teste", content: "teste", image: nil)
        DispatchQueue.main.async {
            curiosidade.readRecord(){
                fetchedRecords,error in
                
                guard let records = fetchedRecords,error == nil else{
                    
                    print("Error in read CloudKit", error as Any)
                    return
                }
                
                self.dataSource = records
                
                
            }
            self.collectionView.reloadData()
            
        }
        
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
        return sections.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0{
            return randomData.count
        }else if section == 1{
            return favoritesData.count
        }
        
        return 0
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeader, for: indexPath) as! SectionHeaderReusableView
        
        sectionHeaderView.sectionTitle = sections[indexPath.section]
        
        return sectionHeaderView
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ExploreCollectionViewCell
        
        let curi = randomData[indexPath.row]
        
        cell.mainTitle.text = curi.title
        cell.hiddenTitle.text = curi.title
        cell.textView.text = curi.content
        cell.backImage.image = curi.parseAssetToImage()
        
        
        
        // Configure the cell
        //cell.backgroundColor = .red
        cell.layer.cornerRadius = 10
        
        expandedHeight = cell.hiddenTitle.frame.height + cell.textView.frame.height + 310
        
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
    
    func didTouchSave(indexPath: IndexPath) {
        let favorito = randomData[indexPath.row]
        print("salvando favoritos")
        favorito.createRecord(){
            error in
            if error != nil{
                print("Error in CloudKit:", error as Any)
            }else{
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
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
