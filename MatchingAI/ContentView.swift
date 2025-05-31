import SwiftUI
import NaturalLanguage // Natural Languageフレームワークを使用

// ---
// MARK: - メインビュー
// ---
struct ContentView: View {
    @State private var profileText: String = ""
    @State private var extractedKeywords: [String] = []
    @State private var suggestedMessage: String = ""
    @State private var suggestedTopics: [String] = []

    // 趣味のキーワード辞書 (簡単化のため一部抜粋)
    let hobbyKeywords: [String: String] = [
        "映画": "映画鑑賞",
        "読書": "読書",
        "旅行": "旅行",
        "カフェ": "カフェ巡り",
        "料理": "料理",
        "音楽": "音楽鑑賞",
        "スポーツ": "スポーツ観戦",
        "猫": "猫好き",
        "犬": "犬好き",
        "ゲーム": "ゲーム",
        "アニメ": "アニメ",
        "漫画": "漫画",
        "アウトドア": "アウトドア",
        "インドア": "インドア",
        "写真": "写真",
        "お酒": "お酒",
        "グルメ": "食べ歩き"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("相手のプロフィールを入力してください")
                        .font(.headline)

                    TextEditor(text: $profileText)
                        .frame(height: 150)
                        .border(Color.gray, width: 0.5)
                        .cornerRadius(5)
                        .padding(.bottom)

                    // MARK: - キーワード抽出ボタン
                    Button(action: processProfile) {
                        Text("プロフィールを分析")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)

                    // MARK: - 抽出されたキーワード
                    if !extractedKeywords.isEmpty {
                        Divider()
                        Text("抽出されたキーワード")
                            .font(.headline)
                        WrappingHStack(alignment: .leading) {
                            ForEach(extractedKeywords, id: \.self) { keyword in
                                Text("#\(keyword)")
                                    .font(.subheadline)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }
                        .padding(.vertical)
                    }

                    // MARK: - 初回メッセージ提案
                    if !suggestedMessage.isEmpty {
                        Divider()
                        Text("初回メッセージの提案")
                            .font(.headline)
                        Text(suggestedMessage)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(5)
                            .fixedSize(horizontal: false, vertical: true) // テキストが収まるように高さを調整
                        Button(action: {
                            UIPasteboard.general.string = suggestedMessage
                        }) {
                            Label("メッセージをコピー", systemImage: "doc.on.doc")
                                .font(.subheadline)
                        }
                        .padding(.top, 5)
                    }

                    // MARK: - デートの話題提案
                    if !suggestedTopics.isEmpty {
                        Divider()
                        Text("デートの話題提案")
                            .font(.headline)
                        ForEach(suggestedTopics, id: \.self) { topic in
                            Text("・\(topic)")
                                .padding(.vertical, 2)
                        }
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(5)
                    }
                }
                .padding()
            }
            .navigationTitle("プロフィール分析アプリ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - プロフィール処理ロジック
    private func processProfile() {
        extractedKeywords.removeAll()
        suggestedMessage = ""
        suggestedTopics.removeAll()

        // Natural Languageフレームワークを使ってトークン化
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = profileText
        var tokens: [String] = []
        tokenizer.enumerateTokens(in: profileText.startIndex..<profileText.endIndex) { tokenRange, _ in
            tokens.append(String(profileText[tokenRange]))
            return true
        }

        // キーワード抽出 (簡易的な文字列検索とNatural Languageの品詞タグ付けを併用)
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = profileText

        tagger.enumerateTags(in: profileText.startIndex..<profileText.endIndex, unit: .word, scheme: .lexicalClass) { tag, tokenRange in
            if let tag = tag, tag == .noun { // 名詞を抽出
                let word = String(profileText[tokenRange])
                // 定義済みの趣味キーワードとのマッチング
                if let mappedKeyword = hobbyKeywords.first(where: { word.contains($0.key) })?.value {
                    if !extractedKeywords.contains(mappedKeyword) {
                        extractedKeywords.append(mappedKeyword)
                    }
                } else if word.count > 1 && !extractedKeywords.contains(word) { // 2文字以上の名詞で、まだ抽出されていないもの
                    // 必要に応じて一般的な単語を除外するロジックを追加
                    if !["私", "あなた", "もの", "こと", "人", "場所", "時間", "方", "中"].contains(word) {
                        extractedKeywords.append(word)
                    }
                }
            }
            return true
        }
        
        // ユニークなキーワードのみを保持
        extractedKeywords = Array(Set(extractedKeywords)).sorted()

        // メッセージと話題の生成
        generateSuggestions()
    }

    // MARK: - メッセージと話題の生成ロジック
    private func generateSuggestions() {
        if extractedKeywords.isEmpty {
            suggestedMessage = "素敵なプロフィールですね！何か共通の話題が見つかると嬉しいです。"
            suggestedTopics = ["最近ハマっていることはありますか？", "休日はどのように過ごされていますか？", "行ってみたい場所はありますか？"]
            return
        }

        let firstKeyword = extractedKeywords.first ?? ""
        let randomKeyword = extractedKeywords.randomElement() ?? ""

        // 初回メッセージの提案
        suggestedMessage = """
        はじめまして！プロフィール拝見しました。\
        \(firstKeyword)がお好きなんですね！私も興味があるので、ぜひお話してみたいです！\
        もしよろしければ、少しお話ししませんか？😊
        """
        // 複数のキーワードがある場合、少しメッセージを調整
        if extractedKeywords.count > 1 {
            suggestedMessage = """
            はじめまして！プロフィール拝見しました。\
            \(firstKeyword)や\(extractedKeywords[1])など、素敵なご趣味をお持ちなんですね！\
            もしよろしければ、共通の話題でお話しませんか？\
            お返事お待ちしております！
            """
        }


        // デートの話題提案
        suggestedTopics.append("\(randomKeyword)について、最近何か面白いことはありましたか？")
        if extractedKeywords.count > 1 {
            let secondKeyword = extractedKeywords[1]
            suggestedTopics.append("\(secondKeyword)に関連するおすすめの場所やお店はありますか？")
        }
        suggestedTopics.append("もし\(randomKeyword)以外の趣味を見つけるとしたら、どんなことに挑戦してみたいですか？")
        suggestedTopics.append("お互いの価値観について、少しお話しませんか？")
        suggestedTopics.append("最近感動したことや、心に残っている出来事はありますか？")
    }
}

// ---
// MARK: - WrappingHStack (補助的なビュー)
// ---
// キーワードを折り返して表示するためのカスタムコンテナ
struct WrappingHStack: Layout {
    let alignment: HorizontalAlignment

