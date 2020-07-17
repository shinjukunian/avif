import XCTest
@testable import avif

final class avifTests: XCTestCase {
    
    let outURL=URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("Image").appendingPathExtension("avifs")
    let roundTripURL=URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("RoundTrip").appendingPathExtension("avifs")
    
    lazy var imageURLS:[URL]={
        let currentURL=URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
        let imageURL=currentURL.appendingPathComponent("Resources", isDirectory: true).appendingPathComponent("testData", isDirectory: true)
           let imageURLs=try! FileManager.default.contentsOfDirectory(at: imageURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
               .sorted(by: {u1,u2 in
                   return u1.lastPathComponent.compare(u2.lastPathComponent, options:[.numeric]) == .orderedAscending
                   
               })
           
        XCTAssertGreaterThan(imageURLs.count, 1, "insufficient images loaded")

        return imageURLs
    }()
    

    func testVersion() {
        let version=AvifEncoder.version
        XCTAssert(version.count > 0)
    }
    
    func testEncoderVersion(){
        let codecVersion=AvifEncoder.codecVersions
        XCTAssert(codecVersion.isEmpty == false)
    }
    
    func testDecoding(){
        let currentURL=URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
        let imageURL=currentURL.appendingPathComponent("Resources", isDirectory: true).appendingPathComponent("Irvine_CA").appendingPathExtension("avif")
        
        do{
            let decoder=try AvifDecoder(url: imageURL)
            let images=try decoder.readImages()
            XCTAssert(images.isEmpty == false)
            
        }
        catch let error{
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testDecodingChimera(){
        let currentURL=URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
        let imageURL=currentURL.appendingPathComponent("Resources", isDirectory: true).appendingPathComponent("Chimera-AV1-8bit-768x432-1160kbps-6").appendingPathExtension("avif")
        
        do{
            let decoder=try AvifDecoder(url: imageURL)
            let images=try decoder.readImages()
            XCTAssert(images.isEmpty == false)
            XCTAssert(images.count == 1)
            guard let first=images.first else {XCTFail(); return}
            XCTAssert(first.image.width == 768)
            XCTAssert(first.image.height == 432)
            
        }
        catch let error{
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDecodingAnimation(){
        let currentURL=URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
        let imageURL=currentURL.appendingPathComponent("Resources", isDirectory: true).appendingPathComponent("star-8bpc").appendingPathExtension("avifs")
        
        do{
            let decoder=try AvifDecoder(url: imageURL)
            let images=try decoder.readImages()
            XCTAssert(images.isEmpty == false)
            XCTAssert(images.count > 1)
//            guard let first=images.first else {XCTFail(); return}
//            XCTAssert(first.image.width == 768)
//            XCTAssert(first.image.height == 432)
            
        }
        catch let error{
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDecodingAnimationAlpha(){
            let currentURL=URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
            let imageURL=currentURL.appendingPathComponent("Resources", isDirectory: true).appendingPathComponent("star-8bpc-with-alpha").appendingPathExtension("avifs")
            
            do{
                let decoder=try AvifDecoder(url: imageURL)
                let images=try decoder.readImages()
                XCTAssert(images.isEmpty == false)
                XCTAssert(images.count > 1)

                
            }
            catch let error{
                XCTFail(error.localizedDescription)
            }
        }
    
    
    func testEncoding(){
        let images=self.imageURLS.compactMap({url->CGImage? in
         guard let source=CGImageSourceCreateWithURL(url as CFURL, nil) else{return nil}
             XCTAssert(CGImageSourceGetCount(source) == 1, "Image Source has image count too high")
             return CGImageSourceCreateImageAtIndex(source, 0, nil)
        })
        
        XCTAssertEqual(images.count, self.imageURLS.count)
        let encoder=AvifEncoder(url: self.outURL)
        do{
            for image in images{
                try encoder.add(image: image, duration: 0.1)
            }
            try encoder.encode()
            try FileManager.default.removeItem(at: self.outURL)
        }
        catch let error{
            XCTFail(error.localizedDescription)
        }
    }
    
    
    
    func testRoundTrip(){
        let images=self.imageURLS.compactMap({url->CGImage? in
         guard let source=CGImageSourceCreateWithURL(url as CFURL, nil) else{return nil}
             XCTAssert(CGImageSourceGetCount(source) == 1, "Image Source has image count too high")
             return CGImageSourceCreateImageAtIndex(source, 0, nil)
        })
        
        XCTAssertEqual(images.count, self.imageURLS.count)
        
        let encoder=AvifEncoder(url: self.roundTripURL)
        do{
            for image in images{
                try encoder.add(image: image, duration: 0.1)
            }
            try encoder.encode()
            
            let decoder=try AvifDecoder(url: self.roundTripURL)
            let readImages=try decoder.readImages()
            XCTAssert(readImages.count > 0)
            XCTAssert(readImages.count == images.count)
            for (encoded, original) in zip(readImages, images){
                XCTAssert(encoded.duration == 0.1)
                XCTAssert(encoded.image.width == original.width)
            }
            
            try FileManager.default.removeItem(at: self.roundTripURL)
        }
        catch let error{
            XCTFail(error.localizedDescription)
        }
    }

    static var allTests = [
        ("testVersion", testVersion),
    ]
}
