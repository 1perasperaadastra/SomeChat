//
//  ViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 12.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.log(#function)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.log(#function)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.log(#function)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.log(#function)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.log(#function)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.log(#function)
    }

    private func log(_ methodName: String) {
        Logger.info("\(Self.description()): \(methodName)")
    }
}

