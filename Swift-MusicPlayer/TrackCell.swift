//
//  TrackCell.swift
//  Swift-MusicPlayer
//
//  Created by Tatsuhiko Akashi on 2014/10/12.
//  Copyright (c) 2014年 akatatsu. All rights reserved.
//

import UIKit
class TrackCell: UITableViewCell {
    @IBOutlet weak var playIcon: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}