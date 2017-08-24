
import UIKit

class ViewController: UIViewController, ScrollableGraphViewDataSource {
    
    @IBOutlet var graphView: ScrollableGraphView!
    
    var numberOfItems = 12
    lazy var plotOneData: [Double] = self.generateRandomData(self.numberOfItems, max: 100, shouldIncludeOutliers: true)
    lazy var plotTwoData: [Double] = self.generateRandomData(self.numberOfItems, max: 80, shouldIncludeOutliers: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphView.dataSource = self
        setupGraph(graphView: graphView)
    }
    
    // ScrollableGraphViewDataSource
    // #############################
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        case "one":
            return plotOneData[pointIndex]
            
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "FEB \(pointIndex + 1)"
    }
    
    func numberOfPoints() -> Int {
        return numberOfItems
    }
    
    // Helper Functions
    // ################
    
    // When using Interface Builder, only add the plots and reference lines in code.
    func setupGraph(graphView: ScrollableGraphView) {
        let barPlot = BarPlot(identifier: "one")
        
        barPlot.barWidth = 25
        barPlot.barLineWidth = 1
        barPlot.barLineColor = UIColor.colorFromHex(hexString: "#777777")
        barPlot.barColor = UIColor.colorFromHex(hexString: "#555555")
        
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        barPlot.animationDuration = 1.5
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.shouldAnimateOnStartup = true
        
        graphView.rangeMax = 12
        graphView.rangeMin = 1
        
        // Add everything
        graphView.addPlot(plot: barPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        
    }
    
    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
