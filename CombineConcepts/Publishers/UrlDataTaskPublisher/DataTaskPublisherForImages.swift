//
//  DataTaskPublisherForImages.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 08.10.2023.
//

import SwiftUI
import Combine

struct DataTaskPublisherForImages: View {
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
        .alert(vm.errorForAlert?.title ?? "Error", isPresented: $vm.isAlertPresented) {
            Button("OK", role: .cancel) {  }
        } message: {
            Text(vm.errorForAlert?.message ?? "message")
        }
    }
}

#Preview {
    DataTaskPublisherForImages()
}

extension DataTaskPublisherForImages {
    @Observable final class ViewModel {
        var imageView: Image?
        var errorForAlert: ErrorForAlert?
        var cancellables = Set<AnyCancellable>()
        var isAlertPresented: Bool {
            get {
                errorForAlert != nil
            }
            set{
                errorForAlert = nil
            }
        }
    
    
        func fetch() {
            let url = URL(string: "https://cdn.freebiesupply.com/images/thumbs/2x/apple-logo.png")!
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .tryMap { data in
                    guard let uiImage = UIImage(data: data) else {
                        throw ErrorForAlert(message: "Did not receive a valid image")
                    }
                    return Image(uiImage: uiImage)
                }
                .receive(on: RunLoop.main)
                .sink { [unowned self] completion in
                    if case .failure(let error) = completion {
                        if error is ErrorForAlert {
                            errorForAlert = (error as! ErrorForAlert)
                        } else {
                            errorForAlert = ErrorForAlert(message: error.localizedDescription)
                        }
                    }
                } receiveValue: { [unowned self] image in
                    imageView = image
                }
                .store(in: &cancellables)
        }
    }
}
