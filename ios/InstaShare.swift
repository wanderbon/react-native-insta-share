import Photos

@objc(InstaShare)
class InstaShare: NSObject {
    private let kInstagramURL = "instagram://"
    private let kAlertViewTitle = "101"
    private let kAlertViewMessage = "app_not_install"

    func postImageToInstagramWithCaption(imageInstagram: UIImage, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let instagramURL = NSURL(string: kInstagramURL)
        
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            if let lastAsset = fetchResult.firstObject {
                let localIdentifier = lastAsset.localIdentifier
                let instgramChoserLink = "instagram://library?LocalIdentifier=" + localIdentifier
                
                UIApplication.shared.open(NSURL(string: instgramChoserLink)! as URL, options: [:], completionHandler: nil)
            }
        }
        else {
            let stringURL = "http://itunes.apple.com/app/instagram/id389801252"
            let url = URL(string: stringURL)
            
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            let errorTemp = NSError(domain:"", code:101, userInfo:nil)
            reject(kAlertViewTitle, kAlertViewMessage, errorTemp)
        }
    }

    @objc(share:withResolver:withRejecter:)
    func share(uri: String, resolve: @escaping RCTPromiseResolveBlock,reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let backgroundImageURL = RCTConvert.nsurl(uri) else {
            let errorTemp = NSError(domain:"", code:102, userInfo:nil)
            return reject(kAlertViewTitle, "url_not_valid", errorTemp)
        }
        
        var image: UIImage? = nil

        do {
            let data = try Data(contentsOf: backgroundImageURL)
            image = UIImage(data: data)
        } catch {
            let errorTemp = NSError(domain:"", code:103, userInfo:nil)
            reject(kAlertViewTitle, "data_not_valid", errorTemp)
        }

        postImageToInstagramWithCaption(imageInstagram: image!, resolve: resolve, reject: reject)
    }
}
