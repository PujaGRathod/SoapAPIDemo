//
//  ViewController.swift
//  DemoApp
//
//  Created by MAC PC-9 on 3/23/19.
//  Copyright © 2019 MAC PC-9. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    var baseJuniperURL = "http://xml2.bookingengine.es/WebService/JP/Operations/StaticDataTransactions.asmx"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detais = segue.destination as! DetailsBooks
        detais.dictAll = sender! as! NSDictionary
    }
    
    @IBOutlet weak var txtBookName: UITextField!
    @IBOutlet weak var txtChapterName: UITextField!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        
        
//        self.callJuniperAPI()
    }
    
    @IBAction func clickSubmit(sender: AnyObject) {
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        activityIndicator.color = UIColor.black
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.callJuniperAPI()
//        if isCheckNull(){
//            self.callSoapAPI(bookName: txtBookName.text!, chapter: txtChapterName.text!)
//        } else {
//            UIAlertView(title: "BooksDetailsq", message: "Please enter Book Name : ", delegate: nil, cancelButtonTitle: "OK").show()
//        }
    }

    func isCheckNull()->Bool{
        

        if let str = txtBookName.text,
            str.count > 0    {
            
            return true
        }
        else{
            
            return false
        }
    }
    
    func callJuniperAPI() {
        // Soap Body
        let soapMessage = "<?xml version='1.0' encoding='UTF-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns='http://www.juniper.es/webservice/2007/'><soapenv:Header/><soapenv:Body><CityList><CityListRQ Version='1.1' Language='en'><Login Password='Azzamaz_' Email='thestartofdream1@gmail.com'/></CityListRQ></CityList></soapenv:Body></soapenv:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = baseJuniperURL
        let theURL = NSURL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL! as URL)
        
        // MUTABLE REQUEST
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        
        // AFNETWORKING REQUEST
        
        let manager = AFHTTPRequestOperation(request: mutableR as URLRequest)
        
        manager.setCompletionBlockWithSuccess({ (operation, responseObject) in
            var dictionaryData = NSDictionary()
            
            do
            {
                dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! NSData) as Data!) as NSDictionary
                
                let mainDict = (((dictionaryData.object(forKey: "soap:Envelope")! as AnyObject).object(forKey: "soap:Body")! as AnyObject).object(forKey: "CityListResponse")! as AnyObject).object(forKey:"CityListRS") ?? NSDictionary()
                
                let errorMsg = (((mainDict as AnyObject).object(forKey: "Errors")! as AnyObject).object(forKey: "Error") as AnyObject).object(forKey: "Text") as? String
                print("mainDict:-\(mainDict)")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                UIAlertView(title: "Juniper response", message: errorMsg, delegate: nil, cancelButtonTitle: "OK").show()
                
            }
            catch
            {
                print("Your Dictionary value nil")
            }
            
            print(dictionaryData)
            
        }) { (operation, error) in
            print(error)
        }
        manager.start()
        
    }
    
    /*
    func callSoapAPI(bookName : String , chapter : String){
        // Soap Body
        let soapMessage =  "<?xml version='1.0' encoding='UTF-8'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ns1='http://www.prioregroup.com/'><SOAP-ENV:Body><ns1:GetVerses><ns1:BookName>\(bookName)</ns1:BookName><ns1:chapter>\(chapter)</ns1:chapter></ns1:GetVerses></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        let soapLenth = String(soapMessage.count)
        let theUrlString = "http://www.prioregroup.com/services/americanbible.asmx"
        let theURL = NSURL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL! as URL)
        
        // MUTABLE REQUEST
        
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        
        // AFNETWORKING REQUEST
        
        let manager = AFHTTPRequestOperation(request: mutableR as URLRequest)
        
        manager.setCompletionBlockWithSuccess({ (operation, responseObject) in
            var dictionaryData = NSDictionary()
            
            do
            {
                dictionaryData = try XMLReader.dictionary(forXMLData: (responseObject as! NSData) as Data!) as NSDictionary
                
                let mainDict = (((dictionaryData.object(forKey: "soap:Envelope")! as AnyObject).object(forKey: "soap:Body")! as AnyObject).object(forKey: "GetVersesResponse")! as AnyObject).object(forKey:"GetVersesResult")   ?? NSDictionary()
                
                if (mainDict as AnyObject).count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! [NSObject : AnyObject])
                    
                    self.performSegue(withIdentifier: "details", sender: mainD)
                    
                }
                else{
                    
                    UIAlertView(title: "BooksDetailsq", message: "Oops! No data found.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
            catch
            {
                print("Your Dictionary value nil")
            }
            
            print(dictionaryData)
            
        }) { (operation, error) in
            print(error)
        }
        manager.start()
        
    }
    */
 }

