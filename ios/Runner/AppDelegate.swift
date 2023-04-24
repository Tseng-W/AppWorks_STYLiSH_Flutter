import Flutter
import TPDirect
import UIKit

let CONST_TEST_TAPPAY_ID: Int32 = 12348
let CONST_TEST_TAPPAY_APP_KEY = "app_pa1pQcKoY22IlnSXq5m5WP5jFKzoRG58VEXpT7wU62ud7mMbDOGzCYIlzzLF"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        weak var register = self.registrar(forPlugin: "TapPayViewPlugin")
        let factory = FLNativeViewFactory(messenger: register!.messenger())
        self.registrar(forPlugin: "<TapPayView>")?.register(factory, withId:  "<TapPayView>")

        let appID: Int32 = CONST_TEST_TAPPAY_ID
        TPDSetup.setWithAppId(appID, withAppKey: CONST_TEST_TAPPAY_APP_KEY, with: TPDServerType.sandBox)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

import SnapKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(
            view: _view,
            messageChannel: FlutterBasicMessageChannel(name: "tapPayResponse", binaryMessenger: messenger!, codec: FlutterStringCodec.sharedInstance())
        )
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView, messageChannel: FlutterBasicMessageChannel){
        let tapPayView = TapPayView(messageChannel: messageChannel)
        _view.addSubview(tapPayView)
        tapPayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @IBAction func someTap(_ button: Any) {
        _view.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
}

class TapPayView: UIView {
    private let cardView: UIView = .init()
    private let payButton: UIButton = .init()
    private var tpdForm: TPDForm?
    private var tpdCard: TPDCard?
    private let messageChannel: FlutterBasicMessageChannel

    init(messageChannel: FlutterBasicMessageChannel) {
        self.messageChannel = messageChannel
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        addSubview(cardView)
        addSubview(payButton)

        cardView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.greaterThanOrEqualTo(200)
        }
        payButton.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalTo(cardView)
        }

        guard let tpdForm = TPDForm.setup(withContainer: cardView) else { fatalError() }
        tpdCard = TPDCard.setup(tpdForm)
        tpdForm.setOkColor(.systemGreen)
        tpdForm.setNormalColor(.black)
        tpdForm.setErrorColor(.systemRed)
        tpdForm.onFormUpdated({ [weak self] status in
            self?.payButton.isEnabled = status.isCanGetPrime()
            self?.payButton.alpha = status.isCanGetPrime() ? 1.0 : 0.25
        })

        payButton.setTitle("Click to pay", for: .normal)
        payButton.backgroundColor = .blue
        payButton.isEnabled = false
        payButton.alpha = 0.25

        payButton.addTarget(self, action: #selector(tapPay(_:)), for: .touchUpInside)
    }

    @IBAction func tapPay(_ action: Any) {
        backgroundColor = UIColor.init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)

        tpdCard?.onSuccessCallback({ primes, cardInfo, cardIdentifier, merchantReferenceInfo in
            print("Success::prime: \(primes), info: \(cardInfo), identifier: \(cardIdentifier), merchantReferenceInfo: \(merchantReferenceInfo)")
            self.messageChannel.sendMessage(primes) { response in
                print("iOS send response: \(response)")
            }
        })
        .onFailureCallback({ status, message in
            print("Failure:: status:\(status), message:\(message)")
//            self.messageChannel.sendMessage(3) { response in
            self.messageChannel.sendMessage(message) { response in
                print("iOS send response: \(response)")
            }
        }).getPrime()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if let textField = view as? UITextField {
            textField.becomeFirstResponder()
        } else if let button = view as? UIButton {
            tapPay(button)
        }
        return view
    }
}
