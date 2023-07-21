import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//           .lightContent
//       }
//

    
    // MARK: - Types

    // MARK: - Constants

    // MARK: - Public Properties

    // MARK: - IBOutlet
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // MARK: - Private Properties
    
    
    private  struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
  
    var currentQuestionIndex = 0
     var correctAnswers = 0
    
    private let questionsCount: Int = 10
     var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var quizResults: QuizResultsViewModel?
    private var alert: AlertModel?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?

    weak var delegate: UIViewController?

    
    // MARK: - Initializers

    // MARK: - UIViewController(*)

    // MARK: - Public Methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate:self)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
       
        questionFactory?.loadData()
    
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {

        guard let currentQuestion = currentQuestion else {
            return
        }
        let answer = true
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let answer = false
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (
            image: UIImage (data: model.image) ?? UIImage (),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)"
        )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }

    
    
    private func showResults() {
        guard let statisticService = statisticService, let alertPresenter = alertPresenter else {
            assertionFailure("error message")
            return
        }
        
        statisticService.store(correct: correctAnswers, total: questionsCount)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeResultMessage(),
            buttonText: "Сыграть еще раз!",
            buttonAction: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
            
        )
        
        alertPresenter.showAlert(alertModel: alertModel)
    
    }
    
    private func makeResultMessage() -> String {
             guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
                 assertionFailure("error message")
                 return ""
             }
         
             let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
             let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
             let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsCount)"
             let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
             let averageAccuracyLine = "Средняя точность: \(accuracy)%"

             let components: [String] =
                 [currentGameResultLine,
                 totalPlaysCountLine,
                 bestGameInfoLine,
                 averageAccuracyLine]
         
             let resultMessage = components.joined(separator: "\n")
             return resultMessage
         }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        correctAnswers = isCorrect ? correctAnswers+1 : correctAnswers
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsCount - 1 {
           
            imageView.layer.borderColor = UIColor.ypBlack.cgColor
            showResults()
            yesButton.isEnabled = true
            noButton.isEnabled = true
        } else {
            currentQuestionIndex += 1
            imageView.layer.borderColor = UIColor.ypBlack.cgColor
            
            yesButton.isEnabled = true
            noButton.isEnabled = true
            questionFactory?.requestNextQuestion()
        
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
     hideLoadingIndicator()
        
        let errorAlert = errorAlert(
            title: "Ошибка",
            buttonText: "Сыграть еще раз!"
        )
        
        alertPresenter?.showErrorAlert(errorAlert: errorAlert)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
}
