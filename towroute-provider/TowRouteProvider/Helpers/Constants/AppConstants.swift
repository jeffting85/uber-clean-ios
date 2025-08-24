//
//  AppConstants.swift
//  Noor
//
//  Created by Uplogic-user on 19/05/17.
//  Copyright © 2017 Uplogic. All rights reserved.
//

import UIKit

let USERDEFAULTS = UserDefaults.standard
let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)

let googleApiKey = "AIzaSyDuQY-uO9-GbTMztijC72zp4JS8l7-7nQg" //***** TowRoute


var driver_id = ""
var driver_name = ""
var driver_lname = ""
var driver_email = ""
var driver_mobile = ""
var driver_dob = ""
var driver_vehicle_type = "gassellingservice"
var driverAddress = ""
var driver_image = ""
var userImage: UIImage?

var navigation_status = ""
var lang_name = [String]()
var lang_id = [String]()
var lang_Shrtform = [String]()
var currency_name = [String]()
var curr_symbol = [String]()
var convertion_ratio_value = [String]()
var currarr: NSArray? = NSArray()
var langarr: NSArray? = NSArray()
var proof_document = [String]()
var proof_document_pt = [String]()
var img_url = [String]()
var proof_expiry_status = [String]()
var proof_expiry_date = [String]()
var proof_status = [String]()
var proof_id = [String]()
var document = [String]()
var documentnames = [String]()
var approvedsts = [String]()
var reason = [String]()
var firebaseDictArray = NSMutableArray()

var msgcontent = ""
var msgcontent_ar = ""
var msgsubject = ""
var msgsubject_ar = ""

var driver_car_type = ""
var driver_vechile_no = ""
var driver_license_no = ""

var tripbookingID = "75"
var customer_num = "6746"

var trip_price = ""

var customer_name = ""
var customer_lname = ""
var customer_id = ""
var cus_mob_no = ""
var cus_msg_no = ""
var cus_pickup_addr = ""
var cus_pickup_lat = ""
var cus_pickup_long = ""
var cus_drop_addr = ""
var cus_drop_lat = ""
var cus_drop_long = ""

var cus_time = ""
var cus_totaldis = ""

var cus_bfare = ""
var cus_cat = ""

var vehicleCategory: NSArray? = NSArray()

var waitalert: UIAlertController?

var currency: String? = "GBP"
var invitecode: String? = ""

var currenc: String? = "GBP"
var currency_symbol: String? = "GBP"
var currencymul = "1"
var tripdelayaccept = 30

var created: String? = ""

/// payout details

var payoutAccountNo: String?
var payoutBankName: String?
var payoutBankcode: String?
var payoutPaypalemail: String?
var payoutType: String?

var payoutdriver_name: String?
var payoutdriver_lname: String?
var payoutdriver_email: String?
var payoutdriver_mobile: String?
var payoutdriver_dob: String?

var mat = "0"
var misc = "0"
var discounttext = "0"
var distancetext = ""
var addresstext = ""
var customer_phone_number = ""
var customer_avatar = ""
var navbarHeight = CGFloat()
var notificationPush = ""

var timeslottitle = ""

struct BASEAPI {
    
    //http://towroute.uplogictech.com/
    //https://backend.towroute.com/
    
    static let URL = "https://backend.towroute.com/api"
    static let IMGURL = "https://backend.towroute.com/"
    static let PRFIMGURL = "https://backend.towroute.com/uploads/"
}


struct LoginAPI {
    
