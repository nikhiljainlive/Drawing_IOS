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
    var lineWidth : CGFloat = 1
    var onColorChange : ((CGColor) -> Void)?
    var onLineWidthChange : ((CGFloat) -> Void)?
    
    private let closeButton : UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    private let redColorSelector : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.addTarget(self, action: #selector(colorValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let greenColorSelector : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.addTarget(self, action: #selector(colorValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let blueColorSelector : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.addTarget(self, action: #selector(colorValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let opacitySelector : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(self, action: #selector(colorValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let lineWidthSelector : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 20
        slider.addTarget(self, action: #selector(lineWidthDidChange), for: .valueChanged)
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setUpSliderValues()
    }
    
    private func setUpLayout() {
        view.backgroundColor = UIColor.white
        setUpColorStackView()
        setUpCloseButton()
    }
    
    private func setUpSliderValues() {
        redColorSelector.value = Float(CIColor(cgColor: color).red) * 255.0
        greenColorSelector.value = Float(CIColor(cgColor: color).green) * 255.0
        blueColorSelector.value = Float(CIColor(cgColor: color).blue) * 255.0
        opacitySelector.value = Float(CIColor(cgColor: color).alpha)
        lineWidthSelector.value = Float(lineWidth)
    }
    
    private func setUpCloseButton() {
        self.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    private func stackView(for slider : UISlider, with text : String) -> UIStackView {
        let label = UILabel()
        label.text = text
        
        let sliderStackView = UIStackView(arrangedSubviews: [label, slider])
        sliderStackView.spacing = 10
        return sliderStackView
    }
    
    private func setUpColorStackView() {
        let colorStackView = UIStackView(arrangedSubviews: [
            stackView(for: redColorSelector, with: "Red"),
            stackView(for: greenColorSelector, with: "Green"),
            stackView(for: blueColorSelector, with: "Blue"),
            stackView(for: opacitySelector, with: "Opacity"),
            stackView(for: lineWidthSelector, with: "Line Width")
        ])
        colorStackView.distribution = .equalCentering
        colorStackView.axis = .vertical
        self.view.addSubview(colorStackView)
        
        colorStackView.translatesAutoresizingMaskIntoConstraints = false
        colorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        colorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        colorStackView.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1).isActive = true
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc private func colorValueDidChange() {
        let redColorValue = CGFloat(redColorSelector.value) / 255.0
        let greenColorValue = CGFloat(greenColorSelector.value) / 255.0
        let blueColorValue = CGFloat(blueColorSelector.value) / 255.0
        let alphaColorValue = CGFloat(opacitySelector.value)
        
        onColorChange?(UIColor.init(red: redColorValue, green: greenColorValue, blue: blueColorValue, alpha: alphaColorValue).cgColor)
    }
    
    @objc private func lineWidthDidChange() {
        onLineWidthChange?(CGFloat(lineWidthSelector.value))
    }
}
