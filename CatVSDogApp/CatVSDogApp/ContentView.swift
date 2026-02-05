//
//  ContentView.swift
//  CatVSDogApp
//
//  Created by Emiliano Cepeda on 11/12/24.
//
/*
 
 Aplicacion original creada por Mohammad Azam el 3/31/23
 Esta aplicacion analiza imagenes dentro de assets y predice si
 el animal en la imagen es un perro o un gato
 
 */

import SwiftUI
import CoreML

//Funcion agregada para la conversion de imagen a Pixel Buffer
extension UIImage {
    // https://www.hackingwithswift.com/whats-new-in-ios-11
    func toCVPixelBuffer() -> CVPixelBuffer? {
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
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
    
    let images = ["dog1", "cat2", "cat3", "cat4", "cat5", "cat1", "dog2", "dog3", "dog4", "dog5"]
    var imageClassifier: CatDogImageClassifier?
    @State private var currentIndex = 0
    @State private var classLabel: String = ""
    
    init() {
        do {
            imageClassifier = try CatDogImageClassifier(configuration: MLModelConfiguration())
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
        VStack {
            Image(images[currentIndex])
            Button("Predict") {
                
                // uiImage
                guard let uiImage = UIImage(named: images[currentIndex]) else { return }
                
                // pixel buffer
                guard let pixelBuffer = uiImage.toCVPixelBuffer() else { return }
                
                do {
                    let result = try imageClassifier?.prediction(image: pixelBuffer)
                    classLabel = result?.target ?? ""
                } catch {
                    print(error)
                }
                
            }.buttonStyle(.borderedProminent)
            
            Text(classLabel)
            
            HStack {
                
                Button("Previous") {
                    currentIndex -= 1
                }.disabled(!isPreviousButtonValid)
                
                Button("Next") {
                    currentIndex += 1
                }
                .disabled(!isNextButtonValid)
                .padding()
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
