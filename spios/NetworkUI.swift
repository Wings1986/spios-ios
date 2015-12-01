//
//  NetworkUI.swift
//  spios
//
//  Created by MobileGenius on 6/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//




import UIKit
import Alamofire
import Analytics

/// Include all Webservice URL and network functions with Alamofire

class NetworkUI: NSObject {
    
    
    /// Base url of api
    let kBaseURL                :String = "https://www.studypool.com/"
    
    /// create url of api
    let kCreateURL              :String = "https://www.createpool.com/"

    
    /// Auth api
    let kAuth                   :String = "site/apiloginstan"//
    
    /// Signup api
    let kSignup                 :String = "site/apisignupstan"//

    /// Signup api
    let kCheckPhoneVerified     :String = "API/CheckPhoneVerified"

    
    ///Post free question
    let kPostQuestionURL        :String = "API/apicreatefreestan"//
    
    ///Post paid question
    let kPostPaidQuestionURL    :String = "API/newquestion"
    
    ///Get My Question
    let kGetMyQuestions         :String = "API/getmyquestions"
    
    ///Get Search query
    let kGetSearchQuery         :String = "API/Searchmyquestions"
    
    ///Get profile
    let kGetProfile             :String = "API/getstudentprofile"
    
    ///Get Avatar
    let kGetAvatarList          :String = "API/getavatarlist"
    
    /// Set Profile URL
    let kSetProfileURL          :String = "API/setprofile"
    
    /// Get My Answers
    let kGetMyAnswer            :String = "API/apimyanswers"//
    
    /// Get Mebmership status
    let kGetMembership          :String = "API/apimembershipcheckstan"//
    
    /// Get AnsweredQuestion
    let kGetAnswerQuestion      :String = "API/apinewest"//
    
    /// Get Bid list of question
    let kGetBidList             :String = "API/getbids"
    
    /// Get one Bid info
    let kGetOneBidList          :String = "API/getonebid"
    
    /// Check if this question is answered
    let kCheckQuestionTaken     :String = "API/apichecktake"//
    
    /// Get Question Detail
    let kGetQuestionDetail      :String = "API/getquestiondetails"
    
    /// Get Answer Detail
    let kGetAnswerDetail        :String = "API/getFinalreceipt"
    
    /// Get Chat history of question between tutor and student
    let kGetDiscussions         :String = "API/getDiscussion"
    
    /// Rate tutor and leave the review
    let kPostAcceptAnswer       :String = "API/finishandreview"
    
    /// Decline tutor's answer, leave the reason
    let kPostDeclineAnswer      :String = "API/withdraw"
    
    /// Get Tutor's profile picture url `````````````````
    let kGetTutorProfilePic     :String = "API/getprofilepic"
    
    /// Send message to Tutor
    let kPostTalk               :String = "API/newDiscussionMessage"
    
    /// Get Promocode from server
    let kGetPromocode           :String = "API/getmyReferralCode"
    
    /// Send promocode
    let kSubmitPromocode        :String = "API/claimReferral"
    
    /// Get Student Profile
    let kGetStudentProfile      :String = "API/getstudentprofile"
    
    /// Get Tutor Profile
    let kGetTutorProfile        :String = "API/gettutorprofile"

    /// Get Tutor Answer(not used)
    let kGetTutorAnswerTaken   :String = "API/ApiAnswerTakeStan"//
    
    /// Post Tutor Answer(not used)
    let kPostTutorAnswerSubmit :String = "API/apisubmitanswersstan"//
    
    /// Send Phonenumber to get SMS
    let kGetPhoneCode          :String = "API/SendPhoneVerificationCode"
    
    /// Confirm SMS code
    let kGetPhoneConfirm       :String = "API/ConfirmPhoneVerificationCode"
    
    /// Check payment status
    let kCheckToken            :String = "API/checkpaymenttoken"

    /// Select tutor for answer (payment)
    let kAcceptTutor           :String = "API/confirmTutor"
    
