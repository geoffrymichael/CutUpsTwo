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
    
    var scrap: String? {
        didSet {
            previewLabel.text = scrap
            previewLabel.textColor = .black
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: Selector(("handleSend")))
        self.navigationItem.leftBarButtonItem = edit
        

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Automatic", style: .plain, target: self, action: #selector(automaticCut))
        
        NotificationCenter.default.addObserver(self, selector: #selector(clipboardChanged),
        name: UIPasteboard.changedNotification, object: nil)        
        
            
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
            
        
        
        let vc = LyricsController()
        vc.scrapsSendDelegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(systemCut(notification:)), name: UIMenuController.didHideMenuNotification, object: nil)
        
      
        
        setupLyricTextView()
        
       
        

    }
    
    //UILabel needs to be subclassed in order to create edge insets for its text
    class PreviewLabel: UILabel {
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            super.drawText(in: rect.inset(by: insets))
        }
        
    }
    
    lazy var previewLabel: PreviewLabel = {
        let label = PreviewLabel()
        label.textColor = .placeholderText
        label.text = "Most Recently Manually Cut/Copied Line"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        
        return label
    }()
    
   
    
    var placeholder = """
    •) Paste any copied text here such as a poem or lyrics
    
    •) Any text that is separated by a "return" will be counted as a new line

    •) You can use the "return" on the keboard to simulate cutting the text anywhere you want. Many source materials may already automatically have lines separated when you paste them in
    
    •) Copying and pasting from different sources is a good way to get interesting blends
        
    •) When you are satisified with your formatting, clicking on "Automatic" will cut the text into lines and send them to the editing board
    
    •) You can also use iOS' copy and paste to manually send a single line, words, or word to the editing board

    •) To begin rearranging the lines, click on the "Edit" button
    
    •) Rearranging can be done manually by clicking on a line and dragging it, or automatically by clicking "shuffle"
    
    •) You can go back to the input screen and add more content at any time
    
    •) Export your rearranged lines via the "Share" button. Press "clear" to start over completely
    """
    
    var placeholderLabel = UILabel()
    
    lazy var lyricTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 16)
        
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.numberOfLines = 0
        
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (view.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        view.addSubview(placeholderLabel)
        
        placeholderLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (view.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !view.text.isEmpty
                    
        
        view.delegate = self

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    func textViewDidChange(_ textView: UITextView) {
           placeholderLabel.isHidden = !lyricTextView.text.isEmpty
       }
    
    //ToDo, perhaps impliment landscape orientation contextual changes
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            
            print(UIDevice.current.orientation.isLandscape)
            
        })
    }
    
    
    func setupLyricTextView() {
        

        view.addSubview(previewLabel)
        
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
           previewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
           previewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
           previewLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8),
            previewLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(lyricTextView)
        
        NSLayoutConstraint.activate([
            lyricTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            lyricTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            lyricTextView.widthAnchor.constraint(equalTo: previewLabel.widthAnchor),
            lyricTextView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 8),
            lyricTextView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        
        ])
        
        
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
            scrap = theString
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
        
        
        scrap = ""

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
    
}




#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct MainPreview: PreviewProvider {
    
    static var previews: some View {
//        Text("preview view")
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return TextInputController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
    }
    
}

//@available(iOS 13.0, *)
//struct SwiftLeeViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        SwiftLeeViewRepresentable()
//    }
//}
#endif
