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

    The Cut-up technique is a creativity process originally popularized by the DADAists. It involves cutting up existing text sources and rearranging them to inspire new ideas. The method was later used by William S. Burroughs, David Bowie, and Radiohead among others. See the wikipedia entry for a detailied history. https://en.wikipedia.org/wiki/Cut-up_technique.
    
    Instructions:

    •) Paste in any copied text such as a poem, lyrics, a journal or diary entry-- even *news articles(although these may require more care in formatting into separate lines). Paste in any text you want.
    
    •) Any text that is separated by a "return" will be counted as a new line.

    •) Pick a Cut-up option by clicking on the scissors icon. A single line is anything separated by a "carraige return". Most text pasted from the interenet will have new line formatting in them already. You can also use the iOS keyboard to add new line separations manually. The options of single words, every fifth word,  and every third word will split the text into their respective sizes. Once the text is cut it will be sent to the editing board which you can access by clicking the Edit button.

    •) Feel free to type in extra lines on the fly or edit existing lines using the keyboard.
    
    •) Copying and pasting from different sources is a good way to get interesting blends.

    •) You can click on the 📷 to input text from physical source materials. You can scan text on the fly or use a picture of a text source from your photo library.

    •) The random button will pull in a completely randomized snippet of text from a book from gutenberg.org. the fomratting will most likely need to be cleaned up manually.
        
    •) Once you have cut your initial text, click on Edit to go to the editing board.

    •) Rearranging can be done manually by dragging and dropping lines, or automatically by clicking the 🔀 button. You can press shuffle as many times as you wish.
    
    •) You can go back to the input screen and add more content at any time.
    
    •) Export your rearranged lines via the ⏍ button.

    •) Press the 🗑 button to start over completely.

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


