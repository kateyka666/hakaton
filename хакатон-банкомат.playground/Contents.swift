protocol UserData {
  var userName: String { get }    //Имя пользователя
  var userCardId: String { get }   //Номер карты
  var userCardPin: Int { get }       //Пин-код
  var userCash: Float { get set}   //Наличные пользователя
  var userBankDeposit: Float { get set}   //Банковский депозит
  var userPhone: String { get }       //Номер телефона
  var userPhoneBalance: Float { get set}    //Баланс телефона
  
}
struct User : UserData {
    var userName: String
    var userCardId: String
    var userCardPin: Int
    var userCash: Float
    var userBankDeposit: Float
    var userPhone: String
    var userPhoneBalance: Float
}
 
// Тексты ошибок
enum TextErrors : String {
  case falseCardIdOrCardPin = "вы неправильно ввели номер карты или пин-код"
  case notEnoughCashOnHands = "вы не можете положить столько наличных"
  case notEnoughCashOnDeposit = "вы не можете снять столько наличных"
  case wrongPhone = "вы неправильно ввели номер телефона"
}
 
// Виды операций, выбранных пользователем (подтверждение выбора)
enum DescriptionTypesAvailableOperations: String {
case requestBalanceDescription = ", вы запросили баланс на банковском депозите"
case withdrawCashFromDepositDescription = ", вы снятили наличные с банковского депозита"
case topUpDepositCashDescription = ", вы пополненили ваш банковский депозит наличными "
case topUpPhoneBalanceCashOrDepositDescription = ", вы пополнили баланс телефона"
}
 
// Действия, которые пользователь может выбирать в банкомате (имитация кнопок)
enum UserActions {
case buttonrequestBalance
case buttonwithdrawCashFromDeposit (withdraw: Float)
case buttontopUpDepositCash (topUp : Float)
case buttontopUpPhoneBalanceCashOrDeposit ( phone: String)

}
 
// Способ оплаты/пополнения наличными или через депозит
enum PaymentMethod {
    case cashik (cashik: Float)
    case depositik (depositik : Float)
   
}
class ATM {
  private let userCardId: String
  private let userCardPin: Int
  private var someBank: BankApi
  private let action: UserActions
  private let paymentMethod: PaymentMethod?

  private var delegate : UserData!
  
  init(userCardId: String, userCardPin: Int, someBank: BankApi, action: UserActions, paymentMethod: PaymentMethod? = nil) {
    self.userCardId = userCardId
    self.userCardPin = userCardPin
    self.someBank = someBank
    self.action = action
    self.paymentMethod = paymentMethod
 
    sendUserDataToBank(userCardId: userCardId, userCardPin: userCardPin, actions: action, payment: paymentMethod )
  }
 
 
  public final func sendUserDataToBank(userCardId: String, userCardPin: Int, actions: UserActions, payment: PaymentMethod?) {
    if someBank.checkCurrentUser(userCardId: userCardId, userCardPin: userCardPin) {
        switch actions {
        case .buttonrequestBalance: someBank.showUserBalance()
        case let .buttontopUpDepositCash(topUp: topUp):
                if someBank.checkMaxAccountDeposit(withdraw: topUp) {
                someBank.putCashDeposit(topUp: topUp)
                someBank.showTopUpAccount(cash: topUp)
                } else { TextErrors.notEnoughCashOnHands }
        case let .buttonwithdrawCashFromDeposit(withdraw: withdraw ):
            if someBank.checkMaxUserCash(cash: withdraw) {
                someBank.getCashFromDeposit(cash: withdraw)
                someBank.showWithdrawalDeposit(cash: withdraw)
            } else { TextErrors.notEnoughCashOnDeposit }
        case let .buttontopUpPhoneBalanceCashOrDeposit(phone: phone):
            if someBank.checkUserPhone(phone: phone) {
             if let payment = payment {
                switch payment {
                case let .cashik(cashik: payment):
                    if  someBank.checkMaxUserCash(cash: payment) {
                        someBank.topUpPhoneBalanceCash(pay: payment)
                        someBank.showUserToppedUpMobilePhoneCash(cash: payment)
                    } else { TextErrors.notEnoughCashOnHands}
                case let .depositik(depositik: payment):
                    if someBank.checkMaxAccountDeposit(withdraw: payment) {
                        someBank.topUpPhoneBalanceDeposit(pay: payment)
                        someBank.showUserToppedUpMobilePhoneDeposite(deposit: payment)
                    } else { TextErrors.notEnoughCashOnDeposit}
                }
             }
          }
      }
    } else { TextErrors.falseCardIdOrCardPin }
  }
}

