//
//  AVIFDecoder.swift
//  
//
//  Created by Morten Bertz on 2020/07/16.
//

import Foundation
import Clibavif
import CoreGraphics

public class AvifDecoder{
    
    public struct AvifImage{
        public let image:CGImage
        public let presentationTime:TimeInterval
        public let duration:TimeInterval
    }
    
    
   public enum AvifDecoderError: Error{
        case wrongFileType
        case fileOpening
        case fileReading
        case fileParsing
        
    }
    
    let decoder = avifDecoderCreate()
 
    let url:URL
    
    var avifData:avifRWData
    
    public init(url:URL)throws {
        self.url=url
        
        guard let file=url.withUnsafeFileSystemRepresentation({path in
            return fopen(path, "rb")
        }) else{
            throw AvifDecoderError.fileOpening
        }
        defer {
            fclose(file)
        }
        
        fseek(file, 0, SEEK_END)
        let fileSize=ftell(file)
        fseek(file, 0, SEEK_SET)
        var data=avifRWData()
        avifRWDataRealloc(&data, fileSize)
        let read=fread(data.data, 1, fileSize, file)
        guard read > 0 else {
            avifRWDataFree(&data)
            throw AvifDecoderError.fileReading
        }
        
        var roData = unsafeBitCast(data, to: avifROData.self)
        guard avifPeekCompatibleFileType (&roData) == AVIF_TRUE else{
            avifRWDataFree(&data)
            throw AvifDecoderError.wrongFileType
        }
        self.avifData = data
    }
    
    public func readImages() throws -> [AvifImage]{
        
        avifDecoderSetIOMemory(decoder, self.avifData.data, self.avifData.size)
        let result=avifDecoderParse(decoder)
        guard result == AVIF_RESULT_OK, let dd=decoder?.pointee else {
            throw AvifDecoderError.fileParsing
        }
        
        let count=dd.imageCount
        var images:[AvifImage]=[AvifImage]()
        
        for idx in 0..<count{
            var timing=avifImageTiming()
            var result=avifDecoderNthImageTiming(decoder, UInt32(idx), &timing)
            guard result == AVIF_RESULT_OK else {break}
            result = avifDecoderNthImage(decoder, UInt32(idx))
            guard result == AVIF_RESULT_OK else {break}
            
            var image=dd.image.pointee
            let width=image.width
            let height=image.height
            
            var rgb=avifRGBImage()
            avifRGBImageSetDefaults(&rgb, &image)
            rgb.format=AVIF_RGB_FORMAT_ARGB
            rgb.depth=8
            
            avifRGBImageAllocatePixels(&rgb)
            avifImageYUVToRGB(&image, &rgb)
            
            defer{
                 avifRGBImageFreePixels(&rgb)
            }
            
            let info=CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
            let rgbData=Data(bytes: rgb.pixels, count: Int(rgb.rowBytes * rgb.height))
            
            guard let provider=CGDataProvider(data: rgbData as CFData),
                let cgImage=CGImage(width: Int(width), height: Int(height), bitsPerComponent: Int(rgb.depth), bitsPerPixel: Int(rgb.depth) * 4, bytesPerRow: Int(rgb.rowBytes), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: info, provider: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            else {break}
            
            let presentationTime=timing.pts
            let duration=timing.duration
            let avifImage=AvifImage(image: cgImage, presentationTime: presentationTime, duration: duration)
            images.append(avifImage)
            
        }
        
        return images
    }
    
        
    
    deinit {
        avifDecoderDestroy(decoder)
        avifRWDataFree(&avifData)
    }
}
