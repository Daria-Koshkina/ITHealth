//
//  TestViewController.swift
//  ITHealth
//
//  Created by Dasha Koshkina on 25.05.2023.
//

import Foundation
import SVProgressHUD

protocol TestViewControllerOutput: AnyObject {
  func back(from: TestViewController)
}

class TestViewController: LocalizableViewController, NavigationButtoned, ErrorAlertDisplayable {
  
  weak var output: TestViewControllerOutput?
  
  private let selfView = TestView()
  
  private var currentQuestion: Question?
  private var selectedAnswer: Answer?
  
  override func initConfigure() {
    super.initConfigure()
    localize()
    configureNavBar()
    setup()
  }
  
  override func loadView() {
    view = selfView
  }
  
  override func localize() {
    super.localize()
    selfView.button.setTitle(localizator.localizedString("test.next.button"), for: .normal)
  }
  
  private func configureNavBar() {
    setNavigationButton(#selector(didTapBack), button: ButtonsFactory.getNavigationBarBackButton())
  }
  
  private func setup() {
    selfView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    if let question = TestsService.shared.nextQuestion() {
      configureView(question: question)
    }
  }
  
  private func configureView(question: Question) {
    currentQuestion = question
    navigationItem.title = "\(localizator.localizedString("test.number")) \(question.number)"
    selfView.descriptionLabel.text = question.description
    
    selfView.answersStackView.removeFullyAllArrangedSubviews()
    question.answers.forEach { answer in
      let view = AnswerView()
      view.answer = answer
      view.setTitle(answer.text)
      let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAnswer(_:)))
      view.addGestureRecognizer(gesture)
      selfView.answersStackView.addArrangedSubview(view)
    }
    selectedAnswer = question.answers.isEmpty ? Answer(id: 0, text: "") : nil
    
    selfView.openAnswersStackView.removeFullyAllArrangedSubviews()
    question.openQuestions.forEach { answer in
      let view = OpenAnswerView()
      view.answer = answer
      view.titleLabel.text = answer.description
      selfView.openAnswersStackView.addArrangedSubview(view)
    }
  }
  
  private func finishTest() {
    SVProgressHUD.show()
    TestsService.shared.finishCurrentTest { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        SVProgressHUD.dismiss()
        switch result {
        case .failure(let error):
          self.handleError(error)
        case .success(let result):
          self.showAlert(
            title: self.localizator.localizedString("test.result.title"),
            message: "\(self.localizator.localizedString("test.result.subtitle")) \(result.result)/\(result.maxPoints)") {
              self.didTapBack()
            }
        }
      }
    }
  }
  
  @objc
  private func didTapButton() {
    guard let currentQuestion = currentQuestion,
          let selectedAnswer = selectedAnswer else {
      return
    }
    var openAnswers = [OpenAnswer]()
    for (index, view) in selfView.openAnswersStackView.arrangedSubviews.enumerated() {
      guard let text = (view as? OpenAnswerView)?.textView.text,
            !text.isEmpty else { return }
      openAnswers.append(OpenAnswer(id: currentQuestion.openQuestions[index].id, answer: text))
    }
    TestsService.shared.addAnswer(questionId: currentQuestion.id, answerId: selectedAnswer.id, openAnswers: openAnswers)
    if let question = TestsService.shared.nextQuestion() {
      configureView(question: question)
    } else {
      finishTest()
    }
  }
  
  @objc
  private func didTapBack() {
    TestsService.shared.resetTest()
    output?.back(from: self)
  }
  
  @objc
  private func didTapAnswer(_ gesture: UITapGestureRecognizer) {
    guard let view = gesture.view as? AnswerView else { return }
    selectedAnswer = view.answer
    selfView.answersStackView.arrangedSubviews.forEach { view in
      (view as? AnswerView)?.setIsSelected((view as? AnswerView)?.answer?.id == selectedAnswer?.id)
    }
  }
}
