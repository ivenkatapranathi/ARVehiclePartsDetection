import UIKit
import SpriteKit
import SceneKit
import ARKit

class PartsInformation: SKScene {
   
    var Title: SKLabelNode?
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func renderDetails(_ data: [String: String]) {
        if let title = self.childNode(withName: "Title") as? SKLabelNode {
            title.text = data["PartName"]
        }
        if let description = self.childNode(withName: "Description") as? SKLabelNode {
            description.text = data["Description"]
            description.preferredMaxLayoutWidth = 400
            description.numberOfLines = 5
        }
        if let maintainance = self.childNode(withName: "Maintainance") as? SKLabelNode {
            maintainance.text = data["Maintance Details"]
            maintainance.preferredMaxLayoutWidth = 400
            maintainance.numberOfLines = 5
        }
    }
    
}
