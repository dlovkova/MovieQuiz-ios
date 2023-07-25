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
    
    
    @IBOutlet var imageView: UIImageView!
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
    
  
     var correctAnswers = 0
    
     var questionFactory: QuestionFactoryProtocol?
  //  private var currentQuestion: QuizQuestion?
    private var quizResults: QuizResultsViewModel?
    private var alert: AlertModel?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()

    weak var delegate: UIViewController?

    
    // MARK: - Initializers

    // MARK: - UIViewController(*)

    // MARK: - Public Methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate:self)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        presenter.viewController = self
        
        showLoadingIndicator()
       
        questionFactory?.loadData()
    
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }

    
    // MARK: - IBAction
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
      //  presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
}
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
      //  presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
   }
    
    // MARK: - Private Methods
    

     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }

    
    
     func showResults() {
        guard let statisticService = statisticService, let alertPresenter = alertPresenter else {
            assertionFailure("error message")
            return
        }
        
        statisticService.store(correct: correctAnswers, total: presenter.questionsCount)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeResultMessage(),
            buttonText: "Сыграть еще раз!",
            buttonAction: { [weak self] in
                self?.presenter.currentQuestionIndex = 0
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
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(presenter.questionsCount)"
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
    
    func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        correctAnswers = isCorrect ? correctAnswers+1 : correctAnswers
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    
//    private func showNextQuestionOrResults() {
//        presenter.showNextQuestionOrResults()
//        if presenter.isLastQuestion() {
//           
//            imageView.layer.borderColor = UIColor.ypBlack.cgColor
//            showResults()
//            yesButton.isEnabled = true
//            noButton.isEnabled = true
//        } else {
//            presenter.switchToNextQuestion()
//            imageView.layer.borderColor = UIColor.ypBlack.cgColor
//            
//            yesButton.isEnabled = true
//            noButton.isEnabled = true
//            questionFactory?.requestNextQuestion()
//        
//        }
   // }
    
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
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
}
