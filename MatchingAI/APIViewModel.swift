import SwiftUI
import OpenAI

class  APIViewModel: ObservableObject {
    
    func makePronpt(input: Inputs) -> String {
        let prompt = """
        あなたはマッチングアプリのスペシャリストとして振る舞っってください。
        マッチングアプリのスペシャリストさん、初めまして！

        今回マッチングした相手への初回メッセージと今後のアプローチ方法についてアドバイスをください。

        相手のプロフィール情報は以下の通りです。

        【相手の基本情報】
        年齢：[\(input.age)]
        居住地：[\(input.location)]
        職業：[\(input.occupation)]
        
        【共通点】
        [\(input.similarities.joined(separator: ", "))]

        【自己紹介文】
        [\(input.selfIntroduction)]

        これらの情報から、最適な初回メッセージと、その後のアプローチ方法を具体的に教えてください。メッセージ例も複数いただけると嬉しいです！
        """
        return prompt
    }
    
    func fetchOpenAIResponse(input: String) async -> String {
        let openAI = OpenAI(apiToken: "")
        guard let message = ChatQuery.ChatCompletionMessageParam(role: .user, content: input) else { return "" }
        let query = ChatQuery(messages: [message], model: .gpt4_o)
        
        do {
            let result = try await openAI.chats(query: query)
            if let firstChoice = result.choices.first {
                switch firstChoice.message.role {
                case "assistant":
                        return firstChoice.message.content ?? "No response"
                default:
                    break
                }
            }
        } catch {
                return "エラー: \(error.localizedDescription)"
        }
        return "No response"
    }
}
