//
//  ISSViewController.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation
import UIKit
import MapKit
import Combine

class ISSViewController: UIViewController {
    
    weak var coordinator: ISSCoordinator?
    private var locationManager = UserLocationManager()
    private let viewModel: ISSViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var didCenterMap = false
    
    init(viewModel: ISSViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        map.showsUserLocation = true
        return map
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
        
    lazy var issTextDetailsView: ISSTextDetailsView = {
        let view = ISSTextDetailsView(viewModel: viewModel)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ISSCellView.self, forCellReuseIdentifier: ISSCellView.reuseIdentifier)
        return tableView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ISS Information"
        layout()
        setupBindings()
        
        if locationManager.isLocationServicesDisabled {
            showLocationServicesAlert()
        }
        
        issTextDetailsView.showLogsButton.addTarget(self, action: #selector(showLogsButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.$issCurrentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLocation in
                guard let self = self, let newLocation = newLocation else { return }
                self.addISSPinToMap(newLocation)
            }
            .store(in: &cancellables)
        
        viewModel.$astronauts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] astronauts in
                guard let self = self else { return }
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    /// Adds the location of ISS to the map
    private func addISSPinToMap(_ coordinate: CLLocationCoordinate2D) {
        map.removeAnnotations(map.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "ISS"
        map.addAnnotation(annotation)
        
        if !didCenterMap {
            didCenterMap = true
            map.setCenter(coordinate, animated: true)
        }
    }
    
    /// Shows alert if allow location is off
    private func showLocationServicesAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "This app requires the user location please enable location services in Settings.", preferredStyle: .alert)
        
        let openSettingsButton = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(openSettingsButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(infoView)
        infoView.addSubview(map)
        infoView.addSubview(stackView)
        stackView.addArrangedSubview(issTextDetailsView)
        stackView.addArrangedSubview(tableView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),

            infoView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            infoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            infoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            infoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            map.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            map.topAnchor.constraint(equalTo: infoView.topAnchor),
            map.leftAnchor.constraint(equalTo: infoView.leftAnchor),
            map.rightAnchor.constraint(equalTo: infoView.rightAnchor),

            stackView.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 15),
            stackView.widthAnchor.constraint(equalTo: infoView.widthAnchor, multiplier: 1),
            stackView.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -40),

            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
    
    @objc func showLogsButtonTapped() {
        guard let coordinator = coordinator else { return }
        coordinator.presentLogs(viewModel)
    }
}

extension ISSViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "ISSAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
            let image = UIImage(systemName: "airplane", withConfiguration: config)
            annotationView?.image = image
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}

extension ISSViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.astronauts?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ISSCellView.reuseIdentifier, for: indexPath) as? ISSCellView else {
            return UITableViewCell()
        }

        let data = viewModel.getAstronautInfoCellText(for: indexPath)
        cell.configureCell((top: data.0, bottom: data.1))
        
        return cell
    }
}

extension ISSViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getNumberOfAstronautsText(for: section)
    }
}
