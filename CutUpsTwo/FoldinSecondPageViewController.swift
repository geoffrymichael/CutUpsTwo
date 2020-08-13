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
    
    
    var fromTextInput = ScrapsToShareData().array
    
    var firstHalfArray = [[String]]()
    
    
    
    let childVC = TextInputController()
    
    
    override func viewDidAppear(_ animated: Bool) {
        childVC.placeholderLabel.text = """
        
        Add a second page of text here that will be folded together with the first. Click on "Fold-in" to see the resultant text on the editing board. 
        
        """
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(childVC.view)
        
        self.addChild(childVC)
        
        let foldInButton = UIBarButtonItem(title: "Fold-in", style: .plain, target: self, action: #selector(foldIn))
        
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(onCamera))
        
        self.navigationItem.setRightBarButtonItems([foldInButton, cameraButton], animated: true)
        
        
        print(firstHalfArray)
        
        print(fromTextInput, "this is from the very first textinput controller" )
    }
    
    
    
    @objc func onCamera() {
        childVC.onCamera()
    }
    
    
    @objc func foldIn() {

        
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
        
        fromTextInput.append(contentsOf: combinedArray)
        
        
        let vc = LyricsController()
        
        vc.lyricScraps = fromTextInput
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}
