//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct Result: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var score: Score
    var isHomeGame: Bool
}

struct ContentView: View {
    @State private var results = [Result]()

    var body: some View {
        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                HStack {
                    Text("\(item.team) vs. \(item.opponent)")
                    Spacer()
                    Text("\(item.score.unc) - \(item.score.opponent)")
                }
                HStack {
                    Text("\(item.date)")
                    Spacer()
                    Text("\(item.isHomeGame ? "Home" : "Away")")
                }.font(.caption)
            }
        }
        .task {
            await loadData()
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