    static let cashpayment = BASEAPI.URL + "/cashPayment"
    static let driverLogin = BASEAPI.URL + "/auth/logind"
    static let driverRegister = BASEAPI.URL + "/auth/registerDriver"
    static let profileViewDriver = BASEAPI.URL + "/profileViewDriver"
    static let updateProfileDriver = BASEAPI.URL + "/updateprofileDriver"
    static let imageUploadDriver = BASEAPI.URL + "/picuploadDriver"
    static let certificateUploadDriver = BASEAPI.URL + "/documentUpload"
    static let certificateReUploadDriver = BASEAPI.URL + "/proofreupload"
    static let viewDocuments = BASEAPI.URL + "/viewdocument"
     static let sociallog = BASEAPI.URL + "/auth/SocialLogDriver"
    static let checkin = BASEAPI.URL + "/checkin"
    static let checkout = BASEAPI.URL + "/checkout"
    static let allServicesDriver = BASEAPI.URL + "/ServiceSelectionGet"
    static let updateService = BASEAPI.URL + "/ServiceSelection"
    static let categoriesDriver = BASEAPI.URL + "/CategoriesDriver"
    static let subCategoriesDriver = BASEAPI.URL + "/ServiceDriver"
    static let privacypolicy = BASEAPI.URL + "/Support"
    static let acceptService = BASEAPI.URL + "/requestService"
    static let stripeacceptService = BASEAPI.URL + "/stripePayment"
    static let refreshToken = BASEAPI.URL + "/auth/refreshd"
    static let pastJobs = BASEAPI.URL + "/pastjobs"
    static let upcomingJobs = BASEAPI.URL + "/upcomingJobs"
    static let pendingJobs = BASEAPI.URL + "/pendingJobs"
    static let declineJob = BASEAPI.URL + "/scheduledcancelJobs"
    static let acceptJob = BASEAPI.URL + "/scheduleJobAccept"
    static let startJob = BASEAPI.URL + "/scheduletripStart"
    static let viewBankDet = BASEAPI.URL + "/bankDetailsGet"
    static let updateBankDet = BASEAPI.URL + "/bankDetailsUpdate"
    static let driverAddMoney = BASEAPI.URL + "/driverAddMoney"
    static let contactAdd = BASEAPI.URL + "/emergencyContactDriver"
    static let contactDelete = BASEAPI.URL + "/emergencyContactDeleteDriver"
    static let contactGet = BASEAPI.URL + "/emergencyContactGETDriver"
    static let driverFeedback = BASEAPI.URL + "/DriverFeedback"
    static let driverFeedbackStore = BASEAPI.URL + "/DriverFeedbackStore"
    static let updatePassword = BASEAPI.URL + "/updatePassword"
    static let verifyMobile = BASEAPI.URL + "/forgetpass"
    static let verifyOtp = BASEAPI.URL + "/verifyotp"
    static let transaction = BASEAPI.URL + "/TransactionDriver"
    static let cancelJobs = BASEAPI.URL + "/cancelJobs"
    static let passwordChange = BASEAPI.URL + "/auth/passwordChangeDriver"
    static let appSetting = BASEAPI.URL + "/appsetting"
    static let verifyEmail = BASEAPI.URL + "/emailAvailable"
    static let notificationToCustomer = BASEAPI.URL + "/notifysend"
    static let managedocument = BASEAPI.URL + "/manage_document"
   static let viewdoc = BASEAPI.URL + "/viewdocument_e"
   static let imgUrl = BASEAPI.URL + "/document_update_e"
     static let imgUpload = BASEAPI.URL + "/imageupload_e?"
    static let imgreUpload = BASEAPI.URL + "/proofreupload_e?"
}

func returndictkey(dict: NSDictionary, key: String) -> String {
    
    if let val = dict[key] {
        return "\(val)"
    }
    
    return ""
    
}
func getCountryCallingCode(countryRegionCode:String)->String{
    
    let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
    let countryDialingCode = prefixCodes[countryRegionCode]
    return countryDialingCode!
    
}

func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
    // let bearing = getBearingBetweenTwoPoints1(point1: startLocation, point2: lastLocation)
    //print("bearingg\(bearing)")
    let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
    let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
    
    let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
    let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
    
    let dLon = lon2 - lon1
    //  print("dlonn\(dLon)")
    let y = sin(dLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
    let radiansBearing = atan2(y, x)
    
    return radiansToDegrees(radians: radiansBearing)
    
}


//////////////////////////////////////////////////

