//
//  UrlDataTaskPublisherIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 08.10.2023.
//

import SwiftUI
import Combine

struct UrlDataTaskPublisherIntro: View {
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
    }
}

#Preview {
    UrlDataTaskPublisherIntro()
}
extension UrlDataTaskPublisherIntro {
    @Observable final class ViewModel {
        var dataToView = Array<CatFact>()
        var cancellables = Set<AnyCancellable>()
        
        func fetch() {
            let url = URL(string: "https://cat-fact.herokuapp.com/facts")!
            URLSession.shared.dataTaskPublisher(for: url)
                .map { (data: Data, response: URLResponse) in
                    data
                }
                .decode(type: [CatFact].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { [unowned self] catFacts in
                    dataToView = catFacts
                }
                .store(in: &cancellables)
        }
    }
}

struct CatFact: Decodable, Identifiable {
    let id: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
    }
}
