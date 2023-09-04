import 'package:angular/angular.dart';
import 'dart:html';
import 'dart:async';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'message-input',
  templateUrl: 'message_input_component.html',
  styleUrls: ['message_input_component.css'],
  directives: [
    coreDirectives,
    materialDirectives,
    MaterialInputComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialFabComponent,
    MaterialMultilineInputComponent,
  ],
  providers: [materialProviders]
)
class MessageInputComponent {
  final _messageChange = StreamController<String>();
  @Output()
  Stream<String> get messageChange => _messageChange.stream;

  String _message = "";
  String get message => _message;
  @Input()
  set message(String val) {
    _message = val;
    _messageChange.add(val);
  }

  bool _inputDisabled;
  get inputDisabled => _inputDisabled;
  @Input()
  set inputDisabled(bool val) => _inputDisabled = val;

  bool _showSendButton = false;
  get showSendButton => _showSendButton;
  @Input()
  set showSendButton(bool val) => _showSendButton = val;

  bool _micAllowed = false;
  bool get micAllowed => _micAllowed;
  @Input()
  set micAllowed(bool val) => _micAllowed = val;

  bool _isRecording = false;
  bool get isRecording => _isRecording;
  @Input()
  set isRecording(bool val) => _isRecording = val;

  bool _showingMic = false;
  bool get showingMic => _showingMic;
  @Input()
  set showingMic(bool val) => _showingMic = val;

  bool _cameraAsNormalButton = false;
  bool get cameraAsNormalButton => _cameraAsNormalButton;
  @Input()
  set cameraAsNormalButton(bool val) => _cameraAsNormalButton = val;

  final _messageTrigger = StreamController<String>.broadcast(sync: true);
  @Output()
  get messageTrigger => _messageTrigger.stream;

  final _contentChangedController = StreamController<Event>.broadcast(sync: true);
  @Output()
  get contentChanged => _contentChangedController.stream;

  final _imageChangedController = StreamController<FileList>.broadcast(sync: true);
  @Output()
  get imageChanged => _imageChangedController.stream;

  final _attachedController = StreamController<FileList>.broadcast(sync: true);
  @Output()
  get attached => _attachedController.stream;

  final _micClickedController = StreamController<Event>.broadcast(sync: true);
  @Output()
  get micClicked => _micClickedController.stream;

  final _cancelClickedController = StreamController<Event>.broadcast(sync: true);
  @Output()
  get cancelClicked => _cancelClickedController.stream;

  final _cameraClickedController = StreamController<Event>.broadcast(sync: true);
  @Output()
  get cameraClicked => _cameraClickedController.stream;

  void handleEnter(KeyboardEvent event) {
    event.preventDefault();
    sendTextMessage();
  }

  void sendTextMessage() {
    String messageText = message.trim();
    if (messageText.isNotEmpty || showSendButton) {
      _messageTrigger.add(messageText);
    }
  }
  
  void handleKeyPress() {
    _contentChangedController.add(Event('contentChanged'));
  }

  void handleImageChange(FileList list) {
    _imageChangedController.add(list);
  }

  void handleAttachment(FileList list) {
    _attachedController.add(list);
  }

  void handleMicClicked() {
    _micClickedController.add(Event('mic button clicked'));
  }

  void handleCancelClicked() {
    _cancelClickedController.add(Event('cancel clicked'));
  }

  void handleCameraClicked() {
    _cameraClickedController.add(Event('camera clicked'));
  }
}