//
//  AvifEncoder.swift
//  
//
//  Created by Morten Bertz on 2020/07/16.
//

import Foundation
import Clibavif

public class AvifEncoder{
    
    public enum AvifEncoderError:Error{
        case contextCreation
        case imageEncoding(avifError:Int)
        case imageWriting(avifError:Int)
    }
    
    public static let version:String = String(cString: avifVersion())
    
    public class var codecVersions:String {
        var outBuffer=[Int8].init(repeating: 0, count: 256)
        avifCodecVersions(&outBuffer)
        let versions=String(cString:outBuffer)
        return versions
    }
    
    
    lazy var  output: avifRWData = avifRWData()
    
    let encoder = avifEncoderCreate()
    let timeScale = 1000 //ms
    
    public init() {
        self.encoder?.pointee.timescale=UInt64(timeScale)
        self.encoder?.pointee.maxThreads=4
    }
    
    public func add(image:CGImage, duration:TimeInterval, isSingle:Bool = false) throws{
        let width=image.width
        let height=image.height
        let bitsPerPixel=image.bitsPerPixel
        let depth=8
        var cgImageBuffer=[UInt8].init(repeating: 0, count: width * height * bitsPerPixel / depth)
        let info=CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        guard let context=CGContext(data: &cgImageBuffer, width: width, height: height, bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: info.rawValue)
            else {
            throw AvifEncoderError.contextCreation
            
        }
        context.draw(image, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        let avifImage=avifImageCreate(Int32(width), Int32(height), Int32(depth), AVIF_PIXEL_FORMAT_YUV420)
        avifImage?.pointee.colorPrimaries=AVIF_COLOR_PRIMARIES_BT709
        avifImage?.pointee.transferCharacteristics=AVIF_TRANSFER_CHARACTERISTICS_SRGB
        avifImage?.pointee.matrixCoefficients=AVIF_MATRIX_COEFFICIENTS_BT709
        avifImage?.pointee.yuvRange=AVIF_RANGE_FULL
        
        
        withUnsafeMutablePointer(to: &cgImageBuffer[0], {buffer in
            
            var avifRGB:avifRGBImage=avifRGBImage()
            avifRGBImageSetDefaults(&avifRGB, avifImage)
            
            avifRGB.depth=UInt32(depth)
            avifRGB.format=AVIF_RGB_FORMAT_ARGB
            avifRGB.rowBytes=UInt32(image.bytesPerRow)
            avifRGB.pixels=buffer
            avifImageRGBToYUV(avifImage, &avifRGB)
        })
        
        let flags:avifAddImageFlags
        if isSingle{
            flags = AVIF_ADD_IMAGE_FLAG_SINGLE
        }
        else{
            flags = AVIF_ADD_IMAGE_FLAG_NONE
        }
        
        let result=avifEncoderAddImage(encoder, avifImage, UInt64(duration * Double(timeScale)), flags.rawValue)
        guard result == AVIF_RESULT_OK else{
            throw AvifEncoderError.imageEncoding(avifError: Int(result.rawValue))
        }
        
        avifImageDestroy(avifImage)
    }
    
    public func encode() throws -> Data{
        let result=avifEncoderFinish(encoder, &output)
        guard result == AVIF_RESULT_OK else{
            throw AvifEncoderError.imageWriting(avifError: Int(result.rawValue))
        }
        let data=Data(bytes: output.data, count: output.size)
        avifRWDataFree(&output)
        return data
    }
    
    public func encode(to url:URL) throws{
        try self.encode().write(to: url)
    }
    
    deinit {
        avifEncoderDestroy(encoder)
       
    }
    
    
}


public extension CGImage{
    var avifData:Data?{
        let encoder=AvifEncoder()
        try? encoder.add(image: self, duration: 1, isSingle: true)
        return try? encoder.encode()
    }
}
