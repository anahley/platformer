//
//  GameViewController.swift
//  platformer
//
//  Created by 90305539 on 11/19/18.
//  Copyright © 2018 Emir Sahbegovic. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SceneHome(size: view.bounds.size)
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true //hopefully this doesnt break everything
        
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape //make it landscape only for a wide platformer game
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
