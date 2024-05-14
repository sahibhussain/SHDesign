//
//  SHDesign.swift
//  SHDesign
//
//  Created by Sahib Hussain on 22/06/23.
//


import AVFoundation

public struct SHDesign {
    
    static func playSystemAudio(_ id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
    
}
