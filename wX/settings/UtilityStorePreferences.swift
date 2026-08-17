// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityStorePreferences {

	static func setDefaults() {
		let value = Utility.readPref("LOC1_X", "")
		if value == "" {
			Utility.writePrefInt("LOC_NUM_INT", 1)
			Utility.writePref("LOC1_X", "35.231")
			Utility.writePref("LOC1_Y", "-97.451")
			Utility.writePref("LOC1_LABEL", "home")
			Utility.writePref("NWS1", "OUN")
			Utility.writePref("RID1", "TLX")
		}
	}
}
