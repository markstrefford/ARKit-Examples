//
//  ViewController.swift
//  AR-Portal
//
//  Based on code by Rayan Slim on 2017-08-31.
//  Modified for Colisseum experience by Mark Strefford (c) Timelaps AI Limited 2020
//
//  Colisseum panoramic image by Emil Persson, aka Humus and licensed under a Creative Commons Attribution 3.0 Unported License.
//  http://creativecommons.org/licenses/by/3.0/
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var planeDetected: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else {return}
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            self.addPortal(hitTestResult: hitTestResult.first!)
        } else {
            //
        }
    }
    
    func addPortal(hitTestResult: ARHitTestResult) {
        let portalScene = SCNScene(named: "Portal.scnassets/Portal.scn")
        let portalNode = portalScene!.rootNode.childNode(withName: "Portal", recursively: false)!
        let transform = hitTestResult.worldTransform
        let planeXposition = transform.columns.3.x
        let planeYposition = transform.columns.3.y
        let planeZposition = transform.columns.3.z
        portalNode.position = SCNVector3(planeXposition, planeYposition, planeZposition)
        self.sceneView.scene.rootNode.addChildNode(portalNode)
//        self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "top")
//        self.addPlane(nodeName: "floor", portalNode: portalNode, imageName: "bottom")
//        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "sideA")
//        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "sideB")
//        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "sideDoorA")
//        self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "sideDoorB")
//        self.addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "back")
        self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "posy")
        self.addPlane(nodeName: "floor", portalNode: portalNode, imageName: "negy")
        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "posx")
        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "negx")
        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "negz-a")
        self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "negz-b")
        self.addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "posz")
    }
    
    func addPlane(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
//        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).png")
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).jpg")
        child?.renderingOrder = 200
    }
    
    func addWalls(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
//        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).png")
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).jpg")
        child?.renderingOrder = 200
        if let mask = child?.childNode(withName: "mask", recursively: false) {
            mask.geometry?.firstMaterial?.transparency = 0.000001
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.planeDetected.isHidden = true
        }
    }
    
}

