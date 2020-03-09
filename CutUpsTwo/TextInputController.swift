//
//  TextInputController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/12/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit

class TextInputController: UIViewController, UITextViewDelegate {
    
    
    var scrapsToShare = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
//        NotificationCenter.default.addObserver(self, selector: #selector(systemCut(notification:)), name: UIMenuController.didHideMenuNotification, object: nil)
        
    
        
        setupLyricTextView()
        
//        view.addSubview(lyricTextView)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
        return .portrait
    }
    
    
    lazy var scrapToSendView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .white
        
        view.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    lazy var lyricTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.white
        
        
        view.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        return view
    }()
    
    
    func setupLyricTextView() {
        
        view.addSubview(lyricTextView)
        
        
        
        
        
        
        lyricTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        lyricTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        lyricTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        lyricTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        view.addSubview(scrapToSendView)
        
        scrapToSendView.centerXAnchor.constraint(equalTo: lyricTextView.centerXAnchor).isActive = true
        scrapToSendView.bottomAnchor.constraint(equalTo: lyricTextView.topAnchor, constant: -8).isActive = true
        scrapToSendView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scrapToSendView.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
        
        
        //Create a container for buttons
        let buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.backgroundColor = .systemRed
        
        view.addSubview(buttonContainer)
        
        buttonContainer.topAnchor.constraint(equalTo: lyricTextView.bottomAnchor).isActive = true
        buttonContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        buttonContainer.leftAnchor.constraint(equalTo: lyricTextView.leftAnchor).isActive = true
        buttonContainer.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
//        buttonContainer.bottomAnchor.constraint(equalTo: lyricTextView.bottomAnchor, constant: 100).isActive = true
//        buttonContainer.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
//        buttonContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Cut", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.backgroundColor = .green
        
        
        buttonContainer.addSubview(sendButton)
        
        
        
        sendButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: buttonContainer.widthAnchor).isActive = true
        
        
        

        
    }
    
    @IBAction func systemCut() {
//        print(notification.description, "🧛‍♂️🧛‍♂️🧛‍♂️🧛‍♂️🧛‍♂️🧛‍♂️🧛‍♂️🧛‍♂️🧛‍♂️")
//
//        print(UIPasteboard.general.string)
//
//        scrapsToShare.append(UIPasteboard.general.string ?? "default")
        
        print("🧛‍♂️🧛‍♂️🧛‍♂️🧛‍♂️")
        
        
    }
    
    @objc func handleSend() {
        let textVC = LyricsController()

//          let lyricRange = lyricTextView.selectedRange
//
//
//                lyricTextView.selectedRange = NSRange(location: 0, length: lyricRange.location)
//
//
//
//                lyricTextView.cut(self)
//
//                let cutText = UIPasteboard.general.string
//
//
//
//
//
//
//
//                let sanitizedCutText = cutText?.filter { !"\n".contains($0) }
        
        let sanitizedCutText = UIPasteboard.general.string
        
        scrapsToShare.append(sanitizedCutText ?? "No go")
        
        textVC.scraps = scrapsToShare
        
        

        navigationController?.pushViewController(textVC, animated: true)
        
        print(sanitizedCutText as Any, "🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️🧝🏼‍♀️")
        
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
