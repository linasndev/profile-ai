//
//  ContentView.swift
//  profile-ai
//
//  Created by linasdev on 01/02/2025.
//

import SwiftUI
import PhotosUI
import ImagePlayground

struct ContentView: View {
  
  @Environment(\.supportsImagePlayground) var supportImagePlayground
  @State private var imageGenerationConcept: String = ""
  @State private var isPresentedImagePlayground: Bool = false
  
  @State private var avatarImage: Image?
  @State private var photosPickerItem: PhotosPickerItem?
  
  var body: some View {
    VStack(spacing: 32) {
      HStack(spacing: 20) {
        PhotosPicker(selection: $photosPickerItem, matching: .not(.screenshots)) {
          (avatarImage ?? Image(systemName: "person.circle.fill"))
            .resizable()
            .foregroundStyle(.mint)
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .clipShape(.circle)
        }
        
        VStack(alignment: .leading) {
          Text("Linas Nutautas")
            .font(.title.bold())
            
          Text("iOS Developer")
            .bold()
            .foregroundStyle(Color.secondary)
        }
        
        Spacer()
        
      }
      
      if supportImagePlayground {
        TextField("Enter avater description", text: $imageGenerationConcept)
          .font(.title3.bold())
          .padding()
          .background(.quaternary, in: .rect(cornerRadius: 16, style: .continuous))
        
        Button("Generate Image", systemImage: "sparkles") {
          isPresentedImagePlayground = true
        }
        .padding()
        .foregroundStyle(.mint)
        .fontWeight(.bold)
        .background(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(Color.mint, lineWidth: 2)
        )
      }
      
      Spacer()
      
    }
    .padding(30)
    .onChange(of: photosPickerItem) { _, _ in
      Task {
        if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
          if let image = UIImage(data: data) {
            avatarImage = Image(uiImage: image)
          }
        }
      }
    }
    .imagePlaygroundSheet(isPresented: $isPresentedImagePlayground, concept: imageGenerationConcept) { url in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          avatarImage = Image(uiImage: image)
        }
      }
    } onCancellation: {
      imageGenerationConcept = ""
    }
  }
}

#Preview {
  ContentView()
}
