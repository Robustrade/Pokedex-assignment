import SwiftUI

struct PokemonImageView: View {
    let url: String
    
    @State private var uiImage: UIImage?
    @State private var failed = false
    
    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else if failed {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            } else {
                ProgressView()
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        uiImage = nil
        failed = false
        
        guard let imageURL = URL(string: url) else {
            failed = true
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            if let image = UIImage(data: data) {
                uiImage = image
            } else {
                failed = true
            }
        } catch {
            if !Task.isCancelled {
                failed = true
            }
        }
    }
}
