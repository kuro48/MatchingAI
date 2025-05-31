//  ContentView.swift
import SwiftUI
import NaturalLanguage

struct Hobby: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let category: String
}

struct ContentView: View {
    @State private var profileText: String = ""
    @State private var extractedKeywords: [String] = []
    @State private var suggestedMessage: String = ""
    @State private var suggestedTopics: [String] = []
    @State private var selectedPreferences: [Hobby] = []
    @State private var showPreferenceOptions: Bool = false

    let maxSelection = 5

    let hobbies: [Hobby] = [
        // 音楽
        Hobby(name: "音楽鑑賞", icon: "🎵", category: "音楽"),
        Hobby(name: "ライブ鑑賞", icon: "🎤", category: "音楽"),
        Hobby(name: "カラオケ", icon: "🎙️", category: "音楽"),

        // 芸術
        Hobby(name: "映画鑑賞", icon: "🎬", category: "芸術"),
        Hobby(name: "美術館巡り", icon: "🖼️", category: "芸術"),
        Hobby(name: "舞台鑑賞", icon: "🎭", category: "芸術"),

        // 知識・教養
        Hobby(name: "読書", icon: "📚", category: "知識"),
        Hobby(name: "英会話学習", icon: "🗣️", category: "知識"),

        // グルメ
        Hobby(name: "カフェ巡り", icon: "☕", category: "グルメ"),
        Hobby(name: "料理", icon: "🍳", category: "グルメ"),
        Hobby(name: "ラーメン巡り", icon: "🍜", category: "グルメ"),

        // アウトドア
        Hobby(name: "旅行", icon: "✈️", category: "アウトドア"),
        Hobby(name: "登山", icon: "⛰️", category: "アウトドア"),
        Hobby(name: "キャンプ", icon: "🏕️", category: "アウトドア"),

        // エンタメ
        Hobby(name: "ゲーム", icon: "🎮", category: "エンタメ"),
        Hobby(name: "アニメ", icon: "🧸", category: "エンタメ"),
        Hobby(name: "YouTube鑑賞", icon: "📺", category: "エンタメ"),

        // 日常・生活
        Hobby(name: "ショッピング", icon: "🛍️", category: "日常"),
        Hobby(name: "ネイル", icon: "💅", category: "日常"),
        Hobby(name: "ファッション", icon: "👗", category: "日常"),
        Hobby(name: "散歩", icon: "🚶", category: "日常")
    ]

    var groupedHobbies: [String: [Hobby]] {
        Dictionary(grouping: hobbies, by: { $0.category })
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionCard(title: "気になる趣味を最大5つ選択（\(selectedPreferences.count)/\(maxSelection)選択中）") {
                        Button(action: {
                            withAnimation {
                                showPreferenceOptions.toggle()
                            }
                        }) {
                            HStack {
                                Text(showPreferenceOptions ? "閉じる" : "趣味を選択する")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: showPreferenceOptions ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                        }

                        if showPreferenceOptions {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(groupedHobbies.keys.sorted(), id: \.self) { category in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(category)
                                            .font(.subheadline)
                                            .fontWeight(.bold)

                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                                            ForEach(groupedHobbies[category] ?? []) { hobby in
                                                Button(action: {
                                                    if selectedPreferences.contains(hobby) {
                                                        selectedPreferences.removeAll { $0 == hobby }
                                                    } else if selectedPreferences.count < maxSelection {
                                                        selectedPreferences.append(hobby)
                                                    }
                                                }) {
                                                    HStack(spacing: 4) {
                                                        Text(hobby.icon)
                                                        Text(hobby.name)
                                                            .font(.footnote)
                                                            .lineLimit(1)
                                                    }
                                                    .padding(8)
                                                    .frame(maxWidth: .infinity)
                                                    .background(selectedPreferences.contains(hobby) ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(selectedPreferences.contains(hobby) ? Color.blue : Color.clear, lineWidth: 1)
                                                    )
                                                    .cornerRadius(6)
                                                }
                                                .disabled(!selectedPreferences.contains(hobby) && selectedPreferences.count >= maxSelection)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                    }

                    SectionCard(title: "相手のプロフィールを入力してください") {
                        TextEditor(text: $profileText)
                            .frame(height: 150)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }

                    if !extractedKeywords.isEmpty {
                        SectionCard(title: "抽出されたキーワード") {
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
                        }
                    }

                    if !suggestedMessage.isEmpty {
                        SectionCard(title: "初回メッセージの提案") {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(suggestedMessage)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(5)
                                Button(action: {
                                    UIPasteboard.general.string = suggestedMessage
                                }) {
                                    HStack {
                                        Image(systemName: "doc.on.doc")
                                        Text("メッセージをコピー")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                }
                            }
                        }
                    }

                    if !suggestedTopics.isEmpty {
                        SectionCard(title: "デートの話題提案") {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(suggestedTopics, id: \.self) { topic in
                                    Text("・\(topic)")
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("プロフィール分析アプリ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func generateSuggestions() {
        if extractedKeywords.isEmpty {
            suggestedMessage = "素敵なプロフィールですね！何か共通の話題が見つかると嬉しいです。"
            suggestedTopics = [
                "最近ハマっていることはありますか？",
                "休日はどのように過ごされていますか？",
                "行ってみたい場所はありますか？"
            ]
            return
        }

        let firstKeyword = extractedKeywords.first ?? ""
        let secondKeyword = extractedKeywords.dropFirst().first ?? ""

        if secondKeyword.isEmpty {
            suggestedMessage = "はじめまして！プロフィール拝見しました。\(firstKeyword)がお好きなんですね！私も興味があるので、ぜひお話してみたいです！もしよろしければ、少しお話ししませんか？😊"
        } else {
            suggestedMessage = "はじめまして！プロフィール拝見しました。\(firstKeyword)や\(secondKeyword)など、素敵なご趣味をお持ちなんですね！もしよろしければ、共通の話題でお話しませんか？お返事お待ちしております！"
        }

        suggestedTopics = [
            "\(firstKeyword)について、最近何か面白いことはありましたか？",
            "\(secondKeyword)に関連するおすすめの場所やお店はありますか？",
            "もし\(firstKeyword)以外の趣味を見つけるとしたら、どんなことに挑戦してみたいですか？",
            "お互いの価値観について、少しお話しませんか？",
            "最近感動したことや、心に残っている出来事はありますか？"
        ]
    }
}
