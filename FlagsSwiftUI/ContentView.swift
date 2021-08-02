//
//  ContentView.swift
//  FlagsSwiftUI
//
//  Created by Alexander Bonney on 7/26/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    let countries: [String:String] = Bundle.main.decode("flags.json")
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.countries, id: \.name) { country in
                    NavigationLink {
                        DetailView(country: country)
                    } label: {
                        Image(country.alpha2Code.lowercased()).resizable().scaledToFit().frame(width: 40, height: 40).shadow(radius: 5)
                        Text(country.name)
                    }
                }
                if vm.countries.count == 0 {
                    Text("You're offline.").foregroundColor(.red)
                    ForEach([String](countries.keys).sorted(), id: \.self) { country in
                        NavigationLink {
                            Image(countries[country] ?? "questionmark")
                                .resizable()
                                .scaledToFit()
                                .shadow(radius: 10)
                                .padding()
                                .navigationBarTitle(country, displayMode: .inline)
                        } label: {
                            Image(countries[country] ?? "questionmark").resizable().scaledToFit().frame(width: 40, height: 40).shadow(radius: 5)
                            Text(country)
                        }
                    }
                }
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Spacer()
                        if vm.countries.count != 0 {
                            Text("\(vm.countries.count) countries in the list.").font(.caption)
                        } else {
                            Text("\(countries.count) countries in the list.").font(.caption)
                        }
                        Spacer()
                    }
                    Link(destination: URL(string: "https://restcountries.eu")!) {
                        Text("API")
                    }
                }
                
            }.navigationBarTitle("Flags")
                .onAppear {
                    vm.fetchData()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DetailView: View {
    var country: WelcomeElement
    @State private var showActivityView = false
    
    var languages: [String] {
        country.languages.map { language in
            language.name
        }
    }
    
    var currencies: [String] {
        country.currencies.map { currency in
            currency.code ?? "Unknown"
        }
    }
    
    var body: some View {
            List {
                Image(country.alpha2Code.lowercased())
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .padding()
                Text("**Native name:** \(country.nativeName)")
                if country.region.rawValue != "" {
                Text("**Region:** \(country.region.rawValue)")
                }
                if country.capital != "" {
                    Text("**Capital:** \(country.capital)")
                }
                Text("**Population:** \(country.population) people")
                Text("**Languages:** \(languages.joined(separator: ", "))")
                Text("**Currencies:** \(currencies.joined(separator: ", "))")
            }
        
        .navigationBarTitle(country.name, displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            showActivityView = true
        }, label: {
            Image(systemName: "square.and.arrow.up")
        }))
        .sheet(isPresented: $showActivityView) {
            showActivityView = false
        } content: {
            ActivityView(activityItems: [getJpegData(country.alpha2Code.lowercased()) as Any], applicationActivities: [])
        }
        
    }
    
    func getJpegData(_ image: String) -> Data? {
        guard let image = UIImage(named: image) else {
            print("image not found")
            fatalError()
        }
        
        return image.jpegData(compressionQuality: 1)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        //
    }
    
    
}
