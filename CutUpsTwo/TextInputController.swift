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
        
        let vc = LyricsController()
        vc.scrapsSendDelegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(systemCut(notification:)), name: UIMenuController.didHideMenuNotification, object: nil)
        
      NotificationCenter.default.addObserver(self, selector: #selector(clipboardChanged),
        name: UIPasteboard.changedNotification, object: nil)
        
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
        label.text = "Text Preview"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        
        return label
    }()
    

    
    lazy var lyricTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.white
        
        
        
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
        
        
        scrap = ""

        navigationController?.pushViewController(textVC, animated: true)
        
//        print(sanitizedCutText as Any, "🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️")
        
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
