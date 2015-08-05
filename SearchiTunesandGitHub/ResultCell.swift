//
//  ResultCell.swift
//  SearchiTunesandGitHub
//
//  Created by Dmitry Kuzin on 05.08.15.
//  Copyright (c) 2015 Dmitry Kuzin. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
   
    @IBOutlet weak var imgleft: UIImageView!
    @IBOutlet weak var imgright: UIImageView!
    @IBOutlet weak var titleleft: UILabel!
    @IBOutlet weak var titleright: UILabel!
    @IBOutlet weak var developerleft: UILabel!
    @IBOutlet weak var priceleft: UILabel!
    @IBOutlet weak var developerright: UILabel!
    @IBOutlet weak var priceright: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgright.layer.cornerRadius = 0.5 * imgright.bounds.size.width
         imgleft.layer.cornerRadius = 0.5 * imgleft.bounds.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func changeForFirst() {
        imgright.hidden = false
        titleright.hidden = false
        developerright.hidden = false
        priceright.hidden = false
        
        imgleft.hidden = true
        titleleft.hidden = true
        developerleft.hidden = true
        priceleft.hidden = true
    }
    func changeforSecond() {
        imgright.hidden = true
        titleright.hidden = true
        developerright.hidden = true
        priceright.hidden = true
        
        imgleft.hidden = false
        titleleft.hidden = false
        developerleft.hidden = false
        priceleft.hidden = false

    }

}
