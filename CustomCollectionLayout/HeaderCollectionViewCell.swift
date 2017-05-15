//
//  HeaderCollectionViewCell.swift
//  CustomCollectionLayout
//
//  Created by Ruslan on 5/01/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import UIKit

protocol CellDelegate {
    
    func on_deletePressed(_ sender:Any)
}

class HeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var l_title: UILabel!
    
    @IBOutlet weak var btn_dellete: UIButton!
    @IBOutlet weak var imgv_image: UIImageView!
    var delegated:CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func on_btnDeletePress(_ sender: Any) {
        delegated?.on_deletePressed(self)
    }
    
  

}
