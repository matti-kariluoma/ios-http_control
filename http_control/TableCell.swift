//
//  TableCell.swift
//  http_control
//
//  Created by Matti Kariluoma on 10/29/14.
//  Copyright (c) 2014 Kariluoma Industries. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell
{
    @IBOutlet
    var title: UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}