protocol BankApi {
  func showUserBalance()
  func showUserToppedUpMobilePhoneCash(cash: Float)
  func showUserToppedUpMobilePhoneDeposite(deposit: Float)
  func showWithdrawalDeposit(cash: Float)
  func showTopUpAccount(cash: Float)
  func showError( error: TextErrors )
 
  func checkUserPhone(phone: String) -> Bool
  func checkMaxUserCash(cash: Float) -> Bool
  func checkMaxAccountDeposit(withdraw: Float) -> Bool
  func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool
 
  mutating func topUpPhoneBalanceCash(pay: Float)
  mutating func topUpPhoneBalanceDeposit(pay: Float)
  mutating func getCashFromDeposit(cash: Float)
  mutating func putCashDeposit(topUp: Float)
}

struct BankServer : BankApi {
    
    private var user : UserData
    init (user: UserData){
        self.user = user
    }
    
    func showUserBalance() {
        print("\(user.userName) \(DescriptionTypesAvailableOperations.requestBalanceDescription.rawValue) , на вашем депозите сейчас \(user.userBankDeposit)")
    }
    
    func showUserToppedUpMobilePhoneCash(cash: Float) {
        print("\(user.userName) \(DescriptionTypesAvailableOperations.topUpPhoneBalanceCashOrDepositDescription.rawValue) наличными на \(cash) , на балансе вашего телефона сейчас \(user.userPhoneBalance)")
    }
    
    func showUserToppedUpMobilePhoneDeposite(deposit: Float) {
        print("\(user.userName) \(DescriptionTypesAvailableOperations.topUpPhoneBalanceCashOrDepositDescription.rawValue) с банковского депозита на \(deposit), на балансе вашего телефона сейчас  \(user.userPhoneBalance)")
    }
    
    func showWithdrawalDeposit(cash: Float) {
        print("\(user.userName)\(DescriptionTypesAvailableOperations.withdrawCashFromDepositDescription.rawValue), количество ваших денег увеличилось на : \(cash), количество ваших наличных сейчас \(user.userCash), на вашем депозите сейчас \(user.userBankDeposit) ")
    }
    
    func showTopUpAccount(cash: Float) {
        print("\(user.userName)\(DescriptionTypesAvailableOperations.topUpDepositCashDescription.rawValue), количество денег на вашем банковском депозите  уменьшилось на \(cash), на вашем депозите сейчас \(user.userBankDeposit), количество ваших наличных сейчас \(user.userCash)")
    }
    
    func showError(error: TextErrors) {
        print("!!!!!!! \(user.userName), \(error.rawValue)")
    }
    
    func checkUserPhone(phone: String) -> Bool {
        if phone == user.userPhone {
            return true
        } else {
            return false
        }
    }
    
    func checkMaxUserCash(cash: Float) -> Bool {
        if cash < 1_000_000 {
            return true
        } else {
            return false
        }
    }
    
    func checkMaxAccountDeposit(withdraw: Float) -> Bool {
        if withdraw < 500_000 {
            return true
        } else {
            return false
        }
    }
    
    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool {
        if userCardId.count <= 19 && userCardPin < 10_000 {
            return true
        } else {
            return false
        }
    }
    
    mutating func topUpPhoneBalanceCash(pay: Float) {
        user.userPhoneBalance += pay
        user.userCash -= pay
    }
    
    mutating func topUpPhoneBalanceDeposit(pay: Float) {
        user.userPhoneBalance += pay
        user.userBankDeposit -= pay
    }
    
    mutating func getCashFromDeposit(cash: Float) {
        user.userBankDeposit -= cash
        user.userCash += cash
    }
    
    mutating func putCashDeposit(topUp: Float) {
        user.userBankDeposit += topUp
        user.userCash -= topUp
    }
}


let kate_borovkova : UserData = User(userName: "Екатерина Боровкова", userCardId: "1111 2222 3333 4444", userCardPin: 1234, userCash: 7000, userBankDeposit: 10000, userPhone: "+7(999)-999-99-99", userPhoneBalance: 100)
let bank = BankServer(user: kate_borovkova)
let atmSber = ATM(userCardId: "1111 2222 3333 4444", userCardPin: 1234, someBank: bank, action: .buttontopUpDepositCash(topUp: 350))

