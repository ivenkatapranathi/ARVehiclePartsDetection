//
//  ViewController.swift
//  VehiclePartsDetectionUsingAR
//
//  Created by Venkata Pranathi Immaneni on 3/9/21.
//

import UIKit
import ARKit
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var labelDetector: UILabel!
    @IBOutlet weak var restartVideoButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    var avplayer: AVPlayer?
    var currentObjectName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        

        let configuration = ARWorldTrackingConfiguration()
       
        
        
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "ARObjects", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        configuration.detectionObjects = referenceObjects
       
        sceneView.session.run(configuration)
//        self.render3DNode("EngineOil")
//        self.render3DVideo("Coolant")
        self.labelDetector.isHidden = true;
        self.restartVideoButton.isHidden = true;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(videoPlayOrPause))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.avplayer != nil) {
            self.avplayer?.pause()
        }
    }
    
    @objc func videoPlayOrPause() {
        if(self.avplayer != nil) {
            DispatchQueue.main.async {
                if(self.avplayer?.rate != 0) {
                    self.avplayer?.pause()
                } else {
                    self.avplayer?.play()
                }
            }
        }
    }
   
    @IBAction func restartVideo(_ sender: Any) {
        DispatchQueue.main.async {
            if(self.avplayer != nil) {
                self.avplayer?.seek(to: CMTime.zero)
                self.avplayer?.play()
                
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let objectAnchor = anchor as? ARObjectAnchor {
            if let objectName = objectAnchor.referenceObject.name {
                DispatchQueue.main.async { [self] in
                    self.labelDetectorTheme(partName: objectName)
                    if(currentObjectName == nil) {
                        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                            node.removeFromParentNode()
                        }
                        self.render3DNode(objectName)
                        self.render3DVideo(objectName)
                    } else if(currentObjectName != objectAnchor.referenceObject.name) {
                        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                            node.removeFromParentNode()
                        }
                        self.render3DNode(objectName)
                        self.render3DVideo(objectName)
                    }
                    currentObjectName = objectName
                }
            }
        }
    }
    
    func labelDetectorTheme(partName: String) {
        DispatchQueue.main.async {
            self.labelDetector.isHidden = false
            self.labelDetector.layer.backgroundColor = UIColor.white.cgColor
            self.labelDetector.text = "Vehicle Part Detected \(partName)"
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.dismissLabel), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc func dismissLabel() {
        DispatchQueue.main.async {
            self.labelDetector.isHidden = true;
        }
        
    }
        
    func render3DNode(_ detectedObjectName: String) {
        if let partInfo = VehicleInformationReader.SharedInst.getPartInfo(partName: detectedObjectName) {
            let plane = SCNPlane(width: 5, height: 5)
            plane.cornerRadius = plane.width / 8
            DispatchQueue.main.async {
                let spriteKitScene = SKScene(fileNamed: "ProductInfo") as? PartsInformation
                spriteKitScene?.renderDetails(partInfo)
                plane.firstMaterial?.diffuse.contents = spriteKitScene
                plane.firstMaterial?.isDoubleSided = true
                    plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                
                let planeNode = SCNNode(geometry: plane)
                planeNode.position = SCNVector3Make(4, 0, -8)
                self.sceneView.scene.rootNode.addChildNode(planeNode);
           
            }
        } else {
            print("part info not found")
        }
    }
    
    func render3DVideo(_ detectedObjectName: String) {
        DispatchQueue.main.async {
            self.restartVideoButton.isHidden = false
        }
        if let partInfo = VehicleInformationReader.SharedInst.getPartInfo(partName: detectedObjectName) {
                let plane = SCNPlane(width: 6 , height: 6)
                plane.cornerRadius = plane.width / 8
                DispatchQueue.main.async {
                
                if let partsVideoUrl = partInfo["VideoURL"] {
//                    let videoToPlay = AVPlayerItem(url: URL(fileURLWithPath: partsVideoUrl))
                    let videoToPlay = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: partsVideoUrl, ofType: "")!))
                    self.avplayer = AVPlayer(playerItem: videoToPlay)
                    
                    let videoNode = SKVideoNode(avPlayer: self.avplayer!)
                    
                    let videoScene = SKScene(size: CGSize(width: 2000, height: 2000))
                    videoScene.scaleMode = .aspectFit
                    
                    videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
                    videoNode.yScale = -2.0
                    videoNode.xScale = 1.5
                    videoScene.addChild(videoNode)
                    videoScene.backgroundColor = UIColor.black
                   
                    plane.firstMaterial?.diffuse.contents = videoScene
                    plane.firstMaterial?.isDoubleSided = true
                    
                    let planeNode = SCNNode(geometry: plane)
                    planeNode.position = SCNVector3Make(-3, 0, -8)
                    self.sceneView.scene.rootNode.addChildNode(planeNode);
                    self.avplayer?.play()
                }
                
            }
        } else {
            print("part info not found")
        }
    }
    
    

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
