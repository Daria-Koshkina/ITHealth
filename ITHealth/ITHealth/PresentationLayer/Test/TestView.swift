//
//  TestView.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 25.05.2023.
//

import UIKit

class TestView: InitView {
  
  private let scrollView = UIScrollView()
  private let containerView = InitView()
  let descriptionLabel = UILabel()
  let answersStackView = UIStackView()
  let openAnswersStackView = UIStackView()
  let button = PrimaryButton()
  
  override func initConfigure() {
    super.initConfigure()
    configureScrollView()
    configureContainerView()
    configureDescriptionLabel()
    configureAnswersStackView()
    configureOpenAnswersStackView()
    configureButton()
  }
  
  private func configureScrollView() {
    addSubview(scrollView)
    scrollView.showsVerticalScrollIndicator = false
    scrollView.backgroundColor = .white
    scrollView.alwaysBounceVertical = false
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(safeAreaLayoutGuide)
    }
  }
  
  private func configureContainerView() {
    scrollView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(self)
    }
  }
  
  private func configureDescriptionLabel() {
    containerView.addSubview(descriptionLabel)
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = Fonts.semibold16
    descriptionLabel.textColor = Colors.blueDark
    descriptionLabel.numberOfLines = .zero
    descriptionLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
        .inset(16)
    }
  }
  
  private func configureAnswersStackView() {
    containerView.addSubview(answersStackView)
    answersStackView.axis = .vertical
    answersStackView.distribution = .fillProportionally
    answersStackView.spacing = 8
    answersStackView.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom)
        .offset(20)
      make.left.right.equalTo(descriptionLabel)
    }
  }
  
  private func configureOpenAnswersStackView() {
    containerView.addSubview(openAnswersStackView)
    openAnswersStackView.axis = .vertical
    openAnswersStackView.distribution = .fillProportionally
    openAnswersStackView.spacing = 8
    openAnswersStackView.snp.makeConstraints { make in
      make.top.equalTo(answersStackView.snp.bottom)
        .offset(20)
      make.left.right.equalTo(descriptionLabel)
    }
  }
  
  private func configureButton() {
    containerView.addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(openAnswersStackView.snp.bottom)
        .offset(20)
      make.left.right.equalTo(descriptionLabel)
      make.height.equalTo(56)
      make.bottom.equalToSuperview()
        .inset(38)
    }
  }
}
