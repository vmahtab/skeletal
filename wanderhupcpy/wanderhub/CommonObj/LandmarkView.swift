//
//  LandmarkView.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 4/12/24.
//

import Foundation
import SwiftUI



struct LandmarkView: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    @StateObject var itineraryEntries = LandmarkStore.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var landmark: Landmark
    @State var rating: Int = 3
    
    var body: some View {
        VStack{
            LandmarkInfo()
            
            RateMe()
            
            Spacer()
            ActionButtons()
        }
        .onAppear(){
            rating = landmark.rating ?? 3
        }
    }

    @ViewBuilder
    private func LandmarkInfo() -> some View {
        Text("\(landmark.name!)")
            .foregroundColor(Color(.systemBlue))
            .fontWeight(.bold)
            .font(.system(size: 24))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        if let message = landmark.message {
            Text("\(message)")
                .foregroundColor(Color(.systemGray))
                .fontWeight(.bold)
                .font(.system(size: 18))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private func RateMe()-> some View {
        HStack{
            Text("Rate Me:")
                .foregroundColor(Color(.systemBlue))
                .fontWeight(.bold)
                .font(.system(size: 18))
                .padding()
            Spacer()
            StarRatingView(rating: $rating)
                .padding()
                .accentColor(.yellow)
        }
        .padding()
        Button(action: {
            Task {
                await itineraryEntries.submitRating(rating: rating, id: landmark.id)
            }
        }) {
            Text("Submit Rating!")
                .font(Font.body)
        }
        .padding()
        .background(Color(.systemBlue))
        .foregroundStyle(.white)
        .clipShape(Capsule())
    }
    
    @ViewBuilder
    private func ActionButtons() -> some View {
        HStack{
            Button(action: {
                viewModel.itineraryDirectNavigation(landmark: landmark)
            }) {
                Text("View on Map")
                    .font(Font.body)
            }
            .padding()
            .background(Color(red: 0, green: 0.5, blue: 0))
            .foregroundStyle(.white)
            .clipShape(Capsule())
            
            Spacer()
            
            Button(action: {
                itineraryEntries.removeLandmark(id: landmark.id)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete")
                    .font(Font.body)
            }
            .padding()
            .background(Color(red: 0.5, green: 0, blue: 0))
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
        .padding()
    }

}


struct StarRatingView: View {
    @Binding var rating: Int // The rating value that the view is bound to

    var maximumRating = 5 // The maximum rating value
    var offImage: Image? // Image used when the star is not selected
    var onImage = Image(systemName: "star.fill") // Image used when the star is selected
    var offColor = Color.gray // Color used when the star is not selected
    var onColor = Color.yellow // Color used when the star is selected

    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }

    private func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}
