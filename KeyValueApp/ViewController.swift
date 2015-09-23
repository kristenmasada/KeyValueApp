//
//  ViewController.swift
//  KeyValueApp
//
//  Created by Kristen Masada on 8/6/15.
//  Copyright (c) 2015 Nice Mohawk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
    var defaultKeyStore: NSUserDefaults? = NSUserDefaults.standardUserDefaults()
    let iCloudTextKey = "iCloudText"
    let DefaultsTextKey = "DefaultsText"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iCloudSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iCloudSwitch.on = true
        iCloudSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchForiCloud() {
        if iCloudSwitch.on == true {
            saveButton.setTitle("Save to iCloud", forState: UIControlState.Normal)
            iCloudSetUp()
        } else {
            saveButton.setTitle("Save Locally", forState: UIControlState.Normal)
            localSetUp()
        }
    }
    
    @IBAction func saveText() {
        if iCloudSwitch.on == true {
           saveToiCloud()
        } else {
            saveLocally()
        }
    }

    func iCloudSetUp() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyValueStoreDidChange:", name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: iCloudKeyStore)
        iCloudKeyStore?.synchronize()
    }
    
    func keyValueStoreDidChange(notification: NSNotification) {
        if let savedString = iCloudKeyStore?.stringForKey(iCloudTextKey) {
            textField.text = savedString
        }
    }
   
    func saveToiCloud() {
        iCloudKeyStore?.setString(textField.text, forKey: iCloudTextKey)
        iCloudKeyStore?.synchronize()
    }
    
    func localSetUp() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: iCloudKeyStore)
        
        if let savedString = defaultKeyStore?.stringForKey(DefaultsTextKey) {
            textField.text = savedString
        }
    }
    
    func saveLocally() {
        defaultKeyStore?.setObject(textField.text, forKey: DefaultsTextKey)
        defaultKeyStore?.synchronize()
    }

}

