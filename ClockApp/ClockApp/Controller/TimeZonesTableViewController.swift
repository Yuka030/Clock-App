import UIKit

class TimeZonesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var location: Location?
    var worldClock: WorldClock?
    var timeZoneIdentifiers: [String] = []
    var timeZones: [String] = []
    var currenTimeZone: TimeZone?
    
    @IBOutlet weak var searchText: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
        timeZones = getTimeZones(timeZoneIdentifiers)
        currenTimeZone = TimeZone.current
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.orange], for: .normal)
    }
    
    func getTimeZones(_ timeZoneIdentifiers: [String]) -> [String] {
        return timeZoneIdentifiers.compactMap{ identifier in
            return identifier.split(separator: "/").last! + "/" + identifier.components(separatedBy: "/")[0]
        }
    }
    
    var cellId = "AddWorldClockCell"
    static let unwindSagueId = "saveUnwind"
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TimeZonesTableViewCell
        
        
        let location = Location(locationName: timeZones[indexPath.row])
        cell.updateUI(with: location)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TimeZonesTableViewController.unwindSagueId {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let country = timeZones[selectedIndexPath.row].components(separatedBy: "/")[1]
                let city = timeZones[selectedIndexPath.row].components(separatedBy: "/")[0]
                let timeZone = TimeZone(identifier: "\(country)/\(city)")
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.dateFormat = "h:mm"
                formatter.timeZone = timeZone
                let timeNow = Date()
                let time = formatter.string(from: timeNow)
                
                worldClock = WorldClock(dayDiff: "Tomorrow", timeDiff: "+16HRS", country: country, city: city, time: time)
            }
        }
    }
    
    // MARK: - UISearchBar delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            timeZones = getTimeZones(timeZoneIdentifiers.filter{$0.contains(searchText)})
        } else {
            timeZones = getTimeZones(timeZoneIdentifiers)
        }
        tableView.reloadData()
    }
    
}
