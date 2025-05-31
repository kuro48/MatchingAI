import SwiftUI

struct HobbySelectionView: View {
    @Binding var similarities: [String] // ContentViewからバインディングで渡される
    let maxSelection: Int
    let groupedHobbies: [String: [Hobby]]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(groupedHobbies.keys.sorted(), id: \.self) { category in
                VStack(alignment: .leading, spacing: 8) {
                    Text(category)
                        .font(.subheadline)
                        .fontWeight(.bold)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                        // ここでHobbyCellを呼び出す
                        ForEach(groupedHobbies[category] ?? []) { hobby in
                            HobbyCell(
                                hobby: hobby,
                                selectedSimilarities: $similarities, // Bindingを渡す
                                maxSelection: maxSelection
                            )
                        }
                    }
                }
            }
        }
    }
}
