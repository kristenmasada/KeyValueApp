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
    var localKeyStore: NSUserDefaults? = NSUserDefaults.standardUserDefaults()
    let iCloudKey = "iCloud Text Key"
    let LocalKey = "Local Text Key"
    
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
        if let savedString = iCloudKeyStore?.stringForKey(iCloudKey) {
            textField.text = savedString
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyValueStoreDidChange:", name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: iCloudKeyStore)
    }
    
    func keyValueStoreDidChange(notification: NSNotification) {
        textField.text = iCloudKeyStore?.stringForKey(iCloudKey)
    }
   
    func saveToiCloud() {
        iCloudKeyStore?.setString(textField.text, forKey: iCloudKey)
        iCloudKeyStore?.synchronize()
    }
    
    func localSetUp() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: iCloudKeyStore)
        
        if let savedString = localKeyStore?.stringForKey(LocalKey) {
            textField.text = savedString
        }
    }
    
    func saveLocally() {
        localKeyStore?.setObject(textField.text, forKey: LocalKey)
        localKeyStore?.synchronize()
    }

}

