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
    
    var fromTextInput = ScrapsToShareData().array
    
    let vc = TextInputController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        vc.placeholderLabel.text = """
        
        According to Wikipedia, a Fold-in is the technique of taking two sheets of linear text (with the same linespacing), folding each sheet in half vertically and combining with the other, then reading across the resulting page
        
        Please enter the first page of your text here and then click "Second Page" to enter the second page
        
        """
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(fromTextInput)
        
        view.addSubview(vc.view)
        
        self.addChild(vc)
        
        let secondPageButton = UIBarButtonItem(title: "Second Page", style: .plain, target: self, action: #selector(secondPage))
        
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(onCamera))
        
        self.navigationItem.setRightBarButtonItems([secondPageButton, cameraButton], animated: true)
        
    }
    
    
    @objc func onCamera() {
        vc.onCamera()
        
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
        
        
        var halfArray = [[String]]()
        
        for (_, line) in linesByWordsArray.enumerated() {

            let fullLine = line.components(separatedBy: " ")
                           
            print(fullLine.split().left)
            
            halfArray.append(fullLine.split().left)
            
            

        }
        
        
        
        
        let vc = FoldinSecondPageViewController()
        
        vc.fromTextInput = self.fromTextInput
        
        vc.firstHalfArray = halfArray
        
        navigationController?.pushViewController(vc, animated: true)
        
        print(halfArray)
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


