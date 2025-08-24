import UIKit
import CoreLocation

let USERDEFAULTS = UserDefaults.standard
let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
let googleApiKey = "AIzaSyDuQY-uO9-GbTMztijC72zp4JS8l7-7nQg"

let pubnubpublishkey = "pub-c-60eb1cea-309e-46a3-a580-bbb44beb63c6"
let pubnubsubscribekey = "sub-c-6131ff14-9d23-11e7-8e6b-ae1a713ba7dc"
var curOption = ["GBP"]
var lang_name = [String]()
var lang_id = [String]()
var lang_Shrtform = [String]()
var currency_name = [String]()
var curr_symbol = [String]()
var convertion_ratio_value = [String]()
var currarr: NSArray? = NSArray()
var langarr: NSArray? = NSArray()

var msgcontent = ""
var msgcontent_ar = ""
var msgsubject = ""
var msgsubject_ar = ""

var userAddress = ""
var userDetails = [String: Any]()
var userImage: UIImage?

var vehicleCategory: NSArray? = NSArray()


var currenc: String? = "GBP"
var currency_symbol: String? = "GBP"
var currencymul = "1"

var invitecode: String? = ""

var bookingID = ""
var customerNumber = ""
var totalAmount = ""
var totalDistance = ""

var miles_dis_text = ""
var miles_dis_value = Int()

var firebaseDictArray = NSMutableArray()

var serviceCategory = "gassellingservice"
var myserviceCategory = ""

var waitalert: UIAlertController?

var driver_name = ""
var driver_id = ""
var driver_mob_no = ""
var device_id = "123"
var driver_rating = ""
var driver_lname = ""
var date_with_time = ""
var pickupLatitude = ""
var tripdropLocation = ""


var customer_lname = ""
var customer_email = ""
var customer_mobile = ""
var customer_name = ""
var customer_id = ""
var customer_mob_no = ""
var customer_image = ""
var currency: String? = "USD"

var userlang = "English"
var ride = ""
var distance_limit = 500

var categoryAddressLbl = ""

struct BASEAPI {
    
    //http://towroute.uplogictech.com/
    //https://backend.towroute.com/
    
    static let URL = "https://backend.towroute.com/api"
    static let IMGURL = "https://backend.towroute.com/uploads/"
    static let IMGURL1 = "https://backend.towroute.com/"
    static let PRFIMGURL = "https://backend.towroute.com/"
}

