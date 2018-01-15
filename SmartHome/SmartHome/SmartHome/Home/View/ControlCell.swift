//
//  ControlCell.swift
//  iOT_Pract2
//
//  Created by 浩哲 夏 on 2018/1/2.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class ControlCell: UICollectionViewCell {
    
  
    @IBOutlet weak var controlTitle: UILabel!
    @IBOutlet weak var controlImage: UIImageView!
    @IBOutlet weak var baseView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = selectBgColor
        baseView.backgroundColor = normalBgColor
        baseView.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    
}

