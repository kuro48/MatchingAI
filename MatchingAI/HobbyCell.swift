import SwiftUI

struct HobbyCell: View {
    let hobby: Hobby // 表示するHobbyオブジェクト
    @Binding var selectedSimilarities: [String] // ContentViewから渡されるBinding
    let maxSelection: Int // 最大選択数

    // 選択状態を判定する計算プロパティ
    var isSelected: Bool {
        selectedSimilarities.contains(hobby.name)
    }

    // 無効状態を判定する計算プロパティ
    var isDisabled: Bool {
        !isSelected && selectedSimilarities.count >= maxSelection
    }

    var body: some View {
        Button(action: {
            // タップ時のアクション
            if isSelected {
                // 既に選択されていれば削除
                selectedSimilarities.removeAll { $0 == hobby.name }
            } else if selectedSimilarities.count < maxSelection {
                // 未選択で、まだ最大選択数に達していなければ追加
                selectedSimilarities.append(hobby.name)
            }
        }) {
            HStack(spacing: 4) {
                Text(hobby.icon) // 趣味のアイコン
                Text(hobby.name) // 趣味の名前
                    .font(.footnote)
                    .lineLimit(1) // 1行に制限
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            // 背景色の条件分岐もHobbyCell内で完結
            .background(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
            // ボーダーの条件分岐もHobbyCell内で完結
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
            )
            .cornerRadius(6)
        }
        // ボタンの有効/無効の条件もHobbyCell内で完結
        .disabled(isDisabled)
    }
}
