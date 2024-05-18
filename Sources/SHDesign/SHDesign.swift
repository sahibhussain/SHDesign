//
//  SHDesign.swift
//  SHDesign
//
//  Created by Sahib Hussain on 22/06/23.
//

import Foundation
import AVFoundation
import SwiftSoup

public struct LinkPreviewModal: Codable {
    
    public let id: UUID
    public let url: URL
    public let imageURL: URL?
    public let title: String
    public let description: String
    
    public let videoURL: URL?
    public let price: String
    
    init(_ url: URL, imageURL: URL?, title: String, description: String, videoURL: URL?, price: String) {
        
        self.id = UUID()
        self.url = url
        self.imageURL = imageURL
        self.title = title
        self.description = description
        
        self.videoURL = videoURL
        self.price = price
        
    }
    
}

public class SHDesign {
    
    public static let shared = SHDesign()
    private init() {}
    
    public func playSystemAudio(_ id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
    
    public func fetchMetadata(of url: URL, completion: @escaping ([Element]) -> Void) {
        DispatchQueue.global(qos: .background)
            .async { [weak self] in
                URLSession.shared.dataTask(with: .init(url: url)) { data, response, error in
                    guard let data,
                          let htmlString = String(data: data, encoding: .utf8),
                          let metas = self?.parse(htmlString) else { completion([]); return }
                    completion(metas.array())
                }.resume()
            }
    }
    
    private func parse(_ html: String) -> Elements? {
        
        guard let doc = try? SwiftSoup.parse(html), let metas = try? doc.select("meta") else { return nil }
        return metas
        
//
//        do {
//            let doc = try SwiftSoup.parse(html)
//
//            let metas = try doc.select("meta")
//            var result: [String: [String]] = [:]
//            
//            metas.forEach { meta in
//                guard var propertyName = try? meta.attr("property"), let content = try? meta.attr("content") else { return }
//                if propertyName.isEmpty, let metaName = try? meta.attr("name") {
//                    propertyName = metaName
//                }
//                
//                var currentValues = result[propertyName, default: []]
//                currentValues.append(content)
//                result.updateValue(currentValues, forKey: propertyName)
//            }
//            if let title = try? doc.title() {
//                result["title"] = [title]
//            }
//            
//            return OpenGraphResponse(source: result)
//        } catch {
//            throw OpenGraphError.parsingError(error)
//        }
    }
    
}
