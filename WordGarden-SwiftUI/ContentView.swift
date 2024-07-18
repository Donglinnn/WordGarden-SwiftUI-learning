//
//  ContentView.swift
//  WordGarden-SwiftUI
//
//  Created by Che-lun Hu on 2024/7/17.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0         // 一個單字中猜中了多少字母
    @State private var wordsMissed = 0          // 一個單字中錯失了多少字母
    @State private var currentWordIndex = 0     // 現在猜的是第幾個單字
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessesRemaining = 8
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "Another Word?"
    @FocusState private var textFieldIsFocused: Bool
    
    private let wordsToGuess = ["SWIFT", "DOG", "CAT"]
    private let maximumGuesses = 8
    
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
                .frame(height: 80)
                .minimumScaleFactor(0.5)
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
                        .keyboardType(.asciiCapable)    // 使用asciiCapable的形式，避免掉表情符號的輸入
                        .submitLabel(.done)             // 鍵盤右下角要按鍵要顯示什麼字
                        .autocorrectionDisabled()       // 隱藏打字會提示的單字
                        .textInputAutocapitalization(.characters)       // 不管大小寫都顯示大寫
                        .onChange(of: guessedLetter) {  // 如果猜字有變化的話
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted) // 把不是字母的字元無效化
                            guard let lastChar = guessedLetter.last else {  // 如果輸入的最後是nil就return
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()   // 否則就把最後輸入的字母當作猜測的字母
                        }
                        .onSubmit {                             // What happens if the "done" button in on the keyboard is pressed.
                            guard guessedLetter != "" else {    // 若沒有輸入就按done submit的話就return
                                return
                            }
                            guessALetter()
                            updateGamePlay()
                        }
                        .focused($textFieldIsFocused)   // 如果有focus在這個元件上才會顯示鍵盤
                    
                    Button("Guess a Letter") {
                        guessALetter()
                        updateGamePlay()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)    // 如果沒有猜字母的話按鍵不會作用
                }
            } else {
                Button(playAgainButtonLabel) {
                    // If all the words have been guessed...
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another Word?"
                    }
                    // Reset after a word was guessed or missed
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
                    lettersGuessed = ""
                    guessesRemaining = maximumGuesses
                    imageName = "flower\(guessesRemaining)"
                    gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
                    playAgainHidden = true
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
            guessesRemaining = maximumGuesses
        })
    }
    
    func guessALetter() {
        // Do these things:
        // 1. Close the keyboard.
        // 2. Plus the last letter guessed into the letterGuessed string.
        // 3. Iterate through all the letter in wordToGuess, if the letter is guessed correctly, reveal it.
        //    Otherwise, keep it underscore.
        // 4. Remove the last space out of the revealedWord string.
        
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
        
    }
    func updateGamePlay() {
        // Do these things:
        // 1. If the letter being guessed is not in the wordToGuess, 1 flower drop.
        // 2. Define two situations that proceeds to another word.
        // 3. If none of the 2 situations occur, change the text to showing how many guesses the user tried.
        // 4. Check if the index is out of range, if yes, change the status to restart mode.
        // 5. Reset the guessedLetter, clean the Textfield.
        
        if !wordToGuess.contains(guessedLetter) {
            guessesRemaining -= 1
            imageName = "flower\(guessesRemaining)"
        }
        // When do we play another word?
        // 1. When revealedWord no longer has "_"
        // 2. When guessRemaining == 0
        if !revealedWord.contains("_") {
            gameStatusMessage = "You've Guessed It! It took you \(lettersGuessed.count) Guesses to Guess the Word."
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false         // Replace the textfield and "Guess a Letter" button with "Another Word" button.
        } else if guessesRemaining == 0 {
            gameStatusMessage = "So Sorry. You're All Out of Guesses."
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false         // Replace the textfield and "Guess a Letter" button with "Another Word" button.
        } else {                            // Keep guessing
            gameStatusMessage = "You've made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
        }
        // If currentWordIndex is out of range, change "Another Word?" to "Restart Game?"
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage = gameStatusMessage + "\nYou've Tried All of the Words. Restart from the Beginning?"
        }
        guessedLetter = ""
    }
}

#Preview {
    ContentView()
}
