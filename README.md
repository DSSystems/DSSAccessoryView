# Chat accessory view for iOS 11 and Swift 4
In this project you will find a simple chat accessory view for iOS 11

The project has a UICollectionViewController as main view and at the bootom there is a chat accessory. The class that returns such accessory is DSSAccessoryView. This view contains thre main elements: an input text, a send button and an custom view where you can put one or more additional buttons.

How to use:

create an instance of DSSAccessoryView

let myChatAccessoryView = DSSAccessoryView()

or

let myChatAccessoryView = DSSAccessoryView(size: myAccessorySize)

this last constructor takes an additional value that determines the height of the input text and buttons. The default height is h = 36px, also the font size is determined by this height as h/2 - 2.

To add this accessory to your (UICollectionView) chat view controller, you need to set myChatAccessoryView as the accessory view that UICollectionView already have, i.e.,

override var inputAccessoryView: UIView? {
        return myChatAccessoryView
    }
    
Do not forget to set the canBecomeFirstResponder property to true in order to interact with the input text of the accessory.

The additional buttons are added by setting the accessories property as follows

myChatAccessoryView.accessories = [additionalView1, additionalView2, ...]

To interact with the send button you need implement the DSSDSSAccessoryViewDelegate delegate and of course set
myChatAccessoryView.delegate = self
Then the handler of the send button is

didPressedSendButton(textView: UITextView)

where textView is a reference to the input text view.

The following properties can be modified to customize the accessory

borderColor: UIColor // secondary color (UIColor.customGray as default, be careful, this color comes from an extension of UIColor)

blurryBackground: Bool // to add a blurry effect to the accessory background (without blurry effect the backgraund color is UIColor.white by default)

tintStyleColor: UIColor // main color of the accessory (UIColor.customTintColor as default, be careful ...)


