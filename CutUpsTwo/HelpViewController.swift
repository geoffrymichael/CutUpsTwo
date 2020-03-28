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
        
//        view.backgroundColor = .white
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = UIColor.white
        } else {
            self.view.backgroundColor = UIColor.black
        }
        
                
        setupHelpView()
        
    }
    
   
       
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = UIColor.white
        } else {
            self.view.backgroundColor = UIColor.black
        }
    }
    
    var placeholder = """

    The Cut-up technique is a creativity process originally popularized by the DADAists. It involves cutting up existing text sources and rearranging them to inspire new ideas. The method was later used by William S. Burroughs, David Bowie, and Radiohead among others. See the wikipedia entry for a detailied history. https://en.wikipedia.org/wiki/Cut-up_technique
    
    Instructions:

    •) Paste in any copied text such as a poem, lyrics, a journal or diary entry-- even *news articles(although these may require more care in formatting into separate lines). Paste in any text you want
    
    •) Any text that is separated by a "return" will be counted as a new line

    •) You can use the "return" on the iOS keyboard to simulate cutting the text anywhere you want. Many source materials may already automatically have lines separated when you paste them in, but it could be fun to cut up lines even further, perhaps in-half 

    •) Feel free to type in extra lines on the fly or edit existing lines using the keyboard
    
    •) Copying and pasting from different sources is a good way to get interesting blends

    •) You can click on the 📷 icon to attempt to scan in physical sources of printed texts. Artists using the Cut-up technique used to cut out newspaper articles or other random text and cut them into their other sources. You can use this feature to mimic this process. Try to run the scan feature in a clean, well-lighted place. You can have the software try to automatically scan a document when it recognizses the text. This process will be indicated by a light blue overlay while trying to process and should result in more reliable results. However, it is more difficult to get a scan this way-- you must keep the camera still, the text must be clear, and you should be in a well-lighted environment. Alternatively, you can also manually press the shutter over an amount of text, and then outline the text you want to scan in the overlay that appears by dragging the corners of the selection box around your text. The results of these scans may be less accurate. When you are satisified with your scan, or scans, press the "SAVE" button to place the text in the text input screen. Please note, the analyzing process can take a few seconds. Make sure to look over and manually edit the resultant text for any inaccuracies. Once you are satisfied, send the text the editing board.
        
    •) When you are satisfied with your formatting, clicking the ✄ button will cut the text into lines and send them to the editing board

    •) You can also use iOS' built-in copy and paste to manually send a single line, words, or word to the editing board

    •) To begin rearranging the lines, click on the "Edit" button
    
    •) Rearranging can be done manually by clicking on a line and dragging it, or automatically by clicking the 🔀 button. You can press shuffle as many times as you wish
    
    •) You can go back to the input screen and add more content at any time
    
    •) Export your rearranged lines via the ⏍ button

    •) Press the 🗑 button to start over completely

    * REMEMBER TO ABIDE BY ANY LICENSING AND ATTRIBUTION REQUIREMENTS IF YOU USE THIRD PARTY SOURCES
    """
    
    lazy var helpView: UITextView = {
        let view = UITextView()
//        view.backgroundColor = UIColor.white
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


