import UIKit
import HomeKit

class ViewController: UIViewController, HMHomeManagerDelegate {

    var homeManager: HMHomeManager?

    var temperatureCharacteristic: HMCharacteristic?

    @IBOutlet weak var temperatureLabel: UILabel!

    var temperature = 0.0 {
        didSet {
            temperatureLabel.text = "\(temperature)"
        }
    }

    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.temperatureCharacteristic?.readValue { _ in
                self.temperature = self.temperatureCharacteristic?.value as? Double ?? 0.0
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        for home in manager.homes {
            for accessorie in home.accessories {
                for service in accessorie.services {
                        for characteristic in service.characteristics {
                            if characteristic.localizedDescription.contains("Temperature") {
                                temperatureCharacteristic = characteristic
                        }
                    }
                }
            }
        }
    }
}
