//
//  SettingsViewController.swift
//  FundooDraw
//
//  Created by Admin on 09/08/20.
//  Copyright © 2020 nikhiljain. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var color : CGColor = UIColor.black.cgColor
    var lineWidth : CGFloat = 1 {
        didSet {
            lineWidthValueLabel.text = String(format: "%\(0.1)f", lineWidth)
            onLineWidthChange?(lineWidth)
        }
    }
    
    var onColorChange : ((CGColor) -> Void)?
    var onLineWidthChange : ((CGFloat) -> Void)?
    
    private var redColorValue : Int = 0 {
        didSet {
            redColorValueLabel.text = redColorValue.description
        }
    }
    
    private var greenColorValue : Int = 0 {
        didSet {
            greenColorValueLabel.text = greenColorValue.description
        }
    }
    
    private var blueColorValue : Int = 0 {
        didSet {
            blueColorValueLabel.text = blueColorValue.description
        }
    }
    
    private var alphaValue : CGFloat = 0 {
        didSet {
            opacityValueLabel.text = String(format: "%\(0.1)f", alphaValue)
        }
    }
    
    private let closeButton : UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    private let redColorSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.addTarget(self, action: #selector(colorValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let greenColorSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.addTarget(self, action: #selector(colorValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let blueColorSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.addTarget(self, action: #selector(colorValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let opacitySlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(self, action: #selector(colorValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let lineWidthSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 20
        slider.addTarget(self, action: #selector(lineWidthDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var redColorValueLabel : UILabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    private lazy var greenColorValueLabel : UILabel = {
        let label = UILabel()
        label.textColor = .green
        return label
    }()
    
    private lazy var blueColorValueLabel : UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    
    private lazy var opacityValueLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private lazy var lineWidthValueLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private lazy var colorStackView = UIStackView(arrangedSubviews: [
        stackView(for: redColorSlider, with: "Red", valueLabel: redColorValueLabel),
        stackView(for: greenColorSlider, with: "Green", valueLabel: greenColorValueLabel),
        stackView(for: blueColorSlider, with: "Blue", valueLabel: blueColorValueLabel),
        stackView(for: opacitySlider, with: "Opacity", valueLabel: opacityValueLabel),
        stackView(for: lineWidthSlider, with: "Line Width", valueLabel: lineWidthValueLabel)
    ])
    
    private let previewView : UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setUpVariablesFromColor()
        setUpSliderValues()
        previewView.backgroundColor = UIColor(cgColor: color)
    }
    
    private func setUpLayout() {
        view.backgroundColor = UIColor.white
        setUpColorStackView()
        setUpColorPreview()
        setUpCloseButton()
    }
    
    private func setUpVariablesFromColor() {
        redColorValue = Int(CIColor(cgColor: color).red * 255)
        greenColorValue = Int(CIColor(cgColor: color).green * 255)
        blueColorValue = Int(CIColor(cgColor: color).blue * 255)
        alphaValue = CIColor(cgColor: color).alpha
    }
    
    private func setUpSliderValues(){
        redColorSlider.value = Float(redColorValue)
        greenColorSlider.value = Float(greenColorValue)
        blueColorSlider.value = Float(blueColorValue)
        opacitySlider.value = Float(alphaValue)
        
        lineWidthSlider.value = Float(lineWidth)
    }
    
    private func setUpCloseButton() {
        self.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    private func stackView(for slider : UISlider, with text : String, valueLabel : UILabel) -> UIStackView {
        let label = UILabel()
        label.text = text
        
        let sliderStackView = UIStackView(arrangedSubviews: [label, slider, valueLabel])
        sliderStackView.spacing = 10
        return sliderStackView
    }
    
    private func setUpColorStackView() {
        colorStackView.distribution = .equalCentering
        colorStackView.axis = .vertical
        self.view.addSubview(colorStackView)
        
        colorStackView.translatesAutoresizingMaskIntoConstraints = false
        colorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        colorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        colorStackView.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1).isActive = true
    }
    
    private func setUpColorPreview() {
        let previewLabel = UILabel()
        previewLabel.text = "Color Preview"
        previewView.layer.cornerRadius = 25
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        previewView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            previewLabel, previewView
        ])
        stackView.spacing = 20
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: colorStackView.bottomAnchor, constant: 20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc private func colorValueDidChange() {
        redColorValue = Int(redColorSlider.value)
        greenColorValue = Int(greenColorSlider.value)
        blueColorValue = Int(blueColorSlider.value)
        alphaValue = CGFloat(opacitySlider.value)
        
        let changedColor = UIColor(red: CGFloat(redColorSlider.value) / 255.0, green: CGFloat(greenColorSlider.value) / 255.0, blue: CGFloat(blueColorSlider.value) / 255.0, alpha: alphaValue)
        onColorChange?(changedColor.cgColor)
        previewView.backgroundColor = changedColor
    }
    
    @objc private func lineWidthDidChange() {
        lineWidth = CGFloat(lineWidthSlider.value)
    }
}
