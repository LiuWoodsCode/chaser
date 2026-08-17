// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectModelGet {

    static func runStatus(_ objectModel: ObjectModel) {
        switch objectModel.prefModel {
        case "NSSLWRF":
            objectModel.runTimeData = UtilityModelNsslWrfInputOutput.getRunTime(objectModel)
        case "ESRL":
            objectModel.runTimeData = UtilityModelEsrlInputOutput.getRunTime(objectModel)
        case "NCEP":
            objectModel.runTimeData = UtilityModelNcepInputOutput.getRunTime(objectModel)
            objectModel.runTimeData.listRun = objectModel.runs
        case "WPCGEFS":
            objectModel.runTimeData = UtilityModelWpcGefsInputOutput.getRunTime()
        case "SPCHRRR":
            objectModel.runTimeData = UtilityModelSpcHrrrInputOutput.getRunTime()
        case "SPCHREF":
            objectModel.runTimeData = UtilityModelSpcHrefInputOutput.getRunTime()
        case "SPCSREF":
            objectModel.runTimeData = UtilityModelSpcSrefInputOutput.getRunTime()
        default:
            break
        }
    }

    static func image(_ objectModel: ObjectModel) -> Bitmap {
        switch objectModel.prefModel {
        case "NSSLWRF":
            return UtilityModelNsslWrfInputOutput.getImage(objectModel)
        case "ESRL":
            return UtilityModelEsrlInputOutput.getImage(objectModel)
        case "NCEP":
            if objectModel.model == "NAM4KM" {
                objectModel.model = "NAM-HIRES"
            }
            if objectModel.model.contains("HRW") && objectModel.model.contains("-AK") {
                objectModel.model = objectModel.model.replace("-AK", "")
            }
            if objectModel.model.contains("HRW") && objectModel.model.contains("-PR") {
                objectModel.model = objectModel.model.replace("-PR", "")
            }
            if objectModel.model != "HRRR" {
                objectModel.timeStr = objectModel.timeStr.truncate(3)
            } else {
                objectModel.timeStr = objectModel.timeStr.truncate(3)
            }
            return UtilityModelNcepInputOutput.getImage(objectModel)
        case "WPCGEFS":
            return UtilityModelWpcGefsInputOutput.getImage(objectModel)
        case "SPCHRRR":
            return UtilityModelSpcHrrrInputOutput.getImage(objectModel)
        case "SPCHREF":
            return UtilityModelSpcHrefInputOutput.getImage(objectModel)
        case "SPCSREF":
            return UtilityModelSpcSrefInputOutput.getImage(objectModel)
        default:
            return Bitmap()
        }
    }

    static func animation(_ objectModel: ObjectModel) -> AnimationDrawable {
        switch objectModel.prefModel {
        case "NSSLWRF":
            return UtilityModels.getAnimation(objectModel, UtilityModelNsslWrfInputOutput.getImage)
        case "ESRL":
            return UtilityModels.getAnimation(objectModel, UtilityModelEsrlInputOutput.getImage)
        case "NCEP":
            return UtilityModels.getAnimation(objectModel, UtilityModelNcepInputOutput.getImage)
        case "WPCGEFS":
            return UtilityModels.getAnimation(objectModel, UtilityModelWpcGefsInputOutput.getImage)
        case "SPCHRRR":
            return UtilityModels.getAnimation(objectModel, UtilityModelSpcHrrrInputOutput.getImage)
        case "SPCHREF":
            return UtilityModels.getAnimation(objectModel, UtilityModelSpcHrefInputOutput.getImage)
        case "SPCSREF":
            return UtilityModels.getAnimation(objectModel, UtilityModelSpcSrefInputOutput.getImage)
        default:
            return AnimationDrawable()
        }
    }
}
