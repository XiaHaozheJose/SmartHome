//
//  JS_CoreImage.swift
//  SmartHome
//
//  Created by 浩哲 夏 on 2018/1/6.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import AVFoundation
class JS_CoreImage: NSObject {
    
    // Singleton
    static let shared = JS_CoreImage()
    private override init(){}
    
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    // MARK:- 懒加载
    fileprivate lazy var session: (UIView, UIView) -> AVCaptureSession? = { (scanView, displayView) in
        
        // 1.获取摄像头设备对象
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else{return nil}
        // 2.让摄像头作为输入对象
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return nil
        }
        
        let output = AVCaptureMetadataOutput()
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        let session = AVCaptureSession()
        if session.canAddInput(input) && session.canAddOutput(output) {
            session.addInput(input)
            session.addOutput(output)
            
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.face]
            
            // 限定扫描区域
            let x: CGFloat = scanView.frame.origin.y / displayView.bounds.height
            let y: CGFloat = scanView.frame.origin.x / displayView.bounds.width
            let w: CGFloat = scanView.frame.height / displayView.bounds.height
            let h: CGFloat = scanView.frame.width / displayView.bounds.width
            output.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
        }
        // 添加预览图层
        let layer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = displayView.bounds
        displayView.layer.insertSublayer(layer, at: 0)
        self.previewLayer = layer
        return session
    }
    fileprivate var result: (()->())?
    
        var face: UIImage?
        
        
        
        
    func detect(scanView: UIView, displayView: UIView, result: @escaping ()->()) {
           session(scanView, displayView)?.startRunning()
            self.result = result
        }
}


extension JS_CoreImage:AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        removeQRCodeBorder()
        guard let resultObjects = metadataObjects as? [AVMetadataMachineReadableCodeObject] else {
            return
        }
        
        for result in resultObjects{
            drawQRCodeBorder(resultObject: result)
            print(result.stringValue!)
        }
    }
    
    
    /// 给二维码绘制边框
    ///
    /// - Parameter resultObject: 二维码数据
    private func drawQRCodeBorder(resultObject: AVMetadataMachineReadableCodeObject) {
        // corners中的坐标是数据坐标,仅仅机器可读,如果想要使用的话,需要使用预览图层进行转换
        guard let resultObject = previewLayer?.transformedMetadataObject(for: resultObject) as? AVMetadataMachineReadableCodeObject
            else {
                return
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        let path = UIBezierPath()
        for (index, corner) in resultObject.corners.enumerated() {
            
            let point = CGPoint(dictionaryRepresentation: corner as! CFDictionary) ??  CGPoint()
            if 0 == index {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.close()
        shapeLayer.path = path.cgPath
        previewLayer?.addSublayer(shapeLayer)
    }
    
    
    /// 移除二维码边框
    private func removeQRCodeBorder() {
        
        for layer in previewLayer?.sublayers ?? [] {
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
}
