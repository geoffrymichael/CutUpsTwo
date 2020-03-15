//
//  ScrapTableViewCell.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/13/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit

class ScrapTableViewCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    var labelText: String? {
        didSet {
            lineTextLabel.text = labelText
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(lineTextLabel)
        
        lineTextLabel.font = lineTextLabel.font.withSize(30)
        
        lineTextLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineTextLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        lineTextLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
    }
    
    
    
    lazy var lineTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Stuff"
        
        return label
        
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
