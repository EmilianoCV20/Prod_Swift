//
//  ContentView.swift
//  appDeportes
//
//  Created by Emiliano Cepeda on 12/12/24.
//

import SwiftUI
import CoreML

// Extension para la conversión de UIImage a CVPixelBuffer
extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else { return nil }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
}

struct ContentView: View {
    let images = ["pelota1", "pelota2", "pelota3", "pelota4", "pelota5", "pelota6", "pelota7", "pelota8", "pelota9", "pelota10", "pelota11", "pelota12", "pelota13", "pelota14", "pelota15"]

    var imageClassifier: ClasificadorPelotas?
    @State private var currentIndex = 0
    @State private var classLabel: String = ""

    init() {
        do {
            imageClassifier = try ClasificadorPelotas(configuration: MLModelConfiguration())
        } catch {
            print("Error loading model: \(error)")
        }
    }

    var isPreviousButtonValid: Bool {
        currentIndex != 0
    }

    var isNextButtonValid: Bool {
        currentIndex < images.count - 1
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("Clasificador de Pelotas")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                Spacer()

                Image(images[currentIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)

                Text(classLabel)
                    .font(.headline)
                    .foregroundColor(.primary)

                Button("Predict") {
                    predictImage()
                }
                .buttonStyle(.borderedProminent)

                HStack(spacing: 20) {
                    Button("Previous") {
                        currentIndex -= 1
                    }
                    .disabled(!isPreviousButtonValid)

                    Button("Next") {
                        currentIndex += 1
                    }
                    .disabled(!isNextButtonValid)
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func predictImage() {
        guard let uiImage = UIImage(named: images[currentIndex]) else { return }
        guard let pixelBuffer = uiImage.toCVPixelBuffer() else { return }

        do {
            let result = try imageClassifier?.prediction(image: pixelBuffer)
            classLabel = result?.target ?? ""
        } catch {
            print("Prediction error: \(error)")
        }
    }
}

#Preview {
    ContentView()
}

