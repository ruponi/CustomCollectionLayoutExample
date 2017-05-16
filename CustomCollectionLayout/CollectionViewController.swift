//
//  CollectionViewController.swift
//  CustomCollectionLayout
//
//  Created by Ruslan on 5/01/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import UIKit



class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,CellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let dateCellIdentifier = "DateCellIdentifier"
    let contentCellIdentifier = "ContentCellIdentifier"
    let contentHeaderIdentifier = "HeaderCellIdentifier"
    var numberRow=50
    var array_of_the_data:[DataObjects.ProductData]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        DataObjects.sharedInstance.getData { (result:[DataObjects.ProductData]) in
            self.array_of_the_data=result
            DispatchQueue.main.async(){
                self.collectionView .reloadData()
            }
        }
            
        
       // array_of_the_data=DataObjects.sharedInstance.allProducts
    
        self.collectionView .register(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dateCellIdentifier)
        self.collectionView .register(UINib(nibName: "ContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: contentCellIdentifier)
        self.collectionView .register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: contentHeaderIdentifier)
    

    
    }
    
    
    //MARK: Protocol for Delete Item -----
    func on_deletePressed(_ sender: Any) {
        let hc:HeaderCollectionViewCell=sender as! HeaderCollectionViewCell
        let position=(collectionView.indexPath(for: hc)?.row)!
        var indexes:[IndexPath]=[]
        for i in 0..<numberRow {
            let index:IndexPath=IndexPath(row: position, section: i)
                indexes.append(index)
        }
        array_of_the_data .remove(at: position-1)
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: indexes)
        }) { (Bool) in
            self.collectionView .reloadData()
        }
        
        
    }
    
    // MARK - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if array_of_the_data.count==0 {
            return 0
        } else {
        return numberRow
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (array_of_the_data.count==0) {
            return 0
        }
        else {
            return array_of_the_data.count+1
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCell(withReuseIdentifier: dateCellIdentifier, for: indexPath) as! DateCollectionViewCell
                dateCell.backgroundColor = UIColor.white
                dateCell.dateLabel.font = UIFont.systemFont(ofSize: 13)
                dateCell.dateLabel.textColor = UIColor.black
                dateCell.dateLabel.text = "Parameter"
                
                return dateCell
            } else {
                let contentCell : HeaderCollectionViewCell = collectionView .dequeueReusableCell(withReuseIdentifier: contentHeaderIdentifier, for: indexPath) as! HeaderCollectionViewCell
                
                return setHeaderCell(hCell:contentCell , indexPath: indexPath)
            }
        } else {
            if indexPath.row == 0 {
                let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCell(withReuseIdentifier: dateCellIdentifier, for: indexPath) as! DateCollectionViewCell
                
                return setDateCell(cCell: dateCell, indexPath: indexPath)
            } else {
                let contentCell : ContentCollectionViewCell = collectionView .dequeueReusableCell(withReuseIdentifier: contentCellIdentifier, for: indexPath) as! ContentCollectionViewCell
                
                return setContentCell(cCell: contentCell, indexPath: indexPath)
            }
        }
    }
    
    //MARK: setup content of the cells
    
    private  func setHeaderCell(hCell:HeaderCollectionViewCell,indexPath:IndexPath)->HeaderCollectionViewCell{
        hCell.l_title!.font = UIFont.systemFont(ofSize: 13)
        hCell.l_title!.textColor = UIColor.red
        hCell.l_title!.text = String(format:"H %ld",indexPath.row)
        hCell.btn_dellete.tag=indexPath.row-1;
        hCell.delegated=self

        if (array_of_the_data.count>=indexPath.row&&array_of_the_data.count>0) {
            let title=array_of_the_data[indexPath.row-1].productHeader?.hTitle
            let imageLink=array_of_the_data[indexPath.row-1].productHeader?.hImageLink
            hCell.l_title.text=title
            hCell.imgv_image!.imageFromServerURL(urlString: imageLink!)
        }
        
        if indexPath.section % 2 != 0 {
            hCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            hCell.backgroundColor = UIColor.white
        }
    
    return hCell
    }
    
   
    private  func setDateCell(cCell:DateCollectionViewCell,indexPath:IndexPath)->DateCollectionViewCell{
        cCell.dateLabel.font = UIFont.systemFont(ofSize: 13)
        cCell.dateLabel.textColor = UIColor.black
        
        
        if (array_of_the_data.count>indexPath.row-1  && array_of_the_data.count>0)  {
            if (array_of_the_data[0].productParameters!.count>indexPath.section-1 && array_of_the_data[0].productParameters!.count>0) {
                let productItem:DataObjects.CellItem =  array_of_the_data[0].productParameters![indexPath.section-1]
                cCell.dateLabel.text = String(format: "%@:",productItem.cTitle!.0)
            }
            else {
                cCell.dateLabel.text = String(indexPath.section)
            }
        } else {
            cCell.dateLabel.text = String(indexPath.section)
        }
        
        if indexPath.section % 2 != 0 {
            cCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            cCell.backgroundColor = UIColor.white
        }
        
        
        return cCell
    }
    
    
    
    
    private  func setContentCell(cCell:ContentCollectionViewCell,indexPath:IndexPath)->ContentCollectionViewCell{
        cCell.contentLabel.font = UIFont.systemFont(ofSize: 13)
        cCell.contentLabel.textColor = UIColor.black
        
        
        if (array_of_the_data.count>indexPath.row-1) {
            if (array_of_the_data[indexPath.row-1].productParameters!.count>indexPath.section-1) {
                let productItem:DataObjects.CellItem =  array_of_the_data[indexPath.row-1].productParameters![indexPath.section-1]
                cCell.contentLabel.text = String(format: "%@",productItem.cTitle!.1)
            }
            else {
                   cCell.contentLabel.text = String(format: "C-%d,%d",indexPath.section,indexPath.row)
            }
        } else {
            cCell.contentLabel.text = String(format: "C-%d,%d",indexPath.section,indexPath.row)
        }

        if indexPath.section % 2 != 0 {
            cCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            cCell.backgroundColor = UIColor.white
        }

    
    return cCell
    }
}

//MARK: extension for UIImgeView for Loading from URL

extension  UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
    
}

