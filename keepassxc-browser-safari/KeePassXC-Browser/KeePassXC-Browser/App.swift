//
//  AppDelegate.swift
//  KeePassXC-Browser
//
//  Created by varjolintu on 21.9.2020.
//

import SwiftUI
import SafariServices

@main
struct KeePassXCBrowserApp: App {
    @State private var isEnabled: Bool = false
    var isEnabledInterceptor: Binding<Bool> {
        Binding<Bool>(
            get: { isEnabled },
            set: { _ in
                SFSafariApplication.showPreferencesForExtension(withIdentifier: "com.keepassxc.KeePassXC-Browser-Extension")
            }
        )
    }
    
    var body: some Scene {
        Window("KeePassXC Browser Extension", id: "KeePassXC") {
            ContentView(isEnabled: isEnabledInterceptor)
            .onAppear(perform: refreshState)
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in refreshState() }
            .frame(width: 400, height: 250)
        }
        .windowResizability(.contentSize)
    }
    
    func refreshState() {
        Task {
            do {
                let state = try await SFSafariExtensionManager.stateOfSafariExtension(withIdentifier: "com.keepassxc.KeePassXC-Browser-Extension")
                
                DispatchQueue.main.async {
                    isEnabled = state.isEnabled
                }
            } catch {
                print(error)
            }
        }
    }
}
