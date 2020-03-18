//
//  HelpViewController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 3/17/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITextViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
                
        setupHelpView()
        
    }
    
        
    var placeholder = """
    
    
    

    •) To get a quick idea of intended use, please check out these links:
    https://en.wikipedia.org/wiki/Cut-up_technique
    
    https://www.youtube.com/watch?v=m1InCrzGIPU

    Instructions:
    •) Paste in any copied text such as a poem or lyrics
    
    •) Any text that is separated by a "return" will be counted as a new line

    •) You can use the "return" on the keyboard to simulate cutting the text anywhere you want. Many source materials may already automatically have lines separated when you paste them in
    
    •) Copying and pasting from different sources is a good way to get interesting blends
        
    •) When you are satisfied with your formatting, clicking on "Automatic" will cut the text into lines and send them to the editing board
    
    •) You can also use iOS' built-in copy and paste to manually send a single line, words, or word to the editing board. If you use this method, the most recently sent line will show up in the preview window to help you keep track of your place

    •) To begin rearranging the lines, click on the "Edit" button
    
    •) Rearranging can be done manually by clicking on a line and dragging it, or automatically by clicking "shuffle"
    
    •) You can go back to the input screen and add more content at any time
    
    •) Export your rearranged lines via the "Share" button.

    •) Press "Clear" to start over completely
    """
    
    lazy var helpView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 16)
        view.text = placeholder
        
        view.isEditable = false
        
        view.isSelectable = true
        
        view.dataDetectorTypes = .all
        
        
        view.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func setupHelpView() {
        
        view.addSubview(helpView)
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            helpView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            helpView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            helpView.topAnchor.constraint(equalTo: margins.topAnchor),
            helpView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            
        ])
        
        
    }
}


