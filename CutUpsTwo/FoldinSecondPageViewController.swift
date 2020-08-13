//
//  FoldinSecondPageViewController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 8/12/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import Foundation
import UIKit

class FoldinSecondPageViewController: UIViewController{
    
    var firstHalfArray = [[String]]()
    
    let childVC = TextInputController()
    
    
    override func viewDidAppear(_ animated: Bool) {
        childVC.placeholderLabel.text = "Add a second page that will be folded together with he first"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(childVC.view)
        
        self.addChild(childVC)
        
        let foldInButton = UIBarButtonItem(title: "Foldin", style: .plain, target: self, action: #selector(foldIn))
        
        self.navigationItem.setRightBarButton(foldInButton, animated: true)
        
        
        print(firstHalfArray)
    }
    
    @objc func foldIn() {
        let vc = LyricsController()
        vc.lyricScraps.append("Cat")
        
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        print("Foldin has been pressed")
        
        splitSeccondAndJoinWithFirst()
        
        
    }
    
    func splitSeccondAndJoinWithFirst() {
        
        var combinedArray = [String]()
        
        var byLineArray = [String]()
             
             childVC.lyricTextView.text.enumerateLines { line, _ in
                 
                 byLineArray.append(line)
        
             }
             
             var linesByWordsArray: [String] = []
             
             for (_, line) in byLineArray.enumerated() {
                 linesByWordsArray.append(line)
             }
             
             
             var secondHalfArray = [[String]]()
             
             for (_, line) in linesByWordsArray.enumerated() {

                 let fullLine = line.components(separatedBy: " ")
                 
                 secondHalfArray.append(fullLine.split().right)
              
             }
        
        
        
        for (index, line) in firstHalfArray.enumerated() {
//            combinedArray.append(lineOne.joined(separator: " "))
            if index < secondHalfArray.count {
                let combinedLine = "\(line.joined(separator: " "))" + " \(secondHalfArray[index].joined(separator: " "))"
                combinedArray.append(combinedLine)
            }
            
        }
        
        print(combinedArray)
    }
    
    
    
}
