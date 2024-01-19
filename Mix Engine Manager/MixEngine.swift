//
//  MixEngine.swift
//  Mix Engine Manager
//
//  Created by Zane Golas on 2/14/23.
//

import Foundation
import AppKit

class MixEngine : ObservableObject {
    private var mixerEngine: [NSRunningApplication] = []
    
    private var executableURL = URL(fileURLWithPath: "/Library/Application Support/Universal Audio/Apollo/UA Mixer Engine.app/Contents/MacOS/UA Mixer Engine")
    
    var stateIconString = "bolt.circle"
    
    @Published var engineOff = true
    
    init() {
        print("Mix Engine Class Initialized")
        updateStatus()
    }
    
    func updateStatus(){
        mixerEngine = NSRunningApplication.runningApplications( withBundleIdentifier : "com.uaudio.ua_mixer_engine")
        if (!isOff()){
            executableURL = mixerEngine[0].executableURL ?? URL(fileURLWithPath: "/Library/Application Support/Universal Audio/Apollo/UA Mixer Engine.app/Contents/MacOS/UA Mixer Engine")
            print("Update complete with executable URL set to: ", executableURL)
        }
        print("Update status function was run")
        engineOff = mixerEngine.isEmpty
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
            if instance.terminate() {
                print("Termination Request Sent")
            } else {
                print("Termination Request Failed")
            }
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
        print("Activition Requested")
        updateStatus()
        if !isOff() {
            print("Engine Is Already Running")
            return
        }
        var launch_task = Process()
        launch_task.executableURL = executableURL
        do {
            try launch_task.run()
        } catch {
            print("Unable To Start UA Mixer Engine")
        }
        sleep(1)
        updateStatus()
    }
    
    private func updateStateIcon(){
        if (isOff()){
            stateIconString = "bolt.slash.circle"
        } else {
            stateIconString = "bolt.circle"
        }
    }
    
    
    
}
