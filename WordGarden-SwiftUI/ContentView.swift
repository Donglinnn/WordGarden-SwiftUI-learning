//
//  ContentView.swift
//  WordGarden-SwiftUI
//
//  Created by Che-lun Hu on 2024/7/17.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    
    private let wordsToGuess = ["SWIFT", "DOG", "CAT"]
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading) {
                    Text("Word Guessed: \(wordsGuessed)")
                    Text("Word Missed: \(wordsMissed)")
                }
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("Words in Game: \(wordsToGuess.count)")
                }
                
            }
            .padding()
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            // TODO: Switch to wordsToGuess[currentWord]
            Text(revealedWord)
                .font(.title)
            
            
            if playAgainHidden {
                HStack {
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.green, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)  // 使用asciiCapable的形式，避免掉表情符號的輸入
                        .submitLabel(.done)  // 鍵盤右下角要按鍵要顯示什麼字
                        .autocorrectionDisabled() // 隱藏打字會提示的單字
                        .textInputAutocapitalization(.characters) // 不管大小寫都顯示大寫
                        .onChange(of: guessedLetter) {  // 如果猜字有變化的話
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted) // 把不是字母的字元無效化
                            guard let lastChar = guessedLetter.last else { // 如果輸入的最後是nil就return
                                return
                            }
                            guessedLetter = String(lastChar).uppercased() // 否則就把最後輸入的字母當作猜測的字母
                        }
                        .focused($textFieldIsFocused)   // 如果有focus在這個元件上才會顯示鍵盤
                    
                    Button("Guess a Letter") {
                        textFieldIsFocused = false
                        lettersGuessed += guessedLetter  // 每次按此按鈕就把猜測的letters加上剛剛輸入的最後一個字母
                        revealedWord = ""
                        for letter in wordToGuess {
                            // check if letter in wordToGuess is in lettersGuessed
                            if lettersGuessed.contains(letter) {
                                // If yes, reveal it.
                                revealedWord += "\(letter) "
                            } else {
                                // If not, keep it underscore.
                                revealedWord += "_ "
                            }
                        }
                        revealedWord.removeLast()
                        guessedLetter = ""
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)  // 如果沒有猜字母的話按鍵不會作用
                }
            } else {
                Button("Another Word?") {
                    //TODO: Another Word Button action here
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear(perform: {   // onAppear指的是程式開啟的時候自動會做的事情
            wordToGuess = wordsToGuess[currentWordIndex]
            // Create a String From a Repeating Value
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
        })
    }
}

#Preview {
    ContentView()
}
