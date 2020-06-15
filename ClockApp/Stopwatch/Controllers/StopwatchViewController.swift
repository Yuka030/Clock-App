//
//  StopwatchViewController.swift
//  ClockApp
//
//  Created by Yusuke Takahashi on 2020/06/11.
//  Copyright © 2020年 usk. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {
    var startTime: TimeInterval?
    var stopTime: TimeInterval?
    var lapTime: TimeInterval?
    var laps: [TimeInterval] = []
    var bestLapIndex: Int?
    var worstLapIndex: Int?
    var timer: Timer!

    let screenWidth: CGFloat = UIScreen.main.bounds.width

    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero

        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.bounces = false
        cv.decelerationRate = UIScrollViewDecelerationRateFast
        return cv
    }()

    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.numberOfPages = 2
        return pc
    }()

    let degitalClockView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let degitalClockLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "HelveticaNeue-Thin", size: 128)

        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.1;

        l.textColor = .white
        l.textAlignment = .center
        return l
    }()

    let analogClockView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let analogClockLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "HelveticaNeue", size: 24)

        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.1;

        l.textColor = .white
        l.textAlignment = .center
        return l
    }()

    let dialImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "stopwatch-dial"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let littleHandImageViewDefaultRotationAngle: CGFloat = 3.01
    let littleHandImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "stopwatch-minutes"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let lapHandImageViewDefaultRotationAngle: CGFloat = -0.079
    let lapHandImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "stopwatch-lap"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let bigHandImageViewDefaultRotationAngle: CGFloat = 2.022
    let bigHandImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "stopwatch-main"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let leftButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .lightGray
        b.backgroundColor = UIColor(red: 0x3e/255, green: 0x3e/255, blue: 0x3e/255, alpha: 1)
        b.clipsToBounds = true
        b.layer.cornerRadius = 40;
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        b.setTitleColor(.white, for: .normal)

        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.layer.cornerRadius = 38
        border.clipsToBounds = true
        border.layer.borderColor = UIColor.black.cgColor
        border.layer.borderWidth = 2

        b.addSubview(border)
        border.widthAnchor.constraint(equalToConstant: 76).isActive = true
        border.heightAnchor.constraint(equalToConstant: 76).isActive = true
        border.centerXAnchor.constraint(equalTo: b.centerXAnchor).isActive = true
        border.centerYAnchor.constraint(equalTo: b.centerYAnchor).isActive = true

        return b
    }()

    let rightButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.clipsToBounds = true
        b.layer.cornerRadius = 40;
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.layer.cornerRadius = 38
        border.clipsToBounds = true
        border.layer.borderColor = UIColor.black.cgColor
        border.layer.borderWidth = 2

        b.addSubview(border)
        border.widthAnchor.constraint(equalToConstant: 76).isActive = true
        border.heightAnchor.constraint(equalToConstant: 76).isActive = true
        border.centerXAnchor.constraint(equalTo: b.centerXAnchor).isActive = true
        border.centerYAnchor.constraint(equalTo: b.centerYAnchor).isActive = true

        return b
    }()

    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        let bgv = UIView(frame: .zero)
        bgv.backgroundColor = .black
        tv.backgroundView = bgv
        tv.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        let header = UIView(frame: CGRect(x: 0, y: 0, width: tv.frame.size.width, height: 1 / UIScreen.main.scale))
        let topSeparator = UIView()
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.backgroundColor = UIColor(red: 0x3e/255, green: 0x3e/255, blue: 0x3e/255, alpha: 1)
        header.addSubview(topSeparator)
        topSeparator.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        topSeparator.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        topSeparator.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12).isActive = true
        topSeparator.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12).isActive = true
        tv.tableHeaderView = header

        return tv
    }()

    var tableViewTopSeparator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 0x3e/255, green: 0x3e/255, blue: 0x3e/255, alpha: 1)
        v.alpha = 0
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupCollectionView()
        setupDegitalClockView()
        setupAnalogClockView()
        setupButtons()
        setupTableView()

        updateUI()
    }

    func updateUI() {
        if startTime == nil {
            leftButton.setTitle("Lap", for: .normal)
            leftButton.alpha = 0.5
            leftButton.isEnabled = false

            rightButton.setTitle("Start", for: .normal)
            rightButton.backgroundColor = UIColor(red: 0x19/255, green: 0x35/255, blue: 0x1e/255, alpha: 1)
            rightButton.setTitleColor(.green, for: .normal)
        } else if self.stopTime == nil {
            leftButton.setTitle("Lap", for: .normal)
            leftButton.alpha = 1
            leftButton.isEnabled = true

            rightButton.setTitle("Stop", for: .normal)
            rightButton.backgroundColor = UIColor(red: 0x3d/255, green: 0x16/255, blue: 0x14/255, alpha: 1)
            rightButton.setTitleColor(.red, for: .normal)
        } else {
            leftButton.setTitle("Reset", for: .normal)

            rightButton.setTitle("Start", for: .normal)
            rightButton.backgroundColor = UIColor(red: 0x19/255, green: 0x35/255, blue: 0x1e/255, alpha: 1)
            rightButton.setTitleColor(.green, for: .normal)
        }

        guard let startTime = startTime else {
            let formettedTimeString = TimeInterval(0).formattedString()
            degitalClockLabel.text = formettedTimeString
            analogClockLabel.text = formettedTimeString
            littleHandImageView.transform = CGAffineTransform(rotationAngle: littleHandImageViewDefaultRotationAngle)
            lapHandImageView.transform = CGAffineTransform(rotationAngle: CGFloat(lapHandImageViewDefaultRotationAngle))
            bigHandImageView.transform = CGAffineTransform(rotationAngle: bigHandImageViewDefaultRotationAngle)
            return
        }

        let currentTime = Date().timeIntervalSince1970
        let totalTime = currentTime - startTime
        let formettedTimeString = totalTime.formattedString()
        degitalClockLabel.text = formettedTimeString
        analogClockLabel.text = formettedTimeString
        let currentLapTime = currentTime - lapTime!
        laps[laps.count - 1] = currentLapTime

        var sec = Int(totalTime * 1000) % 60000
        let intPI = Int(Double.pi*1000)
        let half = Double(30000000)
        var rotation = Double(sec * intPI) / half
        bigHandImageView.transform = CGAffineTransform(rotationAngle: bigHandImageViewDefaultRotationAngle + CGFloat(rotation))

        sec = Int(currentLapTime * 1000) % 60000
        rotation = Double(sec * intPI) / half
        lapHandImageView.transform = CGAffineTransform(rotationAngle: lapHandImageViewDefaultRotationAngle + CGFloat(rotation))

        let min = Int(totalTime * 100) / 60 % 3000
        let minHalf = Double(1500000)
        rotation = Double(min * intPI) / minHalf
        littleHandImageView.transform = CGAffineTransform(rotationAngle: littleHandImageViewDefaultRotationAngle + CGFloat(rotation))

        tableView.reloadData() // TODO: optimize
        // the code below causes weird behavior when it scrolls down to the bottom of the tableView
        // tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")

        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true

        view.addSubview(pageControl)
        pageControl.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        pageControl.centerYAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .touchUpInside)
    }

    @objc func pageControlTapped(_ sender: UIPageControl) {
        collectionView.setContentOffset(CGPoint(x: screenWidth * CGFloat(sender.currentPage), y: 0), animated: true)
    }

    func setupDegitalClockView() {
        degitalClockView.addSubview(degitalClockLabel)
        degitalClockLabel.centerXAnchor.constraint(equalTo: degitalClockView.centerXAnchor).isActive = true
        degitalClockLabel.centerYAnchor.constraint(equalTo: degitalClockView.centerYAnchor, constant: -20).isActive = true
        degitalClockLabel.widthAnchor.constraint(equalTo: degitalClockView.widthAnchor, constant: -20).isActive = true
    }

    func setupAnalogClockView() {
        let bottomMargin = UIView()
        bottomMargin.translatesAutoresizingMaskIntoConstraints = false
        analogClockView.addSubview(bottomMargin)
        bottomMargin.widthAnchor.constraint(equalTo: analogClockView.heightAnchor).isActive = true
        bottomMargin.heightAnchor.constraint(equalTo: analogClockView.heightAnchor, multiplier: 0.33).isActive = true
        bottomMargin.centerXAnchor.constraint(equalTo: analogClockView.centerXAnchor).isActive = true
        bottomMargin.bottomAnchor.constraint(equalTo: analogClockView.bottomAnchor).isActive = true

        analogClockView.addSubview(analogClockLabel)
        analogClockLabel.centerXAnchor.constraint(equalTo: analogClockView.centerXAnchor).isActive = true
        analogClockLabel.centerYAnchor.constraint(equalTo: bottomMargin.topAnchor).isActive = true
        analogClockLabel.widthAnchor.constraint(equalTo: analogClockView.heightAnchor, multiplier: 0.25).isActive = true

        analogClockView.addSubview(dialImageView)
        dialImageView.centerXAnchor.constraint(equalTo: analogClockView.centerXAnchor).isActive = true
        dialImageView.centerYAnchor.constraint(equalTo: analogClockView.centerYAnchor).isActive = true
        dialImageView.widthAnchor.constraint(equalTo: analogClockView.heightAnchor, multiplier: 0.9).isActive = true
        dialImageView.heightAnchor.constraint(equalTo: analogClockView.heightAnchor, multiplier: 0.9).isActive = true

        let topMargin = UIView()
        topMargin.translatesAutoresizingMaskIntoConstraints = false
        dialImageView.addSubview(topMargin)
        topMargin.widthAnchor.constraint(equalTo: dialImageView.heightAnchor).isActive = true
        topMargin.heightAnchor.constraint(equalTo: dialImageView.heightAnchor, multiplier: 0.18).isActive = true
        topMargin.centerXAnchor.constraint(equalTo: dialImageView.centerXAnchor).isActive = true
        topMargin.topAnchor.constraint(equalTo: dialImageView.topAnchor).isActive = true

        dialImageView.addSubview(littleHandImageView)
        littleHandImageView.topAnchor.constraint(equalTo: topMargin.bottomAnchor).isActive = true
        littleHandImageView.centerXAnchor.constraint(equalTo: dialImageView.centerXAnchor).isActive = true
        littleHandImageView.widthAnchor.constraint(equalTo: dialImageView.heightAnchor, multiplier: 0.28).isActive = true
        littleHandImageView.heightAnchor.constraint(equalTo: dialImageView.heightAnchor, multiplier: 0.28).isActive = true
        littleHandImageView.transform = CGAffineTransform(rotationAngle: littleHandImageViewDefaultRotationAngle)

        dialImageView.addSubview(lapHandImageView)
        lapHandImageView.centerXAnchor.constraint(equalTo: dialImageView.centerXAnchor).isActive = true
        lapHandImageView.centerYAnchor.constraint(equalTo: dialImageView.centerYAnchor).isActive = true
        lapHandImageView.widthAnchor.constraint(equalTo: dialImageView.heightAnchor).isActive = true
        lapHandImageView.heightAnchor.constraint(equalTo: dialImageView.heightAnchor).isActive = true
        lapHandImageView.transform = CGAffineTransform(rotationAngle: CGFloat(lapHandImageViewDefaultRotationAngle))

        dialImageView.addSubview(bigHandImageView)
        bigHandImageView.centerXAnchor.constraint(equalTo: dialImageView.centerXAnchor).isActive = true
        bigHandImageView.centerYAnchor.constraint(equalTo: dialImageView.centerYAnchor).isActive = true
        bigHandImageView.widthAnchor.constraint(equalTo: dialImageView.heightAnchor).isActive = true
        bigHandImageView.heightAnchor.constraint(equalTo: dialImageView.heightAnchor).isActive = true
        bigHandImageView.transform = CGAffineTransform(rotationAngle: bigHandImageViewDefaultRotationAngle)
    }

    func setupButtons() {
        view.addSubview(leftButton)
        leftButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        leftButton.centerYAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)

        view.addSubview(rightButton)
        rightButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }

    @objc func leftButtonTapped(_ sender: UIButton) {
        if stopTime == nil {
            var currentIndex: Int? = laps.count - 1
            if currentIndex == 0 {
            } else if currentIndex == 1 {
                if laps[0] <= laps[1] {
                    bestLapIndex = 0
                    worstLapIndex = 1
                } else {
                    bestLapIndex = 1
                    worstLapIndex = 0
                }
                tableView.reloadRows(at: [
                    IndexPath(row: 0, section: 0),
                    IndexPath(row: 1, section: 0),
                    ], with: .none)
            }
            else {
                if laps[currentIndex!] < laps[bestLapIndex!] {
                    swap(&currentIndex, &bestLapIndex)
                    tableView.reloadRows(at: [
                        IndexPath(row: laps.count - 1 - bestLapIndex!, section: 0),
                        IndexPath(row: laps.count - 1 - currentIndex!, section: 0),
                        ], with: .none)
                } else if laps[currentIndex!] > laps[worstLapIndex!] {
                    swap(&currentIndex, &worstLapIndex)
                    tableView.reloadRows(at: [
                        IndexPath(row: laps.count - 1 - worstLapIndex!, section: 0),
                        IndexPath(row: laps.count - 1 - currentIndex!, section: 0),
                        ], with: .none)
                }
            }

            let currentTime = Date().timeIntervalSince1970
            laps.append(currentTime - lapTime!)
            lapTime = currentTime
            UIView.setAnimationsEnabled(false)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            UIView.setAnimationsEnabled(true)
        } else {
            startTime = nil
            stopTime = nil
            lapTime = nil
            laps = []
            bestLapIndex = nil
            worstLapIndex = nil
            tableView.reloadData()
        }
        updateUI()
    }

    @objc func rightButtonTapped(_ sender: UIButton) {
        if startTime == nil {
            startTime = Date().timeIntervalSince1970
            lapTime = startTime
            laps.append(0)
            UIView.setAnimationsEnabled(false)
            tableView.insertRows(at: [IndexPath(row: laps.count - 1, section: 0)], with: .none)
            UIView.setAnimationsEnabled(true)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        } else if stopTime == nil {
            stopTime = Date().timeIntervalSince1970
            timer.invalidate()
        } else {
            let breaktime: TimeInterval = Date().timeIntervalSince1970 - stopTime!
            startTime! += breaktime
            lapTime! += breaktime
            stopTime = nil
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        }
        updateUI()
    }

    @objc func tick() {
        updateUI()
    }

    func setupTableView() {
        tableView.separatorColor = UIColor(red: 0x3e/255, green: 0x3e/255, blue: 0x3e/255, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LapTableViewCell.self, forCellReuseIdentifier: "TableViewCell")

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 12).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        view.addSubview(tableViewTopSeparator)
        tableViewTopSeparator.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        tableViewTopSeparator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        tableViewTopSeparator.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 12).isActive = true
        tableViewTopSeparator.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -12).isActive = true
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView is UICollectionView {
            if velocity.x < 0 {
                targetContentOffset.pointee = CGPoint(x: 0.0, y: 0.0)
                pageControl.currentPage = 0
            } else if velocity.x > 0 {
                targetContentOffset.pointee = CGPoint(x: screenWidth, y: 0.0)
                pageControl.currentPage = 1
            } else if targetContentOffset.pointee.x <= screenWidth / 2 {
                targetContentOffset.pointee = CGPoint(x: 0.0, y: 0.0)
                pageControl.currentPage = 0
            } else {
                targetContentOffset.pointee = CGPoint(x: screenWidth, y: 0.0)
                pageControl.currentPage = 1
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.contentView.addSubview(degitalClockView)
            degitalClockView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            degitalClockView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            degitalClockView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            degitalClockView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        case 1:
            cell.contentView.addSubview(analogClockView)
            analogClockView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            analogClockView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            analogClockView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            analogClockView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        default:
            break
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UITableView {
            if scrollView.contentOffset.y > 0 {
                tableViewTopSeparator.alpha = 1
            } else {
                tableViewTopSeparator.alpha = 0
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! LapTableViewCell
        let lapIndex = laps.count - 1 - indexPath.row
        cell.titleLabel.text = "Lap\(lapIndex + 1)"
        cell.timeLabel.text = laps[lapIndex].formattedString()
        if bestLapIndex != nil && lapIndex == bestLapIndex! {
            cell.titleLabel.textColor = .green
            cell.timeLabel.textColor = .green
        } else if worstLapIndex != nil && lapIndex == worstLapIndex! {
            cell.titleLabel.textColor = .red
            cell.timeLabel.textColor = .red
        } else {
            cell.titleLabel.textColor = .white
            cell.timeLabel.textColor = .white
        }
        return cell
    }
}
