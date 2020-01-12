//
//  TextInputController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/12/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit

class TextInputController: UIViewController, UITextViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
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
        lyricTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
//        lyricTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        lyricTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        lyricTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
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
