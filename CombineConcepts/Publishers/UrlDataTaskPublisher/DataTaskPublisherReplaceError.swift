//
//  DataTaskPublisherReplaceError.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 08.10.2023.
//

import SwiftUI
import Combine

struct DataTaskPublisherReplaceError: View {
    @State private var vm = ViewModel()
    var body: some View {
        VStack {
            HeaderView("DataTask Publisher", subtitle: "For Images", desc: "You can use datatask publisher to download images from a URL")
            vm.imageView
        }
        .font(.title2)
        .task {
            vm.fetch()
        }
    }
}

#Preview {
    DataTaskPublisherReplaceError()
}

extension DataTaskPublisherReplaceError {
    @Observable final class ViewModel {
        var imageView: Image?
        var cancellables = Set<AnyCancellable>()
        func fetch() {
            let url = URL(string: "https")!
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .tryMap { data in
                    guard let uiImage = UIImage(data: data) else {
                        throw ErrorForAlert(message: "Did not receive a valid image")
                    }
                    return Image(uiImage: uiImage)
                }
                .replaceError(with: Image(systemName: "xmark.circle.fill").resizable())
                .receive(on: RunLoop.main)
                .sink { [unowned self] image in
                    imageView = image
                }
                .store(in: &cancellables)
        }
    }
}
