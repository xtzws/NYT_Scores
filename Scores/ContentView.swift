//
//  ContentView.swift
//  Scores
//
//  Created by Isaac Greene on 2024-07-01.
//

import SwiftUI

struct LineScore: Identifiable {
    let id = UUID()
    var score: String
}

struct ContentView: View {
    @State var lineScores: [LineScore] = Array(repeating: LineScore(score: ""), count: 4)
    
    let allOptions = ["NO SOLVE", "🟪🟪🟪🟪", "🟦🟦🟦🟦", "🟩🟩🟩🟩", "🟨🟨🟨🟨"]
    let scoreMapping: [String: Int] = [
        "NO SOLVE": 0,
        "🟪🟪🟪🟪": 4,
        "🟦🟦🟦🟦": 3,
        "🟩🟩🟩🟩": 2,
        "🟨🟨🟨🟨": 1
    ]
    @State var scores = [0, 0, 0, 0]
    let weights = [4, 3, 2, 1]
    
    var totalScore: Int {
        zip(scores, weights).reduce(0) { $0 + scoreMapping[allOptions[$1.0]]! * $1.1 }
    }
    
    var availableOptions: [[String]] {
        var selectedOptions = Set<String>()
        return scores.map { score in
            let selectedOption = allOptions[score]
            selectedOptions.insert(selectedOption)
            return allOptions.filter { !selectedOptions.contains($0) || $0 == selectedOption || $0 == "NO SOLVE"}
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<scores.count, id: \.self) { index in
                HStack {
                    Text("LINE \(index+1)")
                    Picker("SCORE", selection: Binding(
                        get: { scores[index] },
                        set: { newValue in
                            scores[index] = newValue
                            lineScores[index].score = allOptions[newValue]
                        }
                    )) {
                        ForEach(availableOptions[index], id: \.self) { option in
                            Text(option).tag(allOptions.firstIndex(of: option)!)
                        }
                    }
                }
            }
            Text("Score: \(totalScore)/30")
                .padding()
        }
        .onChange(of: scores) { newScores in
            for (index, newValue) in newScores.enumerated() {
                lineScores[index].score = allOptions[newValue]
            }
        }
    }
}

#Preview {
    ContentView()
}
