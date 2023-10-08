//
//  UrlDataTaskPublisherError.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 08.10.2023.
//

import SwiftUI
import Combine

struct UrlDataTaskPublisherError: View {
    @State private var vm = ViewModel()
    var body: some View {
        VStack {
            HeaderView("UrlSession DataTaskPublisher", subtitle: "Intro", desc: "Urlsession has a dataTaskPublisher you can use to get data from a url and run it through a pipeline")
            List(vm.dataToView) { item in
                Text(item.text)
            }
        }
        .font(.title3)
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
    UrlDataTaskPublisherError()
}

extension UrlDataTaskPublisherError {
    @Observable final class ViewModel {
        var dataToView = Array<CatFact>()
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
            let url = URL(string: "https://cat-fact.herokuapp.com/facs")!
            URLSession.shared.dataTaskPublisher(for: url)
                .map { (data: Data, response: URLResponse) in
                    data
                }
                .decode(type: [CatFact].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { [unowned self] completion in
                    if case .failure(let error) = completion {
                        errorForAlert = ErrorForAlert(message: error.localizedDescription)
                    }
                } receiveValue: { [unowned self] catFacts in
                    dataToView = catFacts
                }
                .store(in: &cancellables)
        }
    }
}

struct ErrorForAlert: Error, Identifiable {
    let id = UUID()
    let title = "Error"
    var message = "Please try again later"
}
