//
//  ViewController.swift
//  Tests
//
//  Created by artur on 24.12.2019.
//  Copyright © 2019 Appodeal Inc. All rights reserved.
//

import UIKit
import Appodeal

class ViewController: UIViewController {
    
    private var addWindow: UIWindow?
    
    @IBOutlet private var actualEdge: UIButton!
    var edge: UIRectEdge = .bottom {
        didSet {
            let text = self.edge == .top ? "top" : "bottom"
            self.actualEdge.setTitle(text, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEdges()
        self.view.backgroundColor = .white
    }
    
    @IBAction func showNewWindow(_ sender: UIButton) {
        //        self.edge = self.edge == .top ? .bottom : .top
        //        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        if let window = UIWindowScene.focused.map(UIWindow.init(windowScene:)) {
            window.frame = UIScreen.main.bounds
            window.rootViewController = SecondViewController()
            window.makeKeyAndVisible()
            self.addWindow = window
        }
    }
    
    @IBAction func showAd() {
        Appodeal.showAd(.interstitial, rootViewController: self)
    }
    
    private func updateEdges() {
        if #available(iOS 11.0, *) {
            setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        }
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [edge]
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemRed
        self.view.addSubview(button)
        button.center = view.center
    }
    
    var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
        button.setTitle("Hide Window", for: .normal)
        return button
    }()
    
    @objc func closeWindow() {
        self.view.window?.isHidden = true
    }
}

extension UIWindowScene {
    static var focused: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first {
            $0.activationState == .foregroundActive && $0 is UIWindowScene
            } as? UIWindowScene
    }
}
