//
//  Mix_Engine_ManagerApp.swift
//  Mix Engine Manager
//
//  Created by Zane Golas on 2/14/23.
//

import SwiftUI
import BackgroundTasks
import LaunchAtLogin

let mixerEngine = MixEngine()

@main
struct Mix_Engine_ManagerApp: App {
    @State var engineState: String = "Mix Engine Manager"
    
    var body: some Scene {
        MenuBarExtra(engineState, systemImage: mixerEngine.stateIconString) {
            
            Button("Start UA Mixer Engine") {
                mixerEngine.activateEngine()
                engineState = "UA Engine On"
            }.disabled(!mixerEngine.isOff())
            
            Button("Stop UA Mixer Engine") {
                mixerEngine.terminateEngine()
                engineState = "UA Engine Off"
            }.disabled(mixerEngine.isOff())
            
            Divider()
            LaunchAtLogin.Toggle("Launch On Login")
            
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil);
            }.keyboardShortcut("q")
            
        }
    }
}
