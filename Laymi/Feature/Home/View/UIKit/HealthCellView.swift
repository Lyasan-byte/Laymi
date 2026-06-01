//
//  HealthCellView.swift
//  Laymi
//
//  Created by Ляйсан
//

import UIKit

final class HealthCellView: UIView {
    private var background: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "Today"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var titleStack = stack(
        views: [titleLabel, dateLabel],
        distribution: .equalSpacing
    )
    
    private var dataLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 28, weight: .bold)
        if let descriptor = font.fontDescriptor.withDesign(.rounded) {
            label.font = UIFont(descriptor: descriptor, size: 28)
        } else {
            label.font = font
        }
        label.textAlignment = .left
        
        return label
    }()
    
    private var unitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dataStack = stack(
        views: [dataLabel, unitLabel],
        alignment: .firstBaseline
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, textColor: UIColor, value: Double?, unit: String) {
        titleLabel.text = title
        titleLabel.textColor = textColor
        unitLabel.text = unit
        
        if let value {
            dataLabel.text = value.formatted(.number.precision(.fractionLength(0)))
            dataLabel.textColor = .label
            unitLabel.isHidden = false
        } else {
            dataLabel.text = "No Data"
            dataLabel.textColor = .secondaryLabel
            unitLabel.isHidden = true
        }
    }
    
    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(titleStack)
        background.addSubview(dataStack)
    }
    
    private func setupLayout() {
        background.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        dataStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            titleStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            titleStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            
            dataStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            dataStack.topAnchor.constraint(greaterThanOrEqualTo: titleStack.bottomAnchor, constant: 12),
            dataStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }
    
    private func stack(
        views: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .center
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = 10
        stack.distribution = distribution
        stack.alignment = alignment
        views.forEach { stack.addArrangedSubview($0) }
        return stack
    }
}
