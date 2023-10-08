import SwiftUI
import WebKit

@main
struct HyperTexApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var fileURL: URL?
    
    var body: some View {
        VStack {
            WebView(fileURL: $fileURL)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            Button("Open File") {
                openFile()
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

struct WebView: NSViewRepresentable {
    @Binding var fileURL: URL?
    
    func makeNSView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let fileURL = fileURL {
            nsView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
