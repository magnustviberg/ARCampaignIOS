//
//  TutorialView.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 10/03/2019.
//

import UIKit

class TutorialView: UIView {
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = UIStackView.Alignment.center
        view.distribution = UIStackView.Distribution.fillProportionally
        view.spacing = 16
        view.axis = NSLayoutConstraint.Axis.vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.text = "Hold the camere towards the image"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse porttitor est vitae erat dapibus fringilla. Ut a diam fermentum, congue ante sed, sollicitudin ante. Maecenas a placerat turpis. Etiam in neque libero."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32)
        ])
    }

}
