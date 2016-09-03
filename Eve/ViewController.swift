import UIKit
import HomeKit
import Charts

class ViewController: UIViewController, HMHomeManagerDelegate {

    var homeManager: HMHomeManager?

    var temperatureCharacteristic: HMCharacteristic?

    @IBOutlet weak var lineChartView: LineChartView!

    var temperatures = [Double]() {
        didSet {
            setChartData()
        }
    }

    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }

    func setChartData() {
        var xVals = [String]()
        for i in 0 ..< temperatures.count {
            xVals.append("\(i)")
        }
        var yVals1 = [ChartDataEntry]()
        for i in 0 ..< temperatures.count {
            yVals1.append(ChartDataEntry(value: temperatures[i], xIndex: i))
        }
        let set1 = LineChartDataSet(yVals: yVals1, label: "First Set")
        set1.setCircleColor(UIColor.red) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 2.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        var dataSets = [LineChartDataSet]()
        dataSets.append(set1)
        let data = LineChartData(xVals: xVals, dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        lineChartView.data = data
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.temperatureCharacteristic?.readValue { _ in
                if self.temperatures.count > 20  {
                    self.temperatures.removeFirst()
                }
                self.temperatures.append(self.temperatureCharacteristic?.value as? Double ?? 0.0)
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
