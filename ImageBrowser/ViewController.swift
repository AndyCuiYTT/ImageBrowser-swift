//
//  ViewController.swift
//  ImageBrowser
//
//  Created by CuiXg on 2021/6/2.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let vc = XGImageBrowserController(imagesUrl: [], currentIndex: 3)
        self.present(vc, animated: true, completion: nil)
    }


}