    /// Release milestone for Tutor's answer (payment)
    let kFinalPayment          :String = "API/sendFinalPayment"
    
    /// Retrieve Password
    let kRetrievePW            :String = "user/recovery/apirecovery?UserRecoveryForm[login_or_email]="//
    
    /// Get referral link
    let kReferralLink          :String = "API/getAppLink"
    
    
    let kIdentify              :String = "API/createsegmentidentify"
    
    /// Get balance
    let kBalance               :String = "API/getStudentBalance"
    
    /// Get deadline
    let kDeadline              :String = "API/getDeadline"
    
    /// Post User device token
    let kPostDeviceToken       :String = "API/savepushnotificationtoken"
    
    let kClearNotificationBadge :String = "API/actionclearNotificationBadge"
    
    static let sharedInstance = NetworkUI()
    
    
    
    /**
    Confirm user Auth
    
    :param: params      
    
            - "email"
            - "password"
    :param: success
    
    :returns:
    */
    
    func confirmAuth(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void){
        Alamofire.request(.GET, String(format: "%@%@", kCreateURL, kAuth), parameters: params)
            .responseJSON { (_, _, JSON, error) in

                if(error == nil && JSON != nil){
                    
                    //SEGMENT_CODE: TRACKER
                    SEGAnalytics.sharedAnalytics().track("Regular Log In")
                    
                    success(response: JSON)
                }
                else{
                    
                    failure(error: error)
                }
                
        }
    }
    
    /**
    Signup
    
    :param: params
    
        - "email"
        - "username"
        - "password"
        - "pin"
    :param: success
    
    :returns:
    */
    
    func signup(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void){
        Alamofire.request(.GET, String(format: "%@%@", kCreateURL, kSignup), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    SEGAnalytics.sharedAnalytics().track("Sign up")
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
                
        }
    }
    
    /**
    Phone Verification
    
    :param: params      ["token": token]
    :param: success
    
    :returns:
    */
    
    func isCheckPhoneVerification(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void){
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kCheckPhoneVerified), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("isCheckPhoneVerification", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Get UrlRequest for multiple image uploading with post parameters
    
    :param: urlString   api url of image upload
    :param: parameters  post question parameters
    :param: image       array of image data
    
    :returns: URLRequestConvertible and NSData
    */
    func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, AnyObject>, image:[NSData]) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        var index = 0
        
        for i in image{
            
            let strName = String(format:"media%d",index)
            // add image
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(strName)\"; filename=\"image.jpg\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData(i)
            
            var postData = String()
            postData += "\r\n"
            postData += "\r\n--\(boundaryConstant)--\r\n"
            uploadData.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            index++

        }
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
    
    /**
    Get Get student profile
    
    :param: params      ["token": token]
    :param: success
    
    :returns:
    */
    
    func getStudentsProfile(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetProfile), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getStudentsProfile", JSON: JSON!)
                    
                    var model = ProfileModel(dic: JSON as! NSDictionary)
                    success(response: model)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    
    /**
    Get Avatar Array
    
    :param: params      ["token": token]
    :param: success
    
    :returns:
    */
    func getAvatarList(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetAvatarList), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getAvatarList", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Get membership info
    
    :param: params      ["token": token]
    :param: success     callback
    
    :returns:
    */
    func getMembership(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetMembership), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getMembership", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Set profile image url
    
    :param: params
    
                        - "token"
                        - "path"
    
    :param: success
    
    :returns:
    */
    func setAvatarImagePath(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kSetProfileURL), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("setAvatarImagePath", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
        
    }
    
