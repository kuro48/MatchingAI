import SwiftUI

struct ProfileInputView: View {
    @Binding var age: Int
    @Binding var location: String
    @Binding var occupation: String
    let prefectures: [String]
    let occupations: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 年齢
            VStack(alignment: .leading) {
                Text("年齢")
                    .font(.subheadline)
                TextField("年齢を入力", value: $age, format: .number)
                    .keyboardType(.numberPad)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }

            // 居住地
            VStack(alignment: .leading) {
                Text("居住地（都道府県）")
                    .font(.subheadline)
                Picker("都道府県を選択", selection: $location) {
                    ForEach(prefectures, id: \.self) { prefecture in
                        Text(prefecture)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }

            // 職業
            VStack(alignment: .leading) {
                Text("職業")
                    .font(.subheadline)
                Picker("職業を選択", selection: $occupation) {
                    ForEach(occupations, id: \.self) { occupation in
                        Text(occupation)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }
        }
    }
}
