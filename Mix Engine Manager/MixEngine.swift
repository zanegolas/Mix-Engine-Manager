//
//  MixEngine.swift
//  Mix Engine Manager
//
//  Created by Zane Golas on 2/14/23.
//

import Foundation
import AppKit

class MixEngine {
    private var mixerEngine: [NSRunningApplication] = []
    
    private var executableURL = URL(fileURLWithPath: "/Library/Application Support/Universal Audio/Apollo/UA Mixer Engine.app/Contents/MacOS/UA Mixer Engine")
    private let launchTask = Process()
    
    var stateIconString = "bolt.circle"
    
    init() {
        updateStatus()
    }
    
    func updateStatus(){
        mixerEngine = NSRunningApplication.runningApplications( withBundleIdentifier : "com.uaudio.ua_mixer_engine")
        if (!isOff()){
            executableURL = mixerEngine[0].executableURL ?? URL(fileURLWithPath: "/Library/Application Support/Universal Audio/Apollo/UA Mixer Engine.app/Contents/MacOS/UA Mixer Engine")
            print("Update complete with executable URL set to: ", executableURL)
        }
        updateStateIcon()
    }
    
    func isOff() -> Bool {
        return mixerEngine.isEmpty
    }
    
    func terminateEngine(){
        updateStatus()
        if isOff() {
            print("Engine Is Not Running: No Processes To Kill")
            return
        }
        for instance in mixerEngine{
            instance.terminate()
            print("Termination Request Sent")
            sleep(1)
        }
        updateStatus()
        if isOff() {
            print("Mixer Engine Successfully Killed")
        } else {
            print("Failed To Kill Mixer Engine")
        }
    }
    
    func activateEngine(){
        updateStatus()
        if !isOff() {
            print("Engine Is Already Running")
            return
        }
        launchTask.executableURL = executableURL
        do {
            try launchTask.run()
        } catch {
            print("Unable To Start UA Mixer Engine")
        }
        sleep(1)
        self.updateStatus()
    }
    
    private func updateStateIcon(){
        if (isOff()){
            stateIconString = "bolt.slash.circle"
        } else {
            stateIconString = "bolt.circle"
        }
    }
    
    
    
}
