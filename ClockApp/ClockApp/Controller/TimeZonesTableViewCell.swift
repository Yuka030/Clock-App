import UIKit

class TimeZonesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(with location: Location){
        let locationCityAndCountry = location.locationName.components(separatedBy: "/")
        cityLabel.text = locationCityAndCountry[0]
        countryLabel.text = locationCityAndCountry[1]
    }
}
