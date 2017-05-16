//
//  DataObjects.swift
//  CustomCollectionLayout
//
//  Created by Ruslan on 5/01/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import UIKit


class DataObjects: NSObject {
    
    static let sharedInstance=DataObjects()
    
    //MARK: DataStructure -----
    enum CellType:NSInteger{
        case String=0
        case CheckBox=1
        case Empty=2
    }
    
    
    struct HeaderItem {
        let hImageLink:String?
        let hTitle:String?
        let hIndex:NSInteger
    }
    
    struct CellItem {
        let cType:CellType
        let cTitle:(String,String)?
        let cStatus:Bool
    }
    
    //MARK: Parsed Array with Data -----
    struct ProductData{
        let productHeader:HeaderItem?
        let productParameters:[CellItem]?
        
    }

    public var productCompare:[ProductData]=[]
    public var allProducts:[ProductData]=[]
    
    //MARK: - parse Json File -----
    func parseData(data:NSArray)->[ProductData]{
        var allProductss:[ProductData]=[]
        for item in data {
            let dItem:NSDictionary=item as! NSDictionary
            let tempHeader:HeaderItem=HeaderItem.init(
                hImageLink: dItem.object(forKey: FieldName.PhotoLink.rawValue) as! String?,
                hTitle: dItem.object(forKey: FieldName.ModelName.rawValue) as! String?,
                hIndex: NSInteger(dItem.object(forKey: FieldName.ModelNumber.rawValue) as! String)!)
            
            // get all parameters of the model
            let componentArray = dItem.allKeys
            var productParametersTemp:[CellItem]=[]
            for item in componentArray {
                if (!isHeader(item as! String))  {
                    let value:String=String(format:"%@", dItem.object(forKey: item) as! CVarArg)
                    let cellItemTemp=CellItem.init(
                        cType: DataObjects.CellType.String,
                        cTitle: (item as! String, value),
                        cStatus: true)
                    productParametersTemp.append(cellItemTemp)
                }
            }
            
            let tempData:ProductData=ProductData(productHeader: tempHeader, productParameters: productParametersTemp)
            allProductss.append(tempData)
            
        }
        self.allProducts=allProductss
        return allProductss
       
        
    }
    
    private func isHeader(_ item:String)->Bool{
        if (item==FieldName.PhotoLink.rawValue||item==FieldName.ModelNumber.rawValue||item==FieldName.ModelName.rawValue){
            return true
        } else {
            return false
        }
        
    }
    
    //MARK: Init data structure -----
    func getData(result:@escaping (_ allProductss:[ProductData]) -> ()){
        
        DispatchQueue.global(qos: .utility).async {
        if let path = Bundle.main.path(forResource: "filedata", ofType: "json")
        {
            if let jsonData = NSData.init(contentsOfFile: path)
            {
                do {
                 let jsonResultAny = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    let jsonResult:NSArray = jsonResultAny as! NSArray
                    let returnData:[ProductData] = self.parseData(data:jsonResult )
                      result(returnData)
                      DispatchQueue.main.async {
                          print("File Parsed");
                          print(jsonResult)
                        }
                    
                } catch{
                        print("Somethig  Wrong!");
                }
            } else {
                print("Somethig  Wrong With JSON ! ");

            }
        } else {
            print("Somethig  Wrong With FILE ! ");
            
            }
            
        }
    }
    
    


    
}

//MARK: Public Parameters  -----

enum FieldName:String{
    case ModelName="ModelName"
    case PhotoLink="PhotoLink"
    case ModelNumber="ModelId"
    case NoName=""
}

public let HEADERHEIGHT:CGFloat=100
public let CELLWIDTH:CGFloat=100
public let CELLHEIGTH:CGFloat=30


