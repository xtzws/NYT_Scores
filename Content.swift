//
//  Content.swift
//  Scores
//
//  Created by Isaac Greene on 2024-07-02.
//

import Foundation
import SwiftUI

struct LineScore: Identifiable {
    let id = UUID()
    var score: String
}

struct ChatView: View {
    @State var lineScores: [LineScore] = Array(repeating: LineScore(score: ""), count: 4)
    
    let options = ["NO SOLVE", "PURPLE 🟪", "BLUE 🟦", "GREEN 🟩", "YELLOW 🟨"]
    let scoreMapping: [String: Int] = [
        "NO SOLVE": 0,
        "PURPLE 🟪": 4,
        "BLUE 🟦": 3,
        "GREEN 🟩": 2,
        "YELLOW 🟨": 1
    ]
    @State var scores = [0, 0, 0, 0]
    let weights = [4, 3, 2, 1]

        var totalScore: Int {
            zip(scores, weights).reduce(0) { $0 + scoreMapping[options[$1.0]]! * $1.1 }
        }

    var body: some View {
        VStack {
            ForEach(0..<scores.count, id: \.self) { index in
                Picker("Select Score", selection: Binding(
                    get: { scores[index] },
                    set: { newValue in
                        scores[index] = newValue
                        lineScores[index].score = options[newValue]
                    }
                )) {
                    ForEach(0..<options.count) { optionIndex in
                        Text(options[optionIndex]).tag(optionIndex)
                    }
                }
            }
            
            // Non-editable text box displaying the summed up scores
            Text("Total Score: \(totalScore)")
                .font(.largeTitle)
                .padding()
        }
        .onChange(of: scores) { newScores in
            for (index, newValue) in newScores.enumerated() {
                lineScores[index].score = options[newValue]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