    init(alignment: HorizontalAlignment = .leading) {
        self.alignment = alignment
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.width ?? 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.infinity)
            if currentX + subviewSize.width > containerWidth {
                // 次の行へ
                currentX = 0
                currentY += lineHeight
                totalHeight = currentY + subviewSize.height // 新しい行の高さを含む
                lineHeight = 0
            }
            currentX += subviewSize.width + 8 // スペーシング
            lineHeight = max(lineHeight, subviewSize.height)
            totalHeight = max(totalHeight, currentY + subviewSize.height) // 高さ更新
        }
        return CGSize(width: containerWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let containerWidth = bounds.width
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var lineHeight: CGFloat = 0
        var lineViews: [LayoutSubviews.Element] = []

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.infinity)
            if currentX + subviewSize.width > containerWidth {
                // 行の配置
                placeLine(lineViews: lineViews, in: bounds, currentY: &currentY, lineHeight: lineHeight, containerWidth: containerWidth)
                
                // 次の行へ
                currentX = bounds.minX
                currentY += lineHeight + 8 // 行間
                lineHeight = 0
                lineViews.removeAll()
            }
            lineViews.append(subview)
            currentX += subviewSize.width + 8 // スペーシング
            lineHeight = max(lineHeight, subviewSize.height)
        }
        // 最後の行を配置
        placeLine(lineViews: lineViews, in: bounds, currentY: &currentY, lineHeight: lineHeight, containerWidth: containerWidth)
    }
    
    private func placeLine(lineViews: [LayoutSubviews.Element], in bounds: CGRect, currentY: inout CGFloat, lineHeight: CGFloat, containerWidth: CGFloat) {
        var lineTotalWidth: CGFloat = 0
        for view in lineViews {
            lineTotalWidth += view.sizeThatFits(.infinity).width + 8 // スペーシング含む
        }
        lineTotalWidth -= 8 // 最後の要素のスペーシングは不要

        let startX: CGFloat
        switch alignment {
        case .leading:
            startX = bounds.minX
        case .center:
            startX = bounds.minX + (containerWidth - lineTotalWidth) / 2
        case .trailing:
            startX = bounds.minX + (containerWidth - lineTotalWidth)
        default:
            startX = bounds.minX
        }

        var xOffset = startX
        for view in lineViews {
            let subviewSize = view.sizeThatFits(.infinity)
            view.place(at: CGPoint(x: xOffset, y: currentY), proposal: ProposedViewSize(subviewSize))
            xOffset += subviewSize.width + 8
        }
    }
}


// MARK: - プレビュー
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
