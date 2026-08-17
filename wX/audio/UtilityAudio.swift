// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import AVFoundation

final class UtilityAudio {

    static func playClicked(_ string: String, _ synthesizer: AVSpeechSynthesizer, _ button: ToolbarIcon) {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            button.set(.pause)
        } else if !synthesizer.isSpeaking {
            let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.translateAbbreviations(string))
            synthesizer.speak(myUtterance)
            button.set(.pause)
        } else {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            button.set(.play)
        }
    }

    static func playClickedNewItem(_ string: String, _ synthesizer: AVSpeechSynthesizer, _ button: ToolbarIcon) {
        let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.translateAbbreviations(string))
        synthesizer.speak(myUtterance)
        button.set(.pause)
    }

    static func resetAudio(_ uiv: UIwXViewControllerWithAudio) {
        if uiv.synthesizer.isSpeaking {
            uiv.synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        }
        uiv.synthesizer = AVSpeechSynthesizer()
    }
}
