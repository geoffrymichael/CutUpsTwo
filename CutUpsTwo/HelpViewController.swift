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
    
    
    

    
    The Cut-up technique is a creativity process originally popularized by the DADAists. It involves cutting up existing text sources and rearranging them to inspire new ideas. The method was later used by William S. Burroughs, David Bowie, and Radiohead among others. See the wikipedia entry for a detailied history. https://en.wikipedia.org/wiki/Cut-up_technique
    
    Instructions:

    •) Paste in any copied text such as a poem, lyrics, a journal or diary entry-- even *news articles(although these may require more care in formatting into separate lines). Paste in any text you want
    
    •) Any text that is separated by a "return" will be counted as a new line

    •) You can use the "return" on the iOS keyboard to simulate cutting the text anywhere you want. Many source materials may already automatically have lines separated when you paste them in, but it could be fun to cut up lines even further, perhaps in-half. 

    •) Feel free to type in extra lines on the fly or edit existing lines using the keyboard
    
    •) Copying and pasting from different sources is a good way to get interesting blends
        
    •) When you are satisfied with your formatting, clicking on "Automatic" will cut the text into lines and send them to the editing board

    •) You can also use iOS' built-in copy and paste to manually send a single line, words, or word to the editing board.

    •) To begin rearranging the lines, click on the "Edit" button
    
    •) Rearranging can be done manually by clicking on a line and dragging it, or automatically by clicking "shuffle". You can press shuffle as many times as you wish
    
    •) You can go back to the input screen and add more content at any time
    
    •) Export your rearranged lines via the "Share" button.

    •) Press "Clear" to start over completely

    * REMEMBER TO ABIDE BY ANY LICENSING AND ATTRIBUTION REQUIREMENTS IF YOU USE THIRD PARTY SOURCES
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


