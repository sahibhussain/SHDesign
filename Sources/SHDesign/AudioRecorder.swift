//
//  AudioRecorder.swift
//  SahibDesign
//
//  Created by Sahib Hussain on 22/06/23.
//

import Foundation
import AVFoundation

protocol AudioRecorderDelegate {
    func didUpdateMeter(_ amplitude: Float)
    func didFinishRecording(success: Bool, fileURL: URL)
}

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    private var audioSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder? = nil
    private var timer: Timer? = nil
    
    public var delegate: AudioRecorderDelegate?
    
    static let shared = AudioRecorder()
    
    private override init() {}
    
    
    public func prepare() {
        requestMicPermission { [weak self] success in
            guard let self = self else {return}
            let audioFilename = self.getDocumentsDirectory().appendingPathComponent("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.isMeteringEnabled = true
                self.audioRecorder?.prepareToRecord()
            } catch {
                print(error)
            }
        }
    }
    
    private func requestMicPermission(_ completion: @escaping (Bool) -> Void) {
        
        switch audioSession.recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        default:
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default)
                try audioSession.setActive(true)
                audioSession.requestRecordPermission() { allowed in
                    completion(allowed)
                }
            } catch {
                completion(false)
            }
        }
        
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    public func record() {
        if audioRecorder?.isRecording == true {return}
        audioRecorder?.record()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAmplitude), userInfo: nil, repeats: true)
    }
    
    @objc private func updateAmplitude() {
        
        guard let audioRecorder = audioRecorder else {return}
        
        audioRecorder.updateMeters()
        
        let currentAmplitude = 1 - pow(10, (audioRecorder.averagePower(forChannel: 0) / 20))
        delegate?.didUpdateMeter(currentAmplitude)
        
    }
    
    
    public func stop() {
        timer?.invalidate()
        timer = nil
        audioRecorder?.stop()
    }
    
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let url = audioRecorder?.url else {return}
        delegate?.didFinishRecording(success: flag, fileURL: url)
    }
    
    
}
