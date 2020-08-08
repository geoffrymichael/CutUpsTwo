//
//  FoldinViewController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 8/7/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import Foundation
import UIKit

class FoldinViewController: UIViewController {
        
    
    let vc = TextInputController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        vc.placeholderLabel.text = "First Page of Book Here"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(vc.view)
        
        self.addChild(vc)
        
        let secondPageButton = UIBarButtonItem(title: "Second Page", style: .plain, target: self, action: #selector(secondPage))
        
        self.navigationItem.rightBarButtonItem = secondPageButton
        
    }
    
    
    @objc func secondPage() {
        
        splitInHalf()
        
        
        print("second page pressed")
    }
    
    func splitInHalf() {
        
        var splitArray = [String]()
        
        vc.lyricTextView.text.enumerateLines { line, _ in
            
            splitArray.append(line)
   
        }
        
        
        
        let firstLine = splitArray[0].components(separatedBy: " ")
        
        print(firstLine.count / 2)
        print(firstLine.chunked(into: firstLine.count / 2)[0])
        
        
    }
    
}
