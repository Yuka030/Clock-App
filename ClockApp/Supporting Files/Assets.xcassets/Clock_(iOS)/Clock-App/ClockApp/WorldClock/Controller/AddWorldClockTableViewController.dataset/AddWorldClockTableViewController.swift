import UIKit

class TimeZonesTableViewController: UITableViewController {
    
    var worldClock: WorldClock?
    var timeZones: [String] = []
    var cellId = "AddWorldClockCell"
    static let unwindSagueId = "saveUnwind"
    
    @IBOutlet weak var searchText: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeZones = NSTimeZone.knownTimeZoneNames
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worldClocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TimeZonesTableViewCell
        
        let worldClock = worldClocks[indexPath.row]
        cell.updateUI(with: worldClock)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TimeZonesTableViewController.unwindSagueId {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                worldClock = worldClocks[selectedIndexPath.row]
            }
        }
    }
}
