//Database.executeBatch(new ProcessEWelcomeLetter(),5);
global class ProcessEWelcomeLetter implements Database.Batchable < sObject > , Database.AllowsCallouts, Database.Stateful {
    global List < Welcome_Letter__c > lstWelcomeLetterToUpdate = new List < Welcome_Letter__c > ();

    global Database.querylocator start(Database.BatchableContext BC) {
        system.debug('Start::::');
        //string strOD='a0fO0000009yPJW';
        String dt = Label.Effective_Date_EWelcome_Letter;
        date startDate = date.parse(dt);
        /*Code added by Pramod Nishane dated 17-May-2016 for bug 6914 added AGREEMENTNO__c field in query */
        // Current_utilized_line__c,EMI_Holiday_Month__c----- added by pankaj gupta in query 
        /** Product_Description__c added by Ajinkya Shedage in query */
        String query = ' SELECT Id ,PRODUCT__c ,Scheme__c ,Current_utilized_line__c,EMI_Holiday_Month__c,Customer_Email_ID__c,AGREEMENTNO__c,Product_Description__c from Welcome_Letter__c where  E_Welcome_Letter_Sent__c = FALSE AND Operation_Check__c= True  AND DAY_ONLY(CreatedDate) >= :startDate';
        //String query = ' SELECT Id ,PRODUCT__c,AGREEMENTNO__c,Current_utilized_line__c,EMI_Holiday_Month__c,Scheme__c ,Customer_Email_ID__c from Welcome_Letter__c where id=\'a0fp0000004Rnwt\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < Welcome_Letter__c > lstWelcomeLetter) {
        system.debug('Execute::::');
        system.debug('SIZE:::' + lstWelcomeLetter.size() + 'lstWelcomeLetter::::' + lstWelcomeLetter);

        if (lstWelcomeLetter != null && lstWelcomeLetter.size() > 0) {
            //Messaging.Email[] lstEmail = new List<Messaging.Email>();
            String senderEmailID = '';
            ControlRecursiveCallofTrigger_Util.setIsCalledFromBatchFlag();
            system.debug('::isCalledFromBatchBatch:::' + ControlRecursiveCallofTrigger_Util.hasIsCalledFromBatchFlag());

            //EmailTemplate objEmailTemplate = new EmailTemplate() ;
            //objEmailTemplate = [SELECT id , HtmlValue FROM EmailTemplate WHERE Name = 'E Welcome Letter'];

            //String emailBody =getEmailBody();
            //system.debug('::emailBody::'+emailBody);


            String emailBody;

            EmailTemplate objEmailTemp = [SELECT id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'E Welcome Letter Template'
                LIMIT 1
            ];

            if (objEmailTemp != null) {
                emailBody = objEmailTemp.Body;
                system.debug('::emailBodyTemplate::' + emailBody);
            }

            //fetch sender email ID to send E Welcome letter
            /*orgWideEmailAddress[] owea = [select Address from OrgWideEmailAddress where Address =: Label.E_Welcome_Letter_Sender_Email_ID];
            if(owea.size() > 0 ) {
                senderEmailID=owea.get(0).Address;
                system.debug('senderEmailID:::::'+senderEmailID);
            } */

            for (Welcome_Letter__c objWelcomeLetter: lstWelcomeLetter) {
                if (objWelcomeLetter.PRODUCT__c != null && objWelcomeLetter.Customer_Email_ID__c != null) {
                    // objWelcomeLetter.Current_utilized_line__c,objWelcomeLetter.EMI_Holiday_Month__c ----- added by pankaj gupta in getPageURL method
                    String pageURL = getPageURL(objWelcomeLetter.PRODUCT__c, objWelcomeLetter.Scheme__c, objWelcomeLetter.Current_utilized_line__c, objWelcomeLetter.EMI_Holiday_Month__c);
                    
                    /**Code added by Ajinkya Shedage for getting welcome letter templates according to new mappings as per WelcomeLetterMappings json static resource*/ 
                    if(getPageURLRevamp(objWelcomeLetter.Product_Description__c)!=null && getPageURLRevamp(objWelcomeLetter.Product_Description__c)!='')
                        pageURL=getPageURLRevamp(objWelcomeLetter.Product_Description__c);
                    
                    system.debug('PROD::::' + objWelcomeLetter.PRODUCT__c + '::::Scheme::::' + objWelcomeLetter.Scheme__c + '::pageURL::' + pageURL);
                    if (String.isNotEmpty(pageURL)) {

                        BAFL_EmailServicesLogix.Attachment[] arrAttachment = new List < BAFL_EmailServicesLogix.Attachment > ();


                        // Define the email
                        //Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

                        //Reference the attachment page and pass in the record ID                   
                        PageReference pdf = new PageReference(pageURL);
                        pdf.getParameters().put('id', (String) objWelcomeLetter.id);
                        pdf.setRedirect(true);

                        Blob blobWelcomeLetter;
                        // Take the PDF content
                        if (test.isrunningtest())
                            blobWelcomeLetter = Blob.valueOf('Test');
                        else
                            blobWelcomeLetter = pdf.getContent();

                        // Create Welcome Letter email attachment
                        BAFL_EmailServicesLogix.Attachment eWelcomeKitAtt = new BAFL_EmailServicesLogix.Attachment();
                        eWelcomeKitAtt.Name = 'Welcome Letter.pdf';
                        String strWelcomeLetter = EncodingUtil.base64Encode(blobWelcomeLetter);
                        eWelcomeKitAtt.Data = strWelcomeLetter;
                        arrAttachment.add(eWelcomeKitAtt);

                        //Create list of Flexi Product and check if Product on Welcome Letter object exist in list
                        List < String > lstFlexiProduct = new List < String > ();
                        lstFlexiProduct = Label.Flexi_Product.split(';');
                        Set < String > setString = new Set < String > (lstFlexiProduct);
                        String query = 'Select Body From StaticResource where Name=';
                        if (setString.contains(objWelcomeLetter.PRODUCT__c))
                            query = query + '\'Service_Guide_EWelcome_Kit_Flexi\'';
                        else
                            query = query + '\'Service_Guide_EWelcome_Kit_Normal\'';


                        StaticResource objServiceGuide = new StaticResource();
                        objServiceGuide = database.query(query);
                        //objServiceGuide = [Select Body From StaticResource where Name in  ('Service_Guide_EWelcome_Kit_Flexi'/*,'Service_Guide_EWelcome_Kit_Normal' */)]; 

                        /*Blob blobServiceGuide = objServiceGuide.Body;                    
                        Messaging.EmailFileAttachment serviceGuideAtt = new Messaging.EmailFileAttachment();
                        serviceGuideAtt.setFileName('Service Guide.pdf');
                        serviceGuideAtt.setBody(blobServiceGuide);*/

                        Blob blobServiceGuide = objServiceGuide.Body;
                        BAFL_EmailServicesLogix.Attachment serviceGuideAtt = new BAFL_EmailServicesLogix.Attachment();
                        serviceGuideAtt.Name = 'Service Guide.pdf';
                        String strServiceGuide = EncodingUtil.base64Encode(blobServiceGuide);
                        serviceGuideAtt.Data = strServiceGuide;
                        arrAttachment.add(serviceGuideAtt);


                        //code added by leena for bug 8143-start
                        List < Welcome_Letter__c > childWelcomeLetters = new List < Welcome_Letter__c > ();
                        childWelcomeLetters = [select id from Welcome_Letter__c where Welcome_Letter__c =: objWelcomeLetter.id];
                        if (childWelcomeLetters != null && childWelcomeLetters.size() > 0) {
                            PageReference pdfMOB = Page.WelcomeLetter_New_mobOffers;
                            pdfMOB.getParameters().put('id', (String) objWelcomeLetter.id);
                            pdfMOB.setRedirect(true);
                            transient Blob blobWelcomeLetterChild;
                            // Take the PDF content 
                            if (test.isrunningtest())
                                blobWelcomeLetterChild = Blob.valueOf('Test');
                            else
                                blobWelcomeLetterChild = pdfMOB.getContent();
                            BAFL_EmailServicesLogix.Attachment eWelcomeKitAttMOB = new BAFL_EmailServicesLogix.Attachment();
                            eWelcomeKitAttMOB.Name = 'Offer Letter.pdf';
                            String strWelcomeLetterChild = EncodingUtil.base64Encode(blobWelcomeLetterChild);
                            eWelcomeKitAttMOB.Data = strWelcomeLetterChild;
                            arrAttachment.add(eWelcomeKitAttMOB);
                        }
                        //code added by leena for bug 8143-End
                        List < String > toAddresses = new List < String > {
                            objWelcomeLetter.Customer_Email_ID__c
                        };
                        // Sets the paramaters of the email
                        /*email.setSubject( 'Welcome to Bajaj Finance Ltd.' );
                        email.setToAddresses( toAddresses );
                        email.setHtmlBody( objEmailTemplate.HtmlValue);
                        email.setFileAttachments(new Messaging.EmailFileAttachment[] {eWelcomeKitAtt ,serviceGuideAtt}); 
                                          
                        if(String.IsnotBlank(senderEmailID))    
                            email.setOrgWideEmailAddressId(senderEmailID);
                                          
                        lstEmail.add(email);  */
                        //system.debug('email::::'+email);    
                        /*Code added by Pramod Nishane dated 17-May-2016 for bug 6914 added 'Your Welcome Letter for Loan Account Number objWelcomeLetter.AGREEMENTNO__c. subject line */
                        BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
                        BAFL_EmailServicesLogix.SendEmailResponse mailResponse = stub.SendEmail(
                            Label.E_Welcome_Letter_Sender_Email_ID,
                            '',
                            toAddresses,
                            null,
                            null,
                            'Normal',
                            arrAttachment,
                            'Your Welcome Letter for Loan Account Number ' + objWelcomeLetter.AGREEMENTNO__c + '.',
                            emailBody,
                            'bajaj');

                        system.debug('ani -- Response -- ' + mailResponse);
                        //system.debug('ani -- Response body -- '+mailResponse.getBody());
                        system.debug('::toAddresses1::' + toAddresses);

                        //Check the response and set fields indicating Welcome letter is sent or not
                        if (mailResponse != null && mailResponse.StatusDescription != null && mailResponse.StatusDescription.contains('SUCCESS')) {
                            objWelcomeLetter.E_Welcome_Letter_Sent_Date__c = System.now();
                            objWelcomeLetter.E_Welcome_Letter_Sent__c = true;
                            lstWelcomeLetterToUpdate.add(objWelcomeLetter);
                            system.debug('::toAddresses::' + toAddresses);
                            system.debug('::lstWelcomeLetterToUpdateEx::' + lstWelcomeLetterToUpdate);
                        }
                    }
                }
            }          
        }
    }

    global void finish(Database.BatchableContext BC) {
        ControlRecursiveCallofTrigger_Util.setIsCalledFromBatchFlag();
        system.debug('::isCalledFromBatchBatch:::' + ControlRecursiveCallofTrigger_Util.hasIsCalledFromBatchFlag());
        system.debug('Finish::::');
        system.debug('lstWelcomeLetterToUpdate::::' + lstWelcomeLetterToUpdate);
        If(lstWelcomeLetterToUpdate != null && lstWelcomeLetterToUpdate.size() > 0)
        update lstWelcomeLetterToUpdate;
    }

    /*
    Method : getEmailBody
    Purpose : This method will return Email body of E Welcome letter
    */
    /*public String getEmailBody()
    {           
        string body = '<body bgcolor=\\"#FFFFFF\\" leftmargin=\\"0\\" topmargin=\\"0\\" marginwidth=\\"0\\" marginheight=\\"0\\"><p align=\\"center\\">If you are not able to view the content given below properly, please <a href=\\"http://www.bajajfinservlending.in/mailer/dec/post-personal-discussion-emailer-01/index.html\\" target=\\"_blank\\">click here</a></p>';

        body = body +'<table width=\\"780\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" style=\\"border: 1px #949494 solid; min-width:780px;\\" align=\\"center\\"><tr><td valign=\\"top\\"><a href=\\"https://www.bajajfinserv.in/?utm_source=email_idb&utm_medium=welcomekitmailer_logo&utm_campaign=corporate_customerservice_dec15\\" target=\\"_blank\\"> <img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/bfl-logo.jpg\\" width=\\"229\\" height=\\"75\\" alt=\\"Bajaj Finserv\\" title=\\"Bajaj Finserv\\" align=\\"right\\" border=\\"0\\" /></a></td></tr> ';

        body = body + '<tr><td valign=\\"top\\" colspan=\\"2\\" style=\\"padding:5px 20px 0 0px; font-size:15px;line-height:26px;\\"><div style=\\"margin: 0px 0px 0px 20px; font-family: Arial, Helvetica, sans-serif;font-size:26px;;line-height:28px;font-weight:bold;\\">All your loan related information and more, in your inbox</div></tr>';

        body = body + '<tr><td colspan=\\"2\\"  valign=\\"top\\" style=\\"padding:5px 0;line-height:22px;\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/banner.jpg\\" width=\\"780\\" height=\\"360\\" alt=\\"Bajaj Finserv\\" border=\\"0\\" /></td></tr>';

        body = body + '<tr><td colspan=\\"2\\"  valign=\\"top\\" style=\\"padding:5px 20px;line-height:22px;\\"><p style=\\"padding:0; margin:0; font-family: Arial, Helvetica, sans-serif;font-size:15px;line-height:20px;\\">Dear Customer,</p></td></tr>';

        body = body + '<tr><td colspan=\\"2\\"  valign=\\"top\\" style=\\"padding:5px 20px;line-height:22px;\\"><p style=\\"padding:0; margin:0; font-family: Arial, Helvetica, sans-serif;font-size:15px;line-height:20px;\\">Thank you for choosing Bajaj Finserv as your financial services partner.</p></td></tr><tr><td colspan=\\"2\\"  valign=\\"top\\" style=\\"padding:5px 20px;line-height:22px;\\"><p style=\\"padding:0; margin:0; font-family: Arial, Helvetica, sans-serif;font-size:15px;line-height:20px;\\">Your Welcome Letter and Service Guide has been attached as a PDF document.</p></td></tr><tr><td colspan=\\"2\\"  valign=\\"top\\" style=\\"padding:5px 20px;line-height:22px;\\"><p style=\\"padding:0; margin:0; font-family: Arial, Helvetica, sans-serif;font-size:15px;line-height:20px;\\">Check your inbox for periodic updates from us on your loan account, repayment schedule, EMI details, new products/offerings and much more.</p></td></tr>';


        body = body + '<tr><td colspan=\\"2\\"  valign=\\"top\\" style=\\"padding:5px 20px;line-height:22px;\\"><p style=\\"padding:0; margin:0; font-family: Arial, Helvetica, sans-serif;font-size:15px;line-height:20px;\\">Depending on your personal spam filter settings, it is possible that your monthly statements may be directed to your junk folder rather than your inbox. Please check in both.</p></td></tr><tr><td colspan=\\"2\\"  valign=\\"top\\" style=\\"padding:5px 20px;line-height:22px;\\"><p style=\\"padding:0; margin:0; font-family: Arial, Helvetica, sans-serif;font-size:15px;line-height:20px;\\">6 ways to reach us::</p></td></tr>';

        body = body + '<tr><td colspan=\\"2\\" valign=\\"top\\" style=\\"padding:5px 20px 10px 20px;\\" ><table width=\\"auto\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" align=\\"left\\">    <tr> <td valign=\\"top\\"><a href=\\"https://loan-customers.bajajfinance.com/_layouts/B2C2010/B2C_CustomLogin.aspx?utm_source=email_idb&utm_medium=welcomekitmailer_customerportal_login&utm_campaign=experia_customerservice_dec15\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/portal.jpg\\" width=\\"104\\" height=\\"90\\" alt=\\"Customer portal\\" title=\\"Customer portal\\" align=\\"left\\" border=\\"0\\" /></a></td>   <td valign=\\"top\\"><a href=\\"http://www.bit.ly/Bajaj_ExperiaApp\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/mobile.jpg\\" width=\\"104\\" height=\\"90\\" alt=\\"Mobile App\\" title=\\"Mobile App\\" align=\\"left\\" border=\\"0\\" /></a></td>  <td valign=\\"top\\"><a href=\\"mailto:wecare@bajajfinserv.in\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/email.jpg\\" width=\\"104\\" height=\\"90\\" alt=\\"Email\\" title=\\"Email\\" align=\\"left\\" border=\\"0\\" /></a></td>   <td valign=\\"top\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/iyr.jpg\\" width=\\"104\\" height=\\"90\\" alt=\\"IYR\\" title=\\"IYR\\" align=\\"left\\" border=\\"0\\" /></td>  <td valign=\\"top\\"><a href=\\"https://www.bajajfinserv.in/finance/personal-loan/salaried-personal-loan-contact-details.aspx?utm_source=email_idb&utm_medium=welcomekitmailer_sms&utm_campaign=finance_pl_contactdetails_customerservice_dec15\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/sms.jpg\\" width=\\"104\\" height=\\"90\\" alt=\\"SMS\\" title=\\"SMS\\" align=\\"left\\" border=\\"0\\" /></a></td>   <td valign=\\"top\\"><a href=\\"https://www.bajajfinserv.in/finance/branch-locator.aspx?utm_source=email_idb&utm_medium=welcomekitmailer_branchlocator&utm_campaign=finance_locateus_customerservice_dec15\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/branch.jpg\\" width=\\"104\\" height=\\"90\\" alt=\\"Branch\\" title=\\"Branch\\" align=\\"left\\" border=\\"0\\" /></a></td>   </tr> </table></td></tr>  ';
          
        body = body +'<tr><td colspan=\\"2\\" valign=\\"top\\" style=\\"padding:0px 20px 5px 20px;\\" >Dial <b> 020 3957 5152 </b> for EMI Card or dial  <b>020 3957 4151</b> for other products </td></tr>';  

        body = body +'<tr><td colspan=\\"2\\" valign=\\"top\\" style=\\"padding:0px 20px 5px 20px;\\" >Warm regards,<br />Bajaj Finserv</td></tr>';  

        body = body +'  <tr><td colspan=\\"2\\"  valign=\\"top\\" style=\\"padding:5px 20px;line-height:22px;\\"><a href=\\"https://www.bajajfinserv.in/finance/?utm_source=email_idb&utm_medium=welcomekitmailer_visitlink&utm_campaign=finance_customerservice_dec15\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/visit.jpg\\" alt=\\"Visit www.bajajfinserv.in/finance\\" title=\\"Visit www.bajajfinserv.in/finance\\" width=\\"245\\" height=\\"22\\" border=\\"0\\" /></a></td></tr>';

        body = body +'<tr> <td colspan=\\"2\\" valign=\\"top\\" style=\\"padding:5px 20px 10px 20px;\\" ><table width=\\"auto\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" align=\\"left\\"><tr><td valign=\\"top\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/connenct-with.jpg\\" width=\\"111\\" height=\\"35\\" alt=\\"Connect with us\\" title=\\"Connect with us\\" align=\\"left\\" border=\\"0\\" /></td><td valign=\\"top\\"><a href=\\"https://www.facebook.com/bajajfinserv?sk=app_190322544333196\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/fb.jpg\\" width=\\"41\\" height=\\"35\\" alt=\\"Facebook\\" title=\\"Facebook\\" align=\\"left\\" border=\\"0\\" /></a></td><td valign=\\"top\\"><a href=\\"https://twitter.com/Bajaj_Finserv\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/tw.jpg\\" width=\\"42\\" height=\\"35\\" alt=\\"twitter\\" title=\\"twitter\\" align=\\"left\\" border=\\"0\\" /></a></td><td valign=\\"top\\"><a href=\\"http://www.linkedin.com/company/1092003?trk=tyah\\" target=\\"_blank\\"><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/in.jpg\\" width=\\"38\\" height=\\"35\\" alt=\\"LinkedIn\\" title=\\"LinkedIn\\" align=\\"left\\" border=\\"0\\" /></a></td> </tr></table></td></tr>';

        body = body +'<tr><td valign=\\"top\\" style=\\"padding:5px 20px;line-height:22px;\\"><p style=\\"padding:0; margin:0; font-family: Arial, Helvetica, sans-serif;font-size:13px;line-height:20px;\\">Terms and conditions apply </p></td></tr><tr><td colspan=\\"2\\" valign=\\"top\\" style=\\"padding:10px 10px 10px 0\\" ><img src=\\"http://bajajfinserv.click/finance/mailer/2015/dec/bajaj-e-welcome-kit-emailers/images/bfl-ltd.jpg\\" width=\\"179\\" height=\\"21\\" alt=\\"Bajaj Finance Limited\\" title=\\"Bajaj Finance Limited\\" align=\\"right\\" border=\\"0\\" /></td></tr>';


        body = body +'</table></body>';
        return body;
    }*/

    /*
    Method : getPageURL
    Purpose : This method will return page URL based on conditions
    */
    public String getPageURL(String product, String scheme, Decimal currentUtilizedline, String emimonth) {
        String pageURL = '';
        //Fetch mapping data of Product and its associated VF page
        List < ProductSMS__c > lstProdCustomSetting = ProductSMS__c.getall().values();
        for (ProductSMS__c objProductSMS: lstProdCustomSetting) {
            system.debug('::::Name' + objProductSMS.Name);
            if (objProductSMS.Name.Contains('EWelcome Letter') &&  objProductSMS.Welcome_Letter_Product__c !=null ) {
                system.debug('::::VFPAGE' + objProductSMS.VF_Page__c);
                if (product.toLowerCase() == objProductSMS.Welcome_Letter_Product__c) {
                    if (product.toLowerCase() == 'fas') {
                        if (scheme != null && objProductSMS.Scheme__c == scheme)
                            pageURL = '/apex/WelcomeLetter_New_LASOL';
                        else
                            pageURL = '/apex/WelcomeLetter_New_FAS';
                    } else
                        pageURL = '/apex/' + objProductSMS.VF_Page__c;

                    //  break;
                }
            }
            
            if (objProductSMS.Name.Contains('Auto Welcome Letter') && objProductSMS.Welcome_Letter_Product__c !=null ){
                if (product.toLowerCase() == objProductSMS.Welcome_Letter_Product__c.toLowerCase()) {
                    system.debug('inside required if' + product);
                    
                    if (currentUtilizedLine != null && currentUtilizedLine != 0 && objProductSMS.isCurrentUtilizedLinePresent__c == true) {
                        pageURL = '/apex/' + objProductSMS.VF_Page__c;
                        system.debug('in Currentline ' + pageURL);
                    } else if (emiMonth != null && emiMonth != '' && objProductSMS.isEMIMonthPresent__c == true) {
                        pageURL = '/apex/' + objProductSMS.VF_Page__c;
                        system.debug('in emimonth ' + pageURL);
                    } else if (((emiMonth == null || emiMonth == '') && objProductSMS.isEMIMonthPresent__c == false) && ((currentUtilizedLine == null || currentUtilizedLine == 0) && objProductSMS.isCurrentUtilizedLinePresent__c == false)) {
                        pageURL = '/apex/' + objProductSMS.VF_Page__c;
                        system.debug('in both null ' + pageURL);
                    }
                }
            }                

        }

        system.debug(':::pageURL::' + pageURL);
        return pageURL;
    }
    
    
    
    /**getPageURLRevamp method added by Ajinkya Shedage for WelcomeLetter Revamp*/
    public String getPageURLRevamp(String productDescription){
        String pageURL = '';
        try{
            if(productDescription!=null && String.isNotEmpty(productDescription) && String.isNotBlank(productDescription) ){
                String welcomeLetterTemplate=WelcomeLetterUtilities.getWelcomeLetterTemplate(productDescription);
                System.debug('welcomeLetterTemplate : '+ welcomeLetterTemplate);
                if(welcomeLetterTemplate!=null && String.isNotEmpty(welcomeLetterTemplate) && String.isNotBlank(welcomeLetterTemplate) && welcomeLetterTemplate!='NoTemplateFound')
                    pageURL='/apex/'+ welcomeLetterTemplate ; 
                System.debug('welcomeLetterTemplate pageURL : '+ welcomeLetterTemplate);
            }
        }catch(Exception e){
            System.debug('Exception in getPageURLRevamp\n'+e);
            System.debug('Line Number : '+e.getLineNumber());
            System.debug(e.getStackTraceString());
        }
        
        
        return pageURL;
    }
}