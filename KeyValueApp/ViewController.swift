//
//  ViewController.swift
//  KeyValueApp
//
//  Created by Kristen Masada on 8/6/15.
//  Copyright (c) 2015 Nice Mohawk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var keyStore: NSUbiquitousKeyValueStore?
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        keyStore = NSUbiquitousKeyValueStore()
 
        if let savedValue = keyStore?.stringForKey("Text") {
            textField.text = savedValue
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyValueStoreDidChange:", name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: keyStore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func KeyValueStoreDidChange(notification: NSNotification) {
        textField.text = keyStore?.stringForKey("Text")
    }

    @IBAction func saveToIcloud() {
        keyStore?.setString(textField.text, forKey: "Text")
        keyStore?.synchronize()
    }

}

