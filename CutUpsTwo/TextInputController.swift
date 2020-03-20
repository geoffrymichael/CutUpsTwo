//
//  TextInputController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/12/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit

class ScrapsToShareData {
    var array: [String] = []
}

class TextInputController: UIViewController, UITextViewDelegate, SendScrapsArrayDelegate {
    
    
    func onSend(scraps: [String]) {
        print(scraps)
        scrapsToShareData.array = scraps
    }
    
     
    var scrapsToShareData = ScrapsToShareData()
    
    var scrapsToShare = [String]()
    
//    var scrap: String? {
//        didSet {
//            previewLabel.text = scrap
//            previewLabel.textColor = .black
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        self.lyricTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: Selector(("handleSend")))
        self.navigationItem.leftBarButtonItem = edit
        

        let automaticButton = UIBarButtonItem(title: "Automatic", style: .plain, target: self, action: #selector(automaticCut))
        let helpButton = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(onHelp))
        
        self.navigationItem.setRightBarButtonItems([helpButton, automaticButton], animated: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(clipboardChanged),
        name: UIPasteboard.changedNotification, object: nil)        
        
                
        
        
        let vc = LyricsController()
        vc.scrapsSendDelegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(systemCut(notification:)), name: UIMenuController.didHideMenuNotification, object: nil)
        
      
        
        setupLyricTextView()
        
       
        

    }
    
    //UILabel needs to be subclassed in order to create edge insets for its text
//    class PreviewLabel: UILabel {
//        override func drawText(in rect: CGRect) {
//            let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//            super.drawText(in: rect.inset(by: insets))
//        }
//
//    }
    
//    lazy var previewLabel: PreviewLabel = {
//        let label = PreviewLabel()
//        label.textColor = .placeholderText
//        label.text = "Most Recently Manually Cut/Copied Line"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .white
//
//        return label
//    }()
    
    
    var placeholderLabel = UILabel()
    
    func textViewDidChange(_ textView: UITextView) {
           placeholderLabel.isHidden = !textView.text.isEmpty
       }
    
    lazy var lyricTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 16)
        
        let placeholderText =
                                """
                                To begin, COPY one of your random notes, a poem you wrote, your lyrics, an email, a journal or diary entry, a text from your iMessage, whatever text you want from other apps. Literally any text you can copy on your device can be a source (Of course making sure to abide by any relevent privacy and/or third party licensing requirements). The more varied the sources, the better, as this will lead to more creativity inspiring weirdness when they are blended together

                                PASTE that copied text HERE IN THIS SCREEN. To add more lines, just copy and paste something else. The more sources, and even the more random the sources, the better. Use an old grocery list perhaps. Or you can manually type in lines on the fly.
                                
                                When you are satisifed with your material and formatting, click "AUTOMATIC" to cut the texts into individual lines and they will be sent to the editing board

                                Click on "EDIT" to begin rearranging, whether by manually dragging lines around or randomly by clicking on the "SHUFFLE" button. Click it as many times as you want for more randomization
                                
                                To export your rearranged, "Cut-up", click the "SHARE" button. Text it to a friend. Paste it into your notes app to keep it. Whatever you want.

                                Press the "CLEAR" button to start over with a blank workspace

                                For more detailed instructions, click on "HELP"
                                """

        
        
        placeholderLabel.text = placeholderText
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (view.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        
        placeholderLabel.numberOfLines = 0
        view.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (view.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !view.text.isEmpty
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
    
        
        view.delegate = self

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    
    
    //ToDo, perhaps impliment landscape orientation contextual changes
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            
            print(UIDevice.current.orientation.isLandscape)
            
        })
    }
    
    
    func setupLyricTextView() {
        

//        view.addSubview(previewLabel)
//
//
        let margins = view.layoutMarginsGuide
//        NSLayoutConstraint.activate([
//           previewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
//           previewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
//           previewLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8),
//            previewLabel.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
        view.addSubview(lyricTextView)
        
        NSLayoutConstraint.activate([
            lyricTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            lyricTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            lyricTextView.widthAnchor.constraint(equalTo: margins.widthAnchor),
            lyricTextView.topAnchor.constraint(equalTo: margins.topAnchor),
            lyricTextView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        
        ])
        
        placeholderLabel.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
        
//        previewLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//
//        previewLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        previewLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//
//        previewLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
//        previewLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        previewLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        previewLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        previewLabel.centerXAnchor.constraint(equalTo: lyricTextView.centerXAnchor).isActive = true
        
        
        
                
//        lyricTextView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor).isActive = true
//        lyricTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
//        lyricTextView.widthAnchor.constraint(equalTo: previewLabel.widthAnchor).isActive = true
        
        
        
        //Create a container for buttons
//        let buttonContainer = UIView()
//        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
//        buttonContainer.backgroundColor = .darkGray
//
//        view.addSubview(buttonContainer)
//
//        buttonContainer.topAnchor.constraint(equalTo: lyricTextView.bottomAnchor, constant: 8).isActive = true
//        buttonContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        buttonContainer.leftAnchor.constraint(equalTo: lyricTextView.leftAnchor).isActive = true
//        buttonContainer.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
//
//
//
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send to Table", for: .normal)
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.backgroundColor = .systemGray
//
//
//        buttonContainer.addSubview(sendButton)
//
//
//
//        sendButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
//        sendButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor).isActive = true
//        sendButton.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor).isActive = true
//        sendButton.rightAnchor.constraint(equalTo: buttonContainer.centerXAnchor).isActive = true
//
        
        

        
    }
    
   
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func clipboardChanged(){
        let pasteboardString: String? = UIPasteboard.general.string
        if let theString = pasteboardString {
//            scrap = theString
//            scrapsToShare.append(theString)
            
            scrapsToShareData.array.append(theString)
            
            print(scrapsToShare)
            // Do cool things with the string
        }
    }
    
    @objc func handleSend() {
        let textVC = LyricsController()
        
        textVC.scrapsSendDelegate = self

//          let lyricRange = lyricTextView.selectedRange
//
//
//                lyricTextView.selectedRange = NSRange(location: 0, length: lyricRange.location)

//                lyricTextView.cut(self)
//
//                let cutText = UIPasteboard.general.string

//                let sanitizedCutText = cutText?.filter { !"\n".contains($0) }
        
//        let sanitizedCutText = UIPasteboard.general.string
//
//        scrapsToShare.append(sanitizedCutText ?? "No go")
        
        textVC.scraps = scrapsToShareData.array
        
        print(lyricTextView.text!)
        
        
//        scrap = ""

        navigationController?.pushViewController(textVC, animated: true)
        
//        print(sanitizedCutText as Any, "🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️")
        
    }
    
    //A function to parse text by carriage returns (by line)
    @objc func automaticCut() {
        lyricTextView.text.enumerateLines { line, _ in
            
            self.scrapsToShareData.array.append(line)

        }
        
        
        lyricTextView.text = ""
        
        
    }
    
    @objc func onHelp() {
        print("Help Pressed")
        
        let vc = HelpViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
}

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

