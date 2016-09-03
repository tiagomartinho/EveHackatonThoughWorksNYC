import UIKit
import HomeKit

class ViewController: UIViewController, HMHomeManagerDelegate {

    var homeManager: HMHomeManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }

    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        print("homeManagerDidUpdateHomes")
    }

    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        print("homeManagerDidUpdatePrimaryHome")
    }

    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        print("homeManagerdidAddhome")
    }

    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        print("homeManagerdidRemovehome")
    }
}
