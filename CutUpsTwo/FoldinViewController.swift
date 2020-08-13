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
        
        var byLineArray = [String]()
        
        vc.lyricTextView.text.enumerateLines { line, _ in
            
            byLineArray.append(line)
   
        }
        
        var linesByWordsArray: [String] = []
        
        for (_, line) in byLineArray.enumerated() {
            linesByWordsArray.append(line)
        }
        
        
        var fullArray = [[String]]()
        
        for (_, line) in linesByWordsArray.enumerated() {

            let fullLine = line.components(separatedBy: " ")
                           
            print(fullLine.split().left)
            
            fullArray.append(fullLine.split().left)
            

        }
        
        
        print(fullArray)
//        let firstLine = byLineArray[3].components(separatedBy: " ")
//        
//        print(firstLine.count / 2)
//        print(firstLine.chunked(into: firstLine.count / 2)[0])
//        
//        print(firstHalfArray)
        
        
    }
    
}


extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}


