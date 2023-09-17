//
//  UserSettingManager.swift
//  SplootIOS
//
//  Created by Sahib Hussain on 20/04/22.
//

import Foundation


class UserSettingManager {
    
    static let shared = UserSettingManager()
    private init(){}
    
    
    public func saveFile(_ file: String, value: Any) {
        
        if let arrayValue = value as? [[String: Any?]] {
            UserDefaults.standard.set(sanitize(arrayValue), forKey: file)
            return
        }
        
        if let dictValue = value as? [String: Any?] {
            UserDefaults.standard.set(sanitize(dictValue), forKey: file)
            return
        }
        
        UserDefaults.standard.set(value, forKey: file)
        
    }
    
    public func codableSaveFile<T: Codable>(_ file: String, value: T) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let data = try? encoder.encode(value) {
            UserDefaults.standard.set(data, forKey: file)
        }
    }
    
    public func saveBinaryFile(_ fileName: String, value: Data) -> URL? {
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = docDirectory?.appendingPathComponent(fileName) else {return nil}
        
        do {
            try value.write(to: fileURL)
            return fileURL
        } catch let error {
            print(error)
            return nil
        }
        
    }
    
    
    public func fileExist(_ file: String) -> Bool {
        let value = UserDefaults.standard.object(forKey: file)
        if value == nil {
            return false
        }
        return true
    }
    
    public func binaryFileExist(_ fileName: String) -> Bool {
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = docDirectory?.appendingPathComponent(fileName) else {return false}
        
        return FileManager.default.fileExists(atPath: fileURL.path)
        
    }
    
    
    public func retrieveValue(_ file: String) -> Any? {
        return UserDefaults.standard.value(forKey: file)
    }
    
    public func retrieveBinaryValue(_ fileName: String) -> Data? {
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = docDirectory?.appendingPathComponent(fileName) else {return nil}
        
        return try? Data(contentsOf: fileURL)
        
    }
    
    public func codableRetrieveValue<T: Codable>(_ file: String) -> T? {
        
        guard let data = UserDefaults.standard.value(forKey: file) as? Data else {return nil}
        return try? JSONDecoder().decode(T.self, from: data)
        
    }
    
    
    public func delete(_ file: String) {
        UserDefaults.standard.removeObject(forKey: file)
    }
    
    public func deleteBinary(_ fileName: String) {
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = docDirectory?.appendingPathComponent(fileName) else {return}
        
        try? FileManager.default.removeItem(at: fileURL)
        
    }
    
    
    private func sanitize(_ value: [[String: Any?]]) -> [[String: Any]] {
        var finalValue: [[String: Any]] = []
        for item in value {
            var temp: [String: Any] = [:]
            for (itemKey, itemValue) in item {
                if let stringValue = itemValue as? String {
                    temp[itemKey] = stringValue
                }
                if let numValue = itemValue as? NSNumber {
                    temp[itemKey] = numValue
                }
            }
            finalValue.append(temp)
        }
        return finalValue
    }
    
    private func sanitize(_ value: [String: Any?]) -> [String: Any] {
        var finalValue: [String: Any] = [:]
        for (key, val) in value {
            if value[key] != nil {
                finalValue[key] = val
            }
        }
        return finalValue
    }
    
    
}
