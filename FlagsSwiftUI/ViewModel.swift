//
//  ViewModel.swift
//  ViewModel
//
//  Created by Alexander Bonney on 7/26/21.
//

import Foundation


class ViewModel: ObservableObject {
    
    @Published var countries: Welcome = []
    
    func fetchData() {
        guard let url = URL(string: "https://restcountries.eu/rest/v2/all") else {
            return
        }
        
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                let decoded = try decoder.decode(Welcome.self, from: data)
                    DispatchQueue.main.async {
                        self.countries = decoded
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