struct LoginAPI {
    static let userLogin = BASEAPI.URL + "/auth/login"
    static let userRegister = BASEAPI.URL + "/auth/register"
    static let updateProfile = BASEAPI.URL + "/updateprofile"
    static let profileView = BASEAPI.URL + "/profileView"
    static let refreshToken = BASEAPI.URL + "/auth/refresh"
    static let imageupload = BASEAPI.URL + "/picupload"
    static let categories = BASEAPI.URL + "/Categories"
    static let customerOnGoing = BASEAPI.URL + "/customerongoing"
    static let contactAdd = BASEAPI.URL + "/emergencyContactCustomer"
    static let contactDelete = BASEAPI.URL + "/emergencyContactDelete"
    static let contactGet = BASEAPI.URL + "/emergencyContactGET"
    static let sociallog = BASEAPI.URL + "/auth/SocialLog"
    static let privacypolicy = BASEAPI.URL + "/Support"
    static let profileEdit = BASEAPI.URL + "/customer_edit.php"
    static let profilePicEdit = BASEAPI.URL + "/customer_profile_update.php"
    static let forgotPassword = BASEAPI.URL + "/forgot_password.php"
    static let changePassword = BASEAPI.URL + "/change_password.php"
    static let otpVerify = BASEAPI.URL + "/otp_verify.php"
    static let rideNow = BASEAPI.URL + "/customer_location.php"
    static let vehicleCategory = BASEAPI.URL + "/vehicle_category.php"
    static let currentRide = BASEAPI.URL + "/trips.php"
    static let subCategories = BASEAPI.URL + "/Service"
    static let viewAdvertisement = BASEAPI.URL + "/getbanners"
    static let logout = BASEAPI.URL + "/logout.php"
    static let customerAddMoney = BASEAPI.URL + "/customerAddMoney"
    static let availabilityCheckService = BASEAPI.URL + "/availabilityCheckService"
    static let scheduledBooking = BASEAPI.URL + "/scheduledBooking"
    static let pastJobs = BASEAPI.URL + "/pastjobs"
    static let upcomingJobs = BASEAPI.URL + "/upcomingJobs"
    static let driverFeedbackStore = BASEAPI.URL + "/CustomerFeedbackStore"
    static let updatePassword = BASEAPI.URL + "/updatePassword"
    static let verifyMobile = BASEAPI.URL + "/forgetpass"
    static let verifyOtp = BASEAPI.URL + "/verifyotp"
    static let transaction = BASEAPI.URL + "/Transaction"
    static let customerTripPayment = BASEAPI.URL + "/Paycard"
    static let customerBalancePayment = BASEAPI.URL + "/customerTripPayment"
    static let cancelJobs = BASEAPI.URL + "/cancelJobs"
    static let declineJob = BASEAPI.URL + "/scheduledcancelJobs"
    static let passwordChange = BASEAPI.URL + "/auth/passwordChange"
    static let appSetting = BASEAPI.URL + "/appsetting"
    static let verifyEmail = BASEAPI.URL + "/emailAvailable"
    static let checkPromoCode = BASEAPI.URL + "/checkPromoCode"
    static let notificationToDriver = BASEAPI.URL + "/notifysend"
    static let cancelNotificationToDriver = BASEAPI.URL + "/notifycancel"
    
}
func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, label: UILabel) {
    var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
    let lat: Double = Double("\(pdblLatitude)")!
    //21.228124
    let lon: Double = Double("\(pdblLongitude)")!
    //72.833770
    let ceo: CLGeocoder = CLGeocoder()
    center.latitude = lat
    center.longitude = lon
    
    let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
    
    
    ceo.reverseGeocodeLocation(loc, completionHandler:
        {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            
            guard placemarks != nil else {
                return
            }
            
            let pm = placemarks! as [CLPlacemark]
            
           if pm.count > 0 {
//                let pm = placemarks![0]
//                /* print(pm.country)
//                 print(pm.locality)
//                 print(pm.subLocality)
//                 print(pm.thoroughfare)
//                 print(pm.postalCode)
//                 print(pm.subThoroughfare) */
//                var addressString : String = ""
//                if pm.subLocality != nil {
//                    addressString = addressString + pm.subLocality! + ", "
//                }
//                if pm.thoroughfare != nil {
//                    addressString = addressString + pm.thoroughfare! + ", "
//                }
//                if pm.locality != nil {
//                    addressString = addressString + pm.locality! + ", "
//                }
//                if pm.country != nil {
//                    addressString = addressString + pm.country! + ", "
//                }
//                if pm.postalCode != nil {
//                    addressString = addressString + pm.postalCode! + " "
//                }
//
//                label.text = addressString
//                print(addressString)
//
//                APPDELEGATE.pickupLoationAddress = addressString
//
//            }
            
                let pm = placemarks![0]
            
                 print(pm.country)
                 print(pm.locality)
                 print(pm.subLocality)
                 print(pm.thoroughfare)
                 print(pm.postalCode)
                 print(pm.subThoroughfare)
            
            var addressString : String = ""
                
                
                
                if pm.postalAddress?.street != "" {
                    addressString = addressString + (pm.postalAddress?.street)! + ", "
                }
                if pm.postalAddress?.subLocality != "" {
                    addressString = addressString + (pm.postalAddress?.subLocality)! + ", "
                }
                if pm.postalAddress?.city != "" {
                    addressString = addressString + (pm.postalAddress?.city)! + ", "
                }
                if pm.postalAddress?.state != "" {
                    if pm.postalAddress?.city == pm.postalAddress?.state
                    {
                        
                        
                    }
                    else
                    {
                        addressString = addressString + (pm.postalAddress?.state)! + ", "
                    }
                }
                
                
                if pm.postalAddress?.postalCode != "" {
                    addressString = addressString + (pm.postalAddress?.postalCode)! + ", "
                }
                if pm.postalAddress?.country != "" {
                    addressString = addressString + (pm.postalAddress?.country)! + " "
                }
                
                label.text = addressString
                print(addressString)
                
                APPDELEGATE.pickupLoationAddress = addressString
                
            }
    })
    
}
func getCountryCallingCode(countryRegionCode:String)->String{
    
    let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
    let countryDialingCode = prefixCodes[countryRegionCode]
    return countryDialingCode!
    
}
