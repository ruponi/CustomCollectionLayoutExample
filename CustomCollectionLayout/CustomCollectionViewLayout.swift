//
//  CustomCollectionViewLayout.swift
//  CustomCollectionLayout
//
//  Created by Ruslan on 5/01/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import UIKit


class CustomCollectionViewLayout: UICollectionViewLayout {

    var numberOfColumns:NSInteger=0
    var itemAttributes : NSMutableArray!
    var itemsSize : NSMutableArray!
    var contentSize : CGSize!
    
    
    
    
    
    
    override func prepare() {
        var column = 0
        var xOffset : CGFloat = 0
        var yOffset : CGFloat = 0
        var contentWidth : CGFloat = 0
        var contentHeight : CGFloat = 0
        
        
        if self.collectionView?.numberOfSections == 0 {
            self.contentSize = CGSize(width: contentWidth, height: contentHeight)
            return
        }
        var numberOfItems : Int = self.collectionView!.numberOfItems(inSection: 0)
        numberOfColumns=numberOfItems
        if (self.itemAttributes != nil && self.itemAttributes.count > 0) {
            for section in 0..<self.collectionView!.numberOfSections {
                
                numberOfItems = self.collectionView!.numberOfItems(inSection: section)
                numberOfColumns=numberOfItems
                if   ((self.itemAttributes[section] as AnyObject).count>numberOfColumns){
                    let f:NSMutableArray=itemAttributes.object(at: section) as! NSMutableArray
                    f.removeLastObject()
                    self.itemAttributes.replaceObject(at: section, with:f)
                    
                    let attributes : UICollectionViewLayoutAttributes = (self.itemAttributes.lastObject as AnyObject).lastObject as! UICollectionViewLayoutAttributes
                    contentHeight = attributes.frame.origin.y + attributes.frame.size.height
                    self.contentSize = CGSize(width: getWidthContent(), height: contentHeight)
                 
                
                }
                
                for index in 0..<numberOfItems {
                    if section != 0 && index != 0 {
                        continue
                    }
                    
                    let attributes : UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: IndexPath(item: index, section: section))!
                    if section == 0 {
                        var frame = attributes.frame
                        frame.origin.y = self.collectionView!.contentOffset.y
                        attributes.frame = frame
                    }
                    
                    if index == 0 {
                        var frame = attributes.frame
                        frame.origin.x = self.collectionView!.contentOffset.x
                        attributes.frame = frame
                    }
                }
            }
            return
        }
        
        if (self.itemsSize == nil || self.itemsSize.count != numberOfColumns) {
            self.calculateItemsSize()
        }
        
      
        
        for section in 0..<self.collectionView!.numberOfSections {
            let sectionAttributes = NSMutableArray()
            numberOfColumns=self.collectionView!.numberOfItems(inSection: section)

            for index in 0..<numberOfColumns {
                var itemSize = (self.itemsSize[index] as AnyObject).cgSizeValue
                // Size of the Header Section
                if  section==0 {
                    itemSize=CGSize(width: itemSize!.width, height:HEADERHEIGHT)
                }
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: (itemSize?.width)!, height: (itemSize?.height)!).integral
                
                if section == 0 && index == 0 {
                    attributes.zIndex = 1024;
                } else  if section == 0 || index == 0 {
                    attributes.zIndex = 1023
                }
                
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = self.collectionView!.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = self.collectionView!.contentOffset.x
                    attributes.frame = frame
                }
                
                sectionAttributes.add(attributes)
                
                xOffset += (itemSize?.width)!
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += (itemSize?.height)!
                }
            }
            if (self.itemAttributes == nil) {
                self.itemAttributes = NSMutableArray(capacity: self.collectionView!.numberOfSections)
            }
            self.itemAttributes .add(sectionAttributes)
        }
        if ((self.itemAttributes.lastObject as AnyObject).count)>0{
        let attributes : UICollectionViewLayoutAttributes = (self.itemAttributes.lastObject as AnyObject).lastObject as! UICollectionViewLayoutAttributes
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        } else {
            self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return self.contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        let fd:NSArray=self.itemAttributes
        let fd1:NSArray=fd[indexPath.section] as! NSArray
        let ca:UICollectionViewLayoutAttributes=fd1 .object(at: indexPath.row) as! UICollectionViewLayoutAttributes
        return ca
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if self.itemAttributes != nil {
            
            
            for section in self.itemAttributes {
                
                let sectionw:NSArray=section as! NSArray
                let filteredArray  =  sectionw.filtered(
                    using: NSPredicate(block: { (evaluatedObject, bindings) -> Bool in
                        return rect.intersects( (evaluatedObject as! UICollectionViewLayoutAttributes) .frame)
                    })
                    ) as! [UICollectionViewLayoutAttributes]
                
                
                attributes.append(contentsOf: filteredArray)
                
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    func getWidthContent() ->CGFloat {
    
        var contentWidth:CGFloat=0
        var xOffset:CGFloat=0
        let yOffset:CGFloat=0
        var column=0
        for section in 0..<self.collectionView!.numberOfSections {
                numberOfColumns=self.collectionView!.numberOfItems(inSection: section)
            
            for index in 0..<numberOfColumns {
                var itemSize = (self.itemsSize[index] as AnyObject).cgSizeValue
                if  section==0 {
                    itemSize=CGSize(width: itemSize!.width, height: HEADERHEIGHT)
                }
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: (itemSize?.width)!, height: (itemSize?.height)!).integral
                
                if section == 0 && index == 0 {
                    attributes.zIndex = 1024;
                } else  if section == 0 || index == 0 {
                    attributes.zIndex = 1023
                }
                
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = self.collectionView!.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = self.collectionView!.contentOffset.x
                    attributes.frame = frame
                }
                
               // sectionAttributes.add(attributes)
                
                xOffset += (itemSize?.width)!
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                }
            }
        }
              return contentWidth
                    
        
    }
    
    
    
    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        return CGSize(width: CELLWIDTH, height: CELLHEIGTH)
    }
    
    func calculateItemsSize() {
        self.itemsSize = NSMutableArray(capacity: numberOfColumns)
        for index in 0..<numberOfColumns {
            self.itemsSize.add(NSValue(cgSize: self.sizeForItemWithColumnIndex(index)))
        }
    }
}
