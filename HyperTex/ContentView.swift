//
//  ContentView.swift
//  HyperTex
//
//  Created by Sythatic on 2023-10-02.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var openFile = false

    var body: some View {
        VStack {
            WebView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            Button("Open File") {
                self.openFile = true
            }
        }
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.html]) { result in
            do {
                let fileURL = try result.get()
                NotificationCenter.default.post(name: .openFile, object: fileURL)
            } catch {
                print("Failed to open file: \(error)")
            }
        }
    }
}

struct WebView: NSViewRepresentable {
    @State private var webView = WKWebView()

    func makeNSView(context: Context) -> WKWebView  {
        NotificationCenter.default.addObserver(forName: .openFile, object: nil, queue: .main) { notification in
            if let fileURL = notification.object as? URL {
                self.webView = WKWebView()
                self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
            }
        }
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
    }
}

extension Notification.Name {
    static let openFile = Notification.Name("openFile")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
