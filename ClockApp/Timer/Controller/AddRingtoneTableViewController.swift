import UIKit

class AddRingtoneTableViewController: UITableViewController {
    
    var ringtone: Ringtone?
    var ringtones = Ringtone.ringtones
    var selectedIndex: Int?

    let cellId = "AddRingtoneCell"
    static let unwindSagueId = "saveUnwind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ringtone = Ringtone(id: 1000, title: "Rader")
        selectedIndex = 0
        tableView.backgroundColor = .black
        tableView.separatorColor = UIColor.lightGray
        tableView.allowsMultipleSelection = false
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ringtones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ringtone = ringtones[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddRingtoneTableViewCell
        cell.ringtoneLabel.text = ringtone.title
        
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
            cell.tintColor = .orange
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        ringtone = ringtones[indexPath.row]
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
