import SwiftUI
import WebKit

@main
struct HyperTexApp: App {
    @State private var fileURL: URL?
    @State private var urlString: String = ""

    var body: some Scene {
        WindowGroup {
            ContentView(fileURL: $fileURL, urlString: $urlString)
        }
        
        .commands {
            /* CommandMenu("DEBUG") {
                Button("MORE DEBUG") { print("triggered debug") }
            } */
            CommandGroup(replacing: .newItem) {
                Button("Open") { openFile() }
            }
        }
    }

    private func openFile() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.html]

        openPanel.begin { result in
            if result == .OK, let selectedFileURL = openPanel.url {
                self.fileURL = selectedFileURL
            }
        }
    }
}

struct ContentView: View {
    @Binding var fileURL: URL?
    @Binding var urlString: String

    var body: some View {
        VStack {
            WebView(fileURL: $fileURL)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            /* ToolbarItem(placement: .primaryAction) {
                TextField("Enter a file path", text: $urlString, onCommit: {
                    if let url = URL(string: urlString) {
                        self.fileURL = url
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 256)
            } */
            ToolbarItem(placement: .primaryAction) {
                Button("Open") { openFile() }
            }
            /* ToolbarItem(placement: .primaryAction) {
                Button("Refresh") { fileURL = fileURL }
                .disabled(fileURL == nil)
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Inspector") { openInTextEditor() }
                .disabled(fileURL == nil)
            }
            ToolbarItem(placement: .primaryAction) {
                Button("DEBUG") {print("triggered debug")}
            } */
        }
    }

    private func openFile() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.html]

        openPanel.begin { result in
            if result == .OK, let selectedFileURL = openPanel.url {
                self.fileURL = selectedFileURL
            }
        }
    }

    private func openInTextEditor() {
        if let fileURL = fileURL {
            NSWorkspace.shared.open(fileURL)
        }
    }
}

struct WebView: NSViewRepresentable {
    @Binding var fileURL: URL?

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let fileURL = fileURL {
            nsView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        }
    }
}