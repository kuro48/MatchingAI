//
//  FilledButton.swift
//  MatchingAI
//
//  Created by Richard .T on 2025/05/31.
//
import SwiftUI


struct FilledButton: View {
    let title: String
    let action: () -> Void
    let color: Color

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