    /**
    Post paid question with images
    
    :param: params
    
                        - "token"
                        - "Questions[name]"
                        - "Questions[money]"
                        - "Questions[high]"
                        - "Questions[description]"
                        - "Questions[days]"
                        - "Questions[type]":type,
                        - "Questions[urgent]"
                        - "Questions[private]"
                        - "primary"
                        - "imagecount"
                        - "isPic"
    :param: images      array of images
    :param: success
    
    :returns:
    */
    func postQuestion(params:[String: AnyObject], images:[UIImage], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        var arrImages = [NSData]()
        
        for i in images{
            let imageData = UIImageJPEGRepresentation(i, 0.5);
            arrImages.append(imageData)
        }
        
        
        
        
        // CREATE AND SEND REQUEST ----------
        
        let urlRequest = urlRequestWithComponents(String(format: "%@%@", kBaseURL, kPostPaidQuestionURL), parameters: params, image: arrImages)
        
        Alamofire.upload(urlRequest.0, urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }

            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    if let result = JSON as? NSDictionary {
                        if (result["segment"] != nil) {
                            SEGAnalytics.sharedAnalytics().track("Posted a Question", properties: result["segment"] as? [NSObject: AnyObject])
                        }
                        else {
                            SEGAnalytics.sharedAnalytics().track("Posted a Question")
                        }
                    }
                    
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    
    }
    
    /**
    Post paid question without image
    
    :param: params      
    
                        - "token"
                        - "Questions[name]"
                        - "Questions[money]"
                        - "Questions[high]"
                        - "Questions[description]"
                        - "Questions[days]"
                        - "Questions[type]":type,
                        - "Questions[urgent]"
                        - "Questions[private]"
                        - "primary"
                        - "imagecount"
                        - "isPic"
    :param: success     callback
    
    :returns:
    */
 
    
    func postQuestion(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        NSLog("%@", params)

        Alamofire.request(.POST, String(format: "%@%@", kBaseURL, kPostPaidQuestionURL), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if(error == nil && JSON != nil) {
                    //println(JSON)
                    self.reportToSegment("Posted a Question", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
        
    }
    
    /**
    Post paid question without image
    
    :param: params
    
                        - "token"
                        - "refresh_all" or
                        - "page"
    
    :param: success
    
    :returns:
    */
    func getMyQuestions(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetMyQuestions), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getMyQuestions", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    
    /**
    Get My Answered Question list
    
    :param: params
    
        - "token"
        - "category"
        - "refresh_all"
    
    :param: success
    
    :returns:
    */
    func getAnswerQuestion(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetAnswerQuestion), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getAnswerQuestion", JSON: JSON!)
                    success(response: JSON)
                }
                else{
                    failure(error: error)
                }
                
        }
    }
    
    /**
    Get My Answered Question list
    
    :param: params
    
            - "token"
            - "page"
    
    :param: success
    
    :returns:
    */
    func getMyAnswer(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetMyAnswer), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getMyAnswer", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    
    /**
    Get Search Query list
    
    :param: params
    
        - "token"
        - "query"
    
    :param: success
    
    :returns:
    */
    func getSearchQuery(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetSearchQuery), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getSearchQuery", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    
    
    /**
    Get Search Query list
    
    :param: params
    
        - "token"
        - "query"
    
    :param: success
    
    :returns:
    */
    func getCheckQuestionTaken(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(params)
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kCheckQuestionTaken), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getCheckQuestionTaken", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Get Bid list of question
    
    :param: params
    
        - "token"
        - "questions_id"
    
    :param: success
    
    :returns:
    */
    func getBidList(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(params)
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetBidList), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getBidList", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Get one bid info
    
    :param: params
    
        - "token"
        - "answer_id"
    
    :param: success
    
    :returns:
    */
    func getOneBidList(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(params)
        
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetOneBidList), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getOneBidList", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    
    /**
    Get Question Detail
    
    :param: params
    
        - "token"
        - "question_id"
    
    :param: success
    
    :returns:
    */
    func getQuestionDetail(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(kGetQuestionDetail, params)
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetQuestionDetail), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                //println(JSON)
                 
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getQuestionDetail", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Get Answer Detail
    
    :param: params
    
        - "token"
        - "answer_id"
    
    :param: success
    
    :returns:
    */
    func getAnswerDetail(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(kGetAnswerDetail, params)
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetAnswerDetail), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                //println(JSON)

