//
//  MenuView.swift
//  OpenAIProject
//
//  Created by christian on 1/30/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var profile: Profile
    @Binding var userTheme: UserTheme
    
    let defaultURL = URL(string: "https://www.google.com")!
    let openAIURL = URL(string: "https://openai.com/")!
    let dallEURL = URL(string: "https://openai.com/dall-e-2/")!
    let chatGPTURL = URL(string: "https://chat.openai.com/")!
    let openAIAPIURL = URL(string: "https://openai.com/api/")!
    let githubURL = URL(string: "https://www.github.com/bodhichristian")!
    let twitterURL = URL(string: "https://twitter.com/bodhichristian")!
    
    @State private var editing = false
    var body: some View {
        NavigationView {
            List {
                usernameView
                themePicker
                
                openAICredits
                developerCredits
                appLinks
            }
            .navigationTitle("Settings")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            })
        }
        .environmentObject(profile)
    }
}

extension SettingsView {
    // Username TextField
    private var usernameView: some View {
        Section(header: Text("Username"), footer: editButton) {
                HStack {
                    TextField(profile.username, text: $profile.username)
                        .foregroundColor(editing ? .primary : .gray)
                        .disabled(!editing)
                }
        }
    }
    
    // Wheel picker for selecting theme
    private var themePicker: some View {
        Section(header: Text("Theme")) {
            ThemePicker(selection: $userTheme)
                .padding(.vertical, -20)
                .padding(.horizontal, -10)
                .onChange(of: userTheme) { newTheme in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        profile.theme = newTheme
                        profile.save()
                        print("New theme saved.")
                    }
                }
        }
    }
    
    // Edit Button
    private var editButton: some View {
        Button {
            editing.toggle()
            profile.save()
        } label: {
            Text(editing ? "Done" : "Edit")
                .font(.caption)
                .foregroundColor(.blue)
        }
    }
    
    // OpenAI Credits & Divider
    private var openAICredits: some View {
        Section {
            HStack {
                // OpenAI Description
                Text("OpenAI is an AI research and deployment company. Their mission is to ensure that artificial general intelligence benefits all of humanity. OpenAI seeks to make AI systems more natural and safe to interact with.")
                    .font(.callout)
                // OpenAI Logo
                CircleImage(imageName: "chatGPT", width: 100, height: 100)
            }
            // OpenAI Links
            Link("OpenAI", destination: openAIURL)
            Link("DALL·E", destination: dallEURL)
            Link("ChatGPT", destination: chatGPTURL)
            Link("OpenAI API", destination: openAIAPIURL)
        } header: {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("OpenAI")
            }
        }
    }
    
    // Developer Credits
    private var developerCredits: some View {
        Section {
            HStack {
                Image("christian")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 4)
                Text("AskAI was developed by Christian Lavelle as a native, and approachable way to converse with ChatGPT and generate images with DALL·E.")
                    .font(.callout)
            }
            .padding(.vertical, 4)
            
            HStack {
                Link(destination: githubURL, label: {
                    HStack{
                        Image(colorScheme == .light ? "github-mark" : "github-mark-white")
                            .resizable().scaledToFit()
                            .frame(width: 20)
                        Image(colorScheme == .light ? "github" : "github-white")
                            .resizable().scaledToFit()
                            .frame(width: 65)
                        Text("/bodhichristian")
                    }
                })
            }
            HStack {
                Link(destination: twitterURL, label: {
                    HStack{
                        Image("twitter")
                            .resizable().scaledToFit()
                            .frame(width: 20)
                        Text("Twitter")
                            .fontWeight(.black)
                            .padding(.leading, 4)
                            .foregroundColor(Color("twitterBlue"))
                        Text("@bodhichristian")
                    }
                })
            }        } header: {
                Text("Developer")
            }
    }
 
    // URLs
    private var appLinks: some View {
        Section {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("AskAI Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
            
        } header: {
            Text("More")
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userTheme: .constant(.mint))
            .environmentObject(Profile())
    }
}
