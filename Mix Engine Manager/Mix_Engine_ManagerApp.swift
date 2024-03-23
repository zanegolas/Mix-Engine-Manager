//
//  Mix_Engine_ManagerApp.swift
//  Mix Engine Manager
//
//  Created by Zane Golas on 2/14/23.
//

import SwiftUI
import BackgroundTasks
import LaunchAtLogin

//let mixerEngine = MixEngine()

@main
struct Mix_Engine_ManagerApp: App {
    @State var engineState: String = "Mix Engine Manager"
    @State var observer: NSKeyValueObservation?
    @StateObject var mixerEngine = MixEngine()
    
    var body: some Scene {
        MenuBarExtra(engineState, systemImage: mixerEngine.stateIconString) {
            MenuContent(mixerEngine: mixerEngine)
            .onAppear {
                observer = NSApplication.shared.observe(\.keyWindow) { x, y in
                    mixerEngine.updateStatus();
                }
            }
            
        }
        .menuBarExtraStyle(.window)
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            Image(systemName: "togglepower")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(20)
                .fontWeight(.bold)
                
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .red)
//                .foregroundStyle(configuration.isOn ? (primary: Color.white, secondary: Color.red) : (primary: Color.white, secondary: Color.blue))
                
                .rotationEffect(configuration.isOn ? .degrees(0) : .degrees(90))
                
                
        }.buttonStyle(PlainButtonStyle())
    }
}

struct MenuContent: View {
    @ObservedObject var mixerEngine: MixEngine
    @State private var launchAtLogin = LaunchAtLogin.isEnabled
    
    var body: some View {
        VStack {
            HStack {
                Button(role: .destructive, action: {NSApplication.shared.terminate(nil)}) {
                    Label("", systemImage: "xmark.square")
                        .font(.title)
                        
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
                .keyboardShortcut("q")
                
                Spacer()
            }
            Toggle(isOn: $mixerEngine.engineOff) {
                        Text("Custom Toggle")
                    .onTapGesture {
                        mixerEngine.toggleEngine()
                    }
                
                    }
                    .toggleStyle(CustomToggleStyle())
                    .offset(y: -20)
            
//            Button("Start UA Mixer Engine") {
//                mixerEngine.activateEngine()
////                engineState = "UA Engine On"
//            }.disabled(!mixerEngine.engineOff)
//            
//            Button("Stop UA Mixer Engine") {
//                mixerEngine.terminateEngine()
////                engineState = "UA Engine Off"
//            }.disabled(mixerEngine.engineOff)
            
               Toggle("Auto Launch", isOn: $launchAtLogin)
                    .toggleStyle(SwitchToggleStyle())
                    .font(.title2)
            
        }.padding(10)
            .frame(width: 200, height: 225)
    }
}