                if (error == nil && JSON != nil) {
                    self.reportToSegment("Paid for Question", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Get Chat history of question between tutor and student
    
    :param: params
    
        - "token"
        - "answer_id"
    
    :param: success
    
    :returns:
    */
    
    func getDiscussions(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(params)
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetDiscussions), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getDiscussions", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Rate tutor and leave the review
    
    :param: params
    
        - "token"
        - "answer_id"
        - "rating"
        - "review"
    
    :param: success
    
    :returns:
    */
    func postAcceptAnswer(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(params)
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kPostAcceptAnswer), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("postAcceptAnswer", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Decline tutor's answer, leave the reason
    
    :param: params
    
        - "token"
        - "answer_id"
        - "reason"
        - "review"
    
    :param: success
    
    :returns:
    */
    func postDeclineAnswer(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(params)
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kPostDeclineAnswer), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("postDeclineAnswer", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Send message to Tutor
    
    :param: params
    
        - "token"
        - "answer_id"
        - "message"
    
    :param: success
    
    :returns:
    */

	func postComment(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
		
		//println(params)
		Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kPostTalk), parameters: params)
			.responseJSON { (_, _, JSON, error) in
				//println(JSON)
				
				if (error == nil && JSON != nil) {
					success(response: JSON)
                    let result = JSON! as! NSMutableDictionary
                    var responsestring = result["success"] as! Int
                    if (responsestring > 0) {
                        SEGAnalytics.sharedAnalytics().track("Sent Message", properties: result["segment"] as! [NSObject : AnyObject])
                    }
				}
                else {
					failure(error: error)
				}
		}
	}
    /**
    Get Tutor Profile image url
	
    :param: params
	
        - "token"
        - "answer_id"
	
    :param: success
	
    :returns:
    */
    func getTutorProfilePic(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(params)
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetTutorProfilePic), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                //println(JSON)
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getTutorProfilePic", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Get Promocode from server
    
    :param: params
    
        - "token"
    
    :param: success
    
    :returns:
    */
    func getPromocode(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetPromocode), parameters: params)
            .responseString(encoding: NSUTF8StringEncoding) { (_, _, JSON, error) -> Void in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getPromocode", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
        
    }
    
    /**
    Send promocode
    
    :param: params
    
        - "token"
        - "v_promo"
    
    :param: success
    
    :returns:
    */
    func submitPromocode(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kSubmitPromocode), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                if (error == nil && JSON != nil) {
                    self.reportToSegment("submitPromocode", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    

    
    /**
    Check payment status
    
    :param: params
    
        - "token"
        - "price"
    
    :param: success
    
    :returns:
    */
    func checkPaymentToken(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kCheckToken), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("checkPaymentToken", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                    
                }
        }
        
    }
    
    /**
    Select tutor for answer (payment)
    
    :param: params
    
        - "token"
        - "answer_id"
        - "Mile[type_id]"
        - "Creditcard[card_num]"
        - "Billing"
        - "stripe"
        - "paypal"
    
    :param: success
    
    :returns:
    */
    func acceptTutor(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kAcceptTutor), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("acceptTutor", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
                /// Clear payment tokens
                self.clearPaymentTokens()
        }
        
    }
    
