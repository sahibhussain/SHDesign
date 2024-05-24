//
//  File.swift
//  
//
//  Created by Sahib Hussain on 25/05/24.
//

import UIKit
import AVKit

public class SHImageCacheManager {
    
    public static let shared = SHImageCacheManager()
    
    private var assets: [String: UIImage] = [:]
    private init() {}
    
    public func localFetchAsset(for url: URL) -> UIImage? { assets[url.absoluteString] }
    
    public func fetchVideoThumbnail(for url: URL, completion: ((UIImage?) -> Void)? = nil) {
        
        if let image = assets[url.absoluteString] { completion?(image); return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            let asset = AVURLAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            var image: UIImage? = nil
            let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
            if let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) { 
                let localImage = UIImage(cgImage: imageRef)
                image = localImage
                self?.assets[url.absoluteString] = localImage
            }
            DispatchQueue.main.async { completion?(image) }
        }
        
    }
    
}

public extension UIImageView {
    
    func videoSnapshot(_ url: URL?, placeholder: UIImage) {

        self.image = placeholder
        guard let vidURL = url else { return }
        SHImageCacheManager.shared.fetchVideoThumbnail(for: vidURL) { [weak self] image in
            self?.image = image
        }
        
    }
    
}
