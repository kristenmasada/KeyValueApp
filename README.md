Hi, I'm Kristen––an iOS development newbie and Ben’s summer intern. Most recently, Ben assigned me the task of building a simple app that uses iCloud to store key-value data. 

As one would expect, I immediately looked for a tutorial on the subject. I was disappointed, however, to come up short: all of the tutorials I found were written in Objective-C and I––the newbie who only knows Swift––could only half understand what was going on.

Thankfully, I did eventually figure out how to do all of this in Swift. It wasn’t too bad, either.

I decided to build an app with a text field and button, so that a user can type a short message and save it to iCloud. I began by setting up [iCloud entitlements (see steps 1 & 2)] (http://code.tutsplus.com/tutorials/working-with-icloud-key-value-storage--pre-37542). 

I then opened my ViewController.swift file and declared and initialized an **NSUbiquitousKeyValueStore** object:

    var iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()

The NSUbiquitousKeyValueStore class allows you to save values of various types––NSNumber, NSString, NSDictionary, etc.––and associate them with a key. To save the user’s message for my app, I created an outlet for my text field and a void function to call the **setString:forKey:** and **synchronize** methods. setString:forKey: pairs the text field’s contents with a key, while synchronize saves the message to iCloud.

    let iCloudTextKey = “iCloudText”
    @IBOutlet weak var textField: UITextField!  

    …

    func saveToiCloud() {
        iCloudKeyStore?.setString(textField.text, forKey: iCloudTextKey)
        iCloudKeyStore?.synchronize()
    }

I later realized that I should display the last message the user saved upon launching the app. To do this, I made a void function that uses optional chaining and the **stringForKey:** method to check for and display a previously saved message. 

    func iCloudSetUp() {
        if let savedString = iCloudKeyStore?.stringForKey(iCloudTextKey) {
        textField.text = savedString
        }
    }

Within the same void function, I also registered for the **NSUbiquitousKeyValueStoreDidChangeExternallyNotification** notification so that my app could handle any changes made to the text field by other instances of the app while running. Using the **addObserver** method to do this also requires an additional function to take some sort of action. In my case, I made this function update the message in the text field.

    func iCloudSetUp() {
        ...
        NSNotificationCenter.defaultCenter().addObserver(self, selector: “ubiquitousKeyValueStoreDidChangeExternally:", name:  NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: iCloudKeyStore)
    }
    func ubiquitousKeyValueStoreDidChangeExternally() {
        textField.text = iCloudKeyStore?.stringForKey(iCloudTextKey)
    }

And that's it! Not too bad, right?