    /**
    Release milestone for Tutor's answer (payment)
    
    :param: params
    
        - "token"
        - "answer_id"
        - "Pay[Money]"
        - "review_special"
        - "Transaction[0][money]"
        - "tip"
        - "Pay[pay_type]"
        - "Creditcard[card_num]"
        - "Billing"
    
    :param: success
    
    :returns:
    */
    func releaseFinalPayment(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        //println(params)
        
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kFinalPayment), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("releaseFinalPayment", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
                /// Clear tokens
                self.clearPaymentTokens()
        }
    }
    
    
    
    /**
    Get Student Profile
    
    :param: params
    
        - "token"
    
    :param: success
    
    :returns:
    */
    
    func getStudentProfile(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetStudentProfile), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getStudentProfile", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Get Tutor Profile
    
    :param: params
    
        - "token"
        - "user_id"
    
    :param: success
    
    :returns:
    */
    func getTutorProfile(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetTutorProfile), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getTutorProfile", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    
    
    /**
    Get Tutor Answer
    
    :param: params
    
        - "token"
        - "qid"
    
    :param: success
    
    :returns:
    */
    func getTutorAnswerTaken(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetTutorAnswerTaken), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getTutorAnswerTaken", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }

    /**
    Post Tutor Answer
    
    :param: params
    
        - "token"
        - "questionid"
        - "Answers"
    
    :param: success
    
    :returns:
    */
    func postTutorAnswerSubmit(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        Alamofire.request(.POST, String(format: "%@%@", kBaseURL, kPostTutorAnswerSubmit), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("postTutorAnswerSubmit", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Send Phonenumber to get SMS
    
    :param: params
    
        - "token"
        - "number"
    
    :param: success
    
    :returns:
    */
    func getPhoneCode(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetPhoneCode), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getPhoneCode", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    /**
    Confirm SMS code
    
    :param: params
    
        - "token"
        - "code"
    
    :param: success
    
    :returns:
    */
    func getPhoneConfirm(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kGetPhoneConfirm), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getPhoneConfirm", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    func retrievePassword(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        var userInfo = params["userInput"] as! String
        //println (String(format: "%@%@", (kCreateURL + kRetrievePW), userInfo))
        Alamofire.request(.GET, String(format: "%@%@", (kCreateURL + kRetrievePW), userInfo), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                if (error == nil && JSON != nil) {
                    self.reportToSegment("retrievePassword", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    func getReferralLink(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        let userInfo = ""
        Alamofire.request(.GET, String(format: "%@%@", (kBaseURL + kReferralLink), userInfo), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                if(error == nil && JSON != nil) {
                    self.reportToSegment("getReferralLink", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    func getIdentifyUser(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        let userInfo = ""
        Alamofire.request(.GET, String(format: "%@%@", (kBaseURL + kIdentify), userInfo), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                if(error == nil && JSON != nil){
                    if let result = JSON as? NSMutableDictionary {
                        var identity = NSMutableDictionary(dictionary: result["segment"] as! NSDictionary)
                        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
                        identity.setValue(version, forKey: "version")
                        
                        let final: [NSObject : AnyObject] = identity as [NSObject : AnyObject]
                        
                        //SEGMENT_CODE: USER IDENTIFICATION
                        SEGAnalytics.sharedAnalytics().identify(String(user_id), traits: final)
                    }
                    success(response: JSON)
                }
                else{
                    failure(error: error)
                }
                
        }
    }
    
    func getBalance(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kBalance), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getBalance", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    func getDeadline(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kDeadline), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("getDeadline", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    func postDeviceToken(params:[String: AnyObject], success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kPostDeviceToken), parameters: params)
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("postDeviceToken", JSON: JSON!)
                    success(response: JSON)
                }
                else {
                    failure(error: error)
                }
        }
    }
    
    private func clearPaymentTokens () {
        paypaltoken = ""
        stripetoken = ""
    }
    

    func clearNotificationBadge(token: String) {
        Alamofire.request(.GET, String(format: "%@%@", kBaseURL, kClearNotificationBadge), parameters: ["token" : token])
            .responseJSON { (_, _, JSON, error) in
                
                if (error == nil && JSON != nil) {
                    self.reportToSegment("clearNotificationBadge", JSON: JSON!)
                }
        }
    }
    
    func reportToSegment(eventName: String, JSON: AnyObject) {
        if let result = JSON as? NSDictionary {
            if (result["segment"] != nil) {
                SEGAnalytics.sharedAnalytics().track(eventName, properties: result["segment"] as? [NSObject: AnyObject])
            }
            else {
                SEGAnalytics.sharedAnalytics().track(eventName)
            }
        }
    }
}
