import UIKit

class WorldClockTableViewController: UITableViewController {
    
    var cellId = "WorldClockCell"
    @IBOutlet var table: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noClocksLabel: UILabel!
    
    var myWorldClocks: [WorldClock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .black
        navigationItem.leftBarButtonItem = editButtonItem
        noClocksLabel.isHidden = true
        updateCellBorder()
    }
    
    func updateCellBorder() {
        if myWorldClocks.isEmpty {
            tableView.separatorColor = .none
        } else {
            tableView.separatorColor = .lightGray
        }
    }
    
    // MARK: - Table view data sourcer
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWorldClocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorldClockTableViewCell
        let worldClock = myWorldClocks[indexPath.row]
        cell.updateUI(with: worldClock)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func unwindToWorldClock(sague: UIStoryboardSegue){
        if sague.identifier == TimeZonesTableViewController.unwindSagueId {
            // set the source view controller
            let sourceVC = sague.source as! TimeZonesTableViewController
            if let worldClock = sourceVC.worldClock {
                myWorldClocks.append(worldClock)
                tableView.insertRows(at: [IndexPath(item: myWorldClocks.count - 1, section: 0)], with: .automatic)
                updateCellBorder()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Delete", handler: {[weak self] (action, view, handler) in
                self?.myWorldClocks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self!.updateCellBorder()
            })
        ])
    }
}
