//
//  PokemonImageLoader.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import Combine
import Foundation
import UIKit

@MainActor
final class PokemonImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var hasFailed = false

    private static let cache = NSCache<NSString, UIImage>()
    private let url: URL?
    private let cacheKey: NSString
    private var task: URLSessionDataTask?

    init(urlString: String) {
        self.url = URL(string: urlString)
        self.cacheKey = urlString as NSString
    }

    deinit {
        task?.cancel()
    }

    func loadIfNeeded() {
        guard image == nil, !isLoading else { return }

        if let cached = Self.cache.object(forKey: cacheKey) {
            image = cached
            return
        }

        load(retryCount: 2)
    }

    private func load(retryCount: Int) {
        guard let url else {
            hasFailed = true
            return
        }

        isLoading = true
        hasFailed = false

        task?.cancel()
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            Task { @MainActor in
                self.isLoading = false

                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                if let data, error == nil, (200..<300).contains(statusCode), let image = UIImage(data: data) {
                    Self.cache.setObject(image, forKey: self.cacheKey)
                    self.image = image
                    return
                }

                if retryCount > 0 {
                    try? await Task.sleep(for: .milliseconds(250))
                    self.load(retryCount: retryCount - 1)
                } else {
                    self.hasFailed = true
                }
            }
        }
        task?.resume()
    }
}
