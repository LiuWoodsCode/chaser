// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilityIO {

    static func uncompress(_ disFirst: MemoryBuffer) -> MemoryBuffer {
        var retSize: UInt32 = 2000000
        let oBuff = [UInt8](repeating: 1, count: Int(retSize))
        let compressedFileSize: CLong = disFirst.capacity - disFirst.position
        BZ2_bzBuffToBuffDecompress(
            MemoryBuffer.getPointer(oBuff),
            &retSize,
            MemoryBuffer.getPointerAndAdvance(disFirst.array, by: disFirst.position),
            UInt32(compressedFileSize),
            1,
            0
        )
        return MemoryBuffer(oBuff)
    }

    static func readTextFile(_ file: String) -> String {
        let fnParts = file.split(".")
        let path = Bundle.main.path(forResource: fnParts[0], ofType: fnParts[1])
        return (try? String(contentsOfFile: path!, encoding: .utf8)) ?? ""
    }

    static func rawFileToStringArrayFromResource(_ file: String) -> [String] {
        return readTextFile(file).split(GlobalVariables.newline)
    }

//    static func saveInputStream(_ data: Data, _ filename: String) {
//        do {
//            let documentDirUrl = try FileManager.default.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            )
//            let fileUrl = documentDirUrl.appendingPathComponent(filename)
//            try data.write(to: fileUrl, options: .atomic)
//        } catch let error as NSError {
//            print(error.description)
//        }
//    }

    static func readFileToByteBuffer(_ filename: String) -> MemoryBuffer {
        do {
            let documentDirUrl = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileUrl = documentDirUrl.appendingPathComponent(filename)
            let data = (try? Data(contentsOf: fileUrl)) ?? Data()
            return MemoryBuffer(data)
        } catch {
            print("error in readFiletoByteBuffer")
            return MemoryBuffer()
        }
    }

//    static func readFileToData(_ filename: String) -> Data {
//        do {
//            let documentDirUrl = try FileManager.default.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            )
//            let fileUrl = documentDirUrl.appendingPathComponent(filename)
//            return try Data(contentsOf: fileUrl)
//        } catch {
//            print("error in readFileToData")
//            return Data()
//        }
//    }

    static func readBitmapResourceFromFile(_ file: String) -> Bitmap {
        Bitmap(UIImage(named: file) ?? UIImage())
    }

    static func rawFileToStringArray(_ rawFile: String) -> [String] {
        readTextFile(rawFile).split("\n")
    }

//    static func getHtmlJust(_ url: String) -> String {
//        let myJustDefaults = JustSessionDefaults()
//        let just = JustOf<HTTP>(defaults: myJustDefaults)
//        let result = just.get(url)
//        if let str = String(data: result.content!, encoding: .utf8) {
//            print("UtilityIO.getHtmlJust: " + url + " ")
//            return str
//        } else {
//            print("ERROR UtilityIO.getHtmlJust: " + url + " ")
//            return ""
//        }
//    }

    static func getHtml(_ url: String) -> String {
        getStringFromUrl(url)
    }

    static func getStringFromUrl(_ url: String) -> String {
        UtilityLog.d("getStringFromUrl: " + url)
        guard let safeUrl = URL(string: url) else {
            return ""
        }
        do {
            return try String(contentsOf: safeUrl, encoding: .ascii)
        } catch {
            print("ERROR UtilityIO.getStringFromUrl: " + url + " " + error.localizedDescription)
        }
        return ""
    }

    static func getStringFromUrlUtf8(_ url: String) -> String {
        UtilityLog.d("getStringFromUrl: " + url)
        guard let safeUrl = URL(string: url) else {
            return ""
        }
        do {
            return try String(contentsOf: safeUrl, encoding: .utf8)
        } catch {
            print("ERROR UtilityIO.getStringFromUrl: " + url + " " + error.localizedDescription)
        }
        return ""
    }

    static func getStringFromUrlWin1252(_ url: String) -> String {
        UtilityLog.d("getStringFromUrl: " + url)
        guard let safeUrl = URL(string: url) else {
            return ""
        }
        do {
            return try String(contentsOf: safeUrl, encoding: .windowsCP1252)
        } catch {
            print("ERROR UtilityIO.getStringFromUrl: " + url + " " + error.localizedDescription)
        }
        return ""
    }

    static func getBitmapFromUrl(_ url: String) -> Bitmap {
        UtilityLog.d("getBitmapFromUrl: " + url)
        guard let safeUrl = URL(string: url) else {
            return Bitmap()
        }
        let imageData = try? Data(contentsOf: safeUrl)
        if let image = imageData {
            return Bitmap(image)
        } else {
            return Bitmap()
        }
    }

    static func getDataFromUrl(_ url: String) -> Data {
        UtilityLog.d("getDataFromUrl: " + url)
        guard let safeUrl = URL(string: url) else {
            return Data()
        }
        let imageData = try? Data(contentsOf: safeUrl)
        var data = Data()
        if let dataTmp = imageData {
            data = dataTmp
        }
        return data
    }
}
