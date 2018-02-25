//
//  RecordViewController.swift
//  AthenaHacks
//
//  Created by Vinnie Chen on 2/24/18.
//  Copyright © 2018 Vinnie Chen. All rights reserved.
//

import UIKit
import AFNetworking
import AVFoundation
import Speech

var recordingSession: AVAudioSession!
var audioRecorder: AVAudioRecorder!
var soundPlayer: AVAudioPlayer?
var counter = 0.0
var stopwatch = Timer()
var isRunning = false

class RecordViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var stopwatchLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        stopwatchLabel.text = String("\(Int(counter/10)) min \(Int(counter.truncatingRemainder(dividingBy: 10))) sec")
       
        recordButton.layer.cornerRadius = recordButton.frame.height/2
        recordButton.clipsToBounds = true
        statsButton.layer.cornerRadius = statsButton.frame.height/2
        statsButton.clipsToBounds = true
        
        statsButton.isEnabled = false
        statsButton.backgroundColor = UIColor.gray
        resetButton.isEnabled = false
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    
                    // TODO: change these to be alerts instead
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode // else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
                self.recordButton.backgroundColor = UIColor.green
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textView.text = "(Go ahead, I'm listening)"
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    

    @IBAction func recordButtonTapped() {
        // check if app is already recording
        if audioEngine.isRunning {
            pauseTimer()
            statsButton.isEnabled = true
            statsButton.backgroundColor = UIColor.green
            resetButton.isEnabled = true
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            //recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            startTimer()
            recordButton.setTitle("Pause recording", for: [])
            recordButton.backgroundColor = UIColor.red
            resetButton.isEnabled = true
            statsButton.isEnabled = false
            statsButton.backgroundColor = UIColor.gray
            resetButton.isEnabled = false
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        resetTimer()
    }
    
    @objc func startTimer() {
        if(isRunning) {
            return
        }
        
        stopwatch = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    @objc func UpdateTimer() {
        counter = counter + 0.01
        stopwatchLabel.text = String("\(Int(counter/10)) min \(Int(counter.truncatingRemainder(dividingBy: 10))) sec")
    }
    
    @objc func pauseTimer() {
        recordButton.isEnabled = true
        stopwatch.invalidate()
        isRunning = false
    }

    @objc func resetTimer() {
        stopwatch.invalidate()
        isRunning = false
        counter = 0.00
        stopwatchLabel.text = String("\(Int(counter/10)) min \(Int(counter.truncatingRemainder(dividingBy: 10))) sec")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let speech = textView.text
        let statsViewController = segue.destination as! StatsViewController
        statsViewController.speechText = speech
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
