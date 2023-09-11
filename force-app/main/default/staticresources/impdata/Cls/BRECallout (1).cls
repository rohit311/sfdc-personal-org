public without sharing class BRECallout {

  //SAL IM Sampling inner classs rohit start
  public class WeightagegHistory {
    public String key;
    public Integer value;
  }

  public class Output {
    public Integer weightedScore;
    public Double weightedScoretoMaxWeight;
    public Double maxWeight;
    public List < WeightagegHistory > weightagegHistory;
  }

  class JSONParserForSampling {
    public Output output;
    public Boolean Action;

    public JSONParserForSampling parse(String json) {
      return (JSONParserForSampling) System.JSON.deserialize(json, JSONParserForSampling.class);
    }
  }

  //SAL IM Sampling inner classs rohit end

  String username, password, endpointURL;
  String mcpResultdesc = '';
  String mcpResult = '';
  String DeviationCode = '';
  String approver = '';
  String mandatoryName = '';
  String DocumentCode = '';
  String Documentstatus = '';
  StaticResource staticresc;
  String VerificationCode, VerificationStatus, TelepdCode, TelepdStatus = '';
  Map < String, String > mapOfMCPResult = new Map < String, String > ();
  Map < String, List < Integer >> EligibilityResponse = new Map < String, List < Integer >> ();
  Map < String, String > MapOfDeviationResult = new Map < String, String > ();
  //WA start
  Map < String, String > mapOfWeakAccountResult = new Map < String, String > ();
  String scoreResult = '';
  //WA end
  //Bug 4326 Crisil
  Map < String, String > mapOfGridMismatchResult = new Map < String, String > ();
  String scoreResultGridMismatch = '';
  //Bug 4326 Crisil

  // Start of MSME BL changes
  Map < String, String > mapOfSegmentIndResult = new Map < String, String > (); // Added for RBL Policy changes
  List < String > mapOfFinalSegmentationResult = new List < String > ();
  Double EligibleAmount = 0.0;
  // End of MSME BL changes
  Map < string, string > RDLeliVal = new Map < string, string > (); //Bug 8310
  /*Start BUG-16959*/
  set < string > setPSBLProdName = new set < string > ();
  /*Start BUG-17501*/
  set < string > setSHOLProdName = new set < string > ();

  /*S BUG ID 17470 S*/
  public boolean isPROProductLineProduct {
    get;
    set;
  }
  /*E BUG ID 17470 E*/
  public BREcallout() {
    /* BUG ID 17470*/
    isPROProductLineProduct = false;

    Mid_office_BRE_flow__c BRE_Flow = Mid_office_BRE_flow__c.getValues('BRE Flow');
    if (BRE_Flow != null) {
      username = BRE_Flow.Username__c;
      password = BRE_Flow.Password__c;
      endpointURL = BRE_Flow.EndpointURL__c;
    }
    System.debug('******password: ' + password + '***username' + username);
    /*Start BUG-16959*/
    if (!commonUtility.isempty(Label.PSBL_ProductLine_Products))
      setPSBLProdName.addAll(Label.PSBL_ProductLine_Products.split(';'));
    /*End BUG-16959*/
    /*Start BUG-17501*/
    if (!commonUtility.isempty(Label.SHOL_ProductLine_Products))
      setSHOLProdName.addAll(Label.SHOL_ProductLine_Products.split(';'));

    /*End BUG-17501*/
    // 17664 Rajesh--16621
    staticresc = [SELECT Body, Id, Name FROM StaticResource WHERE Name = 'SalariedCustomSettings'
        limit 1
        ];
  }

    public Map < String, String > callBREMCPCheck(MAP < String, String > mapOfPolicyParameters) {
    System.debug('*************mapOfPolicyCheckParameters: ' + mapOfPolicyParameters);
    System.debug('*************nature: ' + mapOfPolicyParameters.get('nature_of_business'));
    System.debug('*************consti: ' + mapOfPolicyParameters.get('constitution'));

    /*if (mapOfPolicyParameters.get('applicant_type') == null) mapOfPolicyParameters.put('applicant_type', '');
if (mapOfPolicyParameters.get('requested_loan_amount') == null) mapOfPolicyParameters.put('requested_loan_amount', '');
if (mapOfPolicyParameters.get('product') == null) mapOfPolicyParameters.put('product', '');
if (mapOfPolicyParameters.get('stage') == null) mapOfPolicyParameters.put('stage', '');
if (mapOfPolicyParameters.get('net_Salary_for_Month1') == null) mapOfPolicyParameters.put('net_Salary_for_Month1', '');
if (mapOfPolicyParameters.get('branch_type') == null) mapOfPolicyParameters.put('branch_type', '');
if (mapOfPolicyParameters.get('branch_name') == null) mapOfPolicyParameters.put('branch_name', '');
if (mapOfPolicyParameters.get('current_employment_vintage') == null) mapOfPolicyParameters.put('current_employment_vintage', '');
if (mapOfPolicyParameters.get('total_employment_vintage') == null) mapOfPolicyParameters.put('total_employment_vintage', '');
if (mapOfPolicyParameters.get('date_of_birth') == null) mapOfPolicyParameters.put('date_of_birth', '');
if (mapOfPolicyParameters.get('years_in_business_job') == null) mapOfPolicyParameters.put('years_in_business_job', '');
if (mapOfPolicyParameters.get('monthly_loan_obligations') == null) mapOfPolicyParameters.put('monthly_loan_obligations', '');
if (mapOfPolicyParameters.get('cy_sales_turnover') == null) mapOfPolicyParameters.put('cy_sales_turnover', '');
if (mapOfPolicyParameters.get('cy_depriciation') == null) mapOfPolicyParameters.put('cy_depriciation', '');
if (mapOfPolicyParameters.get('cy_total_networth') == null) mapOfPolicyParameters.put('cy_total_networth', '');
if (mapOfPolicyParameters.get('cy_net_profit') == null) mapOfPolicyParameters.put('cy_net_profit', '');
if (mapOfPolicyParameters.get('py_sales_turnover') == null) mapOfPolicyParameters.put('py_sales_turnover', '');
if (mapOfPolicyParameters.get('type_of_degree') == null) mapOfPolicyParameters.put('type_of_degree', '');
if (mapOfPolicyParameters.get('nature_of_business') == null) mapOfPolicyParameters.put('nature_of_business', '');
if (mapOfPolicyParameters.get('constitution') == null) mapOfPolicyParameters.put('constitution', '');
if (mapOfPolicyParameters.get('program_type') == null) mapOfPolicyParameters.put('program_type', '');
if (mapOfPolicyParameters.get('CIBIL_Score') == null) mapOfPolicyParameters.put('CIBIL_Score', '');
if (mapOfPolicyParameters.get('loan_id') == null) mapOfPolicyParameters.put('loan_id', '1');
     */
      //Added By Gulshan  passing Date of Registration of BRE VF Page at PO (field  = PO.COP_Date__c) 22979 same tag is added as 'date_of_incorporation' in body 
     if(!mapOfPolicyParameters.containsKey('date_of_incorporation') || mapOfPolicyParameters.get('date_of_incorporation') == null) mapOfPolicyParameters.put('date_of_incorporation','');
     
    Mid_office_BRE_flow__c BRE_MCP = Mid_office_BRE_flow__c.getValues('BRE MCP');
    if (BRE_MCP != null) {
      // username = BRE_Flow.Username__c;
      // password = BRE_Flow.Password__c;
      endpointURL = '';
      endpointURL = BRE_MCP.EndpointURL__c;
    }

    System.debug('py_sales_turnover---->' + mapOfPolicyParameters.get('py_sales_turnover'));

    /*String body = '<input><Verification><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type></element></Verification><loan_parameter><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><decision_date></decision_date><login_date></login_date><approved_loan_amount></approved_loan_amount><approved_tenor></approved_tenor><requested_loan_amount>' + mapOfPolicyParameters.get('requested_loan_amount') + '</requested_loan_amount><requested_tenor>' + mapOfPolicyParameters.get('requested_tenor') + '</requested_tenor><product>' + mapOfPolicyParameters.get('product') + '</product><stage>' + mapOfPolicyParameters.get('stage') + '</stage><program_type>' + mapOfPolicyParameters.get('program_type') + '</program_type><process_type>' + mapOfPolicyParameters.get('processType') + '</process_type></loan_parameter><CAMS><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><net_Salary_for_Month1>' + mapOfPolicyParameters.get('net_Salary_for_Month1') + '</net_Salary_for_Month1><grossSalary>' + mapOfPolicyParameters.get('grossSalary') + '</grossSalary><incomefromBusinessandProfession>' + mapOfPolicyParameters.get('incomefromBusinessandProfession') + '</incomefromBusinessandProfession></element></CAMS><generic_info><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><branch_type>' + mapOfPolicyParameters.get('branch_type') + '</branch_type><branch_name>' + mapOfPolicyParameters.get('branch_name') + '</branch_name><branch_code></branch_code></generic_info><demographic><element><ownershipType>' + mapOfPolicyParameters.get('ownershipType') + '</ownershipType><vintage>' + mapOfPolicyParameters.get('vintage') + '</vintage><professionType>' + mapOfPolicyParameters.get('professionType') + '</professionType><educational_qualification>' + mapOfPolicyParameters.get('educational_qualification') + '</educational_qualification><current_employment_vintage>' + mapOfPolicyParameters.get('current_employment_vintage') + '</current_employment_vintage><total_employment_vintage>' + mapOfPolicyParameters.get('total_employment_vintage') + '</total_employment_vintage><date_of_birth>' + mapOfPolicyParameters.get('date_of_birth') + '</date_of_birth><constitution>' + mapOfPolicyParameters.get('constitution') + '</constitution><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><years_in_business_job>' + mapOfPolicyParameters.get('years_in_business_job') + '</years_in_business_job><applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type><type_of_degree>' + mapOfPolicyParameters.get('type_of_degree') + '</type_of_degree><nature_of_business>' + mapOfPolicyParameters.get('nature_of_business') + '</nature_of_business><practiceType>' + mapOfPolicyParameters.get('practiceType') + '</practiceType><profession>' + mapOfPolicyParameters.get('profession') + '</profession><customer_type>' + mapOfPolicyParameters.get('customer_type') + '</customer_type><constitutionType>' + mapOfPolicyParameters.get('constitutionType') + '</constitutionType></element></demographic><Cibil_lst><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><CIBIL_Score>' + mapOfPolicyParameters.get('CIBIL_Score') + '</CIBIL_Score><applicant_Type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_Type>';
body = body + '</element></Cibil_lst><Existing_Loan><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type><monthly_loan_obligations>' + mapOfPolicyParameters.get('monthly_loan_obligations') + '</monthly_loan_obligations></element></Existing_Loan><profit_loss_statement><cy_cash_profit>' + mapOfPolicyParameters.get('cy_cash_profit') + '</cy_cash_profit><py_sales_turnover>' + mapOfPolicyParameters.get('py_sales_turnover') + '</py_sales_turnover><cy_sales_turnover>' + mapOfPolicyParameters.get('cy_sales_turnover') + '</cy_sales_turnover><cy_profit_after_tax>' + mapOfPolicyParameters.get('cy_profit_after_tax') + '</cy_profit_after_tax><cy_depriciation>' + mapOfPolicyParameters.get('cy_depriciation') + '</cy_depriciation><cy_total_networth>' + mapOfPolicyParameters.get('cy_total_networth') + '</cy_total_networth><cy_net_profit>' + mapOfPolicyParameters.get('cy_net_profit') + '</cy_net_profit><gross_receipts>' + mapOfPolicyParameters.get('gross_receipts') + '</gross_receipts><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id></profit_loss_statement><bank_summary><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type></element></bank_summary></input>';
     */
    //RSL Tier III SAL Policy added '</company_category><name_of_employer></name_of_employer><financierName>'+mapOfPolicyParameters.get('financierName')+'</financierName><customer_category>'+mapOfPolicyParameters.get('customer_category')+'</customer_category>> to demographic section

    //OTP V3 added special profile in body
  String body = '<input><Verification><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type></element></Verification><loan_parameter><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><decision_date></decision_date><login_date></login_date><approved_loan_amount></approved_loan_amount><approved_tenor></approved_tenor><requested_loan_amount>' + mapOfPolicyParameters.get('requested_loan_amount') + '</requested_loan_amount><requested_tenor>' + mapOfPolicyParameters.get('requested_tenor') + '</requested_tenor><product>' + mapOfPolicyParameters.get('product') + '</product><stage>' + mapOfPolicyParameters.get('stage') + '</stage><program_type>' + mapOfPolicyParameters.get('program_type') + '</program_type><process_type>' + mapOfPolicyParameters.get('processType') + '</process_type></loan_parameter><CAMS><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><net_Salary_for_Month1>' + mapOfPolicyParameters.get('net_Salary_for_Month1') + '</net_Salary_for_Month1><grossSalary>' + mapOfPolicyParameters.get('grossSalary') + '</grossSalary><incomefromBusinessandProfession>' + mapOfPolicyParameters.get('incomefromBusinessandProfession') + '</incomefromBusinessandProfession></element></CAMS><generic_info><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><branch_type>' + mapOfPolicyParameters.get('branch_type') + '</branch_type><branch_name>' + mapOfPolicyParameters.get('branch_name') + '</branch_name><branch_code></branch_code></generic_info><demographic><element><specialProfile>' + mapOfPolicyParameters.get('specialProfile') + '</specialProfile><ownershipType>' + mapOfPolicyParameters.get('ownershipType') + '</ownershipType><vintage>' + mapOfPolicyParameters.get('vintage') + '</vintage><professionType>' + mapOfPolicyParameters.get('professionType') + '</professionType><educational_qualification>' + mapOfPolicyParameters.get('educational_qualification') + '</educational_qualification><current_employment_vintage>' + mapOfPolicyParameters.get('current_employment_vintage') + '</current_employment_vintage><total_employment_vintage>' + mapOfPolicyParameters.get('total_employment_vintage') + '</total_employment_vintage><date_of_birth>' + mapOfPolicyParameters.get('date_of_birth') + '</date_of_birth><date_of_incorporation>'+mapOfPolicyParameters.get('date_of_incorporation')+'</date_of_incorporation><constitution>' + mapOfPolicyParameters.get('constitution') + '</constitution><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><years_in_business_job>' + mapOfPolicyParameters.get('years_in_business_job') + '</years_in_business_job><applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type><type_of_degree>' + mapOfPolicyParameters.get('type_of_degree') + '</type_of_degree><nature_of_business>' + mapOfPolicyParameters.get('nature_of_business') + '</nature_of_business><practiceType>' + mapOfPolicyParameters.get('practiceType') + '</practiceType><profession>' + mapOfPolicyParameters.get('profession') + '</profession><customer_type>' + mapOfPolicyParameters.get('customer_type') + '</customer_type><constitutionType>' + mapOfPolicyParameters.get('constitutionType') + '</constitutionType><first_name>' + mapOfPolicyParameters.get('first_name') + '</first_name><last_name>' + mapOfPolicyParameters.get('last_name') + '</last_name><company_category>' + mapOfPolicyParameters.get('company_category') + '</company_category><financierName>' + mapOfPolicyParameters.get('financierName') + '</financierName><customer_category>' + mapOfPolicyParameters.get('customer_category') + '</customer_category></element></demographic><Cibil_lst><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><CIBIL_Score>' + mapOfPolicyParameters.get('CIBIL_Score') + '</CIBIL_Score><applicant_Type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_Type>';
    body = body + '</element></Cibil_lst><Existing_Loan><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type><monthly_loan_obligations>' + mapOfPolicyParameters.get('monthly_loan_obligations') + '</monthly_loan_obligations></element></Existing_Loan><profit_loss_statement><cy_cash_profit>' + mapOfPolicyParameters.get('cy_cash_profit') + '</cy_cash_profit><py_sales_turnover>' + mapOfPolicyParameters.get('py_sales_turnover') + '</py_sales_turnover><cy_sales_turnover>' + mapOfPolicyParameters.get('cy_sales_turnover') + '</cy_sales_turnover><cy_profit_after_tax>' + mapOfPolicyParameters.get('cy_profit_after_tax') + '</cy_profit_after_tax><cy_depriciation>' + mapOfPolicyParameters.get('cy_depriciation') + '</cy_depriciation><cy_total_networth>' + mapOfPolicyParameters.get('cy_total_networth') + '</cy_total_networth><cy_net_profit>' + mapOfPolicyParameters.get('cy_net_profit') + '</cy_net_profit><gross_receipts>' + mapOfPolicyParameters.get('gross_receipts') + '</gross_receipts><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id></profit_loss_statement><bank_summary><element><loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id><applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type></element></bank_summary></input>';



    body = body.replaceAll('null', '');
    body = body.replaceAll('&', '&amp;');
    // 7515 change body = body.replaceAll('000-1', '0'); 
    body = body.replaceAll('<CIBIL_Score>000-1</CIBIL_Score>', '<CIBIL_Score>0</CIBIL_Score>');
    System.debug('*********body: ' + body);
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/MCP/versions/0.0.1-SNAPSHOT/rules/MCP/mcp/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    System.debug('UserName--->' + username + ' ###  Password---->' + password);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    System.debug('*****BRE call start:-' + system.now());
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*****BRE call end:-' + system.now());
      System.debug('*****req:-' + req.getBody());
      System.debug(res.getBody());
      String result = res.getBody();
      mapOfMCPResult = processResponse1(result);
      System.debug('*********final****mapOfMCPResult: ' + mapOfMCPResult);
    }
    return mapOfMCPResult;
  }


  public Map < String, String > remoteMCPCheck(MAP < String, String > mapOfPolicyParameters) {

    System.debug('*************mapOfPolicyCheckParameters: ' + mapOfPolicyParameters);

    //New code
    System.debug('*************mapOfPolicyCheckParameters: ' + mapOfPolicyParameters);

    /*if (mapOfPolicyParameters.get('applicant_type') == null) mapOfPolicyParameters.put('applicant_type', '');
if (mapOfPolicyParameters.get('requested_loan_amount') == null) mapOfPolicyParameters.put('requested_loan_amount', '');
if (mapOfPolicyParameters.get('product') == null) mapOfPolicyParameters.put('product', '');
if (mapOfPolicyParameters.get('stage') == null) mapOfPolicyParameters.put('stage', '');
if (mapOfPolicyParameters.get('net_Salary_for_Month1') == null) mapOfPolicyParameters.put('net_Salary_for_Month1', '');
if (mapOfPolicyParameters.get('branch_type') == null) mapOfPolicyParameters.put('branch_type', '');
if (mapOfPolicyParameters.get('branch_name') == null) mapOfPolicyParameters.put('branch_name', '');
if (mapOfPolicyParameters.get('current_employment_vintage') == null) mapOfPolicyParameters.put('current_employment_vintage', '');
if (mapOfPolicyParameters.get('total_employment_vintage') == null) mapOfPolicyParameters.put('total_employment_vintage', '');
if (mapOfPolicyParameters.get('date_of_birth') == null) mapOfPolicyParameters.put('date_of_birth', '');
if (mapOfPolicyParameters.get('years_in_business_job') == null) mapOfPolicyParameters.put('years_in_business_job', '');
if (mapOfPolicyParameters.get('monthly_loan_obligations') == null) mapOfPolicyParameters.put('monthly_loan_obligations', '');
if (mapOfPolicyParameters.get('cy_sales_turnover') == null) mapOfPolicyParameters.put('cy_sales_turnover', '');
if (mapOfPolicyParameters.get('cy_depriciation') == null) mapOfPolicyParameters.put('cy_depriciation', '');
if (mapOfPolicyParameters.get('cy_total_networth') == null) mapOfPolicyParameters.put('cy_total_networth', '');
if (mapOfPolicyParameters.get('cy_net_profit') == null) mapOfPolicyParameters.put('cy_net_profit', '');
if (mapOfPolicyParameters.get('py_sales_turnover') == null) mapOfPolicyParameters.put('py_sales_turnover', '');
if (mapOfPolicyParameters.get('constitution') == null) mapOfPolicyParameters.put('constitution', '');
if (mapOfPolicyParameters.get('nature_of_business') == null) mapOfPolicyParameters.put('nature_of_business', '');
if (mapOfPolicyParameters.get('loan_id') == null) mapOfPolicyParameters.put('loan_id', '1');
     */
    String body = '<input>   <Verification>     <element>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type>       <verification_status></verification_status>       <verification_type></verification_type>       <verification_result_updated_date></verification_result_updated_date>     </element>   </Verification>   <loan_parameter>     <dummy_member1></dummy_member1>     <dummy_member2></dummy_member2>     <dummy_member3></dummy_member3>     <dummy_member4></dummy_member4>     <dummy_member5></dummy_member5>     <dummy_member6></dummy_member6>     <dummy_member7></dummy_member7>     <dummy_member8></dummy_member8>     <dummy_member9></dummy_member9>     <dummy_member10></dummy_member10>     <top_up_loan_amount></top_up_loan_amount>     <loan_application_stage></loan_application_stage>     <product_segment></product_segment>     <approved_rate></approved_rate>     <existing_derived_customer_segment></existing_derived_customer_segment>     <derived_customer_segment></derived_customer_segment>     <file_acceptance_status></file_acceptance_status>     <loan_id>' + mapOfPolicyParameters.get('loan_id') + '</loan_id>     <decision_date></decision_date>     <login_date></login_date>     <approved_loan_amount></approved_loan_amount>     <approved_tenor></approved_tenor>     <requested_loan_amount>' + mapOfPolicyParameters.get('requested_loan_amount') + '</requested_loan_amount>     <requested_tenor></requested_tenor>     <reqested_roi></reqested_roi>     <loan_application_number></loan_application_number>     <product>' + mapOfPolicyParameters.get('product') + '</product>     <scheme_name></scheme_name>     <scheme_code></scheme_code>     <type_of_loan></type_of_loan>     <process_type></process_type>     <event></event>     <stage>' + mapOfPolicyParameters.get('stage') + '</stage>     <sourcing_channel_type></sourcing_channel_type>     <existing_loan_product></existing_loan_product>     <existing_loan_amount></existing_loan_amount>     <existing_pos></existing_pos>     <existing_mob></existing_mob>     <existing_lan></existing_lan>     <file_acceptance_date></file_acceptance_date>     <crisil_score></crisil_score>     <sub_stage></sub_stage>     <existing_product></existing_product>     <offer_amount></offer_amount>     <offer_tenor></offer_tenor>     <offer_rate></offer_rate>   </loan_parameter>   <CAMS>     <element>       <loan_id>1</loan_id>       <adjusted_rental_income></adjusted_rental_income>       <average_net_salary></average_net_salary>       <total_net_salary></total_net_salary>       <diff_date_ITRs></diff_date_ITRs>       <eligibility_Multiplier_Formula></eligibility_Multiplier_Formula>       <EMI_on_Proposed_Loan_TO></EMI_on_Proposed_Loan_TO>       <gross_Salary_Month1></gross_Salary_Month1>       <gross_Salary_Month2></gross_Salary_Month2>       <gross_Salary_Month3></gross_Salary_Month3>       <imputed_Income_Capped_at_50></imputed_Income_Capped_at_50>       <loan_eligibility></loan_eligibility>       <max_Loan_Amt_NAS_Multi></max_Loan_Amt_NAS_Multi>       <net_Salary_for_Month1>' + mapOfPolicyParameters.get('net_Salary_for_Month1') + '</net_Salary_for_Month1>       <proposed_Loan_Amt></proposed_Loan_Amt>       <rental_Income></rental_Income>       <sal_MUE_Funding></sal_MUE_Funding>       <final_FOIR></final_FOIR>       <tenor></tenor>       <applicable_FOIR1></applicable_FOIR1>       <average_Monthly_Net_Income1></average_Monthly_Net_Income1>       <type_of_CAM_Entity></type_of_CAM_Entity>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>       <credit_program></credit_program>     </element>   </CAMS>   <generic_info>     <dummy_member1></dummy_member1>     <dummy_member2></dummy_member2>     <dummy_member3></dummy_member3>     <dummy_member4></dummy_member4>     <dummy_member5></dummy_member5>     <dummy_member6></dummy_member6>     <dummy_member7></dummy_member7>     <dummy_member8></dummy_member8>     <dummy_member9></dummy_member9>     <dummy_member10></dummy_member10>     <loan_id>1</loan_id>     <branch_type>' + mapOfPolicyParameters.get('branch_type') + '</branch_type>     <branch_name>' + mapOfPolicyParameters.get('branch_name') + '</branch_name>     <branch_code></branch_code>   </generic_info>   <demographic>     <element>       <type_of_constitution></type_of_constitution>       <vip></vip>       <educational_qualification></educational_qualification>       <loan_application_employment_type></loan_application_employment_type>       <current_employment_vintage>' + mapOfPolicyParameters.get('current_employment_vintage') + '</current_employment_vintage>       <total_employment_vintage>' + mapOfPolicyParameters.get('total_employment_vintage') + '</total_employment_vintage>       <date_of_birth>' + mapOfPolicyParameters.get('date_of_birth') + '</date_of_birth>       <date_of_incorporation></date_of_incorporation>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>       <spouse_doctor_flag></spouse_doctor_flag>       <age></age>       <constitution>' + mapOfPolicyParameters.get('constitution') + '</constitution>       <costomer_type></costomer_type>       <residence_ownership></residence_ownership>       <permanent_house_ownership></permanent_house_ownership>       <factory_plant_ownership></factory_plant_ownership>       <customer_segment></customer_segment>       <clinic_hospital_type></clinic_hospital_type>       <outside_geo_limit></outside_geo_limit>       <stake_in_entity></stake_in_entity>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <dob_doi></dob_doi>       <years_in_business_job>' + mapOfPolicyParameters.get('years_in_business_job') + '</years_in_business_job>       <first_name></first_name>       <last_name></last_name>       <residence_type></residence_type>       <existing_customer_flag></existing_customer_flag>       <applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type>       <marital_status></marital_status>       <company_category></company_category>       <company_type></company_type>       <professional_qualification></professional_qualification>       <type_of_degree></type_of_degree>       <office_email_id></office_email_id>       <office_icard></office_icard>       <name_of_employer></name_of_employer>       <years_in_current_business_job></years_in_current_business_job>       <gender></gender>       <pan></pan>       <residence_city></residence_city>       <office_city></office_city>       <residence_pin_code></residence_pin_code>       <office_pin_code></office_pin_code>       <caste></caste>       <religion></religion>       <staying__since_year></staying__since_year>       <nature_of_business>' + mapOfPolicyParameters.get('nature_of_business') + '</nature_of_business>       <industry></industry>       <sub_industry></sub_industry>       <e_mail_id></e_mail_id>       <customer_type></customer_type>       <permenent_house_ownership></permenent_house_ownership>       <relationship_with_applicant></relationship_with_applicant>     </element>   </demographic>   <Cibil_lst>     <element>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <applicant_Type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_Type>       <currentBalance>         <currentBalance1></currentBalance1>         <currentBalance2></currentBalance2>         <currentBalance3></currentBalance3>         <currentBalance4></currentBalance4>         <currentBalance5></currentBalance5>         <currentBalance6></currentBalance6>         <currentBalance7></currentBalance7>         <currentBalance8></currentBalance8>         <currentBalance9></currentBalance9>         <currentBalance10></currentBalance10>         <currentBalance11></currentBalance11>         <currentBalance12></currentBalance12>         <currentBalance13></currentBalance13>         <currentBalance14></currentBalance14>         <currentBalance15></currentBalance15>         <currentBalance16></currentBalance16>         <currentBalance17></currentBalance17>         <currentBalance18></currentBalance18>         <currentBalance19></currentBalance19>         <currentBalance20></currentBalance20>         <currentBalance21></currentBalance21>         <currentBalance22></currentBalance22>         <currentBalance23></currentBalance23>         <currentBalance24></currentBalance24>         <currentBalance25></currentBalance25>         <currentBalance26></currentBalance26>         <currentBalance27></currentBalance27>         <currentBalance28></currentBalance28>         <currentBalance29></currentBalance29>         <currentBalance></currentBalance>       </currentBalance>       <writtenOffPrincipal>         <writtenOffPrincipal></writtenOffPrincipal>         <writtenOffPrincipal1></writtenOffPrincipal1>         <writtenOffPrincipal2></writtenOffPrincipal2>         <writtenOffPrincipal3></writtenOffPrincipal3>         <writtenOffPrincipal4></writtenOffPrincipal4>         <writtenOffPrincipal5></writtenOffPrincipal5>         <writtenOffPrincipal6></writtenOffPrincipal6>         <writtenOffPrincipal7></writtenOffPrincipal7>         <writtenOffPrincipal8></writtenOffPrincipal8>         <writtenOffPrincipal9></writtenOffPrincipal9>         <writtenOffPrincipal10></writtenOffPrincipal10>         <writtenOffPrincipal11></writtenOffPrincipal11>         <writtenOffPrincipal12></writtenOffPrincipal12>         <writtenOffPrincipal13></writtenOffPrincipal13>         <writtenOffPrincipal14></writtenOffPrincipal14>         <writtenOffPrincipal15></writtenOffPrincipal15>         <writtenOffPrincipal16></writtenOffPrincipal16>         <writtenOffPrincipal17></writtenOffPrincipal17>         <writtenOffPrincipal18></writtenOffPrincipal18>         <writtenOffPrincipal19></writtenOffPrincipal19>         <writtenOffPrincipal20></writtenOffPrincipal20>         <writtenOffPrincipal21></writtenOffPrincipal21>         <writtenOffPrincipal22></writtenOffPrincipal22>         <writtenOffPrincipal23></writtenOffPrincipal23>         <writtenOffPrincipal24></writtenOffPrincipal24>         <writtenOffPrincipal25></writtenOffPrincipal25>         <writtenOffPrincipal26></writtenOffPrincipal26>         <writtenOffPrincipal27></writtenOffPrincipal27>         <writtenOffPrincipal28></writtenOffPrincipal28>         <writtenOffPrincipal29></writtenOffPrincipal29>       </writtenOffPrincipal>       <dateClosed>         <dateClosed1></dateClosed1>         <dateClosed2></dateClosed2>         <dateClosed3></dateClosed3>         <dateClosed4></dateClosed4>         <dateClosed5></dateClosed5>         <dateClosed6></dateClosed6>         <dateClosed7></dateClosed7>         <dateClosed8></dateClosed8>         <dateClosed9></dateClosed9>         <dateClosed10></dateClosed10>         <dateClosed11></dateClosed11>         <dateClosed12></dateClosed12>         <dateClosed13></dateClosed13>         <dateClosed14></dateClosed14>         <dateClosed15></dateClosed15>         <dateClosed16></dateClosed16>         <dateClosed17></dateClosed17>         <dateClosed18></dateClosed18>         <dateClosed19></dateClosed19>         <dateClosed20></dateClosed20>         <dateClosed21></dateClosed21>         <dateClosed22></dateClosed22>         <dateClosed23></dateClosed23>         <dateClosed24></dateClosed24>         <dateClosed25></dateClosed25>         <dateClosed26></dateClosed26>         <dateClosed27></dateClosed27>         <dateClosed28></dateClosed28>         <dateClosed29></dateClosed29>         <dateClosed></dateClosed>       </dateClosed>       <dateReported>         <dateReported1></dateReported1>         <dateReported2></dateReported2>         <dateReported3></dateReported3>         <dateReported4></dateReported4>         <dateReported5></dateReported5>         <dateReported6></dateReported6>         <dateReported7></dateReported7>         <dateReported8></dateReported8>         <dateReported9></dateReported9>         <dateReported10></dateReported10>         <dateReported11></dateReported11>         <dateReported12></dateReported12>         <dateReported13></dateReported13>         <dateReported14></dateReported14>         <dateReported15></dateReported15>         <dateReported16></dateReported16>         <dateReported17></dateReported17>         <dateReported18></dateReported18>         <dateReported19></dateReported19>         <dateReported20></dateReported20>         <dateReported21></dateReported21>         <dateReported22></dateReported22>         <dateReported23></dateReported23>         <dateReported24></dateReported24>         <dateReported25></dateReported25>         <dateReported26></dateReported26>         <dateReported27></dateReported27>         <dateReported28></dateReported28>         <dateReported29></dateReported29>         <dateReported></dateReported>       </dateReported>       <paymentHistoryEndDate>         <paymentHistoryEndDate1></paymentHistoryEndDate1>         <paymentHistoryEndDate2></paymentHistoryEndDate2>         <paymentHistoryEndDate3></paymentHistoryEndDate3>         <paymentHistoryEndDate4></paymentHistoryEndDate4>         <paymentHistoryEndDate5></paymentHistoryEndDate5>         <paymentHistoryEndDate6></paymentHistoryEndDate6>         <paymentHistoryEndDate7></paymentHistoryEndDate7>         <paymentHistoryEndDate8></paymentHistoryEndDate8>         <paymentHistoryEndDate9></paymentHistoryEndDate9>         <paymentHistoryEndDate10></paymentHistoryEndDate10>         <paymentHistoryEndDate11></paymentHistoryEndDate11>         <paymentHistoryEndDate12></paymentHistoryEndDate12>         <paymentHistoryEndDate13></paymentHistoryEndDate13>         <paymentHistoryEndDate14></paymentHistoryEndDate14>         <paymentHistoryEndDate15></paymentHistoryEndDate15>         <paymentHistoryEndDate16></paymentHistoryEndDate16>         <paymentHistoryEndDate17></paymentHistoryEndDate17>         <paymentHistoryEndDate18></paymentHistoryEndDate18>         <paymentHistoryEndDate19></paymentHistoryEndDate19>         <paymentHistoryEndDate20></paymentHistoryEndDate20>         <paymentHistoryEndDate21></paymentHistoryEndDate21>         <paymentHistoryEndDate22></paymentHistoryEndDate22>         <paymentHistoryEndDate23></paymentHistoryEndDate23>         <paymentHistoryEndDate24></paymentHistoryEndDate24>         <paymentHistoryEndDate25></paymentHistoryEndDate25>         <paymentHistoryEndDate26></paymentHistoryEndDate26>         <paymentHistoryEndDate27></paymentHistoryEndDate27>         <paymentHistoryEndDate28></paymentHistoryEndDate28>         <paymentHistoryEndDate29></paymentHistoryEndDate29>         <paymentHistoryEndDate></paymentHistoryEndDate>       </paymentHistoryEndDate>       <paymentHistoryStartDate>         <paymentHistoryStartDate1></paymentHistoryStartDate1>         <paymentHistoryStartDate2></paymentHistoryStartDate2>         <paymentHistoryStartDate3></paymentHistoryStartDate3>         <paymentHistoryStartDate4></paymentHistoryStartDate4>         <paymentHistoryStartDate5></paymentHistoryStartDate5>         <paymentHistoryStartDate6></paymentHistoryStartDate6>         <paymentHistoryStartDate7></paymentHistoryStartDate7>         <paymentHistoryStartDate8></paymentHistoryStartDate8>         <paymentHistoryStartDate9></paymentHistoryStartDate9>         <paymentHistoryStartDate10></paymentHistoryStartDate10>         <paymentHistoryStartDate11></paymentHistoryStartDate11>         <paymentHistoryStartDate12></paymentHistoryStartDate12>         <paymentHistoryStartDate13></paymentHistoryStartDate13>         <paymentHistoryStartDate14></paymentHistoryStartDate14>         <paymentHistoryStartDate15></paymentHistoryStartDate15>         <paymentHistoryStartDate16></paymentHistoryStartDate16>         <paymentHistoryStartDate17></paymentHistoryStartDate17>         <paymentHistoryStartDate18></paymentHistoryStartDate18>         <paymentHistoryStartDate19></paymentHistoryStartDate19>         <paymentHistoryStartDate20></paymentHistoryStartDate20>         <paymentHistoryStartDate21></paymentHistoryStartDate21>         <paymentHistoryStartDate22></paymentHistoryStartDate22>         <paymentHistoryStartDate23></paymentHistoryStartDate23>         <paymentHistoryStartDate24></paymentHistoryStartDate24>         <paymentHistoryStartDate25></paymentHistoryStartDate25>         <paymentHistoryStartDate26></paymentHistoryStartDate26>         <paymentHistoryStartDate27></paymentHistoryStartDate27>         <paymentHistoryStartDate28></paymentHistoryStartDate28>         <paymentHistoryStartDate29></paymentHistoryStartDate29>         <paymentHistoryStartDate></paymentHistoryStartDate>       </paymentHistoryStartDate>       <acountType>         <accountType1></accountType1>         <accountType2></accountType2>         <accountType3></accountType3>         <accountType4></accountType4>         <accountType5></accountType5>         <accountType6></accountType6>         <accountType7></accountType7>         <accountType8></accountType8>         <accountType9></accountType9>         <accountType10></accountType10>         <accountType11></accountType11>         <accountType12></accountType12>         <accountType13></accountType13>         <accountType14></accountType14>         <accountType15></accountType15>         <accountType16></accountType16>         <accountType17></accountType17>         <accountType18></accountType18>         <accountType19></accountType19>         <accountType20></accountType20>         <accountType21></accountType21>         <accountType22></accountType22>         <accountType23></accountType23>         <accountType24></accountType24>         <accountType25></accountType25>         <accountType26></accountType26>         <accountType27></accountType27>         <accountType28></accountType28>         <accountType29></accountType29>         <accountType></accountType>       </acountType>       <accountOverdue>         <amountOverdue1></amountOverdue1>         <amountOverdue2></amountOverdue2>         <amountOverdue3></amountOverdue3>         <amountOverdue4></amountOverdue4>         <amountOverdue5></amountOverdue5>         <amountOverdue6></amountOverdue6>         <amountOverdue7></amountOverdue7>         <amountOverdue8></amountOverdue8>         <amountOverdue9></amountOverdue9>         <amountOverdue10></amountOverdue10>         <amountOverdue11></amountOverdue11>         <amountOverdue12></amountOverdue12>         <amountOverdue13></amountOverdue13>         <amountOverdue14></amountOverdue14>         <amountOverdue15></amountOverdue15>         <amountOverdue16></amountOverdue16>         <amountOverdue17></amountOverdue17>         <amountOverdue18></amountOverdue18>         <amountOverdue19></amountOverdue19>         <amountOverdue20></amountOverdue20>         <amountOverdue21></amountOverdue21>         <amountOverdue22></amountOverdue22>         <amountOverdue23></amountOverdue23>         <amountOverdue24></amountOverdue24>         <amountOverdue25></amountOverdue25>         <amountOverdue26></amountOverdue26>         <amountOverdue27></amountOverdue27>         <amountOverdue28></amountOverdue28>         <amountOverdue29></amountOverdue29>         <amountOverdue></amountOverdue>';
    body = body + '</accountOverdue>       <dateOfEnquiry>         <dateOfEnquiry1></dateOfEnquiry1>         <dateOfEnquiry2></dateOfEnquiry2>         <dateOfEnquiry3></dateOfEnquiry3>         <dateOfEnquiry4></dateOfEnquiry4>         <dateOfEnquiry5></dateOfEnquiry5>         <dateOfEnquiry6></dateOfEnquiry6>         <dateOfEnquiry7></dateOfEnquiry7>         <dateOfEnquiry8></dateOfEnquiry8>         <dateOfEnquiry9></dateOfEnquiry9>         <dateOfEnquiry10></dateOfEnquiry10>         <dateOfEnquiry11></dateOfEnquiry11>         <dateOfEnquiry12></dateOfEnquiry12>         <dateOfEnquiry13></dateOfEnquiry13>         <dateOfEnquiry14></dateOfEnquiry14>         <dateOfEnquiry15></dateOfEnquiry15>         <dateOfEnquiry16></dateOfEnquiry16>         <dateOfEnquiry17></dateOfEnquiry17>         <dateOfEnquiry18></dateOfEnquiry18>         <dateOfEnquiry19></dateOfEnquiry19>         <dateOfEnquiry20></dateOfEnquiry20>         <dateOfEnquiry21></dateOfEnquiry21>         <dateOfEnquiry22></dateOfEnquiry22>         <dateOfEnquiry23></dateOfEnquiry23>         <dateOfEnquiry24></dateOfEnquiry24>         <dateOfEnquiry25></dateOfEnquiry25>         <dateOfEnquiry26></dateOfEnquiry26>         <dateOfEnquiry27></dateOfEnquiry27>         <dateOfEnquiry28></dateOfEnquiry28>         <dateOfEnquiry29></dateOfEnquiry29>         <dateOfEnquiry></dateOfEnquiry>       </dateOfEnquiry>       <daysPastDue>         <daysPastDue1></daysPastDue1>         <daysPastDue2></daysPastDue2>         <daysPastDue3></daysPastDue3>         <daysPastDue4></daysPastDue4>         <daysPastDue5></daysPastDue5>         <daysPastDue6></daysPastDue6>         <daysPastDue7></daysPastDue7>         <daysPastDue8></daysPastDue8>         <daysPastDue9></daysPastDue9>         <daysPastDue10></daysPastDue10>         <daysPastDue11></daysPastDue11>         <daysPastDue12></daysPastDue12>         <daysPastDue13></daysPastDue13>         <daysPastDue14></daysPastDue14>         <daysPastDue15></daysPastDue15>         <daysPastDue16></daysPastDue16>         <daysPastDue17></daysPastDue17>         <daysPastDue18></daysPastDue18>         <daysPastDue19></daysPastDue19>         <daysPastDue20></daysPastDue20>         <daysPastDue21></daysPastDue21>         <daysPastDue22></daysPastDue22>         <daysPastDue23></daysPastDue23>         <daysPastDue24></daysPastDue24>         <daysPastDue25></daysPastDue25>         <daysPastDue26></daysPastDue26>         <daysPastDue27></daysPastDue27>         <daysPastDue28></daysPastDue28>         <daysPastDue29></daysPastDue29>         <daysPastDue></daysPastDue>       </daysPastDue>       <enquiryAmount>         <enquiryAmt1></enquiryAmt1>         <enquiryAmt2></enquiryAmt2>         <enquiryAmt3></enquiryAmt3>         <enquiryAmt4></enquiryAmt4>         <enquiryAmt5></enquiryAmt5>         <enquiryAmt6></enquiryAmt6>         <enquiryAmt7></enquiryAmt7>         <enquiryAmt8></enquiryAmt8>         <enquiryAmt9></enquiryAmt9>         <enquiryAmt10></enquiryAmt10>         <enquiryAmt11></enquiryAmt11>         <enquiryAmt12></enquiryAmt12>         <enquiryAmt13></enquiryAmt13>         <enquiryAmt14></enquiryAmt14>         <enquiryAmt15></enquiryAmt15>         <enquiryAmt16></enquiryAmt16>         <enquiryAmt17></enquiryAmt17>         <enquiryAmt18></enquiryAmt18>         <enquiryAmt19></enquiryAmt19>         <enquiryAmt20></enquiryAmt20>         <enquiryAmt21></enquiryAmt21>         <enquiryAmt22></enquiryAmt22>         <enquiryAmt23></enquiryAmt23>         <enquiryAmt24></enquiryAmt24>         <enquiryAmt25></enquiryAmt25>         <enquiryAmt26></enquiryAmt26>         <enquiryAmt27></enquiryAmt27>         <enquiryAmt28></enquiryAmt28>         <enquiryAmt29></enquiryAmt29>         <enquiryAmt></enquiryAmt>       </enquiryAmount>       <enquiryPurpose>         <enquiryPurpose1></enquiryPurpose1>         <enquiryPurpose2></enquiryPurpose2>         <enquiryPurpose3></enquiryPurpose3>         <enquiryPurpose4></enquiryPurpose4>         <enquiryPurpose5></enquiryPurpose5>         <enquiryPurpose6></enquiryPurpose6>         <enquiryPurpose7></enquiryPurpose7>         <enquiryPurpose8></enquiryPurpose8>         <enquiryPurpose9></enquiryPurpose9>         <enquiryPurpose10></enquiryPurpose10>         <enquiryPurpose11></enquiryPurpose11>         <enquiryPurpose12></enquiryPurpose12>         <enquiryPurpose13></enquiryPurpose13>         <enquiryPurpose14></enquiryPurpose14>         <enquiryPurpose15></enquiryPurpose15>         <enquiryPurpose16></enquiryPurpose16>         <enquiryPurpose17></enquiryPurpose17>         <enquiryPurpose18></enquiryPurpose18>         <enquiryPurpose19></enquiryPurpose19>         <enquiryPurpose20></enquiryPurpose20>         <enquiryPurpose21></enquiryPurpose21>         <enquiryPurpose22></enquiryPurpose22>         <enquiryPurpose23></enquiryPurpose23>         <enquiryPurpose24></enquiryPurpose24>         <enquiryPurpose25></enquiryPurpose25>         <enquiryPurpose26></enquiryPurpose26>         <enquiryPurpose27></enquiryPurpose27>         <enquiryPurpose28></enquiryPurpose28>         <enquiryPurpose29></enquiryPurpose29>         <enquiryPurpose></enquiryPurpose>       </enquiryPurpose>       <memberName>         <memberName1></memberName1>         <memberName2></memberName2>         <memberName3></memberName3>         <memberName4></memberName4>         <memberName5></memberName5>         <memberName6></memberName6>         <memberName7></memberName7>         <memberName8></memberName8>         <memberName9></memberName9>         <memberName10></memberName10>         <memberName11></memberName11>         <memberName12></memberName12>         <memberName13></memberName13>         <memberName14></memberName14>         <memberName15></memberName15>         <memberName16></memberName16>         <memberName17></memberName17>         <memberName18></memberName18>         <memberName19></memberName19>         <memberName20></memberName20>         <memberName21></memberName21>         <memberName22></memberName22>         <memberName23></memberName23>         <memberName24></memberName24>         <memberName25></memberName25>         <memberName26></memberName26>         <memberName27></memberName27>         <memberName28></memberName28>         <memberName29></memberName29>         <memberName></memberName>       </memberName>       <member>         <member1></member1>         <member2></member2>         <member3></member3>         <member4></member4>         <member5></member5>         <member6></member6>         <member7></member7>         <member8></member8>         <member9></member9>         <member10></member10>         <member11></member11>         <member12></member12>         <member13></member13>         <member14></member14>         <member15></member15>         <member16></member16>         <member17></member17>         <member18></member18>         <member19></member19>         <member20></member20>         <member21></member21>         <member22></member22>         <member23></member23>         <member24></member24>         <member25></member25>         <member26></member26>         <member27></member27>         <member28></member28>         <member29></member29>         <member></member>       </member>       <ownership>         <ownership1></ownership1>         <ownership2></ownership2>         <ownership3></ownership3>         <ownership4></ownership4>         <ownership5></ownership5>         <ownership6></ownership6>         <ownership7></ownership7>         <ownership8></ownership8>         <ownership9></ownership9>         <ownership10></ownership10>         <ownership11></ownership11>         <ownership12></ownership12>         <ownership13></ownership13>         <ownership14></ownership14>         <ownership15></ownership15>         <ownership16></ownership16>         <ownership17></ownership17>         <ownership18></ownership18>         <ownership19></ownership19>         <ownership20></ownership20>         <ownership21></ownership21>         <ownership22></ownership22>         <ownership23></ownership23>         <ownership24></ownership24>         <ownership25></ownership25>         <ownership26></ownership26>         <ownership27></ownership27>         <ownership28></ownership28>         <ownership29></ownership29>         <ownership></ownership>       </ownership>       <startEndDate>         <startEndDate1></startEndDate1>         <startEndDate2></startEndDate2>         <startEndDate3></startEndDate3>         <startEndDate4></startEndDate4>         <startEndDate5></startEndDate5>         <startEndDate6></startEndDate6>         <startEndDate7></startEndDate7>         <startEndDate8></startEndDate8>         <startEndDate9></startEndDate9>         <startEndDate10></startEndDate10>         <startEndDate11></startEndDate11>         <startEndDate12></startEndDate12>         <startEndDate13></startEndDate13>         <startEndDate14></startEndDate14>         <startEndDate15></startEndDate15>         <startEndDate16></startEndDate16>         <startEndDate17></startEndDate17>         <startEndDate18></startEndDate18>         <startEndDate19></startEndDate19>         <startEndDate20></startEndDate20>         <startEndDate21></startEndDate21>         <startEndDate22></startEndDate22>         <startEndDate23></startEndDate23>         <startEndDate24></startEndDate24>         <startEndDate25></startEndDate25>         <startEndDate26></startEndDate26>         <startEndDate27></startEndDate27>         <startEndDate28></startEndDate28>         <startEndDate29></startEndDate29>         <startEndDate></startEndDate>       </startEndDate>       <suitFiledStatus>         <suitFiledStatus></suitFiledStatus>         <suitFiledStatus1></suitFiledStatus1>         <suitFiledStatus2></suitFiledStatus2>         <suitFiledStatus3></suitFiledStatus3>         <suitFiledStatus4></suitFiledStatus4>         <suitFiledStatus5></suitFiledStatus5>         <suitFiledStatus6></suitFiledStatus6>         <suitFiledStatus7></suitFiledStatus7>         <suitFiledStatus8></suitFiledStatus8>         <suitFiledStatus9></suitFiledStatus9>         <suitFiledStatus10></suitFiledStatus10>         <suitFiledStatus11></suitFiledStatus11>         <suitFiledStatus12></suitFiledStatus12>         <suitFiledStatus13></suitFiledStatus13>         <suitFiledStatus14></suitFiledStatus14>         <suitFiledStatus15></suitFiledStatus15>         <suitFiledStatus16></suitFiledStatus16>         <suitFiledStatus17></suitFiledStatus17>         <suitFiledStatus18></suitFiledStatus18>         <suitFiledStatus19></suitFiledStatus19>         <suitFiledStatus20></suitFiledStatus20>         <suitFiledStatus21></suitFiledStatus21>         <suitFiledStatus22></suitFiledStatus22>         <suitFiledStatus23></suitFiledStatus23>         <suitFiledStatus24></suitFiledStatus24>         <suitFiledStatus25></suitFiledStatus25>         <suitFiledStatus26></suitFiledStatus26>         <suitFiledStatus27></suitFiledStatus27>         <suitFiledStatus28></suitFiledStatus28>         <suitFiledStatus29></suitFiledStatus29>       </suitFiledStatus>       <writtenOffAndSettledStatus>         <writtenOffAndSettledStatus1></writtenOffAndSettledStatus1>         <writtenOffAndSettledStatus2></writtenOffAndSettledStatus2>         <writtenOffAndSettledStatus3></writtenOffAndSettledStatus3>         <writtenOffAndSettledStatus4></writtenOffAndSettledStatus4>         <writtenOffAndSettledStatus5></writtenOffAndSettledStatus5>         <writtenOffAndSettledStatus6></writtenOffAndSettledStatus6>         <writtenOffAndSettledStatus7></writtenOffAndSettledStatus7>         <writtenOffAndSettledStatus8></writtenOffAndSettledStatus8>         <writtenOffAndSettledStatus9></writtenOffAndSettledStatus9>         <writtenOffAndSettledStatus10></writtenOffAndSettledStatus10>         <writtenOffAndSettledStatus11></writtenOffAndSettledStatus11>         <writtenOffAndSettledStatus12></writtenOffAndSettledStatus12>         <writtenOffAndSettledStatus13></writtenOffAndSettledStatus13>         <writtenOffAndSettledStatus14></writtenOffAndSettledStatus14>         <writtenOffAndSettledStatus15></writtenOffAndSettledStatus15>         <writtenOffAndSettledStatus16></writtenOffAndSettledStatus16>         <writtenOffAndSettledStatus17></writtenOffAndSettledStatus17>         <writtenOffAndSettledStatus18></writtenOffAndSettledStatus18>         <writtenOffAndSettledStatus19></writtenOffAndSettledStatus19>         <writtenOffAndSettledStatus20></writtenOffAndSettledStatus20>         <writtenOffAndSettledStatus21></writtenOffAndSettledStatus21>         <writtenOffAndSettledStatus22></writtenOffAndSettledStatus22>         <writtenOffAndSettledStatus23></writtenOffAndSettledStatus23>         <writtenOffAndSettledStatus24></writtenOffAndSettledStatus24>         <writtenOffAndSettledStatus25></writtenOffAndSettledStatus25>         <writtenOffAndSettledStatus26></writtenOffAndSettledStatus26>         <writtenOffAndSettledStatus27></writtenOffAndSettledStatus27>         <writtenOffAndSettledStatus28></writtenOffAndSettledStatus28>         <writtenOffAndSettledStatus29></writtenOffAndSettledStatus29>         <writtenOffAndSettledStatus></writtenOffAndSettledStatus>       </writtenOffAndSettledStatus>       <amout_Overdue_Limit></amout_Overdue_Limit>       <CIBIL_Fired_time></CIBIL_Fired_time>       <CIBIL_updated_time></CIBIL_updated_time>       <date_Processed></date_Processed>       <EM_Date_of_Entry_for_Cibil_Remarks_Code></EM_Date_of_Entry_for_Cibil_Remarks_Code>       <EM_Date_of_Entry_for_Error_Code></EM_Date_of_Entry_for_Error_Code>       <EM_Date_of_Entry_for_Error_Dispute_Re></EM_Date_of_Entry_for_Error_Dispute_Re>       <bad_Track_Record></bad_Track_Record>       <CIBIL_Match_check></CIBIL_Match_check>       <CIBIL_Rules_Fail></CIBIL_Rules_Fail>       <CIBIL_Score></CIBIL_Score>       <PL_Score></PL_Score>       <TU_Score></TU_Score>       <write_Off></write_Off>     </element>   </Cibil_lst>   <Existing_Loan>     <element>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type>       <monthly_loan_obligations>' + mapOfPolicyParameters.get('monthly_loan_obligations') + '</monthly_loan_obligations>       <monthly_secured_loan_obligations></monthly_secured_loan_obligations>       <monthly_unsecured_loan_obligations></monthly_unsecured_loan_obligations>       <total_outstanding></total_outstanding>       <number_of_hl_loans></number_of_hl_loans>       <number_of_personal_loans></number_of_personal_loans>       <number_of_auto_loans></number_of_auto_loans>       <outstanding_of_hl_loans></outstanding_of_hl_loans>       <outstanding_of_personal_loans></outstanding_of_personal_loans>       <total_home_loan_amount></total_home_loan_amount>       <total_personal_loan_amount></total_personal_loan_amount>       <total_auto_loan_amount></total_auto_loan_amount>       <annual_obligations></annual_obligations>       <outstanding_of_auto_loans></outstanding_of_auto_loans>     </element>   </Existing_Loan>   <profit_loss_statement>     <cy_interest_to_pvt_parties></cy_interest_to_pvt_parties>     <py_sales_turnover>' + mapOfPolicyParameters.get('py_sales_turnover') + '</py_sales_turnover>     <cy_sales_turnover>' + mapOfPolicyParameters.get('cy_sales_turnover') + '</cy_sales_turnover>     <py_profit_before_tax></py_profit_before_tax>     <py_profit_after_tax></py_profit_after_tax>     <py_income_as_per_itr></py_income_as_per_itr>     <cy_profit_before_tax></cy_profit_before_tax>     <cy_profit_after_tax></cy_profit_after_tax>     <cy_income_as_per_itr></cy_income_as_per_itr>     <py_depriciation></py_depriciation>     <cy_depriciation>' + mapOfPolicyParameters.get('cy_depriciation') + '</cy_depriciation>     <py_salary_to_partner></py_salary_to_partner>     <cy_salary_to_partner></cy_salary_to_partner>     <py_interest_to_partner></py_interest_to_partner>     <cy_interest_to_partner></cy_interest_to_partner>     <py_ebitda></py_ebitda>     <cy_ebitda></cy_ebitda>     <py_total_interest_paid></py_total_interest_paid>     <cy_total_interest_paid></cy_total_interest_paid>     <py_cash_profit></py_cash_profit>     <cy_cash_profit></cy_cash_profit>     <py_total_networth></py_total_networth>     <cy_total_networth>' + mapOfPolicyParameters.get('cy_total_networth') + '</cy_total_networth>     <py_debtors></py_debtors>     <cy_debtors></cy_debtors>     <py_creditors></py_creditors>     <cy_creditors></cy_creditors>     <py_adjusted_networth></py_adjusted_networth>     <cy_adjusted_networth></cy_adjusted_networth>     <cy_annual_receipt></cy_annual_receipt>     <cy_income_from_business></cy_income_from_business>     <cy_net_profit>' + mapOfPolicyParameters.get('cy_net_profit') + '</cy_net_profit>     <py_net_profit></py_net_profit>     <gross_receipts></gross_receipts>     <cy_Interest_to_FI></cy_Interest_to_FI>     <py_Interest_to_FI></py_Interest_to_FI>     <py_interest_to_pvt_parties></py_interest_to_pvt_parties>     <cy_inBigDecimal_to_pvt_parties></cy_inBigDecimal_to_pvt_parties>     <py_Total_ouside_borrowings></py_Total_ouside_borrowings>     <cy_Total_ouside_borrowings></cy_Total_ouside_borrowings>     <days_gap_in_itr></days_gap_in_itr>     <dummy_member9></dummy_member9>     <dummy_member10></dummy_member10>     <cy_inventory></cy_inventory>     <py_inventory></py_inventory>     <cy_total_assets></cy_total_assets>     <py_total_assets></py_total_assets>     <cy_current_assets></cy_current_assets>     <py_current_assets></py_current_assets>     <cy_current_liabilities></cy_current_liabilities>     <py_current_liabilities></py_current_liabilities>     <loan_id>1</loan_id>     <applicant_id></applicant_id>   </profit_loss_statement>   <bank_summary>     <element>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <applicant_type>' + mapOfPolicyParameters.get('applicant_type') + '</applicant_type>       <avg_od_cc_utilisation></avg_od_cc_utilisation>       <avg_bank_balance></avg_bank_balance>       <avg_od_cc_limit></avg_od_cc_limit>       <avg_bounce_inward></avg_bounce_inward>       <total_bounce_inward></total_bounce_inward>       <avg_bounce_outward></avg_bounce_outward>       <total_bounce_outward></total_bounce_outward>       <avg_credit_amount></avg_credit_amount>       <total_credit_amount></total_credit_amount>       <avg_debit_amount></avg_debit_amount>       <total_debit_amount></total_debit_amount>       <no_of_months_bankstatement></no_of_months_bankstatement>       <avg_monthly_balance_6mths></avg_monthly_balance_6mths>       <avg_monthly_balance_3mths></avg_monthly_balance_3mths>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>     </element>   </bank_summary> </input>';

    body = body.replaceAll('null', '');

    System.debug('body-----------------' + body);
    HttpRequest req = new HttpRequest();
    //Added by Mahima- IP Changes-- start--
    Mid_office_BRE_flow__c Remote_MCP_Check = Mid_office_BRE_flow__c.getValues('Remote MCP Check');
    if (Remote_MCP_Check != null) {
      // username = Remote_MCP_Check.Username__c;
      // password = Remote_MCP_Check.Password__c;
      endpointURL = '';
      endpointURL = Remote_MCP_Check.EndpointURL__c;
    }
    //Added by Mahima- IP Changes-- end--
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/MCP/versions/0.0.1-SNAPSHOT/rules/MCP/mcp/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    // req.setHeader('Authorization', 'Basic REVGQVVMVFxBZG1pbjpBZG1pbg==');
    Http http = new Http();
    System.debug('*****BRE call start:-' + system.now());
    System.debug('req-----------------' + req);
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*****BRE call end:-' + system.now());
      System.debug('*****req:-' + req.getBody());
      System.debug(res.getBody());
      String result = res.getBody();
      mapOfMCPResult = processResponse1(result);
    }
    System.debug('*********final****mapOfMCPResult: ' + mapOfMCPResult);
    //mapOfMCPResult: {FinalResult=Fail, MCPList=,Salary Policy Fail,Total Experience Policy Fail,Age Policy Pass}
    return mapOfMCPResult;
  }

  String result, refNo;
  public Map < String, String > processResponse1(String response) {
    System.debug('*************response: ' + response);
    DOM.Document doc = new DOM.Document();
    doc.load(response);
    DOM.XMLNode root = doc.getRootElement();
    System.debug('*************root: ' + root);
    refNo = root.getattribute('mcpOutput', null);
    result = result + root.getText();
    mapOfMCPResult = parseResponse1(root);
    System.debug('*************mapOfMCPResult: ' + mapOfMCPResult);
    return mapOfMCPResult;

  }
  public Map < String, String > parseResponseBLDeviation(DOM.XMLNode root) {
    //For deviations
    for (Dom.XMLNode obj: root.getChildElements()) {
      if (obj.getName() == 'deviationsList') {
        System.debug('*******deviationsList******objobj.getName: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'element') {
            for (Dom.XMLNode obj2: obj1.getChildElements()) {
              if (obj2.getName() == 'deviation') {
                System.debug('***in deviation*obj1.getText(): ' + obj2.getText());
                //DeviationCode = DeviationCode+','+obj2.getText();
                DeviationCode = obj2.getText();
                System.debug('****DeviationCode: ' + DeviationCode);
              }
              if (obj2.getName() == 'approver') {
                System.debug('***in approver*obj1.getText(): ' + obj2.getText());
                //approver = approver+','+obj2.getText();
                approver = obj2.getText();
                System.debug('****approver: ' + approver);
              }
            }
            MapOfDeviationResult.put(DeviationCode, approver);
          }
        }
      }
    }
    return MapOfDeviationResult;
  }
  public Map < String, String > parseResponse1(DOM.XMLNode root) {
    System.debug('************root ' + root.getChildElements());
    for (Dom.XMLNode obj: root.getChildElements()) {
      System.debug('*************obj: ' + obj);
      System.debug('*************objobj.getName: ' + obj.getName());
      if (obj.getName() == 'mcp_list') {
        System.debug('*************objobj.getName: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'element') {
            for (Dom.XMLNode obj2: obj1.getChildElements()) {
              if (obj2.getName() == 'mcpDesc') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mcpResultdesc = mcpResultdesc + ',' + obj2.getText();
                System.debug('****mcpResultdesc123: ' + mcpResultdesc);
              }
            }
          }
        }
      }
      System.debug('****mcp_list: ' + obj.getChildElements());
      if (obj.getName() == 'mcp_policy') {
        System.debug('****mcp polist result: ' + obj.getText());
        mcpResult = obj.getText();
        mapOfMCPResult.put('FinalResult', mcpResult);
      }

      // Start of MSME BL changes
      if (obj.getName() == 'output') {
        System.debug('****output for PD : ' + obj.getText());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          System.debug('****Inside for loop : ' + obj1.getText());
          if (obj1.getName() == 'pdType') {
            System.debug('****pdType : ' + obj1.getText());
            mapOfMCPResult.put('pdType', obj1.getText());
          }
        }
      }
      // End of MSME BL changes

      // Start of pureflexi ad-hoc DSS bug - 6017
      boolean flag = true;
      // End of pureflexi ad-hoc DSS bug - 6017

      //For Eligibilty
      if (obj.getName() == 'Eligibility') {
        System.debug('*************objobj.getName: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'element') {
            for (Dom.XMLNode obj2: obj1.getChildElements()) {
              if (obj2.getName() == 'np_tenor_wise_eligibility_12') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('EMI_tenor_wise_eligibility_12', obj2.getText());
              } else if (obj2.getName() == 'np_tenor_wise_eligibility_24') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('EMI_tenor_wise_eligibility_24', obj2.getText());
              } /** Sainath - 14508 start **/
              else if (obj2.getName() == 'rejection_reason') {
                mapOfMCPResult.put('rejection_reason', obj2.getText());
                /** Sainath - 14508 end **/
                /* 17139 start*/
              } else if (obj2.getName() == 'max_emi_as_per_multiplier') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_emi_as_per_multiplier', obj2.getText());
              } /* 17139 end*/
              else if (obj2.getName() == 'np_tenor_wise_eligibility_36') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('EMI_tenor_wise_eligibility_36', obj2.getText());
              } else if (obj2.getName() == 'np_tenor_wise_eligibility_48') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('EMI_tenor_wise_eligibility_48', obj2.getText());
              } else if (obj2.getName() == 'np_tenor_wise_eligibility_60') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('EMI_tenor_wise_eligibility_60', obj2.getText());
              } else if (obj2.getName() == 'np_tenor_wise_eligibility_72') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('EMI_tenor_wise_eligibility_72', obj2.getText());
              } else if (obj2.getName() == 'applicable_FOIR') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('applicable_FOIR', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_FOIR_12') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_loan_as_per_FOIR_12', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_FOIR_24') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_loan_as_per_FOIR_24', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_FOIR_36') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_loan_as_per_FOIR_36', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_FOIR_48') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_loan_as_per_FOIR_48', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_FOIR_60') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_loan_as_per_FOIR_60', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_FOIR_72') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_loan_as_per_FOIR_72', obj2.getText());
              } else if (obj2.getName() == 'eligible_loan_amount_12') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('eligible_loan_amount_12', obj2.getText());
              } else if (obj2.getName() == 'eligible_loan_amount_24') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('eligible_loan_amount_24', obj2.getText());
              } else if (obj2.getName() == 'eligible_loan_amount_36') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('eligible_loan_amount_36', obj2.getText());
              } else if (obj2.getName() == 'eligible_loan_amount_48') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('eligible_loan_amount_48', obj2.getText());
              } else if (obj2.getName() == 'eligible_loan_amount_60') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('eligible_loan_amount_60', obj2.getText());
              } else if (obj2.getName() == 'eligible_loan_amount_72') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('eligible_loan_amount_72', obj2.getText());
              } else if (obj2.getName() == 'eligible_loan_amount') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('eligible_loan_amount', obj2.getText());
              } else if (obj2.getName() == 'max_emi_can_be_offered') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_emi_can_be_offered', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_multiplier') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mapOfMCPResult.put('max_loan_as_per_multiplier', obj2.getText());
              } else if (obj2.getName() == 'max_emi_as_per_FOIR') {
                mapOfMCPResult.put('max_emi_as_per_FOIR', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_FOIR') {
                mapOfMCPResult.put('max_loan_as_per_FOIR', obj2.getText());
              } else if (obj2.getName() == 'adjustedRentalIncome') {
                mapOfMCPResult.put('adjustedRentalIncome', obj2.getText());
              } else if (obj2.getName() == 'plusOfferAmount') {
                mapOfMCPResult.put('plusOfferAmount', obj2.getText());
              } else if (obj2.getName() == 'plusEmi') {
                mapOfMCPResult.put('plusEmi', obj2.getText());
              } else if (obj2.getName() == 'eligibleLoanAmountMinofMultiplierAndFOIR') {
                System.debug('&&&&&&&' + obj2.getText());
                mapOfMCPResult.put('eligibleLoanAmountMinofMultiplierAndFOIR', obj2.getText());
              } else if (obj2.getName() == 'multiplier') {
                System.debug('&&&&&&&' + obj2.getText());
                mapOfMCPResult.put('multiplier', obj2.getText());
              } else if (obj2.getName() == 'finalOfferAmount') {
                mapOfMCPResult.put('finalOfferAmount', obj2.getText());
              } else if (obj2.getName() == 'minimumPrice') {
                mapOfMCPResult.put('minimumPrice', obj2.getText());
              } else if (obj2.getName() == 'amount') {
                mapOfMCPResult.put('amount', obj2.getText());
              } else if (obj2.getName() == 'smeScore') {
                mapOfMCPResult.put('smeScore', obj2.getText());
              } else if (obj2.getName() == 'customerCategory') {
                mapOfMCPResult.put('customerCategory', obj2.getText());
              } else if (obj2.getName() == 'eligibleLoanAmountHL') {
                mapOfMCPResult.put('eligibleLoanAmountHL', obj2.getText());
              } else if (obj2.getName() == 'eligibleLoanAmountLAP') {
                mapOfMCPResult.put('eligibleLoanAmountLAP', obj2.getText());
              } else if (obj2.getName() == 'eligibleLoanAmountAL') {
                mapOfMCPResult.put('eligibleLoanAmountAL', obj2.getText());
              } else if (obj2.getName() == 'eligibleLoanAmountODCC') {
                mapOfMCPResult.put('eligibleLoanAmountODCC', obj2.getText());
              } else if (obj2.getName() == 'eligibleLoanAmountCACCOUNT') {
                mapOfMCPResult.put('eligibleLoanAmountCACCOUNT', obj2.getText());
              } else if (obj2.getName() == 'eligibleLoanAmountCRISIL') {
                mapOfMCPResult.put('eligibleLoanAmountCRISIL', obj2.getText());
              } else if (obj2.getName() == 'eligible_loan_amount_line') {
                System.debug('**eligible_loan_amount_line***' + obj2.getText());
                mapOfMCPResult.put('eligible_loan_amount_line', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_multiplier_line') {
                mapOfMCPResult.put('max_loan_as_per_multiplier_line', obj2.getText());
              } else if (obj2.getName() == 'max_loan_as_per_FOIR_line') {
                mapOfMCPResult.put('max_loan_as_per_FOIR_line', obj2.getText());
              } //code added by akshata start
              else if (obj2.getName() == 'maxLoanAsPerCibil') {
                mapOfMCPResult.put('maxLoanAsPerCibil', obj2.getText());
              } //code added by akshata end
              else if (obj2.getName() == 'pureFlexi' && flag == true) {
                /*Added for ad-hoc DSS enhancement bug - 6017*/
                System.debug('BRECallout pureFlexi ==> ' + obj2.getText());
                mapOfMCPResult.put('pureFlexi', obj2.getText());
                flag = false;
              } else if (obj2.getName() == 'pureFlexi' && flag == false) {
                /*Added for ad-hoc DSS enhancement bug - 6017*/
                System.debug('BRECallout pureFlexi 1 ==> ' + obj2.getText());
                mapOfMCPResult.put('pureFlexi1', obj2.getText());
              }
              /*BRD : Bug :6217 -PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED  
    Purpose : Added eligible_loan_amount_age_band related tags*/
              else if (obj2.getName() == 'eligible_loan_amount_age_band12')
                mapOfMCPResult.put('eligible_loan_amount_age_band12', obj2.getText());
              else if (obj2.getName() == 'eligible_loan_amount_age_band24')
                mapOfMCPResult.put('eligible_loan_amount_age_band24', obj2.getText());
              else if (obj2.getName() == 'eligible_loan_amount_age_band36')
                mapOfMCPResult.put('eligible_loan_amount_age_band36', obj2.getText());
              else if (obj2.getName() == 'eligible_loan_amount_age_band48')
                mapOfMCPResult.put('eligible_loan_amount_age_band48', obj2.getText());
              else if (obj2.getName() == 'eligible_loan_amount_age_band60')
                mapOfMCPResult.put('eligible_loan_amount_age_band60', obj2.getText());
              else if (obj2.getName() == 'EMIForPLOC') {
                mapOfMCPResult.put('EMIForPLOC', obj2.getText());
              } else if (obj2.getName() == 'EligibleForPLOC') {
                mapOfMCPResult.put('EligibleForPLOC', obj2.getText());
              } //PLOC 
              else if (obj2.getName() == 'pdFlag') { //bug 8314:PD 4 TAT
                mapOfMCPResult.put('pdFlag', obj2.getText());
              } //end
              //Rate Approval start
              else if (obj2.getName() == 'rate_processed_normal') {
                mapOfMCPResult.put('rate_processed_normal', obj2.getText());
              } else if (obj2.getName() == 'rate_processed_flexi') {
                mapOfMCPResult.put('rate_processed_flexi', obj2.getText());
              } else if (obj2.getName() == 'rate_processed_loc') {
                mapOfMCPResult.put('rate_processed_loc', obj2.getText());
              }
              //Rate Approval end
              /* OTP V3 CR - added by krish start*/
              else if (obj2.getName() == 'codifiedCibil') {
                mapOfMCPResult.put('codifiedCibil', obj2.getText());
              } else if (obj2.getName() == 'codified_cibil_policy') {
                mapOfMCPResult.put('codified_cibil_policy', obj2.getText());
              }
              //mapOfMCPResult.put('codified_cibil_policy', 'FAIL#reason1');
              /* OTP V3 CR - added by krish end*/

            }
          }
        }
      }

      //For deviations
      if (obj.getName() == 'deviationsList') {
        System.debug('*******deviationsList******objobj.getName: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'element') {
            String DevName = '';
            for (Dom.XMLNode obj2: obj1.getChildElements()) {

              if (obj2.getName() == 'deviation') {
                System.debug('***in deviation*obj1.getText(): ' + obj2.getText());
                DeviationCode = DeviationCode + ',' + obj2.getText();
                System.debug('****DeviationCode: ' + DeviationCode);
                DevName = obj2.getText();
              }

              if (obj2.getName() == 'approver') {
                System.debug('***in approver*obj1.getText(): ' + obj2.getText());
                //approver = approver+','+obj2.getText();
                approver = obj2.getText();
                System.debug('****approver: ' + approver);
              }

            }
            mapOfMCPResult.put(DevName, approver);
            System.debug('***in approvermapOfMCPResult: ' + mapOfMCPResult);
          }
        }

      }


      //For documents
      if (obj.getName() == 'documentList') {
        System.debug('*******documentList*****: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {

          if (obj1.getName() == 'element') {
            String DocName = '';
            for (Dom.XMLNode obj2: obj1.getChildElements()) {


              System.debug('****obj2.getName(): ' + obj2.getName());
              if (obj2.getName() == 'document_code') {
                System.debug('***in deviation*obj1.getText(): ' + obj2.getText());
                DocumentCode = DocumentCode + ',' + obj2.getText();
                System.debug('****DocumentCode: ' + DocumentCode);
                DocName = obj2.getText();
              }

              if (obj2.getName() == 'document_status') {
                System.debug('****DocumentCode: ' + obj2.getText());
                DocumentStatus = DocumentStatus + ',' + obj2.getText();
                mandatoryName = obj2.getText();
              }
              System.debug('****DocName : ' + DocName + 'mandatoryName::' + mandatoryName);


            }
            mapOfMCPResult.put(DocName, mandatoryName);
            System.debug('***mapOfMCPResult: ' + mapOfMCPResult);
          }
        }

      }

      //For verifications

      if (obj.getName() == 'verificationList') {
        System.debug('*******documentList*****: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'element') {
            for (Dom.XMLNode obj2: obj1.getChildElements()) {
              if (obj2.getName() == 'verification_code') {
                System.debug('***in deviation*obj1.getText(): ' + obj2.getText());
                VerificationCode = VerificationCode + ',' + obj2.getText();
                System.debug('****DocumentCode: ' + DocumentCode);
              }

              if (obj2.getName() == 'verification_status') {
                VerificationStatus = VerificationStatus + ',' + obj2.getText();

              }
            }
          }
        }

      }
      //For telepd ,TelepdCode,TelepdStatus 

      if (obj.getName() == 'uwTreatmentList') {
        System.debug('*******uwTreatmentList*****: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'element') {
            for (Dom.XMLNode obj2: obj1.getChildElements()) {
              if (obj2.getName() == 'uwTreatmentCode') {
                System.debug('***in deviation*obj1.getText(): ' + obj2.getText());
                TelepdCode = TelepdCode + ',' + obj2.getText();
                System.debug('****TelepdCode: ' + TelepdCode);
              }

              if (obj2.getName() == 'uwTreatmentStatus') {
                TelepdStatus = TelepdStatus + ',' + obj2.getText();

              }
            }
          }
        }

      }


      //New segmnetation grid
      if (obj.getName() == 'output') {
        System.debug('*************objobj.getName: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'customerSegment') {
            System.debug('****mcp customerSegment result: ' + obj1.getText());
            mcpResult = obj1.getText();
            mapOfMCPResult.put('CustomerSegment', mcpResult);
            mapOfMCPResult.put('CustomerSegment1', mcpResult);
          }
          if (obj1.getName() == 'customerSubSegment') {
            System.debug('****mcp customerSegment result: ' + obj1.getText());
            mcpResult = obj1.getText();
            mapOfMCPResult.put('CustomerSubSegment', mcpResult);
          }
          //bureauSegment
          if (obj1.getName() == 'bureauSegment') {
            System.debug('****mcp bureauSegment result: ' + obj1.getText());
            mcpResult = obj1.getText();
            mapOfMCPResult.put('bureauSegment', mcpResult);
          }
          if (obj1.getName() == 'final_seg') {
            System.debug('****mcp customerSegment result: ' + obj1.getText());
            mcpResult = obj1.getText();
            if (mcpResult != '' || mcpResult != null) mapOfMCPResult.put('CustomerSegment1', mcpResult);
          }
          //SAL policy Change start
          if (obj1.getName() == 'declineRiskSegment') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('declineRiskSegment', obj1.getText());
            }
          }
          if (obj1.getName() == 'deviationRiskSegment') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('deviationRiskSegment', obj1.getText());
            }
          }
          //EReferral API Integration
          if (obj1.getName() == 'riskSegmentSal') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('riskSegmentSal', obj1.getText());
            }
          }
          //SAL policy Change End
          /*OTP V3 CR - added by Krish start */
          if (obj1.getName() == 'riskSegmentClassification') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('riskSegmentClassification', obj1.getText());
            }
          }
          if (obj1.getName() == 'revisedCustomerSegment') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('revisedCustomerSegment', obj1.getText());
            }
          }
          if (obj1.getName() == 'appScore') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('appScore', obj1.getText());
            }
          }
          if (obj1.getName() == 'riskCodesPerLocation') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('riskCodesPerLocation', obj1.getText());
            }
          }
          if (obj1.getName() == 'locationBasedEWSCategory') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('locationBasedEWSCategory', obj1.getText());
            }
          }
          if (obj1.getName() == 'ews_rule_policy') {
            if (obj1.getText() != '' || obj1.getText() != null) {
              mapOfMCPResult.put('ews_rule_policy', obj1.getText());
            } else {
              mapOfMCPResult.put('ews_rule_policy', '');
            }
          }
          //mapOfMCPResult.put('ews_rule_policy', 'FAIL#reason1;reason2');
          //mapOfMCPResult.put('codified_cibil_policy', 'FAIL#reason1');
          /*OTP V3 CR - added by Krish end */
          if (obj1.getName() == 'categories') {
            for (Dom.XMLNode obj2: obj1.getChildElements()) {
              if (obj2.getName() == 'prudence') {
                mapOfMCPResult.put('prudence', obj2.getText());
              } else if (obj2.getName() == 'stability') {
                mapOfMCPResult.put('stability', obj2.getText());
              } else if (obj2.getName() == 'achievement') {
                mapOfMCPResult.put('achievement', obj2.getText());
              } else if (obj2.getName() == 'salaryToAge') {
                mapOfMCPResult.put('salaryToAge', obj2.getText());
              } else if (obj2.getName() == 'education') {
                mapOfMCPResult.put('education', obj2.getText());
              } else if (obj2.getName() == 'age') {
                mapOfMCPResult.put('age', obj2.getText());
              } else if (obj2.getName() == 'companyCategory') {
                mapOfMCPResult.put('companyCategory', obj2.getText());
              } else if (obj2.getName() == 'loanAmount') {
                mapOfMCPResult.put('loanAmount', obj2.getText());
              } else if (obj2.getName() == 'unsecuredFOIR') {
                mapOfMCPResult.put('unsecuredFOIR', obj2.getText());
              } else if (obj2.getName() == 'totalFOIR') {
                mapOfMCPResult.put('totalFOIR', obj2.getText());
              } else if (obj2.getName() == 'residenceStability') {
                mapOfMCPResult.put('residenceStability', obj2.getText());
              } else if (obj2.getName() == 'currentExperiance') {
                mapOfMCPResult.put('currentExperiance', obj2.getText());
              } else if (obj2.getName() == 'totalExperiance') {
                mapOfMCPResult.put('totalExperiance', obj2.getText());
              } else if (obj2.getName() == 'benchTotalFOIR') {
                mapOfMCPResult.put('benchTotalFOIR', obj2.getText());
              } else if (obj2.getName() == 'actualLoanAmountToEligibleAmount') {
                mapOfMCPResult.put('actualLoanAmountToEligibleAmount', obj2.getText());
              } else if (obj2.getName() == 'benchSalaryToAge') {
                mapOfMCPResult.put('benchSalaryToAge', obj2.getText());
              }
            }
          }
        }

      }
    }
    if (DeviationCode != null) mapOfMCPResult.put('BRECodes', DeviationCode);
    if (DocumentCode != null) mapOfMCPResult.put('BREDocumentCodes', DocumentCode);
    if (DocumentStatus != null) mapOfMCPResult.put('BREDocumentStatus', DocumentStatus);

    //verification
    if (VerificationCode != null) mapOfMCPResult.put('BREVerificationCodes', VerificationCode);
    if (VerificationStatus != null) mapOfMCPResult.put('BREVerificationStatus', VerificationStatus);

    //TelepdCode  TelepdStatus       
    if (TelepdCode != null) mapOfMCPResult.put('BRETelePDCodes', TelepdCode);
    if (TelepdStatus != null) mapOfMCPResult.put('BRETelePDStatus', TelepdStatus);
    mapOfMCPResult.put('MCPList', mcpResultdesc);
    System.debug('****mcpResultdes final : ' + mcpResultdesc);
    System.debug('****mapOfMCPResult  : ' + mapOfMCPResult);
    return mapOfMCPResult;
  }


  //forRelationshipManagement MCps
  public Map < String, String > parseResponseRM(DOM.XMLNode root) {
    String mcpResultdesc = '';
    String finalResult;
    Map < String, String > mapOfMCPResult = new Map < String, String > ();
    System.debug('************root ' + root.getChildElements());
    for (Dom.XMLNode obj: root.getChildElements()) {
      System.debug('*************obj: ' + obj);
      System.debug('*************objobj.getName: ' + obj.getName());
      if (obj.getName() == 'mcp_list') {
        System.debug('*************objobj.getName: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'element') {
            for (Dom.XMLNode obj2: obj1.getChildElements()) {
              if (obj2.getName() == 'mcpDesc') {
                System.debug('****obj1.getText(): ' + obj2.getText());
                mcpResultdesc = mcpResultdesc + ';' + obj2.getText();
                System.debug('****mcpResultdesc123: ' + mcpResultdesc);
              }
            }
          }
        }
      }
      if (obj.getName() == 'mcp_policy') {
        finalResult = obj.getText();
        System.debug('obj.getText(); -> ' + obj.getText());
      }
      mapOfMCPResult.put('MCPList', mcpResultdesc);
      mapOfMCPResult.put('FinalResult', finalResult);

      System.debug('mapOfMCPResult.get(FinalResult)' + mapOfMCPResult.get('FinalResult'));
    }
    return mapOfMCPResult;
  }

  //For eligibility
  Map < String, Integer > mapOfcam = new Map < String, Integer > ();
  Integer HLcount = 0, bajajObligations = 0;

  public MAP < String, String > callBREeligibility(Map < String, String > valuesMap) {
    //New code
    /*if (valuesMap.get('requested_loan_amount') == null) valuesMap.put('requested_loan_amount', '');
if (valuesMap.get('branch_name') == null) valuesMap.put('branch_name', '');
if (valuesMap.get('branch_type') == null) valuesMap.put('branch_type', '');
if (valuesMap.get('rental_Income') == null) valuesMap.put('rental_Income', '');
if (valuesMap.get('reimbursement') == null) valuesMap.put('reimbursement', '');
if (valuesMap.get('avgIncentive') == null) valuesMap.put('avgIncentive', '');
if (valuesMap.get('applicant_net_salary_m1') == null) valuesMap.put('applicant_net_salary_m1', '');
if (valuesMap.get('applicant_net_salary_m2') == null) valuesMap.put('applicant_net_salary_m2', '');
if (valuesMap.get('applicant_net_salary_m3') == null) valuesMap.put('applicant_net_salary_m3', '');
if (valuesMap.get('co_applicant_net_salary_m1') == null) valuesMap.put('co_applicant_net_salary_m1', '');
if (valuesMap.get('co_applicant_net_salary_m2') == null) valuesMap.put('co_applicant_net_salary_m2', '');
if (valuesMap.get('co_applicant_net_salary_m3') == null) valuesMap.put('co_applicant_net_salary_m3', '');

if (valuesMap.get('applicant_type') == null) valuesMap.put('applicant_type', '');
if (valuesMap.get('requested_tenor') == null) valuesMap.put('requested_tenor', '');
if (valuesMap.get('reqested_roi') == null) valuesMap.put('reqested_roi', '');
if (valuesMap.get('monthly_loan_obligations') == null) valuesMap.put('monthly_loan_obligations', '');
if (valuesMap.get('product') == null) valuesMap.put('product', '');
if (valuesMap.get('number_of_hl_loans') == null) valuesMap.put('number_of_hl_loans', '');
if (valuesMap.get('bajaj_loan_obligations') == null) valuesMap.put('bajaj_loan_obligations', '');
if (valuesMap.get('customer_segment') == null) valuesMap.put('customer_segment', '');
if (valuesMap.get('date_of_birth') == null) valuesMap.put('date_of_birth', '');
if (valuesMap.get('residence_type') == null) valuesMap.put('residence_type', '');
if (valuesMap.get('company_type') == null) valuesMap.put('company_type', '');
if (valuesMap.get('CIBIL_Score') == null) valuesMap.put('CIBIL_Score', '');
if (valuesMap.get('offer_amount') == null) valuesMap.put('offer_amount', '');
//New code
if (valuesMap.get('cy_sales_turnover') == null) valuesMap.put('cy_sales_turnover', '');
if (valuesMap.get('cy_depriciation') == null) valuesMap.put('cy_depriciation', '');
if (valuesMap.get('cy_net_profit') == null) valuesMap.put('cy_net_profit', '');
if (valuesMap.get('nature_of_business') == null) valuesMap.put('nature_of_business', '');
if (valuesMap.get('date_of_birth') == null) valuesMap.put('date_of_birth', '');
if (valuesMap.get('type_of_degree') == null) valuesMap.put('type_of_degree', '');
if (valuesMap.get('specialisation') == null) valuesMap.put('specialisation', '');
if (valuesMap.get('CIBIL_Score') == null) valuesMap.put('CIBIL_Score', '');
if (valuesMap.get('cibilPos') == null) valuesMap.put('cibilPos', '');
if (valuesMap.get('gross_receipts') == null) valuesMap.put('gross_receipts', '');
if (valuesMap.get('years_in_business_job') == null) valuesMap.put('years_in_business_job', '');
if (valuesMap.get('branch_type') == null) valuesMap.put('branch_type', '');
if (valuesMap.get('loan_id') == null) valuesMap.put('loan_id', '1');
     */

    /*RSL BRE Rules added by shilpa start*/
    if (valuesMap.get('applicant_salary_date_m1') == null) valuesMap.put('applicant_salary_date_m1', '');
    if (valuesMap.get('applicant_salary_date_m2') == null) valuesMap.put('applicant_salary_date_m2', '');
    if (valuesMap.get('applicant_salary_date_m3') == null) valuesMap.put('applicant_salary_date_m3', '');
    if (valuesMap.get('sourcing_channel_type') == null) valuesMap.put('sourcing_channel_type', '');
    /*RSl BRE Rules added by shilpa end*/
    // Bug 15858 S - CS/CWA Program - Hemant Keni
    if (CommonUtility.isEmpty(valuesMap.get('monthly_loan_obligations')))
      valuesMap.put('monthly_loan_obligations', '0');

    // Bug 15858 E
    //Added for SOL Line Assignment DG - @Gaurav
    if (valuesMap.get('preapproved_amount') == null) valuesMap.put('preapproved_amount', '0');

    /*S BUG ID 17470*/

    transient set < string > setPROProdName = new set < string > ();
    if (!commonUtility.isEmpty(Label.PRO_ProductLine_Products))
      setPROProdName.addAll(Label.PRO_ProductLine_Products.split(';'));
    if (valuesMap.size() > 0 && valuesMap.containsKey('product') && valuesMap.get('product') != null) {
      isPROProductLineProduct = setPROProdName.contains(valuesMap.get('product').toUpperCase());
    }
    /*E BUG ID 17470*/


    //5777 DOE
    Boolean DOEFlag = false;
    System.debug(LoggingLevel.Info, 'valuesMap.size()=' + valuesMap.size() + '=valuesMap.get=' + valuesMap.get('product') + '=valuesMap.containsKey(doetype)=' + valuesMap.containsKey('doetype'));
    /* BUG ID 17470*/
    if (valuesMap.size() > 0 && valuesMap.containsKey('product') && isPROProductLineProduct && valuesMap.containsKey('doetype')) {
      DOEFlag = true;
    }
    System.debug('DOEFlag=' + DOEFlag);
    System.debug('py_sales_turnover---->' + valuesMap.get('py_sales_turnover'));
    Mid_office_BRE_flow__c BRE_Eligibility = Mid_office_BRE_flow__c.getValues('BRE Eligibility');
    if (BRE_Eligibility != null) {
      // username = BRE_Flow.Username__c;
      //password = BRE_Flow.Password__c;
      endpointURL = '';
      endpointURL = BRE_Eligibility.EndpointURL__c;
    }
    /*String body = '<input><Generic><loan_id>1</loan_id><branch_type>' + valuesMap.get('branch_type') + '</branch_type><branch_name>' + valuesMap.get('branch_name') + '</branch_name></Generic><CAMS><element><loan_id>1</loan_id>';
body = body + '<rental_Income>' + valuesMap.get('rental_Income') + '</rental_Income><reimbursement>' + valuesMap.get('reimbursement') + '</reimbursement><avgIncentive>' + valuesMap.get('avgIncentive') + '</avgIncentive><applicant_net_salary_m1>' + valuesMap.get('applicant_net_salary_m1') + '</applicant_net_salary_m1><applicant_net_salary_m2>' + valuesMap.get('applicant_net_salary_m2') + '</applicant_net_salary_m2><applicant_net_salary_m3>' + valuesMap.get('applicant_net_salary_m3') + '</applicant_net_salary_m3><co_applicant_net_salary_m1>' + valuesMap.get('co_applicant_net_salary_m1') + '</co_applicant_net_salary_m1><co_applicant_net_salary_m2>' + valuesMap.get('co_applicant_net_salary_m2') + '</co_applicant_net_salary_m2><co_applicant_net_salary_m3>' + valuesMap.get('co_applicant_net_salary_m3') + '</co_applicant_net_salary_m3><incomeFromBusinessandProfession>' + valuesMap.get('incomeFromBusinessandProfession') + '</incomeFromBusinessandProfession><receiptMonth1>' + valuesMap.get('receiptMonth1') + '</receiptMonth1><receiptMonth2>' + valuesMap.get('receiptMonth2') + '</receiptMonth2><receiptMonth3>' + valuesMap.get('receiptMonth3') + '</receiptMonth3><totalExposure>' + valuesMap.get('totalExposure') + '</totalExposure><unsecuredExposure>' + valuesMap.get('unsecuredExposure') + '</unsecuredExposure></element></CAMS><Verification><element>';
body = body + '<applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type></element></Verification><Bank_summary><element><loan_id>1</loan_id><applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type></element></Bank_summary><Loan_Parameter><loan_id>' + valuesMap.get('loan_id') + '</loan_id><requested_loan_amount>' + valuesMap.get('requested_loan_amount') + '</requested_loan_amount><requested_tenor>' + valuesMap.get('requested_tenor') + '</requested_tenor><reqested_roi>' + valuesMap.get('reqested_roi') + '</reqested_roi><product>' + valuesMap.get('product') + '</product><offer_amount>' + valuesMap.get('offer_amount') + '</offer_amount><program_type>' + valuesMap.get('program_type') + '</program_type><processType>' + valuesMap.get('processType') + '</processType></Loan_Parameter><Existing_Loan><element><mortgageLoanAmount>' + valuesMap.get('mortgageLoanAmount') + '</mortgageLoanAmount><loan_id>1</loan_id><applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type><monthly_loan_obligations>' + valuesMap.get('monthly_loan_obligations') + '</monthly_loan_obligations><number_of_hl_loans>' + valuesMap.get('number_of_hl_loans') + '</number_of_hl_loans><bajaj_loan_obligations>' + valuesMap.get('bajaj_loan_obligations') + '</bajaj_loan_obligations><annual_obligations>'+valuesMap.get('annual_obligations')+'</annual_obligations></element></Existing_Loan><Demographic><element><professionType>' + valuesMap.get('professionType') + '</professionType><date_of_birth>' + valuesMap.get('date_of_birth') + '</date_of_birth><total_employment_vintage>'+valuesMap.get('total_employment_vintage')+'</total_employment_vintage><customer_segment>' + valuesMap.get('customer_segment') + '</customer_segment><loan_id>1</loan_id><years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job><residence_type>' + valuesMap.get('residence_type') + '</residence_type><applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type><company_type>' + valuesMap.get('company_type') + '</company_type><type_of_degree>' + valuesMap.get('type_of_degree') + '</type_of_degree><nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business><specialisation>' + valuesMap.get('specialisation') + '</specialisation><practiceType>' + valuesMap.get('practiceType') + '</practiceType>  <profession>' + valuesMap.get('profession') + '</profession><expPostGradSuperSpecialist>'+valuesMap.get('expPostGradSuperSpecialist')+'</expPostGradSuperSpecialist><age>'+valuesMap.get('age')+'</age><clinic_hospital_type>'+valuesMap.get('clinic_hospital_type')+'</clinic_hospital_type><customer_type>'+valuesMap.get('customer_type')+'</customer_type><constitutionType>'+valuesMap.get('constitutionType')+'</constitutionType></element></Demographic><Cibil_lst><element><securedUnsecuredLoanAmount>' + valuesMap.get('securedUnsecuredLoanAmount') + '</securedUnsecuredLoanAmount><loan_id>1</loan_id><applicant_Type>' + valuesMap.get('applicant_type') + '</applicant_Type>';
body = body + '<CIBIL_Score>' + valuesMap.get('CIBIL_Score') + '</CIBIL_Score><cibilPos>' + valuesMap.get('cibilPos') + '</cibilPos><securedMob>'+valuesMap.get('securedMob')+'</securedMob><unsecuredMob>'+valuesMap.get('unsecuredMob')+'</unsecuredMob><securedLoanAmount>'+valuesMap.get('securedLoanAmount')+'</securedLoanAmount><unSecuredLoanAmount>'+valuesMap.get('unSecuredLoanAmount')+'</unSecuredLoanAmount><mob>'+valuesMap.get('mob')+'</mob><autoLoanMob>'+valuesMap.get('autoLoanMob')+'</autoLoanMob><autoLoan>'+valuesMap.get('autoLoan')+'</autoLoan></element></Cibil_lst><profit_loss_statement><cy_total_networth>' + valuesMap.get('cy_total_networth') + '</cy_total_networth><cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover><cy_profit_after_tax>' + valuesMap.get('cy_profit_after_tax') + '</cy_profit_after_tax><cy_depriciation>' + valuesMap.get('cy_depriciation') + '</cy_depriciation><py_depriciation>' + valuesMap.get('py_depriciation') + '</py_depriciation><cy_net_profit>' + valuesMap.get('cy_net_profit') + '</cy_net_profit><py_net_profit>' + valuesMap.get('py_net_profit') + '</py_net_profit><cy_capital>'+valuesMap.get('cy_capital')+'</cy_capital><cy_reserve_surplus>'+valuesMap.get('cy_reserve_surplus')+'</cy_reserve_surplus><gross_receipts>' + valuesMap.get('gross_receipts') + '</gross_receipts><loan_id>1</loan_id></profit_loss_statement></input>';
     */
    //RSL Tier III Adding <customer_category>
    //Added preapproved_amount value for 5 tags of preapproved_amount - SOL Line Assignment DG - @Gaurav
    //SAL PLTB adding lta_medical_amount
    //OTP V3 CR added specialProfile,riskSegmentClassification,overdueamount,dpdinlast3months,dpsinlast6months in body -Krish
    String body = '<input><Generic><loan_id>1</loan_id><branch_type>' + valuesMap.get('branch_type') + '</branch_type><branch_name>' + valuesMap.get('branch_name') + '</branch_name></Generic><CAMS><element><loan_id>1</loan_id>';
    body = body + '<lta_medical_amount>' + valuesMap.get('lta_medical_amount') + '</lta_medical_amount><rental_Income>' + valuesMap.get('rental_Income') + '</rental_Income><reimbursement>' + valuesMap.get('reimbursement') + '</reimbursement><avgIncentive>' + valuesMap.get('avgIncentive') + '</avgIncentive><applicant_net_salary_m1>' + valuesMap.get('applicant_net_salary_m1') + '</applicant_net_salary_m1><applicant_net_salary_m2>' + valuesMap.get('applicant_net_salary_m2') + '</applicant_net_salary_m2><applicant_net_salary_m3>' + valuesMap.get('applicant_net_salary_m3') + '</applicant_net_salary_m3><co_applicant_net_salary_m1>' + valuesMap.get('co_applicant_net_salary_m1') + '</co_applicant_net_salary_m1><co_applicant_net_salary_m2>' + valuesMap.get('co_applicant_net_salary_m2') + '</co_applicant_net_salary_m2><co_applicant_net_salary_m3>' + valuesMap.get('co_applicant_net_salary_m3') + '</co_applicant_net_salary_m3><incomeFromBusinessandProfession>' + valuesMap.get('incomeFromBusinessandProfession') + '</incomeFromBusinessandProfession><receiptMonth1>' + valuesMap.get('receiptMonth1') + '</receiptMonth1><receiptMonth2>' + valuesMap.get('receiptMonth2') + '</receiptMonth2><receiptMonth3>' + valuesMap.get('receiptMonth3') + '</receiptMonth3><totalExposure>' + valuesMap.get('totalExposure') + '</totalExposure><unsecuredExposure>' + valuesMap.get('unsecuredExposure') + '</unsecuredExposure>';
    /*RSL BRE Rules added by shilpa start*/
    if (valuesMap.containsKey('product') && valuesMap.get('product') == 'RSL') {
      body = body + '<applicant_salary_date_m1>' + valuesMap.get('applicant_salary_date_m1') + '</applicant_salary_date_m1><applicant_salary_date_m2>' + valuesMap.get('applicant_salary_date_m2') + '</applicant_salary_date_m2><applicant_salary_date_m3>' + valuesMap.get('applicant_salary_date_m3') + '</applicant_salary_date_m3>';
    }
    /*RSL BRE Rules added by shilpa end*/
    body = body + '</element></CAMS><Verification><element>';
    // bug 14509:-Bug 15806 - Hemant Keni - Added New Parameter process_Type
    body = body + '<applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type></element></Verification><Bank_summary><element><loan_id>1</loan_id><applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type></element></Bank_summary><Loan_Parameter><loan_id>' + valuesMap.get('loan_id') + '</loan_id><requested_loan_amount>' + valuesMap.get('requested_loan_amount') + '</requested_loan_amount><requested_tenor>' + valuesMap.get('requested_tenor') + '</requested_tenor><reqested_roi>' + valuesMap.get('reqested_roi') + '</reqested_roi><product>' + valuesMap.get('product') + '</product><offer_amount>' + valuesMap.get('offer_amount') + '</offer_amount><program_type>' + valuesMap.get('program_type') + '</program_type><process_Type>' + valuesMap.get('process_Type') + '</process_Type><processType>' + valuesMap.get('processType') + '</processType><stage>' + valuesMap.get('stage') + '</stage><preApprovedOffer12M>' + valuesMap.get('preapproved_amount') + '</preApprovedOffer12M><preApprovedOffer24M>' + valuesMap.get('preapproved_amount') + '</preApprovedOffer24M><preApprovedOffer36M>' + valuesMap.get('preapproved_amount') + '</preApprovedOffer36M><preApprovedOffer48M>' + valuesMap.get('preapproved_amount') + '</preApprovedOffer48M><preApprovedOffer60M>' + valuesMap.get('preapproved_amount') + '</preApprovedOffer60M><preApprovedOffer72M>' + valuesMap.get('preapproved_amount') + '</preApprovedOffer72M>';
    /*
Code added by Rakesh Shinde
BRD : Bug :6217 -PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED  
Purpose : Added tag approved_loan_amount to body                
     */
    if (valuesMap.containskey('approved_loan_amount'))
      body = body + '<approved_loan_amount>' + valuesMap.get('approved_loan_amount') + '</approved_loan_amount>';
    //5777 DOE
    if (DOEFlag == true)
      body = body + '<doetype>' + valuesMap.get('doetype') + '</doetype>';

    // Added <mortgageLoan> for Pureflexi ad-hoc DSS enhancement bug - 6017
    /* body = body + '</Loan_Parameter><Existing_Loan><element><mortgageLoan>' + valuesMap.get('mortgageLoan') + '</mortgageLoan><mortgageLoanAmount>' + valuesMap.get('mortgageLoanAmount') + '</mortgageLoanAmount><loan_id>1</loan_id><applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type><monthly_loan_obligations>' + valuesMap.get('monthly_loan_obligations') + '</monthly_loan_obligations><number_of_hl_loans>' + valuesMap.get('number_of_hl_loans') + '</number_of_hl_loans><bajaj_loan_obligations>' + valuesMap.get('bajaj_loan_obligations') + '</bajaj_loan_obligations><annual_obligations>' + valuesMap.get('annual_obligations') + '</annual_obligations></element></Existing_Loan><Demographic><element><professionType>' + valuesMap.get('professionType') + '</professionType><date_of_birth>' + valuesMap.get('date_of_birth') + '</date_of_birth><total_employment_vintage>' + valuesMap.get('total_employment_vintage') + '</total_employment_vintage><customer_segment>' + valuesMap.get('customer_segment') + '</customer_segment><loan_id>1</loan_id><years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job><residence_type>' + valuesMap.get('residence_type') + '</residence_type><applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type><company_type>' + valuesMap.get('company_type') + '</company_type><degreeType>' + valuesMap.get('degreeType') + '</degreeType><type_of_degree>' + valuesMap.get('type_of_degree') + '</type_of_degree><nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business><specialisation>' + valuesMap.get('specialisation') + '</specialisation><practiceType>' + valuesMap.get('practiceType') + '</practiceType><profession>' + valuesMap.get('profession') + '</profession><expPostGradSuperSpecialist>' + valuesMap.get('expPostGradSuperSpecialist') + '</expPostGradSuperSpecialist><age>' + valuesMap.get('age') + '</age><clinic_hospital_type>' + valuesMap.get('clinic_hospital_type') + '</clinic_hospital_type><customer_type>' + valuesMap.get('customer_type') + '</customer_type><constitutionType>' + valuesMap.get('constitutionType') + '</constitutionType><first_name>' + valuesMap.get('first_name') + '</first_name><last_name>' + valuesMap.get('last_name') + '</last_name></element></Demographic><Cibil_lst><element><securedUnsecuredLoanAmount>' + valuesMap.get('securedUnsecuredLoanAmount') + '</securedUnsecuredLoanAmount><loan_id>1</loan_id><applicant_Type>' + valuesMap.get('applicant_type') + '</applicant_Type>';
body = body + '<CIBIL_Score>' + valuesMap.get('CIBIL_Score') + '</CIBIL_Score><cibilPos>' + valuesMap.get('cibilPos') + '</cibilPos><securedMob>' + valuesMap.get('securedMob') + '</securedMob><unsecuredMob>' + valuesMap.get('unsecuredMob') + '</unsecuredMob><securedLoanAmount>' + valuesMap.get('securedLoanAmount') + '</securedLoanAmount><unSecuredLoanAmount>' + valuesMap.get('unSecuredLoanAmount') + '</unSecuredLoanAmount><mob>' + valuesMap.get('mob') + '</mob><autoLoanMob>' + valuesMap.get('autoLoanMob') + '</autoLoanMob><autoLoan>' + valuesMap.get('autoLoan') + '</autoLoan></element></Cibil_lst><profit_loss_statement><cy_total_networth>' + valuesMap.get('cy_total_networth') + '</cy_total_networth><cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover><cy_profit_after_tax>' + valuesMap.get('cy_profit_after_tax') + '</cy_profit_after_tax><cy_depriciation>' + valuesMap.get('cy_depriciation') + '</cy_depriciation><py_depriciation>' + valuesMap.get('py_depriciation') + '</py_depriciation><cy_net_profit>' + valuesMap.get('cy_net_profit') + '</cy_net_profit><py_net_profit>' + valuesMap.get('py_net_profit') + '</py_net_profit><cy_capital>' + valuesMap.get('cy_capital') + '</cy_capital><cy_reserve_surplus>' + valuesMap.get('cy_reserve_surplus') + '</cy_reserve_surplus><gross_receipts>' + valuesMap.get('gross_receipts') + '</gross_receipts><loan_id>1</loan_id></profit_loss_statement></input>';
/*Commented for PLOC added new 3 tags */

    /*RSL BRE Rules added by shilpa start*/
    if (valuesMap.containsKey('product') && valuesMap.get('product') == 'RSL') {
      System.debug('Product from valueMap=' + valuesMap.get('product'));
      body = body + '<sourcing_channel_type>' + valuesMap.get('sourcing_channel_type') + '</sourcing_channel_type>';
    }
    /*RSL BRE Rules added by shilpa end*/
    //code added by leena added post_qualification_exp tag and college details tag and maxCreditCardAmount tag
    //Bug Id:14509 , added securedLoan_20lacs and unsecuredLoan_5lacs
    body = body + '</Loan_Parameter><Existing_Loan><element><mortgageLoan>' + valuesMap.get('mortgageLoan') + '</mortgageLoan><mortgageLoanAmount>' + valuesMap.get('mortgageLoanAmount') + '</mortgageLoanAmount><loan_id>1</loan_id><applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type><monthly_loan_obligations>' + valuesMap.get('monthly_loan_obligations') + '</monthly_loan_obligations><number_of_hl_loans>' + valuesMap.get('number_of_hl_loans') + '</number_of_hl_loans><bajaj_loan_obligations>' + valuesMap.get('bajaj_loan_obligations') + '</bajaj_loan_obligations><annual_obligations>' + valuesMap.get('annual_obligations') + '</annual_obligations><securedLoan_20lacs>  ' + valuesMap.get('securedLoan_20lacs') + '</securedLoan_20lacs ><unsecuredLoan_5lacs >' + valuesMap.get('unsecuredLoan_5lacs') + '</unsecuredLoan_5lacs></element></Existing_Loan><Demographic><element><specialProfile>' + valuesMap.get('specialProfile') + '</specialProfile><riskSegmentClassification>' + valuesMap.get('riskSegmentClassification') + '</riskSegmentClassification><professionType>' + valuesMap.get('professionType') + '</professionType><post_qualification_exp>' + valuesMap.get('post_qualification_exp') + '</post_qualification_exp><date_of_birth>' + valuesMap.get('date_of_birth') + '</date_of_birth><total_employment_vintage>' + valuesMap.get('total_employment_vintage') + '</total_employment_vintage><customer_segment>' + valuesMap.get('customer_segment') + '</customer_segment><loan_id>1</loan_id><years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job><residence_type>' + valuesMap.get('residence_type') + '</residence_type><applicant_type>' + valuesMap.get('applicant_type') + '</applicant_type><company_type>' + valuesMap.get('company_type') + '</company_type><degreeType>' + valuesMap.get('degreeType') + '</degreeType><type_of_degree>' + valuesMap.get('type_of_degree') + '</type_of_degree><nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business><specialisation>' + valuesMap.get('specialisation') + '</specialisation><practiceType>' + valuesMap.get('practiceType') + '</practiceType><profession>' + valuesMap.get('profession') + '</profession><expPostGradSuperSpecialist>' + valuesMap.get('expPostGradSuperSpecialist') + '</expPostGradSuperSpecialist><age>' + valuesMap.get('age') + '</age><clinic_hospital_type>' + valuesMap.get('clinic_hospital_type') + '</clinic_hospital_type><customer_type>' + valuesMap.get('customer_type') + '</customer_type><constitutionType>' + valuesMap.get('constitutionType') + '</constitutionType><first_name>' + valuesMap.get('first_name') + '</first_name><last_name>' + valuesMap.get('last_name') + '</last_name><company_category>' + valuesMap.get('company_category') + '</company_category><customer_category>' + valuesMap.get('customer_category') + '</customer_category></element></Demographic><College_details><college_name>' + valuesMap.get('college_name') + '</college_name><college_city>' + valuesMap.get('college_city') + '</college_city><stream>' + valuesMap.get('stream') + '</stream></College_details><Cibil_lst><element><overdueAmtinLast24Month>' + valuesMap.get('overdueAmtinLast24Month') + '</overdueAmtinLast24Month><dpdinLast3Months>' + valuesMap.get('dpdinLast3Months') + '</dpdinLast3Months><dpdinLast6Months>' + valuesMap.get('dpdinLast6Months') + '</dpdinLast6Months><securedUnsecuredLoanAmount>' + valuesMap.get('securedUnsecuredLoanAmount') + '</securedUnsecuredLoanAmount><loan_id>1</loan_id><applicant_Type>' + valuesMap.get('applicant_type') + '</applicant_Type>';
    //total_Amount_overdue,total_FOIR,unsecuredFOIR',ever_HL_In_CIBIL for ploc
    body = body + '<CIBIL_Score>' + valuesMap.get('CIBIL_Score') + '</CIBIL_Score><cibilPos>' + valuesMap.get('cibilPos') + '</cibilPos><securedMob>' + valuesMap.get('securedMob') + '</securedMob><unsecuredMob>' + valuesMap.get('unsecuredMob') + '</unsecuredMob><securedLoanAmount>' + valuesMap.get('securedLoanAmount') + '</securedLoanAmount><credit_card_amount>' + valuesMap.get('maxCreditCardAmount') + '</credit_card_amount><unSecuredLoanAmount>' + valuesMap.get('unSecuredLoanAmount') + '</unSecuredLoanAmount><mob>' + valuesMap.get('mob') + '</mob><autoLoanMob>' + valuesMap.get('autoLoanMob') + '</autoLoanMob><autoLoan>' + valuesMap.get('autoLoan') + '</autoLoan><total_Amount_overdue>' + valuesMap.get('total_Amount_overdue') + '</total_Amount_overdue><total_FOIR>' + valuesMap.get('total_FOIR') + '</total_FOIR><unsecuredFOIR>' + valuesMap.get('unsecuredFOIR') + '</unsecuredFOIR><ever_HL_In_CIBIL>' + valuesMap.get('ever_HL_In_CIBIL') + '</ever_HL_In_CIBIL></element></Cibil_lst><profit_loss_statement><cy_total_networth>' + valuesMap.get('cy_total_networth') + '</cy_total_networth><cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover><cy_profit_after_tax>' + valuesMap.get('cy_profit_after_tax') + '</cy_profit_after_tax><cy_depriciation>' + valuesMap.get('cy_depriciation') + '</cy_depriciation><py_depriciation>' + valuesMap.get('py_depriciation') + '</py_depriciation><cy_net_profit>' + valuesMap.get('cy_net_profit') + '</cy_net_profit><py_net_profit>' + valuesMap.get('py_net_profit') + '</py_net_profit><cy_capital>' + valuesMap.get('cy_capital') + '</cy_capital><cy_reserve_surplus>' + valuesMap.get('cy_reserve_surplus') + '</cy_reserve_surplus><gross_receipts>' + valuesMap.get('gross_receipts') + '</gross_receipts><loan_id>1</loan_id></profit_loss_statement></input>';


    body = body.replaceAll('null', '');
    // 7515 change body = body.replaceAll('000-1', '0');
    body = body.replaceAll('<CIBIL_Score>000-1</CIBIL_Score>', '<CIBIL_Score>0</CIBIL_Score>');
    System.debug('*********body: ' + body);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Loan_Eligibility/versions/0.0.1-SNAPSHOT/rules/Loan_Eligibility/loanEligibilityMain/executions');
    //http://138.91.38.234:8087//executionserver/rest/1/ruleServices/Loan_Eligibility/versions/0.0.1-SNAPSHOT/rules/Loan_Eligibility/loanEligibilityMain/executions
    req.setMethod('POST');
    req.setbody(body);
    System.debug('Body : ' + body);
    req.setTimeout(120000);
    System.debug('UserName--->' + username + ' ###  Password---->' + password);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('Eligibility', null);
      mapOfMCPResult = parseResponse1(root);
      System.debug('*************mapOfMCPResult : ' + mapOfMCPResult);
    }
    return mapOfMCPResult;
  }

  //Charges API Enhacement Start
  public MAP < String, String > callCharegesAPIService(Map < string, string > valuesMap) {
    System.debug('valuesMap======>' + valuesMap);
    Map < string, string > ChargesAPIResponse = new Map < string, string > ();
    System.debug('**0**');
    JSONGenerator gen = JSON.createGenerator(true);

    System.debug('**1**');
    gen.writeStartObject();
    gen.writeFieldName('ChargesRequest');
    System.debug('**2**');
    gen.writeStartObject();
    System.debug('**3**');
    gen.writeStringField('DealID', valuesMap.get('DealID'));
    System.debug('**4**');
    gen.writeStringField('LoanAmount', valuesMap.get('LoanAmount'));
    gen.writeStringField('DueDay', valuesMap.get('DueDay'));
    gen.writeStringField('Scheme', valuesMap.get('Scheme'));
    gen.writeStringField('RateOfInterest', valuesMap.get('RateOfInterest'));
    gen.writeStringField('Tenure', valuesMap.get('Tenure'));
    gen.writeEndObject();
    gen.writeEndObject();

    String jsonString = gen.getAsString();
    System.debug('jsonString=======>' + jsonString);
    HttpRequest req = new HttpRequest();
    Mid_office_BRE_flow__c chargesAPIEndpoint = Mid_office_BRE_flow__c.getValues('Charges API Integration');
    if (chargesAPIEndpoint != null) {
      endpointURL = '';
      endpointURL = chargesAPIEndpoint.EndpointURL__c;
    }
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    if (!Test.isRunningTest()) {
      Http http = new Http();
      HTTPResponse res = http.send(req);
      String result = res.getBody();
      System.debug('result======>' + result);
      ChargesRequest charges = ChargesRequest.parse(result);
      System.debug('charges======>' + charges);
      ChargesAPIResponse.put('result', charges.result);
    }
    return ChargesAPIResponse;
  }
  //Charges API Enhacement End

  public MAP < String, String > callBREeligibilityBL(Map < string, string > valuesMap) {
    System.debug('****valuesMap--  : ' + valuesMap);
    /*if (valuesMap.get('cy_sales_turnover') == null) valuesMap.put('cy_sales_turnover', '');
if (valuesMap.get('cy_depriciation') == null) valuesMap.put('cy_depriciation', '');
if (valuesMap.get('cy_net_profit') == null) valuesMap.put('cy_net_profit', '');
if (valuesMap.get('nature_of_business') == null) valuesMap.put('nature_of_business', '');
if (valuesMap.get('date_of_birth') == null) valuesMap.put('date_of_birth', '');
if (valuesMap.get('type_of_degree') == null) valuesMap.put('type_of_degree', '');
if (valuesMap.get('specialisation') == null) valuesMap.put('specialisation', '');
if (valuesMap.get('CIBIL_Score') == null) valuesMap.put('CIBIL_Score', '');
if (valuesMap.get('cibilPos') == null) valuesMap.put('cibilPos', '');
if (valuesMap.get('gross_receipts') == null) valuesMap.put('gross_receipts', '');
if (valuesMap.get('years_in_business_job') == null) valuesMap.put('years_in_business_job', '');

if (valuesMap.get('avg_od_cc_limit') == null) valuesMap.put('avg_od_cc_limit', '');
if (valuesMap.get('_10th_balance') == null) valuesMap.put('_10th_balance', '');
if (valuesMap.get('_20th_balance') == null) valuesMap.put('_20th_balance', '');
if (valuesMap.get('last_day_balance') == null) valuesMap.put('last_day_balance', '');

if (valuesMap.get('branch_type') == null) valuesMap.put('branch_type', '');
if (valuesMap.get('loan_id') == null) valuesMap.put('loan_id', '1');
     */
    System.debug('py_sales_turnover---->' + valuesMap.get('py_sales_turnover'));

    // System.debug('****valuesMap--  : ' + (valuesMap.get('cy_sales_turnover') <> null ? valuesMap.get('cy_sales_turnover') : 'test'));
    /* dev
String body = '<input xmlns="http://www.visual-rules.com/vrpath/Loan_Eligibility/loanEligibilityMain/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Generic><branch_type>' + valuesMap.get('branch_type') + '</branch_type><branch_name>' + valuesMap.get('branch_name') + '</branch_name>';
body = body + '</Generic><Bank_summary><element><applicant_type>Primary</applicant_type><avg_od_cc_limit>' + valuesMap.get('avg_od_cc_limit') + '</avg_od_cc_limit><_10th_balance>' + valuesMap.get('_10th_balance') + '</_10th_balance><_20th_balance>' + valuesMap.get('_20th_balance') + '</_20th_balance><last_day_balance>' + valuesMap.get('last_day_balance') + '</last_day_balance><avg_od_cc_utilisation>' + valuesMap.get('avg_od_cc_utilisation') +'</avg_od_cc_utilisation>';
body = body + '</element></Bank_summary><Loan_Parameter><product>' + valuesMap.get('product') + '</product><loan_id>' + valuesMap.get('loan_id') + '</loan_id></Loan_Parameter><existing_loan><element><loan_id>1</loan_id><applicant_id></applicant_id><applicant_type>Primary</applicant_type><monthly_loan_obligations>' + valuesMap.get('monthly_loan_obligations') + '</monthly_loan_obligations>';
body = body + '</element></existing_loan><Demographic><element><loan_id>1</loan_id><applicant_id></applicant_id><years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job><applicant_type>Primary</applicant_type><nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business>';
body = body + '</element></Demographic><Cibil_lst><element><loan_id>1</loan_id><applicant_id></applicant_id><applicant_Type>Primary</applicant_Type><CIBIL_Score>' + valuesMap.get('CIBIL_Score') + '</CIBIL_Score></element></Cibil_lst><profit_loss_statement><py_sales_turnover>' + valuesMap.get('py_sales_turnover') + '</py_sales_turnover>';
body = body + '<cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover><cy_depriciation>' + valuesMap.get('cy_depriciation') + '</cy_depriciation><py_debtors></py_debtors><cy_debtors>' + valuesMap.get('cy_debtors') + '</cy_debtors><py_creditors></py_creditors><cy_creditors>' + valuesMap.get('cy_creditors') + '</cy_creditors><cy_net_profit>' + valuesMap.get('cy_net_profit') + '</cy_net_profit>';
body = body + '<cy_Total_ouside_borrowings>' + valuesMap.get('cy_Total_ouside_borrowings') + '</cy_Total_ouside_borrowings><loan_id>1</loan_id><applicant_id></applicant_id><cy_balance_sheet>' + valuesMap.get('cy_balance_sheet') + '</cy_balance_sheet><cy_closing_stock>' + valuesMap.get('cy_closing_stock') + '</cy_closing_stock><cy_bank_cash_balance>' + valuesMap.get('cy_bank_cash_balance') + '</cy_bank_cash_balance>';
body = body + '<cy_capital>' + valuesMap.get('cy_capital') + '</cy_capital><cy_reserve_surplus>' + valuesMap.get('cy_reserve_surplus') + '</cy_reserve_surplus></profit_loss_statement></input>';
     */
    //System.debug('avg_od_cc_utilisation is' + valuesMap.get('avg_od_cc_utilisation'));
    String body = '';
    /** Sainath - 14508 start**/
    if (valuesMap.get('program_type') != null && valuesMap.get('program_type') == 'Banking Scorecard') {
      body = '<input xmlns="http://www.visual-rules.com/vrpath/Loan_Eligibility/loanEligibilityMain/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Generic><branch_type>' + valuesMap.get('branch_type') + '</branch_type><branch_name>' + valuesMap.get('branch_name') + '</branch_name>';
      body = body + '</Generic><Bank_summary><element><odccFlag>' + valuesMap.get('odccFlag') + '</odccFlag><applicant_type>Primary</applicant_type><avg_od_cc_limit>' + valuesMap.get('avg_od_cc_limit') + '</avg_od_cc_limit><_10th_balance>' + valuesMap.get('_10th_balance') + '</_10th_balance><_20th_balance>' + valuesMap.get('_20th_balance') + '</_20th_balance><last_day_balance>' + valuesMap.get('last_day_balance') + '</last_day_balance><avg_debit_amount>' + valuesMap.get('avg_debit_amount') + '</avg_debit_amount><avg_opening_balance>' + valuesMap.get('avg_opening_balance') + '</avg_opening_balance><annualizedBTO>' + valuesMap.get('annualizedBTO') + '</annualizedBTO><total_bounce_inward>' + valuesMap.get('total_bounce_inward') + '</total_bounce_inward><avg_bank_balance>' + valuesMap.get('avg_bank_balance') + '</avg_bank_balance><avg_od_cc_utilisation>' + valuesMap.get('avg_od_cc_utilisation') + '</avg_od_cc_utilisation>';

   body = body + '</element></Bank_summary><Loan_Parameter><product>' + valuesMap.get('product') + '</product><loan_id>' + valuesMap.get('loan_id') + '</loan_id><stage>' + valuesMap.get('stage') + '</stage><program_type>' + valuesMap.get('program_type') + '</program_type><sub_stage>' + valuesMap.get('sub_stage') + '</sub_stage><liveAL>' + valuesMap.get('liveAL') + '</liveAL>'+'<liveBL>' + valuesMap.get('liveBL') + '</liveBL>'+'<livePL>' + valuesMap.get('livePL') + '</livePL>'+'<liveHL>' + valuesMap.get('liveHL') + '</liveHL>'+'<liveLAP>' + valuesMap.get('liveLAP') + '</liveLAP></Loan_Parameter><existing_loan><element><loan_id>1</loan_id><applicant_id></applicant_id><applicant_type>Primary</applicant_type><monthly_loan_obligations>' + valuesMap.get('monthly_loan_obligations') + '</monthly_loan_obligations>';
      body = body + '</element></existing_loan><Demographic><element><loan_id>1</loan_id><applicant_id></applicant_id><years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job><applicant_type>Primary</applicant_type><nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business><constitution>' + valuesMap.get('constitution') + '</constitution><date_of_birth>' + valuesMap.get('date_of_birth') + '</date_of_birth><total_employment_vintage>' + valuesMap.get('total_employment_vintage') + '</total_employment_vintage><programType>' + valuesMap.get('program_type') + '</programType><first_name>' + valuesMap.get('first_name') + '</first_name><last_name>' + valuesMap.get('last_name') + '</last_name>';

      body = body + '</element></Demographic><Cibil_lst><element><loan_id>1</loan_id><applicant_id></applicant_id><applicant_Type>Primary</applicant_Type><CIBIL_Score>' + valuesMap.get('CIBIL_Score') + '</CIBIL_Score><max_dpd_12M>' + valuesMap.get('max_dpd_12M') + '</max_dpd_12M><no_of_enquiries_12M>' + valuesMap.get('no_of_enquiries_12M') + '</no_of_enquiries_12M><cibil_vintage>' + valuesMap.get('WoE_old_mob') + '</cibil_vintage></element></Cibil_lst><profit_loss_statement><py_sales_turnover>' + valuesMap.get('py_sales_turnover') + '</py_sales_turnover>';

      body = body + '<cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover><cy_depriciation>' + valuesMap.get('cy_depriciation') + '</cy_depriciation><py_debtors></py_debtors><cy_debtors>' + valuesMap.get('cy_debtors') + '</cy_debtors><py_creditors></py_creditors><cy_creditors>' + valuesMap.get('cy_creditors') + '</cy_creditors><cy_net_profit>' + valuesMap.get('cy_net_profit') + '</cy_net_profit>';
      body = body + '<cy_Total_ouside_borrowings>' + valuesMap.get('cy_Total_ouside_borrowings') + '</cy_Total_ouside_borrowings><loan_id>1</loan_id><applicant_id></applicant_id><cy_balance_sheet>' + valuesMap.get('cy_balance_sheet') + '</cy_balance_sheet><cy_closing_stock>' + valuesMap.get('cy_closing_stock') + '</cy_closing_stock><cy_bank_cash_balance>' + valuesMap.get('cy_bank_cash_balance') + '</cy_bank_cash_balance>';
      body = body + '<cy_capital>' + valuesMap.get('cy_capital') + '</cy_capital><cy_reserve_surplus>' + valuesMap.get('cy_reserve_surplus') + '</cy_reserve_surplus></profit_loss_statement>';

      body = body.replaceAll('<CIBIL_Score>000-1</CIBIL_Score>', '<CIBIL_Score>0</CIBIL_Score>');
    }
    /** Sainath - 14508 end**/
    else {
      body = '<input xmlns="http://www.visual-rules.com/vrpath/Loan_Eligibility/loanEligibilityMain/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Generic><branch_type>' + valuesMap.get('branch_type') + '</branch_type><branch_name>' + valuesMap.get('branch_name') + '</branch_name>';
      body = body + '</Generic><Bank_summary><element><odccFlag>' + valuesMap.get('odccFlag') + '</odccFlag><applicant_type>Primary</applicant_type><avg_od_cc_limit>' + valuesMap.get('avg_od_cc_limit') + '</avg_od_cc_limit><_10th_balance>' + valuesMap.get('_10th_balance') + '</_10th_balance><_20th_balance>' + valuesMap.get('_20th_balance') + '</_20th_balance><last_day_balance>' + valuesMap.get('last_day_balance') + '</last_day_balance><avg_od_cc_utilisation>' + valuesMap.get('avg_od_cc_utilisation') + '</avg_od_cc_utilisation>';
   body = body + '</element></Bank_summary><Loan_Parameter><product>' + valuesMap.get('product') + '</product><loan_id>' + valuesMap.get('loan_id') + '</loan_id><stage>' + valuesMap.get('stage') + '</stage><sub_stage>' + valuesMap.get('sub_stage') + '</sub_stage><liveAL>' + valuesMap.get('liveAL') + '</liveAL>'+'<liveBL>' + valuesMap.get('liveBL') + '</liveBL>'+'<livePL>' + valuesMap.get('livePL') + '</livePL>'+'<liveHL>' + valuesMap.get('liveHL') + '</liveHL>'+'<liveLAP>' + valuesMap.get('liveLAP') + '</liveLAP></Loan_Parameter><existing_loan><element><loan_id>1</loan_id><applicant_id></applicant_id><applicant_type>Primary</applicant_type><monthly_loan_obligations>' + valuesMap.get('monthly_loan_obligations') + '</monthly_loan_obligations>' ;
      body = body + '</element></existing_loan><Demographic><element><loan_id>1</loan_id><applicant_id></applicant_id><years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job><applicant_type>Primary</applicant_type><nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business><first_name>' + valuesMap.get('first_name') + '</first_name><last_name>' + valuesMap.get('last_name') + '</last_name>';
      body = body + '</element></Demographic><Cibil_lst><element><loan_id>1</loan_id><applicant_id></applicant_id><applicant_Type>Primary</applicant_Type><CIBIL_Score>' + valuesMap.get('CIBIL_Score') + '</CIBIL_Score></element></Cibil_lst><profit_loss_statement><py_sales_turnover>' + valuesMap.get('py_sales_turnover') + '</py_sales_turnover>';
      body = body + '<cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover><cy_depriciation>' + valuesMap.get('cy_depriciation') + '</cy_depriciation><py_debtors></py_debtors><cy_debtors>' + valuesMap.get('cy_debtors') + '</cy_debtors><py_creditors></py_creditors><cy_creditors>' + valuesMap.get('cy_creditors') + '</cy_creditors><cy_net_profit>' + valuesMap.get('cy_net_profit') + '</cy_net_profit>';
      body = body + '<cy_Total_ouside_borrowings>' + valuesMap.get('cy_Total_ouside_borrowings') + '</cy_Total_ouside_borrowings><loan_id>1</loan_id><applicant_id></applicant_id><cy_balance_sheet>' + valuesMap.get('cy_balance_sheet') + '</cy_balance_sheet><cy_closing_stock>' + valuesMap.get('cy_closing_stock') + '</cy_closing_stock><cy_bank_cash_balance>' + valuesMap.get('cy_bank_cash_balance') + '</cy_bank_cash_balance>';
      body = body + '<cy_capital>' + valuesMap.get('cy_capital') + '</cy_capital><cy_reserve_surplus>' + valuesMap.get('cy_reserve_surplus') + '</cy_reserve_surplus></profit_loss_statement>';
    }
    // Start of pureflexi changes bug - 6017
    /*BUG-16959 by Rajesh added Prod condition for DBOL*/
    if (valuesMap.get('product') != null && setPSBLProdName.contains(valuesMap.get('product'))) {
      if (Integer.valueOf(valuesMap.get('pureflexiListSize')) == 0) {
        body = body + '<securedLoanList><element><securedLoanAmount>0</securedLoanAmount>';
        body = body + '<mob>0</mob></element></securedLoanList>';
      } else {
        body = body + '<securedLoanList>';
        for (Integer i = 0; i < Integer.valueOf(valuesMap.get('pureflexiListSize')); i++) {
          body = body + '<element><securedLoanAmount>' + valuesMap.get('securedLoanAmount' + i) + '</securedLoanAmount>';
          body = body + '<mob>' + valuesMap.get('mob' + i) + '</mob></element>';
        }
        body = body + '</securedLoanList>';
      }
    }
    body = body + '</input>';
    // End of pureflexi changes bug - 6017

    body = body.replaceAll('null', '');

    username = Mid_office_BRE_flow__c.getValues('BRE Flow').Username__c;
    password = Mid_office_BRE_flow__c.getValues('BRE Flow').Password__c;
    endpointURL = Mid_office_BRE_flow__c.getValues('BRE Flow').EndpointURL__c;

    System.debug('*********body: ' + body);
    System.debug('*********endpointURL: ' + endpointURL);
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    //http://138.91.38.234:8087//executionserver/rest/1/ruleServices/Loan_Eligibility/versions/0.0.1-SNAPSHOT/rules/Loan_Eligibility/loanEligibilityMain/executions
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    System.debug('UserName--->' + username + ' ###  Password---->' + password);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + res);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('Eligibility', null);
      mapOfMCPResult = parseResponse1(root);
      System.debug('*************mapOfMCPResult : ' + mapOfMCPResult);
    }
    return mapOfMCPResult;
  }


  public MAP < String, String > callBREeligibilityCalculator(Map < string, string > valuesMap) {
    System.debug('****valuesMap--  : ' + valuesMap);
    /*if (valuesMap.get('cy_sales_turnover') == null) valuesMap.put('cy_sales_turnover', '');
if (valuesMap.get('cy_depriciation') == null) valuesMap.put('cy_depriciation', '');
if (valuesMap.get('cy_net_profit') == null) valuesMap.put('cy_net_profit', '');
if (valuesMap.get('nature_of_business') == null) valuesMap.put('nature_of_business', '');
if (valuesMap.get('date_of_birth') == null) valuesMap.put('date_of_birth', '');
if (valuesMap.get('type_of_degree') == null) valuesMap.put('type_of_degree', '');
if (valuesMap.get('specialisation') == null) valuesMap.put('specialisation', '');
if (valuesMap.get('CIBIL_Score') == null) valuesMap.put('CIBIL_Score', '');
if (valuesMap.get('cibilPos') == null) valuesMap.put('cibilPos', '');
if (valuesMap.get('gross_receipts') == null) valuesMap.put('gross_receipts', '');
if (valuesMap.get('years_in_business_job') == null) valuesMap.put('years_in_business_job', '');
if (valuesMap.get('loan_id') == null) valuesMap.put('loan_id', '1');

if (valuesMap.get('branch_type') == null) valuesMap.put('branch_type', '');
     */
    // System.debug('****valuesMap--  : ' + (valuesMap.get('cy_sales_turnover') < > null ? valuesMap.get('cy_sales_turnover') : 'test'));

    String body = '<input xmlns="http://www.visual-rules.com/vrpath/Eligibility_Calculator/eligibilityCalculator/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">   <Generic>     <dummy_member1></dummy_member1>     <dummy_member2></dummy_member2>     <dummy_member3></dummy_member3>     <dummy_member4></dummy_member4>     <dummy_member5></dummy_member5>     <dummy_member6></dummy_member6>     <dummy_member7></dummy_member7>     <dummy_member8></dummy_member8>     <dummy_member9></dummy_member9>     <dummy_member10></dummy_member10>     <loan_id>1</loan_id>     <branch_type>' + valuesMap.get('branch_type') + '</branch_type>     <branch_name>' + valuesMap.get('branch_name') + '</branch_name>     <branch_code></branch_code>   </Generic>   <CAMS>     <element>       <loan_id>1</loan_id>       <adjusted_rental_income></adjusted_rental_income>       <average_net_salary></average_net_salary>       <total_net_salary></total_net_salary>       <diff_date_ITRs></diff_date_ITRs>       <eligibility_Multiplier_Formula></eligibility_Multiplier_Formula>       <EMI_on_Proposed_Loan_TO></EMI_on_Proposed_Loan_TO>       <gross_Salary_Month1></gross_Salary_Month1>       <gross_Salary_Month2></gross_Salary_Month2>       <gross_Salary_Month3></gross_Salary_Month3>       <imputed_Income_Capped_at_50></imputed_Income_Capped_at_50>       <loan_eligibility></loan_eligibility>       <max_Loan_Amt_NAS_Multi></max_Loan_Amt_NAS_Multi>       <net_Salary_for_Month1></net_Salary_for_Month1>       <proposed_Loan_Amt></proposed_Loan_Amt>       <rental_Income></rental_Income>       <sal_MUE_Funding></sal_MUE_Funding>       <final_FOIR></final_FOIR>       <tenor></tenor>       <applicable_FOIR1></applicable_FOIR1>       <average_Monthly_Net_Income1></average_Monthly_Net_Income1>       <type_of_CAM_Entity></type_of_CAM_Entity>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>       <credit_program></credit_program>       <applicantNetSalary></applicantNetSalary>       <coApplicantSalary></coApplicantSalary>       <reimbursement></reimbursement>       <avgIncentive></avgIncentive>       <typeOfIncentive></typeOfIncentive>       <applicant_net_salary_m1></applicant_net_salary_m1>       <applicant_net_salary_m2></applicant_net_salary_m2>       <applicant_net_salary_m3></applicant_net_salary_m3>       <co_applicant_net_salary_m1></co_applicant_net_salary_m1>       <co_applicant_net_salary_m2></co_applicant_net_salary_m2>       <co_applicant_net_salary_m3></co_applicant_net_salary_m3>     </element>   </CAMS>   <Verification>     <element>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <applicant_type>Primary</applicant_type>       <verification_status></verification_status>       <verification_type></verification_type>       <verification_result_updated_date></verification_result_updated_date>     </element>   </Verification>   <Bank_summary>     <element>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <applicant_type>Primary</applicant_type>       <avg_od_cc_utilisation></avg_od_cc_utilisation>       <avg_bank_balance></avg_bank_balance>       <avg_od_cc_limit></avg_od_cc_limit>       <avg_bounce_inward></avg_bounce_inward>       <total_bounce_inward></total_bounce_inward>       <avg_bounce_outward></avg_bounce_outward>       <total_bounce_outward></total_bounce_outward>       <avg_credit_amount></avg_credit_amount>       <total_credit_amount></total_credit_amount>       <avg_debit_amount></avg_debit_amount>       <total_debit_amount></total_debit_amount>       <no_of_months_bankstatement></no_of_months_bankstatement>       <avg_monthly_balance_6mths></avg_monthly_balance_6mths>       <avg_monthly_balance_3mths></avg_monthly_balance_3mths>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>     </element>   </Bank_summary>   <Loan_Parameter>     <dummy_member1></dummy_member1>     <dummy_member2></dummy_member2>     <dummy_member3></dummy_member3>     <dummy_member4></dummy_member4>     <dummy_member5></dummy_member5>     <dummy_member6></dummy_member6>     <dummy_member7></dummy_member7>     <dummy_member8></dummy_member8>     <dummy_member9></dummy_member9>     <dummy_member10></dummy_member10>     <top_up_loan_amount></top_up_loan_amount>     <loan_application_stage></loan_application_stage>     <product_segment></product_segment>     <approved_rate></approved_rate>     <existing_derived_customer_segment></existing_derived_customer_segment>     <derived_customer_segment></derived_customer_segment>     <file_acceptance_status></file_acceptance_status>     <loan_id>' + valuesMap.get('loan_id') + '</loan_id>     <decision_date></decision_date>     <login_date></login_date>     <approved_loan_amount></approved_loan_amount>     <approved_tenor></approved_tenor>     <requested_loan_amount></requested_loan_amount>     <requested_tenor></requested_tenor>     <reqested_roi></reqested_roi>     <loan_application_number></loan_application_number>     <product>' + valuesMap.get('product') + '</product>     <scheme_name></scheme_name>     <scheme_code></scheme_code>     <type_of_loan></type_of_loan>     <process_type></process_type>     <event></event>     <stage></stage>     <sourcing_channel_type></sourcing_channel_type>     <existing_loan_product></existing_loan_product>     <existing_loan_amount></existing_loan_amount>     <existing_pos></existing_pos>     <existing_mob></existing_mob>     <existing_lan></existing_lan>     <file_acceptance_date></file_acceptance_date>     <crisil_score></crisil_score>     <sub_stage></sub_stage>     <existing_product></existing_product>     <offer_amount></offer_amount>     <offer_tenor></offer_tenor>     <offer_rate></offer_rate>   </Loan_Parameter>   <existing_loan>     <element>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <applicant_type>Primary</applicant_type>       <monthly_loan_obligations>' + valuesMap.get('monthly_loan_obligations') + '</monthly_loan_obligations>       <monthly_secured_loan_obligations></monthly_secured_loan_obligations>       <monthly_unsecured_loan_obligations></monthly_unsecured_loan_obligations>       <total_outstanding></total_outstanding>       <number_of_hl_loans></number_of_hl_loans>       <number_of_personal_loans></number_of_personal_loans>       <number_of_auto_loans></number_of_auto_loans>       <outstanding_of_hl_loans></outstanding_of_hl_loans>       <outstanding_of_personal_loans></outstanding_of_personal_loans>       <total_home_loan_amount></total_home_loan_amount>       <total_personal_loan_amount></total_personal_loan_amount>       <total_auto_loan_amount></total_auto_loan_amount>       <annual_obligations></annual_obligations>       <outstanding_of_auto_loans></outstanding_of_auto_loans>       <bajaj_loan_obligations></bajaj_loan_obligations>     </element>   </existing_loan>   <Demographic>     <element>       <type_of_constitution></type_of_constitution>       <vip></vip>       <educational_qualification></educational_qualification>       <loan_application_employment_type></loan_application_employment_type>       <current_employment_vintage></current_employment_vintage>       <total_employment_vintage>10</total_employment_vintage>       <date_of_birth>' + valuesMap.get('date_of_birth') + '</date_of_birth>       <date_of_incorporation></date_of_incorporation>       <dummy_member1></dummy_member1>       <dummy_member2></dummy_member2>       <dummy_member3></dummy_member3>       <dummy_member4></dummy_member4>       <dummy_member5></dummy_member5>       <dummy_member6></dummy_member6>       <dummy_member7></dummy_member7>       <dummy_member8></dummy_member8>       <dummy_member9></dummy_member9>       <dummy_member10></dummy_member10>       <spouse_doctor_flag></spouse_doctor_flag>       <age></age>       <constitution></constitution>       <costomer_type></costomer_type>       <residence_ownership></residence_ownership>       <permanent_house_ownership></permanent_house_ownership>       <factory_plant_ownership></factory_plant_ownership>       <customer_segment></customer_segment>       <clinic_hospital_type></clinic_hospital_type>       <outside_geo_limit></outside_geo_limit>       <stake_in_entity></stake_in_entity>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <dob_doi></dob_doi>       <years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job>       <first_name></first_name>       <last_name></last_name>       <residence_type></residence_type>       <existing_customer_flag></existing_customer_flag>       <applicant_type>Primary</applicant_type>       <marital_status></marital_status>       <company_category></company_category>       <company_type></company_type>       <professional_qualification></professional_qualification>       <type_of_degree>' + valuesMap.get('type_of_degree') + '</type_of_degree>       <office_email_id></office_email_id>       <office_icard></office_icard>       <name_of_employer></name_of_employer>       <years_in_current_business_job></years_in_current_business_job>       <gender></gender>       <pan></pan>       <residence_city></residence_city>       <office_city></office_city>       <residence_pin_code></residence_pin_code>       <office_pin_code></office_pin_code>       <caste></caste>       <religion></religion>       <staying__since_year></staying__since_year>       <nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business>       <industry></industry>       <sub_industry></sub_industry>       <e_mail_id></e_mail_id>       <customer_type></customer_type>       <permenent_house_ownership></permenent_house_ownership>       <relationship_with_applicant></relationship_with_applicant>       <specialisation>' + valuesMap.get('specialisation') + '</specialisation>       <medical_registration_no></medical_registration_no>     </element>   </Demographic>   <Cibil_lst>     <element>       <loan_id>1</loan_id>       <applicant_id></applicant_id>       <applicant_Type>Primary</applicant_Type>       <currentBalance>         <currentBalance1></currentBalance1>         <currentBalance2></currentBalance2>         <currentBalance3></currentBalance3>         <currentBalance4></currentBalance4>         <currentBalance5></currentBalance5>         <currentBalance6></currentBalance6>         <currentBalance7></currentBalance7>         <currentBalance8></currentBalance8>         <currentBalance9></currentBalance9>         <currentBalance10></currentBalance10>         <currentBalance11></currentBalance11>         <currentBalance12></currentBalance12>         <currentBalance13></currentBalance13>         <currentBalance14></currentBalance14>         <currentBalance15></currentBalance15>         <currentBalance16></currentBalance16>         <currentBalance17></currentBalance17>         <currentBalance18></currentBalance18>         <currentBalance19></currentBalance19>         <currentBalance20></currentBalance20>         <currentBalance21></currentBalance21>         <currentBalance22></currentBalance22>         <currentBalance23></currentBalance23>         <currentBalance24></currentBalance24>         <currentBalance25></currentBalance25>         <currentBalance26></currentBalance26>         <currentBalance27></currentBalance27>         <currentBalance28></currentBalance28>         <currentBalance29></currentBalance29>         <currentBalance></currentBalance>       </currentBalance>       <writtenOffPrincipal>         <writtenOffPrincipal></writtenOffPrincipal>         <writtenOffPrincipal1></writtenOffPrincipal1>         <writtenOffPrincipal2></writtenOffPrincipal2>         <writtenOffPrincipal3></writtenOffPrincipal3>         <writtenOffPrincipal4></writtenOffPrincipal4>         <writtenOffPrincipal5></writtenOffPrincipal5>         <writtenOffPrincipal6></writtenOffPrincipal6>         <writtenOffPrincipal7></writtenOffPrincipal7>         <writtenOffPrincipal8></writtenOffPrincipal8>         <writtenOffPrincipal9></writtenOffPrincipal9>         <writtenOffPrincipal10></writtenOffPrincipal10>         <writtenOffPrincipal11></writtenOffPrincipal11>         <writtenOffPrincipal12></writtenOffPrincipal12>         <writtenOffPrincipal13></writtenOffPrincipal13>         <writtenOffPrincipal14></writtenOffPrincipal14>         <writtenOffPrincipal15></writtenOffPrincipal15>         <writtenOffPrincipal16></writtenOffPrincipal16>         <writtenOffPrincipal17></writtenOffPrincipal17>         <writtenOffPrincipal18></writtenOffPrincipal18>         <writtenOffPrincipal19></writtenOffPrincipal19>         <writtenOffPrincipal20></writtenOffPrincipal20>         <writtenOffPrincipal21></writtenOffPrincipal21>         <writtenOffPrincipal22></writtenOffPrincipal22>         <writtenOffPrincipal23></writtenOffPrincipal23>         <writtenOffPrincipal24></writtenOffPrincipal24>         <writtenOffPrincipal25></writtenOffPrincipal25>         <writtenOffPrincipal26></writtenOffPrincipal26>         <writtenOffPrincipal27></writtenOffPrincipal27>         <writtenOffPrincipal28></writtenOffPrincipal28>         <writtenOffPrincipal29></writtenOffPrincipal29>       </writtenOffPrincipal>       <dateClosed>         <dateClosed1></dateClosed1>         <dateClosed2></dateClosed2>         <dateClosed3></dateClosed3>         <dateClosed4></dateClosed4>         <dateClosed5></dateClosed5>         <dateClosed6></dateClosed6>         <dateClosed7></dateClosed7>         <dateClosed8></dateClosed8>         <dateClosed9></dateClosed9>         <dateClosed10></dateClosed10>         <dateClosed11></dateClosed11>         <dateClosed12></dateClosed12>         <dateClosed13></dateClosed13>         <dateClosed14></dateClosed14>         <dateClosed15></dateClosed15>         <dateClosed16></dateClosed16>         <dateClosed17></dateClosed17>         <dateClosed18></dateClosed18>         <dateClosed19></dateClosed19>         <dateClosed20></dateClosed20>         <dateClosed21></dateClosed21>         <dateClosed22></dateClosed22>         <dateClosed23></dateClosed23>         <dateClosed24></dateClosed24>         <dateClosed25></dateClosed25>         <dateClosed26></dateClosed26>         <dateClosed27></dateClosed27>         <dateClosed28></dateClosed28>         <dateClosed29></dateClosed29>         <dateClosed></dateClosed>       </dateClosed>       <dateReported>         <dateReported1></dateReported1>         <dateReported2></dateReported2>         <dateReported3></dateReported3>         <dateReported4></dateReported4>         <dateReported5></dateReported5>         <dateReported6></dateReported6>         <dateReported7></dateReported7>         <dateReported8></dateReported8>         <dateReported9></dateReported9>         <dateReported10></dateReported10>         <dateReported11></dateReported11>         <dateReported12></dateReported12>         <dateReported13></dateReported13>         <dateReported14></dateReported14>         <dateReported15></dateReported15>         <dateReported16></dateReported16>         <dateReported17></dateReported17>         <dateReported18></dateReported18>         <dateReported19></dateReported19>         <dateReported20></dateReported20>         <dateReported21></dateReported21>         <dateReported22></dateReported22>         <dateReported23></dateReported23>         <dateReported24></dateReported24>         <dateReported25></dateReported25>         <dateReported26></dateReported26>         <dateReported27></dateReported27>         <dateReported28></dateReported28>         <dateReported29></dateReported29>         <dateReported></dateReported>       </dateReported>       <paymentHistoryEndDate>         <paymentHistoryEndDate1></paymentHistoryEndDate1>         <paymentHistoryEndDate2></paymentHistoryEndDate2>';
    body = body + '<paymentHistoryEndDate3></paymentHistoryEndDate3>         <paymentHistoryEndDate4></paymentHistoryEndDate4>         <paymentHistoryEndDate5></paymentHistoryEndDate5>         <paymentHistoryEndDate6></paymentHistoryEndDate6>         <paymentHistoryEndDate7></paymentHistoryEndDate7>         <paymentHistoryEndDate8></paymentHistoryEndDate8>         <paymentHistoryEndDate9></paymentHistoryEndDate9>         <paymentHistoryEndDate10></paymentHistoryEndDate10>         <paymentHistoryEndDate11></paymentHistoryEndDate11>         <paymentHistoryEndDate12></paymentHistoryEndDate12>         <paymentHistoryEndDate13></paymentHistoryEndDate13>         <paymentHistoryEndDate14></paymentHistoryEndDate14>         <paymentHistoryEndDate15></paymentHistoryEndDate15>         <paymentHistoryEndDate16></paymentHistoryEndDate16>         <paymentHistoryEndDate17></paymentHistoryEndDate17>         <paymentHistoryEndDate18></paymentHistoryEndDate18>         <paymentHistoryEndDate19></paymentHistoryEndDate19>         <paymentHistoryEndDate20></paymentHistoryEndDate20>         <paymentHistoryEndDate21></paymentHistoryEndDate21>         <paymentHistoryEndDate22></paymentHistoryEndDate22>         <paymentHistoryEndDate23></paymentHistoryEndDate23>         <paymentHistoryEndDate24></paymentHistoryEndDate24>         <paymentHistoryEndDate25></paymentHistoryEndDate25>         <paymentHistoryEndDate26></paymentHistoryEndDate26>         <paymentHistoryEndDate27></paymentHistoryEndDate27>         <paymentHistoryEndDate28></paymentHistoryEndDate28>         <paymentHistoryEndDate29></paymentHistoryEndDate29>         <paymentHistoryEndDate></paymentHistoryEndDate>       </paymentHistoryEndDate>       <paymentHistoryStartDate>         <paymentHistoryStartDate1></paymentHistoryStartDate1>         <paymentHistoryStartDate2></paymentHistoryStartDate2>         <paymentHistoryStartDate3></paymentHistoryStartDate3>         <paymentHistoryStartDate4></paymentHistoryStartDate4>         <paymentHistoryStartDate5></paymentHistoryStartDate5>         <paymentHistoryStartDate6></paymentHistoryStartDate6>         <paymentHistoryStartDate7></paymentHistoryStartDate7>         <paymentHistoryStartDate8></paymentHistoryStartDate8>         <paymentHistoryStartDate9></paymentHistoryStartDate9>         <paymentHistoryStartDate10></paymentHistoryStartDate10>         <paymentHistoryStartDate11></paymentHistoryStartDate11>         <paymentHistoryStartDate12></paymentHistoryStartDate12>         <paymentHistoryStartDate13></paymentHistoryStartDate13>         <paymentHistoryStartDate14></paymentHistoryStartDate14>         <paymentHistoryStartDate15></paymentHistoryStartDate15>         <paymentHistoryStartDate16></paymentHistoryStartDate16>         <paymentHistoryStartDate17></paymentHistoryStartDate17>         <paymentHistoryStartDate18></paymentHistoryStartDate18>         <paymentHistoryStartDate19></paymentHistoryStartDate19>         <paymentHistoryStartDate20></paymentHistoryStartDate20>         <paymentHistoryStartDate21></paymentHistoryStartDate21>         <paymentHistoryStartDate22></paymentHistoryStartDate22>         <paymentHistoryStartDate23></paymentHistoryStartDate23>         <paymentHistoryStartDate24></paymentHistoryStartDate24>         <paymentHistoryStartDate25></paymentHistoryStartDate25>         <paymentHistoryStartDate26></paymentHistoryStartDate26>         <paymentHistoryStartDate27></paymentHistoryStartDate27>         <paymentHistoryStartDate28></paymentHistoryStartDate28>         <paymentHistoryStartDate29></paymentHistoryStartDate29>         <paymentHistoryStartDate></paymentHistoryStartDate>       </paymentHistoryStartDate>       <acountType>         <accountType1></accountType1>         <accountType2></accountType2>         <accountType3></accountType3>         <accountType4></accountType4>         <accountType5></accountType5>         <accountType6></accountType6>         <accountType7></accountType7>         <accountType8></accountType8>         <accountType9></accountType9>         <accountType10></accountType10>         <accountType11></accountType11>         <accountType12></accountType12>         <accountType13></accountType13>         <accountType14></accountType14>         <accountType15></accountType15>         <accountType16></accountType16>         <accountType17></accountType17>         <accountType18></accountType18>         <accountType19></accountType19>         <accountType20></accountType20>         <accountType21></accountType21>         <accountType22></accountType22>         <accountType23></accountType23>         <accountType24></accountType24>         <accountType25></accountType25>         <accountType26></accountType26>         <accountType27></accountType27>         <accountType28></accountType28>         <accountType29></accountType29>         <accountType></accountType>       </acountType>       <accountOverdue>         <amountOverdue1></amountOverdue1>         <amountOverdue2></amountOverdue2>         <amountOverdue3></amountOverdue3>         <amountOverdue4></amountOverdue4>         <amountOverdue5></amountOverdue5>         <amountOverdue6></amountOverdue6>         <amountOverdue7></amountOverdue7>         <amountOverdue8></amountOverdue8>         <amountOverdue9></amountOverdue9>         <amountOverdue10></amountOverdue10>         <amountOverdue11></amountOverdue11>         <amountOverdue12></amountOverdue12>         <amountOverdue13></amountOverdue13>         <amountOverdue14></amountOverdue14>         <amountOverdue15></amountOverdue15>         <amountOverdue16></amountOverdue16>         <amountOverdue17></amountOverdue17>         <amountOverdue18></amountOverdue18>         <amountOverdue19></amountOverdue19>         <amountOverdue20></amountOverdue20>         <amountOverdue21></amountOverdue21>         <amountOverdue22></amountOverdue22>         <amountOverdue23></amountOverdue23>         <amountOverdue24></amountOverdue24>         <amountOverdue25></amountOverdue25>         <amountOverdue26></amountOverdue26>         <amountOverdue27></amountOverdue27>         <amountOverdue28></amountOverdue28>         <amountOverdue29></amountOverdue29>         <amountOverdue></amountOverdue>       </accountOverdue>       <dateOfEnquiry>         <dateOfEnquiry1></dateOfEnquiry1>         <dateOfEnquiry2></dateOfEnquiry2>         <dateOfEnquiry3></dateOfEnquiry3>         <dateOfEnquiry4></dateOfEnquiry4>         <dateOfEnquiry5></dateOfEnquiry5>         <dateOfEnquiry6></dateOfEnquiry6>         <dateOfEnquiry7></dateOfEnquiry7>         <dateOfEnquiry8></dateOfEnquiry8>         <dateOfEnquiry9></dateOfEnquiry9>         <dateOfEnquiry10></dateOfEnquiry10>         <dateOfEnquiry11></dateOfEnquiry11>         <dateOfEnquiry12></dateOfEnquiry12>         <dateOfEnquiry13></dateOfEnquiry13>         <dateOfEnquiry14></dateOfEnquiry14>         <dateOfEnquiry15></dateOfEnquiry15>         <dateOfEnquiry16></dateOfEnquiry16>         <dateOfEnquiry17></dateOfEnquiry17>         <dateOfEnquiry18></dateOfEnquiry18>         <dateOfEnquiry19></dateOfEnquiry19>         <dateOfEnquiry20></dateOfEnquiry20>         <dateOfEnquiry21></dateOfEnquiry21>         <dateOfEnquiry22></dateOfEnquiry22>         <dateOfEnquiry23></dateOfEnquiry23>         <dateOfEnquiry24></dateOfEnquiry24>         <dateOfEnquiry25></dateOfEnquiry25>         <dateOfEnquiry26></dateOfEnquiry26>         <dateOfEnquiry27></dateOfEnquiry27>         <dateOfEnquiry28></dateOfEnquiry28>         <dateOfEnquiry29></dateOfEnquiry29>         <dateOfEnquiry></dateOfEnquiry>       </dateOfEnquiry>       <daysPastDue>         <daysPastDue1></daysPastDue1>         <daysPastDue2></daysPastDue2>         <daysPastDue3></daysPastDue3>         <daysPastDue4></daysPastDue4>         <daysPastDue5></daysPastDue5>         <daysPastDue6></daysPastDue6>         <daysPastDue7></daysPastDue7>         <daysPastDue8></daysPastDue8>         <daysPastDue9></daysPastDue9>         <daysPastDue10></daysPastDue10>         <daysPastDue11></daysPastDue11>         <daysPastDue12></daysPastDue12>         <daysPastDue13></daysPastDue13>         <daysPastDue14></daysPastDue14>         <daysPastDue15></daysPastDue15>         <daysPastDue16></daysPastDue16>         <daysPastDue17></daysPastDue17>         <daysPastDue18></daysPastDue18>         <daysPastDue19></daysPastDue19>         <daysPastDue20></daysPastDue20>         <daysPastDue21></daysPastDue21>         <daysPastDue22></daysPastDue22>         <daysPastDue23></daysPastDue23>         <daysPastDue24></daysPastDue24>         <daysPastDue25></daysPastDue25>         <daysPastDue26></daysPastDue26>         <daysPastDue27></daysPastDue27>         <daysPastDue28></daysPastDue28>         <daysPastDue29></daysPastDue29>         <daysPastDue></daysPastDue>       </daysPastDue>       <enquiryAmount>         <enquiryAmt1></enquiryAmt1>         <enquiryAmt2></enquiryAmt2>         <enquiryAmt3></enquiryAmt3>         <enquiryAmt4></enquiryAmt4>         <enquiryAmt5></enquiryAmt5>         <enquiryAmt6></enquiryAmt6>         <enquiryAmt7></enquiryAmt7>         <enquiryAmt8></enquiryAmt8>         <enquiryAmt9></enquiryAmt9>         <enquiryAmt10></enquiryAmt10>         <enquiryAmt11></enquiryAmt11>         <enquiryAmt12></enquiryAmt12>         <enquiryAmt13></enquiryAmt13>         <enquiryAmt14></enquiryAmt14>         <enquiryAmt15></enquiryAmt15>         <enquiryAmt16></enquiryAmt16>         <enquiryAmt17></enquiryAmt17>         <enquiryAmt18></enquiryAmt18>         <enquiryAmt19></enquiryAmt19>         <enquiryAmt20></enquiryAmt20>         <enquiryAmt21></enquiryAmt21>         <enquiryAmt22></enquiryAmt22>         <enquiryAmt23></enquiryAmt23>         <enquiryAmt24></enquiryAmt24>         <enquiryAmt25></enquiryAmt25>         <enquiryAmt26></enquiryAmt26>         <enquiryAmt27></enquiryAmt27>         <enquiryAmt28></enquiryAmt28>         <enquiryAmt29></enquiryAmt29>         <enquiryAmt></enquiryAmt>       </enquiryAmount>       <enquiryPurpose>         <enquiryPurpose1></enquiryPurpose1>         <enquiryPurpose2></enquiryPurpose2>         <enquiryPurpose3></enquiryPurpose3>         <enquiryPurpose4></enquiryPurpose4>         <enquiryPurpose5></enquiryPurpose5>         <enquiryPurpose6></enquiryPurpose6>         <enquiryPurpose7></enquiryPurpose7>         <enquiryPurpose8></enquiryPurpose8>         <enquiryPurpose9></enquiryPurpose9>         <enquiryPurpose10></enquiryPurpose10>         <enquiryPurpose11></enquiryPurpose11>         <enquiryPurpose12></enquiryPurpose12>         <enquiryPurpose13></enquiryPurpose13>         <enquiryPurpose14></enquiryPurpose14>         <enquiryPurpose15></enquiryPurpose15>         <enquiryPurpose16></enquiryPurpose16>         <enquiryPurpose17></enquiryPurpose17>         <enquiryPurpose18></enquiryPurpose18>         <enquiryPurpose19></enquiryPurpose19>         <enquiryPurpose20></enquiryPurpose20>         <enquiryPurpose21></enquiryPurpose21>         <enquiryPurpose22></enquiryPurpose22>         <enquiryPurpose23></enquiryPurpose23>         <enquiryPurpose24></enquiryPurpose24>         <enquiryPurpose25></enquiryPurpose25>         <enquiryPurpose26></enquiryPurpose26>         <enquiryPurpose27></enquiryPurpose27>         <enquiryPurpose28></enquiryPurpose28>         <enquiryPurpose29></enquiryPurpose29>         <enquiryPurpose></enquiryPurpose>       </enquiryPurpose>       <memberName>         <memberName1></memberName1>         <memberName2></memberName2>         <memberName3></memberName3>         <memberName4></memberName4>         <memberName5></memberName5>         <memberName6></memberName6>         <memberName7></memberName7>         <memberName8></memberName8>         <memberName9></memberName9>         <memberName10></memberName10>         <memberName11></memberName11>         <memberName12></memberName12>         <memberName13></memberName13>         <memberName14></memberName14>         <memberName15></memberName15>         <memberName16></memberName16>         <memberName17></memberName17>         <memberName18></memberName18>         <memberName19></memberName19>         <memberName20></memberName20>         <memberName21></memberName21>         <memberName22></memberName22>         <memberName23></memberName23>         <memberName24></memberName24>         <memberName25></memberName25>         <memberName26></memberName26>         <memberName27></memberName27>         <memberName28></memberName28>         <memberName29></memberName29>         <memberName></memberName>       </memberName>       <member>         <member1></member1>         <member2></member2>         <member3></member3>         <member4></member4>         <member5></member5>         <member6></member6>         <member7></member7>         <member8></member8>         <member9></member9>         <member10></member10>         <member11></member11>         <member12></member12>         <member13></member13>         <member14></member14>         <member15></member15>         <member16></member16>         <member17></member17>         <member18></member18>         <member19></member19>         <member20></member20>         <member21></member21>         <member22></member22>         <member23></member23>         <member24></member24>         <member25></member25>         <member26></member26>         <member27></member27>         <member28></member28>         <member29></member29>         <member></member>       </member>       <ownership>         <ownership1></ownership1>         <ownership2></ownership2>         <ownership3></ownership3>         <ownership4></ownership4>         <ownership5></ownership5>         <ownership6></ownership6>         <ownership7></ownership7>         <ownership8></ownership8>         <ownership9></ownership9>         <ownership10></ownership10>         <ownership11></ownership11>         <ownership12></ownership12>         <ownership13></ownership13>         <ownership14></ownership14>         <ownership15></ownership15>         <ownership16></ownership16>         <ownership17></ownership17>         <ownership18></ownership18>         <ownership19></ownership19>         <ownership20></ownership20>         <ownership21></ownership21>         <ownership22></ownership22>         <ownership23></ownership23>         <ownership24></ownership24>         <ownership25></ownership25>         <ownership26></ownership26>         <ownership27></ownership27>         <ownership28></ownership28>         <ownership29></ownership29>         <ownership></ownership>       </ownership>       <startEndDate>         <startEndDate1></startEndDate1>         <startEndDate2></startEndDate2>         <startEndDate3></startEndDate3>         <startEndDate4></startEndDate4>         <startEndDate5></startEndDate5>         <startEndDate6></startEndDate6>         <startEndDate7></startEndDate7>         <startEndDate8></startEndDate8>         <startEndDate9></startEndDate9>         <startEndDate10></startEndDate10>         <startEndDate11></startEndDate11>         <startEndDate12></startEndDate12>         <startEndDate13></startEndDate13>         <startEndDate14></startEndDate14>         <startEndDate15></startEndDate15>         <startEndDate16></startEndDate16>         <startEndDate17></startEndDate17>         <startEndDate18></startEndDate18>         <startEndDate19></startEndDate19>         <startEndDate20></startEndDate20>         <startEndDate21></startEndDate21>         <startEndDate22></startEndDate22>         <startEndDate23></startEndDate23>         <startEndDate24></startEndDate24>         <startEndDate25></startEndDate25>         <startEndDate26></startEndDate26>         <startEndDate27></startEndDate27>         <startEndDate28></startEndDate28>         <startEndDate29></startEndDate29>         <startEndDate></startEndDate>       </startEndDate>       <suitFiledStatus>         <suitFiledStatus></suitFiledStatus>         <suitFiledStatus1></suitFiledStatus1>         <suitFiledStatus2></suitFiledStatus2>         <suitFiledStatus3></suitFiledStatus3>         <suitFiledStatus4></suitFiledStatus4>         <suitFiledStatus5></suitFiledStatus5>         <suitFiledStatus6></suitFiledStatus6>         <suitFiledStatus7></suitFiledStatus7>         <suitFiledStatus8></suitFiledStatus8>         <suitFiledStatus9></suitFiledStatus9>         <suitFiledStatus10></suitFiledStatus10>         <suitFiledStatus11></suitFiledStatus11>         <suitFiledStatus12></suitFiledStatus12>         <suitFiledStatus13></suitFiledStatus13>         <suitFiledStatus14></suitFiledStatus14>         <suitFiledStatus15></suitFiledStatus15>         <suitFiledStatus16></suitFiledStatus16>         <suitFiledStatus17></suitFiledStatus17>         <suitFiledStatus18></suitFiledStatus18>         <suitFiledStatus19></suitFiledStatus19>         <suitFiledStatus20></suitFiledStatus20>         <suitFiledStatus21></suitFiledStatus21>         <suitFiledStatus22></suitFiledStatus22>         <suitFiledStatus23></suitFiledStatus23>         <suitFiledStatus24></suitFiledStatus24>         <suitFiledStatus25></suitFiledStatus25>         <suitFiledStatus26></suitFiledStatus26>         <suitFiledStatus27></suitFiledStatus27>         <suitFiledStatus28></suitFiledStatus28>         <suitFiledStatus29></suitFiledStatus29>       </suitFiledStatus>       <writtenOffAndSettledStatus>         <writtenOffAndSettledStatus1></writtenOffAndSettledStatus1>         <writtenOffAndSettledStatus2></writtenOffAndSettledStatus2>         <writtenOffAndSettledStatus3></writtenOffAndSettledStatus3>         <writtenOffAndSettledStatus4></writtenOffAndSettledStatus4>         <writtenOffAndSettledStatus5></writtenOffAndSettledStatus5>         <writtenOffAndSettledStatus6></writtenOffAndSettledStatus6>         <writtenOffAndSettledStatus7></writtenOffAndSettledStatus7>         <writtenOffAndSettledStatus8></writtenOffAndSettledStatus8>         <writtenOffAndSettledStatus9></writtenOffAndSettledStatus9>         <writtenOffAndSettledStatus10></writtenOffAndSettledStatus10>         <writtenOffAndSettledStatus11></writtenOffAndSettledStatus11>         <writtenOffAndSettledStatus12></writtenOffAndSettledStatus12>         <writtenOffAndSettledStatus13></writtenOffAndSettledStatus13>         <writtenOffAndSettledStatus14></writtenOffAndSettledStatus14>         <writtenOffAndSettledStatus15></writtenOffAndSettledStatus15>         <writtenOffAndSettledStatus16></writtenOffAndSettledStatus16>         <writtenOffAndSettledStatus17></writtenOffAndSettledStatus17>         <writtenOffAndSettledStatus18></writtenOffAndSettledStatus18>         <writtenOffAndSettledStatus19></writtenOffAndSettledStatus19>         <writtenOffAndSettledStatus20></writtenOffAndSettledStatus20>         <writtenOffAndSettledStatus21></writtenOffAndSettledStatus21>         <writtenOffAndSettledStatus22></writtenOffAndSettledStatus22>         <writtenOffAndSettledStatus23></writtenOffAndSettledStatus23>         <writtenOffAndSettledStatus24></writtenOffAndSettledStatus24>         <writtenOffAndSettledStatus25></writtenOffAndSettledStatus25>         <writtenOffAndSettledStatus26></writtenOffAndSettledStatus26>         <writtenOffAndSettledStatus27></writtenOffAndSettledStatus27>         <writtenOffAndSettledStatus28></writtenOffAndSettledStatus28>         <writtenOffAndSettledStatus29></writtenOffAndSettledStatus29>         <writtenOffAndSettledStatus></writtenOffAndSettledStatus>       </writtenOffAndSettledStatus>       <amout_Overdue_Limit></amout_Overdue_Limit>       <CIBIL_Fired_time></CIBIL_Fired_time>       <CIBIL_updated_time></CIBIL_updated_time>       <date_Processed></date_Processed>       <EM_Date_of_Entry_for_Cibil_Remarks_Code></EM_Date_of_Entry_for_Cibil_Remarks_Code>       <EM_Date_of_Entry_for_Error_Code></EM_Date_of_Entry_for_Error_Code>       <EM_Date_of_Entry_for_Error_Dispute_Re></EM_Date_of_Entry_for_Error_Dispute_Re>       <bad_Track_Record></bad_Track_Record>       <CIBIL_Match_check></CIBIL_Match_check>       <CIBIL_Rules_Fail></CIBIL_Rules_Fail>       <CIBIL_Score>' + valuesMap.get('CIBIL_Score') + '</CIBIL_Score>       <PL_Score></PL_Score>       <TU_Score></TU_Score>       <write_Off></write_Off>       <cibilPos>' + valuesMap.get('cibilPos') + '</cibilPos>     </element>   </Cibil_lst>   <profit_loss_statement>     <cy_interest_to_pvt_parties></cy_interest_to_pvt_parties>     <py_sales_turnover></py_sales_turnover>     <cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover>     <py_profit_before_tax></py_profit_before_tax>     <py_profit_after_tax></py_profit_after_tax>     <py_income_as_per_itr></py_income_as_per_itr>     <cy_profit_before_tax></cy_profit_before_tax>     <cy_profit_after_tax></cy_profit_after_tax>     <cy_income_as_per_itr></cy_income_as_per_itr>     <py_depriciation></py_depriciation>     <cy_depriciation>' + valuesMap.get('cy_depriciation') + '</cy_depriciation>     <py_salary_to_partner></py_salary_to_partner>     <cy_salary_to_partner></cy_salary_to_partner>     <py_interest_to_partner></py_interest_to_partner>     <cy_interest_to_partner></cy_interest_to_partner>     <py_ebitda></py_ebitda>     <cy_ebitda></cy_ebitda>     <py_total_interest_paid></py_total_interest_paid>     <cy_total_interest_paid></cy_total_interest_paid>     <py_cash_profit></py_cash_profit>     <cy_cash_profit></cy_cash_profit>     <py_total_networth></py_total_networth>     <cy_total_networth></cy_total_networth>     <py_debtors></py_debtors>     <cy_debtors></cy_debtors>     <py_creditors></py_creditors>     <cy_creditors></cy_creditors>     <py_adjusted_networth></py_adjusted_networth>     <cy_adjusted_networth></cy_adjusted_networth>     <cy_annual_receipt></cy_annual_receipt>     <cy_income_from_business></cy_income_from_business>     <cy_net_profit>' + valuesMap.get('cy_net_profit') + '</cy_net_profit>     <py_net_profit></py_net_profit>     <gross_receipts>' + valuesMap.get('gross_receipts') + '</gross_receipts>     <cy_Interest_to_FI></cy_Interest_to_FI>     <py_Interest_to_FI></py_Interest_to_FI>     <py_interest_to_pvt_parties></py_interest_to_pvt_parties>     <cy_inBigDecimal_to_pvt_parties></cy_inBigDecimal_to_pvt_parties>     <py_Total_ouside_borrowings></py_Total_ouside_borrowings>     <cy_Total_ouside_borrowings></cy_Total_ouside_borrowings>     <days_gap_in_itr></days_gap_in_itr>     <dummy_member9></dummy_member9>     <dummy_member10></dummy_member10>     <cy_inventory></cy_inventory>     <py_inventory></py_inventory>     <cy_total_assets></cy_total_assets>     <py_total_assets></py_total_assets>     <cy_current_assets></cy_current_assets>     <py_current_assets></py_current_assets>     <cy_current_liabilities></cy_current_liabilities>     <py_current_liabilities></py_current_liabilities>     <loan_id>1</loan_id>     <applicant_id></applicant_id>   </profit_loss_statement> </input>';

    body = body.replaceAll('null', '');

    System.debug('*********body: ' + body);
    System.debug('*********endpointURL: ' + endpointURL);

    //Added By Mahima- Ip Address Changes-S
    Mid_office_BRE_flow__c BREeligibilityCalculator = Mid_office_BRE_flow__c.getValues('BRE Eligibility Calculator');
    if (BREeligibilityCalculator != null) {
      username = BREeligibilityCalculator.Username__c;
      password = BREeligibilityCalculator.Password__c;
      endpointURL = '';
      endpointURL = BREeligibilityCalculator.EndpointURL__c;
    }
    //Added By Mahima- Ip Address Changes-S

    HttpRequest req = new HttpRequest();
    //req.setEndpoint('//http://138.91.38.234:8087//executionserver/rest/1/ruleServices/Loan_Eligibility/versions/0.0.1-SNAPSHOT/rules/Eligibility_Calculator/eligibilityCalculator/executions');
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Eligibility_Calculator/versions/0.0.1-SNAPSHOT/rules/Eligibility_Calculator/eligibilityCalculator/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    System.debug('UserName--->' + username + ' ###  Password---->' + password);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + res);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('Eligibility', null);
      mapOfMCPResult = parseResponse1(root);
      System.debug('*************mapOfMCPResult : ' + mapOfMCPResult);
    }
    return mapOfMCPResult;
  }

  public MAP < String, String > callBRESurrogateEligibility(Map < string, string > valuesMap) {
    System.debug('****valuesMap--  : ' + valuesMap);
    /*if (valuesMap.get('cy_sales_turnover') == null) valuesMap.put('cy_sales_turnover', '');
if (valuesMap.get('cy_depriciation') == null) valuesMap.put('cy_depriciation', '');
if (valuesMap.get('cy_net_profit') == null) valuesMap.put('cy_net_profit', '');
if (valuesMap.get('nature_of_business') == null) valuesMap.put('nature_of_business', '');
if (valuesMap.get('date_of_birth') == null) valuesMap.put('date_of_birth', '');
if (valuesMap.get('type_of_degree') == null) valuesMap.put('type_of_degree', '');
if (valuesMap.get('specialisation') == null) valuesMap.put('specialisation', '');
if (valuesMap.get('CIBIL_Score') == null) valuesMap.put('CIBIL_Score', '');
if (valuesMap.get('cibilPos') == null) valuesMap.put('cibilPos', '');
if (valuesMap.get('gross_receipts') == null) valuesMap.put('gross_receipts', '');
if (valuesMap.get('years_in_business_job') == null) valuesMap.put('years_in_business_job', '');
if (valuesMap.get('rating') == null) valuesMap.put('rating', '');
if (valuesMap.get('typeOfRating') == null) valuesMap.put('typeOfRating', '');
if (valuesMap.get('avg_od_cc_utilisation') == null) valuesMap.put('avg_od_cc_utilisation', '');
if (valuesMap.get('branch_type') == null) valuesMap.put('branch_type', '');
if (valuesMap.get('branch_name') == null) valuesMap.put('branch_name', '');
if (valuesMap.get('autoLoanEMI') == null) valuesMap.put('autoLoanEMI', '');
if (valuesMap.get('loan_id') == null) valuesMap.put('loan_id', '1');
     */
    System.debug('****branch type--  : ' + valuesMap.get('branch_type'));
    System.debug('****autoLoanEMI--  : ' + valuesMap.get('autoLoanEMI'));
    //  System.debug('****valuesMap--  : ' + (valuesMap.get('cy_sales_turnover') < > null ? valuesMap.get('cy_sales_turnover') : 'test'));

    System.debug('****autoLoanEMI--  : ' + valuesMap.get('lastDoneDate'));
    /*dev
String body = '<input xmlns="http://www.visual-rules.com/vrpath/Surrogate/surrogateMain/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><profit_loss_statement><cy_net_profit></cy_net_profit><cy_interest_to_pvt_parties></cy_interest_to_pvt_parties><py_sales_turnover></py_sales_turnover><cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover><targetLoanAmount>' + valuesMap.get('targetLoanAmount') + '</targetLoanAmount><creditProgram>' + valuesMap.get('creditProgram') + '</creditProgram><typeOfRating>' + valuesMap.get('typeOfRating') + '</typeOfRating><ratingAgency></ratingAgency><rating>' + valuesMap.get('rating') + '</rating><mob>' + valuesMap.get('mob') + '</mob><autoLoanEMI>' + valuesMap.get('autoLoanEMI') + '</autoLoanEMI></profit_loss_statement><Bank_summary><element><loan_id>1</loan_id><applicant_id></applicant_id><applicant_type>Primary</applicant_type><avg_od_cc_utilisation>' + valuesMap.get('avg_od_cc_utilisation') + '</avg_od_cc_utilisation><avg_bank_balance></avg_bank_balance><avg_od_cc_limit>' + valuesMap.get('avg_od_cc_limit') + '</avg_od_cc_limit>';
body = body + '</element></Bank_summary><Demographic><element><date_of_incorporation>' + valuesMap.get('date_of_incorporation') + '</date_of_incorporation><loan_id>1</loan_id><applicant_id></applicant_id><dob_doi></dob_doi><years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job><applicant_type>Primary</applicant_type><nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business><lastDoneDate>' + valuesMap.get('lastDoneDate') + '</lastDoneDate><customer_type>'+valuesMap.get('customer_type')+'</customer_type></element></Demographic><Generic><loan_id>1</loan_id><branch_type>' + valuesMap.get('branch_type') + '</branch_type><branch_name>' + valuesMap.get('branch_name') + '</branch_name><branch_code></branch_code></Generic><Loan_Parameter><loan_id>' + valuesMap.get('loan_id') + '</loan_id><decision_date></decision_date><login_date></login_date><approved_loan_amount></approved_loan_amount><approved_tenor></approved_tenor><requested_loan_amount></requested_loan_amount><requested_tenor>' + valuesMap.get('requested_tenor') + '</requested_tenor><reqested_roi></reqested_roi><loan_application_number></loan_application_number><product>' + valuesMap.get('product') + '</product></Loan_Parameter></input>';
     */
    String body = '<input xmlns="http://www.visual-rules.com/vrpath/Surrogate/surrogateMain/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><profit_loss_statement><cy_net_profit></cy_net_profit><cy_interest_to_pvt_parties></cy_interest_to_pvt_parties><py_sales_turnover></py_sales_turnover><cy_sales_turnover>' + valuesMap.get('cy_sales_turnover') + '</cy_sales_turnover><targetLoanAmount>' + valuesMap.get('targetLoanAmount') + '</targetLoanAmount><creditProgram>' + valuesMap.get('creditProgram') + '</creditProgram><typeOfRating>' + valuesMap.get('typeOfRating') + '</typeOfRating><ratingAgency></ratingAgency><rating>' + valuesMap.get('rating') + '</rating><mob>' + valuesMap.get('mob') + '</mob><autoLoanEMI>' + valuesMap.get('autoLoanEMI') + '</autoLoanEMI></profit_loss_statement><Bank_summary><element><loan_id>1</loan_id><applicant_id></applicant_id><applicant_type>Primary</applicant_type><avg_od_cc_utilisation>' + valuesMap.get('avg_od_cc_utilisation') + '</avg_od_cc_utilisation><avg_bank_balance></avg_bank_balance><avg_od_cc_limit>' + valuesMap.get('avg_od_cc_limit') + '</avg_od_cc_limit>';
    body = body + '</element></Bank_summary><Demographic><element><date_of_incorporation>' + valuesMap.get('date_of_incorporation') + '</date_of_incorporation><loan_id>1</loan_id><applicant_id></applicant_id><dob_doi></dob_doi><years_in_business_job>' + valuesMap.get('years_in_business_job') + '</years_in_business_job><applicant_type>Primary</applicant_type><nature_of_business>' + valuesMap.get('nature_of_business') + '</nature_of_business><lastDoneDate>' + valuesMap.get('lastDoneDate') + '</lastDoneDate><customer_type>' + valuesMap.get('customer_type') + '</customer_type><first_name>' + valuesMap.get('first_name') + '</first_name><last_name>' + valuesMap.get('last_name') + '</last_name></element></Demographic><Generic><loan_id>1</loan_id><branch_type>' + valuesMap.get('branch_type') + '</branch_type><branch_name>' + valuesMap.get('branch_name') + '</branch_name><branch_code></branch_code></Generic><Loan_Parameter><loan_id>' + valuesMap.get('loan_id') + '</loan_id><decision_date></decision_date><login_date></login_date><approved_loan_amount></approved_loan_amount><approved_tenor></approved_tenor><requested_loan_amount></requested_loan_amount><requested_tenor>' + valuesMap.get('requested_tenor') + '</requested_tenor><reqested_roi></reqested_roi><loan_application_number></loan_application_number><product>' + valuesMap.get('product') + '</product><stage>' + valuesMap.get('stage') + '</stage><sub_stage>' + valuesMap.get('sub_stage') + '</sub_stage></Loan_Parameter></input>';

    body = body.replaceAll('null', '');

    //  System.debug('*********body: ' + body);
    System.debug('*********endpointURL: ' + endpointURL);

    //Added By Mahima- Ip Address Changes-S
    Mid_office_BRE_flow__c BRE_Surrogate_Eligibility = Mid_office_BRE_flow__c.getValues('BRE Surrogate Eligibility');
    if (BRE_Surrogate_Eligibility != null) {
      username = BRE_Surrogate_Eligibility.Username__c;
      password = BRE_Surrogate_Eligibility.Password__c;
      endpointURL = '';
      endpointURL = BRE_Surrogate_Eligibility.EndpointURL__c;
    }
    //Added By Mahima- Ip Address Changes-S


    HttpRequest req = new HttpRequest();
    //req.setEndpoint('//http://138.91.38.234:8087//executionserver/rest/1/ruleServices/Loan_Eligibility/versions/0.0.1-SNAPSHOT/rules/Eligibility_Calculator/eligibilityCalculator/executions');
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Surrogate/versions/0.0.1-SNAPSHOT/rules/Surrogate/surrogateMain/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    System.debug('UserName--->' + username + ' ###  Password---->' + password);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + res);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('Eligibility', null);
      mapOfMCPResult = parseResponse1(root);
      System.debug('*************mapOfMCPResult : ' + mapOfMCPResult);
    }
    return mapOfMCPResult;
  }

  public MAP < String, String > callBRESegmentation(Map < String, String > mapOfInput) {
    /*
//Final string
if (mapOfInput.get('loan_id') == null) mapOfInput.put('loan_id', '1');
//added for DL
if (mapOfInput.get('CIBIL_Score') == null) mapOfInput.put('CIBIL_Score', '');
if (mapOfInput.get('total_no_of_loans_excl_cc') == null) mapOfInput.put('total_no_of_loans_excl_cc', '');
if (mapOfInput.get('unsecured_live_loan_balance') == null) mapOfInput.put('unsecured_live_loan_balance', '');
if (mapOfInput.get('highest_dpd_In_1_year') == null) mapOfInput.put('highest_dpd_In_1_year', '');
if (mapOfInput.get('ratioCCUtil') == null) mapOfInput.put('ratioCCUtil', '');
if (mapOfInput.get('total_no_of_secured_loans') == null) mapOfInput.put('total_no_of_secured_loans', '');
if (mapOfInput.get('specialisation') == null) mapOfInput.put('specialisation', '');
if (mapOfInput.get('type_of_degree') == null) mapOfInput.put('type_of_degree', '');
if (mapOfInput.get('branch_Name') == null) mapOfInput.put('branch_Name', '');
     */
    Mid_office_BRE_flow__c BRE_seg = Mid_office_BRE_flow__c.getValues('BRE segmentation');
    if (BRE_seg != null) {
      // username = BRE_Flow.Username__c;
      //password = BRE_Flow.Password__c;
      endpointURL = '';
      endpointURL = BRE_seg.EndpointURL__c;
    }

    //SAL Policy Rule Changes :: Added by Pritha :: Added tag ><number_of_live_PL_Loans>' + mapOfInput.get('number_of_live_PL_Loans') + '</number_of_live_PL_Loans::: <sumOfAmountOverdue>' + mapOfInput.get('sumOfAmountOverdue') + '</sumOfAmountOverdue>'</number_of_HL_Loans><noOfPLEnquiriesIn12M>' + mapOfInput.get('noOfPLEnquiriesIn12M') + '</noOfPLEnquiriesIn12M><noOfPLEnquiriesIn6M>' + mapOfInput.get('noOfPLEnquiriesIn6M') + '</noOfPLEnquiriesIn6M>

    /* String body = '<input><Cibil_lst><element><loan_id>1</loan_id><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><CIBIL_Score>' + mapOfInput.get('CIBIL_Score') + '</CIBIL_Score><highest_dpd_In_1_year>' + mapOfInput.get('highest_dpd_In_1_year') + '</highest_dpd_In_1_year><avg_balance>' + mapOfInput.get('avg_balance') + '</avg_balance><total_no_of_live_trades>' + mapOfInput.get('total_no_of_live_trades') + '</total_no_of_live_trades><ratioUnsecuredToTotalNumberOfLoans>' + mapOfInput.get('ratioUnsecuredToTotalNumberOfLoans') + '</ratioUnsecuredToTotalNumberOfLoans><creditCardUtilization>' + mapOfInput.get('creditCardUtilization') + '</creditCardUtilization><newest_MOB>' + mapOfInput.get('newest_MOB') + '</newest_MOB><secured_sanction_amt>' + mapOfInput.get('secured_sanction_amt') + '</secured_sanction_amt><unsecured_sanction_amt>' + mapOfInput.get('unsecured_sanction_amt') + '</unsecured_sanction_amt><unsecured_loans_in_12_months>' + mapOfInput.get('unsecured_loans_in_12_months') + '</unsecured_loans_in_12_months><oldest_MOB>' + mapOfInput.get('oldest_MOB') + '</oldest_MOB><total_no_of_loan_enquiry_in_3_months>' + mapOfInput.get('total_no_of_loan_enquiry_in_3_months') + '</total_no_of_loan_enquiry_in_3_months><_30PlusTradelinesInLast12Months>' + mapOfInput.get('_30PlusTradelinesInLast12Months') + '</_30PlusTradelinesInLast12Months><total_no_of_loans_excl_cc>' + mapOfInput.get('total_no_of_loans_excl_cc') + '</total_no_of_loans_excl_cc><unsecured_live_loan_balance>' + mapOfInput.get('unsecured_live_loan_balance') + '</unsecured_live_loan_balance><ratioCCUtil>' + mapOfInput.get('ratioCCUtil') + '</ratioCCUtil><total_no_of_secured_loans>' + mapOfInput.get('total_no_of_secured_loans') + '</total_no_of_secured_loans><sumOfAmountOverdue>' + mapOfInput.get('sumOfAmountOverdue') + '</sumOfAmountOverdue></element></Cibil_lst><Demographic><element><profession>' + mapOfInput.get('profession') + '</profession><coApplicantFlag>' + mapOfInput.get('coApplicantFlag') + '</coApplicantFlag><residence_Type>' + mapOfInput.get('Residence_Type') + '</residence_Type><applicant_Type>Primary</applicant_Type><company_Category>' + mapOfInput.get('Company_Category') + '</company_Category><company_Type>' + mapOfInput.get('Company_Type') + '</company_Type><educational_Qualification>' + mapOfInput.get('Educational_Qualification') + '</educational_Qualification><office_Email_Id>' + mapOfInput.get('Office_Email_Id') + '</office_Email_Id><current_Employment_Vintage>' + mapOfInput.get('Current_Employment_Vintage') + '</current_Employment_Vintage><total_Employment_Vintage>' + mapOfInput.get('total_Employment_Vintage') + '</total_Employment_Vintage><date_of_Birth>' + mapOfInput.get('date_of_Birth') + '</date_of_Birth><loan_id>1</loan_id><specialisation>' + mapOfInput.get('specialisation') + '</specialisation><type_of_degree>' + mapOfInput.get('type_of_degree') + '</type_of_degree><age>' + mapOfInput.get('age') + '</age><businessVintage>' + mapOfInput.get('businessVintage') + '</businessVintage><hospitalOwnership>' + mapOfInput.get('hospitalOwnership') + '</hospitalOwnership><customer_type>' + mapOfInput.get('customer_type') + '</customer_type><first_Name>' + mapOfInput.get('first_Name') + '</first_Name><last_Name>' + mapOfInput.get('last_Name') + '</last_Name><profession>' + mapOfInput.get('profession') + '</profession></element></Demographic><Loan_Parameter><product>' + mapOfInput.get('product') + '</product><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><approved_Loan_Amount>' + mapOfInput.get('approved_Loan_Amount') + '</approved_Loan_Amount><requested_Loan_Amount>' + mapOfInput.get('requestedLoan') + '</requested_Loan_Amount><program_type>' + mapOfInput.get('program_type') + '</program_type><processType>' + mapOfInput.get('processType') + '</processType><stage>' + mapOfInput.get('stage') + '</stage></Loan_Parameter><CAMS><element><loan_id>1</loan_id><average_Net_Salary>' + mapOfInput.get('average_Net_Salary') + '</average_Net_Salary><final_FOIR>' + mapOfInput.get('final_FOIR') + '</final_FOIR><applicable_FOIR1>' + mapOfInput.get('applicable_FOIR') + '</applicable_FOIR1><average_Monthly_Net_Income1>' + mapOfInput.get('final_FOIR') + '</average_Monthly_Net_Income1><unsecuredExposure>' + mapOfInput.get('unsecuredExposure') + '</unsecuredExposure><totalExposure>' + mapOfInput.get('totalExposure') + '</totalExposure></element></CAMS><Existing_Loan><element><loan_id>1</loan_id><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><number_of_HL_Loans>' + mapOfInput.get('number_of_HL_loans') + '</number_of_HL_Loans><noOfPLEnquiriesIn12M>' + mapOfInput.get('noOfPLEnquiriesIn12M') + '</noOfPLEnquiriesIn12M><noOfPLEnquiriesIn6M>' + mapOfInput.get('noOfPLEnquiriesIn6M') + '</noOfPLEnquiriesIn6M><number_of_live_PL_Loans>' + mapOfInput.get('number_of_live_PL_Loans') + '</number_of_live_PL_Loans></element></Existing_Loan><generic><loan_id>1</loan_id><branch_Type>' + mapOfInput.get('branch_Type') + '</branch_Type><branch_Name>' + mapOfInput.get('branch_Name') + '</branch_Name></generic><profitLossStatement><gross_receipts>' + mapOfInput.get('gross_receipts') + '</gross_receipts></profitLossStatement><Sector_Industries><mrn>' + mapOfInput.get('mrn') + '</mrn><total_exp>' + mapOfInput.get('total_exp') + '</total_exp><networth>' + mapOfInput.get('networth') + '</networth><noOfClients>' + mapOfInput.get('noOfClients') + '</noOfClients></Sector_Industries></input>';*/
    //RSL start
    List < Existing_Loan_Details__c > ExistLoans = new List < Existing_Loan_Details__c > ();
    List < String > existingproducts = new List < String > ();
    List < String > existingAmount = new List < String > ();
    //code added by leena for Engineers program moved this null check code outside
    if (mapOfInput.get('highest_dpd_In_1_year') == null) mapOfInput.put('highest_dpd_In_1_year', '');
    if (mapOfInput.get('unsecured_live_loan_balance') == null) mapOfInput.put('unsecured_live_loan_balance', '');
    if (mapOfInput.get('total_no_of_loans_excl_cc') == null) mapOfInput.put('total_no_of_loans_excl_cc', '');
    if (mapOfInput.get('ratioCCUtil') == null) mapOfInput.put('ratioCCUtil', '');
    if (mapOfInput.get('total_no_of_secured_loans') == null) mapOfInput.put('total_no_of_secured_loans', '');
    if (mapOfInput.get('profession') == null) mapOfInput.put('profession', '');
    if (mapOfInput.get('specialisation') == null) mapOfInput.put('specialisation', '');
    if (mapOfInput.get('type_of_degree') == null) mapOfInput.put('type_of_degree', '');
    if (mapOfInput.get('age') == null) mapOfInput.put('age', '');
    if (mapOfInput.get('businessVintage') == null) mapOfInput.put('businessVintage', '');
    if (mapOfInput.get('hospitalOwnership') == null) mapOfInput.put('hospitalOwnership', '');
    if (mapOfInput.get('customer_type') == null) mapOfInput.put('customer_type', '');
    if (mapOfInput.get('first_Name') == null) mapOfInput.put('first_Name', '');
    if (mapOfInput.get('last_Name') == null) mapOfInput.put('last_Name', '');
    if (mapOfInput.get('program_type') == null) mapOfInput.put('program_type', '');
    if (mapOfInput.get('stage') == null) mapOfInput.put('stage', '');
    if (mapOfInput.get('processType') == null) mapOfInput.put('processType', '');
    if (mapOfInput.get('unsecuredExposure') == null) mapOfInput.put('unsecuredExposure', '');
    if (mapOfInput.get('totalExposure') == null) mapOfInput.put('totalExposure', '');
    if (mapOfInput.get('gross_receipts') == null) mapOfInput.put('gross_receipts', '');
    if (mapOfInput.get('mrn') == null) mapOfInput.put('mrn', '');
    if (mapOfInput.get('total_exp') == null) mapOfInput.put('total_exp', '');
    if (mapOfInput.get('networth') == null) mapOfInput.put('networth', '');
    if (mapOfInput.get('noOfClients') == null) mapOfInput.put('noOfClients', '');
    if (mapOfInput.get('product') == 'RSL') {
      System.debug('map segemntation::' + mapOfInput);
      System.debug('priya>>>' + mapOfInput.get('loan_id'));
      string loanId = mapOfInput.get('loan_id');
      System.debug('priya>>>' + mapOfInput.get('loan_id'));
      Opportunity opp = new Opportunity();
      List < Opportunity > opplist = new List < Opportunity > ();
      System.debug('map loanId::' + loanId);
      if (loanId != null && loanId != '')
        opplist = [select id from Opportunity where Loan_Application_Number__c =: loanId];
      if (opplist.size() > 0) {
        opp = opplist[0];
        ExistLoans = [select id, name, Secured_Unsecured__c, Loan_Type__c, Seen_in__c,
                      Loan_Acc_No__c, Select__c, Applicant__r.ContactName__c, Principal_O_s__c, Status__c,
                      Financer__c, Amount__c, Month1_Amount__c, Month2_Amount__c, Financers__c, Obligation__c,
                      Start_On__c, Tenor__c, Tenor_Left__c, MOB__c, POS__c, EMI__c, Applicant__c, Annual_Obligation__c, Type_of_Oblig__c,
                      Month3Amount__c, Month4Amount__c, Month5Amount__c, Month6Amount__c, Mthly_Oblig__c, EMI_Over_In_Next_6_months__c, Property_Owner__c, Loan_Amount__c, Bank_Account_Name__c, Property_Address__c, Rate_of_Interest__c, City__c, Derived_EMI__c
                      from Existing_Loan_Details__c where Loan_Application__c =: opp.Id order by CreatedDate
                      ];
      }

      if (ExistLoans.size() > 0) {
        Mid_office_BRE_flow__c BRE_Ext = Mid_office_BRE_flow__c.getValues('RSLSegmentationProducts');
        Set < String > extProd = new Set < String > ();
        for (String str: BRE_Ext.RSL_Segmentation_Products__c.split(';')) {
          extProd.add(str.ToUpperCase());
        }
        for (Existing_Loan_Details__c exp: ExistLoans) {
          if (extProd.contains(exp.Loan_Type__c.ToUpperCase())) {
            existingproducts.add(exp.Loan_Type__c);
            if (exp.Loan_Amount__c != null)
              existingAmount.add(String.valueOf(exp.Loan_Amount__c));
          }
        }
      }
    }



    System.debug('date_of_Birth :' + mapOfInput.get('date_of_Birth'));
    ///code added by Leena-13487 Engineering Program start added <post_qualification_exp>'+mapOfInput.get('post_qualification_exp')+'</post_qualification_exp>
    String body = '<input><Cibil_lst><element><unsecuredLoanRatio>' + mapOfInput.get('unsecuredLoanRatio') + '</unsecuredLoanRatio><loan_id>1</loan_id><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><CIBIL_Score>' + mapOfInput.get('CIBIL_Score') + '</CIBIL_Score><highest_dpd_In_1_year>' + mapOfInput.get('highest_dpd_In_1_year') + '</highest_dpd_In_1_year><avg_balance>' + mapOfInput.get('avg_balance') + '</avg_balance><total_no_of_live_trades>' + mapOfInput.get('total_no_of_live_trades') + '</total_no_of_live_trades><ratioUnsecuredToTotalNumberOfLoans>' + mapOfInput.get('ratioUnsecuredToTotalNumberOfLoans') + '</ratioUnsecuredToTotalNumberOfLoans><creditCardUtilization>' + mapOfInput.get('creditCardUtilization') + '</creditCardUtilization><newest_MOB>' + mapOfInput.get('newest_MOB') + '</newest_MOB><secured_sanction_amt>' + mapOfInput.get('secured_sanction_amt') + '</secured_sanction_amt><unsecured_sanction_amt>' + mapOfInput.get('unsecured_sanction_amt') + '</unsecured_sanction_amt><unsecured_loans_in_12_months>' + mapOfInput.get('unsecured_loans_in_12_months') + '</unsecured_loans_in_12_months><oldest_MOB>' + mapOfInput.get('oldest_MOB') + '</oldest_MOB><total_no_of_loan_enquiry_in_3_months>' + mapOfInput.get('total_no_of_loan_enquiry_in_3_months') + '</total_no_of_loan_enquiry_in_3_months><_30PlusTradelinesInLast12Months>' + mapOfInput.get('_30PlusTradelinesInLast12Months') + '</_30PlusTradelinesInLast12Months><total_no_of_loans_excl_cc>' + mapOfInput.get('total_no_of_loans_excl_cc') + '</total_no_of_loans_excl_cc><unsecured_live_loan_balance>' + mapOfInput.get('unsecured_live_loan_balance') + '</unsecured_live_loan_balance><ratioCCUtil>' + mapOfInput.get('ratioCCUtil') + '</ratioCCUtil><total_no_of_secured_loans>' + mapOfInput.get('total_no_of_secured_loans') + '</total_no_of_secured_loans><sumOfAmountOverdue>' + mapOfInput.get('sumOfAmountOverdue') + '</sumOfAmountOverdue></element></Cibil_lst><Demographic><element><profession>' + mapOfInput.get('profession') + '</profession><post_qualification_exp>' + mapOfInput.get('post_qualification_exp') + '</post_qualification_exp><coApplicantFlag>' + mapOfInput.get('coApplicantFlag') + '</coApplicantFlag><residence_Type>' + mapOfInput.get('Residence_Type') + '</residence_Type><applicant_Type>Primary</applicant_Type><company_Category>' + mapOfInput.get('Company_Category') + '</company_Category><company_Type>' + mapOfInput.get('Company_Type') + '</company_Type><educational_Qualification>' + mapOfInput.get('Educational_Qualification') + '</educational_Qualification><office_Email_Id>' + mapOfInput.get('Office_Email_Id') + '</office_Email_Id><current_Employment_Vintage>' + mapOfInput.get('Current_Employment_Vintage') + '</current_Employment_Vintage><total_Employment_Vintage>' + mapOfInput.get('total_Employment_Vintage') + '</total_Employment_Vintage><date_of_Birth>' + mapOfInput.get('date_of_Birth') + '</date_of_Birth><loan_id>1</loan_id><specialisation>' + mapOfInput.get('specialisation') + '</specialisation><type_of_degree>' + mapOfInput.get('type_of_degree') + '</type_of_degree><age>' + mapOfInput.get('age') + '</age><businessVintage>' + mapOfInput.get('businessVintage') + '</businessVintage><hospitalOwnership>' + mapOfInput.get('hospitalOwnership') + '</hospitalOwnership><customer_type>' + mapOfInput.get('customer_type') + '</customer_type><first_Name>' + mapOfInput.get('first_Name') + '</first_Name><last_Name>' + mapOfInput.get('last_Name') + '</last_Name><profession>' + mapOfInput.get('profession') + '</profession></element></Demographic><Loan_Parameter><product>' + mapOfInput.get('product') + '</product><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><approved_Loan_Amount>' + mapOfInput.get('approved_Loan_Amount') + '</approved_Loan_Amount><requested_Loan_Amount>' + mapOfInput.get('requestedLoan') + '</requested_Loan_Amount><program_type>' + mapOfInput.get('program_type') + '</program_type><processType>' + mapOfInput.get('processType') + '</processType><stage>' + mapOfInput.get('stage') + '</stage><application_source>' + mapOfInput.get('application_source') + '</application_source></Loan_Parameter><CAMS><element><net_Salary_for_Month1>' + mapOfInput.get('net_Salary_for_Month1') + '</net_Salary_for_Month1><loan_id>1</loan_id><average_Net_Salary>' + mapOfInput.get('average_Net_Salary') + '</average_Net_Salary><final_FOIR>' + mapOfInput.get('final_FOIR') + '</final_FOIR><applicable_FOIR1>' + mapOfInput.get('applicable_FOIR') + '</applicable_FOIR1><average_Monthly_Net_Income1>' + mapOfInput.get('final_FOIR') + '</average_Monthly_Net_Income1><unsecuredExposure>' + mapOfInput.get('unsecuredExposure') + '</unsecuredExposure><totalExposure>' + mapOfInput.get('totalExposure') + '</totalExposure></element></CAMS>';

    System.debug('existingproducts=' + existingproducts + '=existingAmount=' + existingAmount);
    if (mapOfInput.get('product') == 'RSL') {
      if (existingproducts.size() > 0 && existingAmount.size() > 0) {
        body = body + '<Existing_Loan><element><loan_id>1</loan_id><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><number_of_HL_Loans>' + mapOfInput.get('number_of_HL_loans') + '</number_of_HL_Loans><noOfPLEnquiriesIn12M>' + mapOfInput.get('noOfPLEnquiriesIn12M') + '</noOfPLEnquiriesIn12M><noOfPLEnquiriesIn6M>' + mapOfInput.get('noOfPLEnquiriesIn6M') + '</noOfPLEnquiriesIn6M><number_of_live_PL_Loans>' + mapOfInput.get('number_of_live_PL_Loans') + '</number_of_live_PL_Loans>';
        for (integer i = 0; i < existingproducts.size(); i++) {
          System.debug(existingproducts[i] + '---' + existingAmount[i]);
          body = body + '<existingLoanProduct>' + existingproducts[i] + '</existingLoanProduct><existingLoanAmount>' + existingAmount[i] + '</existingLoanAmount>';
          System.debug('77777');
        }
        body = body + '</element></Existing_Loan>';
        System.debug('8888888');
      }
    }
    //OTP V3 CR added Cibil_lst.unsecuredLoanRatio,CAM.net_Salary_for_Month1,Existing_Loan.securedToTotalRatioAmount,Existing_Loan.liveLoanAmount,Existing_Loan.bankName,Existing_Loan.mob,Existing_Loan.maxDPDEver,Existing_Loan.noOfEnquiriesinLast12Months,Existing_Loan.noofAllLiveLoans,Existing_Loan.noofPLLiveLoans in body - Krish
    else {
      //Rohit added for Bug 21238 start
      String blplRisk = '';
      if (Label.BLPLProducts != null) {
        List < String > prodLst = Label.BLPLProducts.split(';');
        if (prodLst != null && prodLst.contains(mapOfInput.get('product'))) {
          blplRisk = '<BL_PL_risk>' + mapOfInput.get('BL_PL_risk') + '</BL_PL_risk>';
        }
      }

      //Rohit added for Bug 21238 stop
      body = body + '<Existing_Loan><element>' + blplRisk + '<securedToTotalRatioAmount>' + mapOfInput.get('securedToTotalRatioAmount') + '</securedToTotalRatioAmount><liveLoanAmount>' + mapOfInput.get('liveLoanAmount') + '</liveLoanAmount><bankName>' + mapOfInput.get('bankName') + '</bankName><mob>' + mapOfInput.get('mob') + '</mob><maxDPDEver>' + mapOfInput.get('maxDPDEver') + '</maxDPDEver><noOfEnquiriesinLast12Months>' + mapOfInput.get('noOfEnquiriesinLast12Months') + '</noOfEnquiriesinLast12Months><noofAllLiveLoans>' + mapOfInput.get('noofAllLiveLoans') + '</noofAllLiveLoans><noofPLLiveLoans>' + mapOfInput.get('noofPLLiveLoans') + '</noofPLLiveLoans><loan_id>1</loan_id><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><number_of_HL_Loans>' + mapOfInput.get('number_of_HL_loans') + '</number_of_HL_Loans><noOfPLEnquiriesIn12M>' + mapOfInput.get('noOfPLEnquiriesIn12M') + '</noOfPLEnquiriesIn12M><noOfPLEnquiriesIn6M>' + mapOfInput.get('noOfPLEnquiriesIn6M') + '</noOfPLEnquiriesIn6M><number_of_live_PL_Loans>' + mapOfInput.get('number_of_live_PL_Loans') + '</number_of_live_PL_Loans></element></Existing_Loan>';
    }
    /*code added by Leena-13487 Engineering Program start added <College_details><college_name>'+mapOfInput.get('college_name')+'</college_name><college_city>'+mapOfInput.get('college_city')+'</college_city><stream>'+mapOfInput.get('stream')+'</stream></College_details>*/
    body = body + '<generic><loan_id>1</loan_id><branch_Type>' + mapOfInput.get('branch_Type') + '</branch_Type><branch_Name>' + mapOfInput.get('branch_Name') + '</branch_Name></generic><profitLossStatement><gross_receipts>' + mapOfInput.get('gross_receipts') + '</gross_receipts></profitLossStatement><Sector_Industries><mrn>' + mapOfInput.get('mrn') + '</mrn><total_exp>' + mapOfInput.get('total_exp') + '</total_exp><networth>' + mapOfInput.get('networth') + '</networth><noOfClients>' + mapOfInput.get('noOfClients') + '</noOfClients></Sector_Industries><College_details><college_name>' + mapOfInput.get('college_name') + '</college_name><college_city>' + mapOfInput.get('college_city') + '</college_city><stream>' + mapOfInput.get('stream') + '</stream></College_details></input>';

    System.debug('segmentation body:' + body);
    //RSL end

    body = body.replaceAll('null', '');
    // 7515 change body = body.replaceAll('000-1', '0');
    body = body.replaceAll('<CIBIL_Score>000-1</CIBIL_Score>', '<CIBIL_Score>0</CIBIL_Score>');

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL); //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Customer_Segmentation/versions/0.0.1-SNAPSHOT/rules/Customer_Segmentation/customerSegmentation/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    System.debug('*************body: ' + body);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      refNo = root.getattribute('output', null);
      mapOfMCPResult = parseResponse1(root);
    }
    return mapOfMCPResult;


  }

  public MAP < String, String > callBREDeviations(Map < String, String > mapOfInput) {
    if (mapOfInput.get('loan_id') == null) mapOfInput.put('loan_id', '1');
    //String body = '<input><Cibil_lst><element><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><applicant_Type>' + mapOfInput.get('ApplicantType') + '</applicant_Type><CIBIL_Score>' + mapOfInput.get('cibilScore') + '</CIBIL_Score><_30dpd>' + mapOfInput.get('30DPD') + '</_30dpd><smaSubDbtLssValue>' + mapOfInput.get('SMA_SUB_DBT_LSS') + '</smaSubDbtLssValue><loanCardCharges>' + mapOfInput.get('Loan_Card_Charge_Off') + '</loanCardCharges><dedupeCustomerStatus>' + mapOfInput.get('dedupeCustomerStatus') + '</dedupeCustomerStatus><writeOffAmount>' + mapOfInput.get('writeOffAmount') + '</writeOffAmount><unsecuredLoanEnquiryInLast3Months>' + mapOfInput.get('unsecuredLoanEnquiryInLast3Months') + '</unsecuredLoanEnquiryInLast3Months><_30dpd_3_Months>' + mapOfInput.get('_30dpd_3_Months') + '</_30dpd_3_Months><_30dpd_12_Months>' + mapOfInput.get('_30dpd_12_Months') + '</_30dpd_12_Months><write_Off>' + mapOfInput.get('write_Off') + '</write_Off><securedUnsecuredLoanAmount>' + mapOfInput.get('securedUnsecuredLoanAmount') + '</securedUnsecuredLoanAmount><mob>' + mapOfInput.get('mob') + '</mob></element></Cibil_lst><Loan_Parameter><product>' + mapOfInput.get('product') + '</product><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><requested_Loan_Amount>' + mapOfInput.get('requested_Loan_Amt') + '</requested_Loan_Amount><primary_app_bank_acc_no>' + mapOfInput.get('Primary_Bank_ACNumber') + '</primary_app_bank_acc_no><second_bank_acc_no>' + mapOfInput.get('Secondary_Bank_ACNumber') + '</second_bank_acc_no><processType>' + mapOfInput.get('processType') + '</processType><program_type>' + mapOfInput.get('program_type') + '</program_type><approved_Loan_Amount>' + mapOfInput.get('approved_Loan_Amount') + '</approved_Loan_Amount></Loan_Parameter><CAMS><element><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><emiBounceInLast3Months>' + mapOfInput.get('EMIBounce') + '</emiBounceInLast3Months><maxLoanAmountAsPerFoir>' + mapOfInput.get('AmountAsPerFoir') + '</maxLoanAmountAsPerFoir><maxLoanAmountAsPerMultiplier>' + mapOfInput.get('AmountAsPerFoirMultiplier') + '</maxLoanAmountAsPerMultiplier><totalExposure>' + mapOfInput.get('totalExposure') + '</totalExposure></element></CAMS><generic><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><branch_Type>' + mapOfInput.get('branch_Type') + '</branch_Type></generic><Demographic><element><applicant_Type>' + mapOfInput.get('ApplicantType') + '</applicant_Type><office_Email_Id>' + mapOfInput.get('OfficeEmail') + '</office_Email_Id><date_of_Birth>' + mapOfInput.get('date_of_Birth') + '</date_of_Birth><e_mail_ID>' + mapOfInput.get('OfficeEmail') + '</e_mail_ID><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><negativeOfficeVerification>' + mapOfInput.get('OfficeVerification') + '</negativeOfficeVerification><negativeResidenceVerification>' + mapOfInput.get('ResidenceVerification') + '</negativeResidenceVerification><customerType>' + mapOfInput.get('customerType') + '</customerType><customerSegment>' + mapOfInput.get('customerSegment') + '</customerSegment><existingCustomerFlag>' + mapOfInput.get('existingCustomerFlag') + '</existingCustomerFlag><specialization>' + mapOfInput.get('specialization') + '</specialization><typeOfDegree>' + mapOfInput.get('typeOfDegree') + '</typeOfDegree><years_in_business_job>' + mapOfInput.get('years_in_business_job') + '</years_in_business_job><total_Employment_Vintage>' + mapOfInput.get('total_Employment_Vintage') + '</total_Employment_Vintage><coApplicantFlag>' + mapOfInput.get('coApplicantFlag') + '</coApplicantFlag><ownedPropertyFlag>' + mapOfInput.get('ownedPropertyFlag') + '</ownedPropertyFlag><postGradSuperSpeExp>' + mapOfInput.get('postGradSuperSpeExp') + '</postGradSuperSpeExp></element></Demographic><profitLossStatement><cy_total_networth>' + mapOfInput.get('cy_total_networth') + '</cy_total_networth><gross_receipts>' + mapOfInput.get('gross_receipts') + '</gross_receipts></profitLossStatement><existingLoan><element><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><gold_Loans_Amount>' + mapOfInput.get('gold_Loans_Amount') + '</gold_Loans_Amount><unsecuredLoanAmount>' + mapOfInput.get('unsecuredLoanAmount') + '</unsecuredLoanAmount><mortgageLoanAmount>' + mapOfInput.get('mortgageLoanAmount') + '</mortgageLoanAmount></element></existingLoan></input>';
    //SAL Policy Changes Parameter Adding:<deviationType>risk deviation</deviationType><risk_deviation_codes>' + mapOfInput.get('risk_deviation_codes') + '</risk_deviation_codes>
    /*Bug 14503, Auto Deviation Start - Anshita */
    List < Existing_Loan_Details__c > ExistLoans = new List < Existing_Loan_Details__c > ();
    string loanId = mapOfInput.get('loan_id');
    Opportunity opp = new Opportunity();
    List < Opportunity > opplist = new List < Opportunity > ();
    if (loanId != null && loanId != '')
      opplist = [select id, Product__c from Opportunity where Loan_Application_Number__c =: loanId];
    if (opplist.size() > 0) {
      opp = opplist[0];
      if (opp.Product__c != null && opp.Product__c == 'SAL' || opp.Product__c == 'SPL') {
        ExistLoans = [select id, Status__c, name, Loan_Type__c, Financer__c, Financers__c, MOB__c, Applicant__c
                      from Existing_Loan_Details__c where Loan_Application__c =: opp.Id and Loan_Type__c In('PL', 'Personal Loan') and(MOB__c < 3) order by MOB__c limit 1
                      ];
      }
    }
    /*Bug 14503, Auto Deviation End - Anshita */
    //OTP V3 added Demographic.rented_accomodation,Demographic.current_residence_accommodation,Loan_Parameter.requested_tenor,Loan_Parameter.codifiedCibil,Loan_Parameter.negativeArea,Demographic.specialProfile,Loan_Parameter.riskSegmentClassification,Demographic.company_Type in body - Krish
    String body = '<input><Cibil_lst><element><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><applicant_Type>' + mapOfInput.get('ApplicantType') + '</applicant_Type><CIBIL_Score>' + mapOfInput.get('cibilScore') + '</CIBIL_Score><_30dpd>' + mapOfInput.get('30DPD') + '</_30dpd><smaSubDbtLssValue>' + mapOfInput.get('SMA_SUB_DBT_LSS') + '</smaSubDbtLssValue><loanCardCharges>' + mapOfInput.get('Loan_Card_Charge_Off') + '</loanCardCharges><dedupeCustomerStatus>' + mapOfInput.get('dedupeCustomerStatus') + '</dedupeCustomerStatus><writeOffAmount>' + mapOfInput.get('writeOffAmount') + '</writeOffAmount><unsecuredLoanEnquiryInLast3Months>' + mapOfInput.get('unsecuredLoanEnquiryInLast3Months') + '</unsecuredLoanEnquiryInLast3Months><_30dpd_3_Months>' + mapOfInput.get('_30dpd_3_Months') + '</_30dpd_3_Months><_30dpd_12_Months>' + mapOfInput.get('_30dpd_12_Months') + '</_30dpd_12_Months><write_Off>' + mapOfInput.get('write_Off') + '</write_Off><securedUnsecuredLoanAmount>' + mapOfInput.get('securedUnsecuredLoanAmount') + '</securedUnsecuredLoanAmount><mob>' + mapOfInput.get('mob') + '</mob></element></Cibil_lst><Loan_Parameter><requested_tenor>' + mapOfInput.get('requested_tenor') + '</requested_tenor><riskSegmentClassification>' + mapOfInput.get('riskSegmentClassification') + '</riskSegmentClassification><negativeArea>' + mapOfInput.get('negativeArea') + '</negativeArea><codifiedCibil>' + mapOfInput.get('codifiedCibil') + '</codifiedCibil><deviationType>risk deviation</deviationType><risk_deviation_codes>' + mapOfInput.get('risk_deviation_codes') + '</risk_deviation_codes><product>' + mapOfInput.get('product') + '</product><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><requested_Loan_Amount>' + mapOfInput.get('requested_Loan_Amt') + '</requested_Loan_Amount><primary_app_bank_acc_no>' + mapOfInput.get('Primary_Bank_ACNumber') + '</primary_app_bank_acc_no><second_bank_acc_no>' + mapOfInput.get('Secondary_Bank_ACNumber') + '</second_bank_acc_no><processType>' + mapOfInput.get('processType') + '</processType><program_type>' + mapOfInput.get('program_type') + '</program_type><approved_Loan_Amount>' + mapOfInput.get('approved_Loan_Amount') + '</approved_Loan_Amount><stage>' + mapOfInput.get('stage') + '</stage>';
    /* isDomainChecked,btAmount added for Bug 14503 Auto Deviation Start - Anshita*/
    body += '<isDomainChecked>' + mapOfInput.get('isDomainChecked') + '</isDomainChecked><btAmount>' + mapOfInput.get('btAmount') + '</btAmount><type_of_loan>' + mapOfInput.get('type_of_loan') + '</type_of_loan>'; //type_of_loan added for Auto Deviation CR
    /* isDomainChecked,btAmount added for Bug 14503 Auto Deviation End - Anshita*/
    body += '</Loan_Parameter><CAMS><element><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><emiBounceInLast3Months>' + mapOfInput.get('EMIBounce') + '</emiBounceInLast3Months><maxLoanAmountAsPerFoir>' + mapOfInput.get('AmountAsPerFoir') + '</maxLoanAmountAsPerFoir><maxLoanAmountAsPerMultiplier>' + mapOfInput.get('AmountAsPerFoirMultiplier') + '</maxLoanAmountAsPerMultiplier><totalExposure>' + mapOfInput.get('totalExposure') + '</totalExposure>';

    /* final_FOIR,applicable_FOIR1 added for Bug 14503 Auto Deviation Start*/
    body += '<final_FOIR>' + mapOfInput.get('final_FOIR') + '</final_FOIR><applicable_FOIR1>' + mapOfInput.get('applicable_FOIR1') + '</applicable_FOIR1>';
    /* final_FOIR,applicable_FOIR1 added for Bug 14503 Auto Deviation End*/

    body += '</element></CAMS><generic><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><branch_Type>' + mapOfInput.get('branch_Type') + '</branch_Type>';

    /* branch_Name added for Bug 14503 Auto Deviation Start*/
    body += '<branch_Name>' + mapOfInput.get('branch_Name') + '</branch_Name>';
    /* branch_Name added for Bug 14503 Auto Deviation End*/

    body += '</generic><Demographic><element><specialProfile>' + mapOfInput.get('specialProfile') + '</specialProfile><company_Type>' + mapOfInput.get('company_Type') + '</company_Type><current_residence_accommodation>' + mapOfInput.get('current_residence_accommodation') + '</current_residence_accommodation><rented_accommodation>' + mapOfInput.get('rented_accommodation') + '</rented_accommodation><salaryDelay>' + mapOfInput.get('salaryDelay') + '</salaryDelay><current_Employment_Vintage>' + mapOfInput.get('current_Employment_Vintage') + '</current_Employment_Vintage><applicant_Type>' + mapOfInput.get('ApplicantType') + '</applicant_Type><office_Email_Id>' + mapOfInput.get('OfficeEmail') + '</office_Email_Id><date_of_Birth>' + mapOfInput.get('date_of_Birth') + '</date_of_Birth><e_mail_ID>' + mapOfInput.get('OfficeEmail') + '</e_mail_ID><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><negativeOfficeVerification>' + mapOfInput.get('OfficeVerification') + '</negativeOfficeVerification><negativeResidenceVerification>' + mapOfInput.get('ResidenceVerification') + '</negativeResidenceVerification><customerType>' + mapOfInput.get('customerType') + '</customerType><customerSegment>' + mapOfInput.get('customerSegment') + '</customerSegment><existingCustomerFlag>' + mapOfInput.get('existingCustomerFlag') + '</existingCustomerFlag><specialization>' + mapOfInput.get('specialization') + '</specialization><typeOfDegree>' + mapOfInput.get('typeOfDegree') + '</typeOfDegree><years_in_business_job>' + mapOfInput.get('years_in_business_job') + '</years_in_business_job><total_Employment_Vintage>' + mapOfInput.get('total_Employment_Vintage') + '</total_Employment_Vintage><coApplicantFlag>' + mapOfInput.get('coApplicantFlag') + '</coApplicantFlag><ownedPropertyFlag>' + mapOfInput.get('ownedPropertyFlag') + '</ownedPropertyFlag><postGradSuperSpeExp>' + mapOfInput.get('postGradSuperSpeExp') + '</postGradSuperSpeExp><company_Category>' + mapOfInput.get('company_Category') + '</company_Category>';

    if (mapOfInput.get('product') == 'FAS') {
      body += '<borrowerType>' + mapOfInput.get('borrowerType') + '</borrowerType>';
    }

    body += '<first_Name>' + mapOfInput.get('first_Name') + '</first_Name><last_Name>' + mapOfInput.get('last_Name') + '</last_Name>';

    /* residence_Type and dpdClusterSegment added for Bug 14503 Auto Deviation Start*/
    body += '<residence_Type>' + mapOfInput.get('residence_type') + '</residence_Type><dpdClusterSegment>' + mapOfInput.get('dpdClusterSegment') + '</dpdClusterSegment>';
    /* residence_Type and dpdClusterSegment added for Bug 14503 Auto Deviation End*/

    /*Added by Mahima - Ca dedupe- 13017-- start*/
    if (mapOfInput.get('ca_name') != null) {
      body += '<ca_name>' + mapOfInput.get('ca_name') + '</ca_name>';
    }
    if (mapOfInput.get('profession') != null) {
      body += '<profession>' + mapOfInput.get('profession') + '</profession>';
    }

    /*Added by Mahima - Ca dedupe- 13017-- start*/

    body += '<geo_limit>' + mapOfInput.get('geo_limit') + '</geo_limit>'; //Bug 17531 - Rural Geo Fencing

    body += '</element></Demographic><profitLossStatement><cy_total_networth>' + mapOfInput.get('cy_total_networth') + '</cy_total_networth><gross_receipts>' + mapOfInput.get('gross_receipts') + '</gross_receipts>';

    if (mapOfInput.get('product') == 'FAS') {
      body += '<cy_basket_portfolio>' + mapOfInput.get('cy_basket_portfolio') + '</cy_basket_portfolio>';
    }

    body += '</profitLossStatement><existingLoan><element><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><applicant_Type>' + mapOfInput.get('ApplicantType') + '</applicant_Type><gold_Loans_Amount>' + mapOfInput.get('gold_Loans_Amount') + '</gold_Loans_Amount><unsecuredLoanAmount>' + mapOfInput.get('unsecuredLoanAmount') + '</unsecuredLoanAmount><mortgageLoanAmount>' + mapOfInput.get('mortgageLoanAmount') + '</mortgageLoanAmount>';
    /* financierName,loanType,loanStatus,mob added for Bug 14503 Auto Deviation Start*/
    if (ExistLoans != null && ExistLoans.size() > 0) {
      for (integer i = 0; i < ExistLoans.size(); i++) {
        body += '<financierName>' + ((ExistLoans[i].Financers__c != null) ? ExistLoans[i].Financers__c : '') + '</financierName><loanType>' + ((ExistLoans[i].Loan_Type__c != null) ? ExistLoans[i].Loan_Type__c : '') + '</loanType><mob>' + ((ExistLoans[i].MOB__c != null) ? String.Valueof(ExistLoans[i].MOB__c) : '') + '</mob><loanStatus>' + ((ExistLoans[i].Status__c != null) ? ExistLoans[i].Status__c : '') + '</loanStatus>';
      }
    }
    /* financierName,loanType,loanStatus,mob added for Bug 14503 Auto Deviation End*/

    body += '</element></existingLoan></input>';

    body = body.replaceAll('null', '');
    // 7515 change body = body.replaceAll('000-1', '0');
    body = body.replaceAll('<CIBIL_Score>000-1</CIBIL_Score>', '<CIBIL_Score>0</CIBIL_Score>');

    System.debug('*********body: ' + body);
    HttpRequest req = new HttpRequest();
    Mid_office_BRE_flow__c BRE_seg = Mid_office_BRE_flow__c.getValues('BRE Deviation');
    if (BRE_seg != null) {
      // username = BRE_Flow.Username__c;
      //password = BRE_Flow.Password__c;
      endpointURL = '';
      endpointURL = BRE_seg.EndpointURL__c;
    }
    req.setEndpoint(endpointURL);
    //req.setEndpoint('http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Deviations/versions/0.0.1-SNAPSHOT/rules/Deviations/deviationsMain/executions');
    req.setMethod('POST');
    system.debug('body before setting : ' + body);
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      system.debug('request is :: ' + req);
      HTTPResponse res = http.send(req);
      system.debug('res.getBody :: ' + res.getBody());
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      refNo = root.getattribute('output', null);
      mapOfMCPResult = parseResponse1(root);
    }
    return mapOfMCPResult;
  }
  public MAP < String, String > callBREDeviationsBL(Map < String, String > mapOfInput) {

    if (mapOfInput.get('loan_id') == null) mapOfInput.put('loan_id', '1');
    String body = '<input><Cibil_lst><element><applicant_Type>Primary</applicant_Type>';


    /*  if(mapOfInput.get('product') != null && mapOfInput.get('product') == 'FAS'){
      body = body + '<company_Category>' + mapOfInput.get('company_Category') + '</company_Category>';
  }*/

    body = body + '<CIBIL_Score>' + mapOfInput.get('CIBIL_Score') + '</CIBIL_Score><_30dpd>' + mapOfInput.get('_30dpd') + '</_30dpd><loanCardCharges>' + mapOfInput.get('loanCardCharges') + '</loanCardCharges>';
    body = body + '</element></Cibil_lst><Loan_Parameter><product>' + mapOfInput.get('product') + '</product><requested_Loan_Amount>' + mapOfInput.get('requested_Loan_Amount') + '</requested_Loan_Amount><loan_id>' + mapOfInput.get('loan_id') + '</loan_id> </Loan_Parameter><generic></generic><Demographic><element><applicant_Type>Primary</applicant_Type>';

    if (mapOfInput.get('product') != null && mapOfInput.get('product') == 'FAS') {
      body = body + '<company_Category>' + mapOfInput.get('company_Category') + '</company_Category>';
    }
    body = body + '<date_of_Birth>' + mapOfInput.get('date_of_Birth') + '</date_of_Birth>';

    if (mapOfInput.get('product') != null && mapOfInput.get('product') == 'FAS') {
      body = body + '<borrowerType>' + mapOfInput.get('borrowerType') + '</borrowerType>';
    }

    body += '<geo_limit>' + mapOfInput.get('geo_limit') + '</geo_limit>'; //Bug 17531 - Rural Geo Fencing

    body = body + '</element></Demographic><profitLossStatement>';
    body = body + '<py_sales_turnover>' + mapOfInput.get('py_sales_turnover') + '</py_sales_turnover><cy_sales_turnover>' + mapOfInput.get('cy_sales_turnover') + '</cy_sales_turnover><cy_depriciation>' + mapOfInput.get('cy_depriciation') + '</cy_depriciation>';

    if (mapOfInput.get('product') == 'FAS') {
      body = body + '<cy_basket_portfolio>' + mapOfInput.get('cy_basket_portfolio') + '</cy_basket_portfolio>';
    }

    body = body + '</profitLossStatement></input>';

    // Start of MSME BL changes
    String RBLBody;
    if (mapOfInput.get('product') != null && mapOfInput.get('product') == 'RBL') {
      System.debug('<== Inside RBL deviation parameter construction ==>');
      // Start of RBL policy changes
      RBLBody = '<input><generic><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><branch_Type>' + mapOfInput.get('branch_Type') + '</branch_Type><branch_Name>' + mapOfInput.get('branch_Name') + '</branch_Name><branch_Code>' + mapOfInput.get('branch_Code') + '</branch_Code></generic>';
      RBLBody += '<Cibil_lst><element><CIBIL_Score>' + mapOfInput.get('CIBIL_Score') + '</CIBIL_Score><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type></element></Cibil_lst>';
      RBLBody += '<Loan_Parameter><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><product>' + mapOfInput.get('product') + '</product><requested_Loan_Amount>' + mapOfInput.get('requested_Loan_Amount') + '</requested_Loan_Amount><approved_Tenor>' + mapOfInput.get('approved_Tenor') + '</approved_Tenor><requested_tenor>' + mapOfInput.get('requested_tenor') + '</requested_tenor><program_type>' + mapOfInput.get('program_type') + '</program_type></Loan_Parameter>';
      RBLBody += '<profitLossStatement><py_sales_turnover>' + mapOfInput.get('py_sales_turnover') + '</py_sales_turnover><cy_sales_turnover>' + mapOfInput.get('cy_sales_turnover') + '</cy_sales_turnover><py_cash_profit>' + mapOfInput.get('py_cash_profit') + '</py_cash_profit><cy_cash_profit>' + mapOfInput.get('cy_cash_profit') + '</cy_cash_profit><cy_net_profit>' + mapOfInput.get('cy_net_profit') + '</cy_net_profit><py_net_profit>' + mapOfInput.get('py_net_profit') + '</py_net_profit><cy_salary_to_partner>' + mapOfInput.get('cy_salary_to_partner') + '</cy_salary_to_partner><py_salary_to_partner>' + mapOfInput.get('py_salary_to_partner') + '</py_salary_to_partner><cy_interest_to_partner>' + mapOfInput.get('cy_interest_to_partner') + '</cy_interest_to_partner><py_interest_to_partner>' + mapOfInput.get('py_interest_to_partner') + '</py_interest_to_partner><minimum_banking_turnover>' + mapOfInput.get('minimum_banking_turnover') + '</minimum_banking_turnover></profitLossStatement>';
      RBLBody += '<CAMS><element><tenor>' + mapOfInput.get('tenor') + '</tenor><maxLoanAmountAsPerFoir>' + mapOfInput.get('maxLoanAmountAsPerFoir') + '</maxLoanAmountAsPerFoir></element></CAMS>';
      RBLBody += '<Demographic><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><date_of_Birth>' + mapOfInput.get('date_of_Birth') + '</date_of_Birth><business_since>' + mapOfInput.get('business_since') + '</business_since><residence_since>' + mapOfInput.get('residence_since') + '</residence_since><office_type>' + mapOfInput.get('office_type') + '</office_type><residence_Type>' + mapOfInput.get('residence_Type') + '</residence_Type><loanAmount>' + mapOfInput.get('loanAmount') + '</loanAmount></element></Demographic>';
      RBLBody += '<bank_summary><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><avg_OD_CC_utilisation>' + mapOfInput.get('avg_OD_CC_utilisation') + '</avg_OD_CC_utilisation></element></bank_summary></input>';
      body = RBLBody;
      // End of RBL policy changes
    }
    // End of MSME BL changes
    //Code added by Rasika Dated 26 Sep 2016 for Bug 8310 S
    String RDLBody;
    if (mapOfInput.get('product') != null && mapOfInput.get('product') == 'RDL') {

      RDLBody = '<input><generic><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><branch_Type>' + mapOfInput.get('branch_Type') + '</branch_Type><branch_Name>' + mapOfInput.get('branch_Name') + '</branch_Name><branch_Code>' + mapOfInput.get('branch_Code') + '</branch_Code></generic>';
      RDLBody += '<Cibil_lst><element><CIBIL_Score>' + mapOfInput.get('CIBIL_Score') + '</CIBIL_Score><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type></element></Cibil_lst>';
      /* RDLBody += '<Loan_Parameter><product>' + mapOfInput.get('product') + '</product><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><program_type></program_type></Loan_Parameter>';
         RDLBody += '<profitLossStatement><cy_income_as_per_itr>' + mapOfInput.get('cy_income_as_per_itr') + '</cy_income_as_per_itr><gross_receipts>' + mapOfInput.get('gross_receipts') + '</gross_receipts></profitLossStatement>';
         RDLBody += '<CAMS><element><average_Net_Salary>' + mapOfInput.get('average_Net_Salary') + '</average_Net_Salary><average_bank_balance>' + mapOfInput.get('average_bank_balance') + '</average_bank_balance><EMI>' + mapOfInput.get('EMI') + '</EMI></element></CAMS>';
         RDLBody += '<Demographic><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><date_of_Birth>' + mapOfInput.get('date_of_Birth') + '</date_of_Birth><business_since>' + mapOfInput.get('business_since') + '</business_since><residence_since>' + mapOfInput.get('residence_since') + '</residence_since><office_type>' + mapOfInput.get('office_type') + '</office_type><residence_Type>' + mapOfInput.get('residence_Type') + '</residence_Type><loanAmount>' + mapOfInput.get('loanAmount') + '</loanAmount></element></Demographic>';
         RDLBody += '<existingLoan><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><total_home_loan_amount></total_home_loan_amount><total_lap_loan_amount></total_lap_loan_amount><total_auto_loan_amount></total_auto_loan_amount></element> </existingLoan></input>';
       */

      //Added by mahima - 11678- ---Start---
      RDLBody += '<Loan_Parameter><product>' + mapOfInput.get('product') + '</product><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><program_type>' + mapOfInput.get('program_type') + '</program_type></Loan_Parameter>';


      //Added salary_base and salary_base_co in profitLossStatement
      RDLBody += '<profitLossStatement><cy_income_as_per_itr>' + mapOfInput.get('cy_income_as_per_itr') + '</cy_income_as_per_itr><gross_receipts>' + mapOfInput.get('gross_receipts') + '</gross_receipts><salary_base>' + mapOfInput.get('salary_base') + '</salary_base>';
      if (mapOfInput.get('salary_base_co') != null) {
        RDLBody += '<salary_base_co>' + mapOfInput.get('salary_base_co') + '</salary_base_co>';
      }
      if (mapOfInput.get('cy_income_as_per_itr_co') != null) {
        RDLBody += '<cy_income_as_per_itr_co>' + mapOfInput.get('cy_income_as_per_itr_co') + '</cy_income_as_per_itr_co>';
      }
      if (mapOfInput.get('gross_receipts_co') != null) {
        RDLBody += '<gross_receipts_co>' + mapOfInput.get('gross_receipts_co') + '</gross_receipts_co>';
      }

      RDLBody += '</profitLossStatement>';

      RDLBody += '<CAMS><element><average_Net_Salary>' + mapOfInput.get('average_Net_Salary') + '</average_Net_Salary><average_bank_balance>' + mapOfInput.get('average_bank_balance') + '</average_bank_balance><EMI>' + mapOfInput.get('EMI') + '</EMI></element></CAMS>';

      RDLBody += '<Demographic><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><date_of_Birth>' + mapOfInput.get('date_of_Birth') + '</date_of_Birth><business_since>' + mapOfInput.get('business_since') + '</business_since><residence_since>' + mapOfInput.get('residence_since') + '</residence_since><office_type>' + mapOfInput.get('office_type') + '</office_type><residence_Type>' + mapOfInput.get('residence_Type') + '</residence_Type><loanAmount>' + mapOfInput.get('loanAmount') + '</loanAmount>'; //</element></Demographic>';

      RDLBody += '<geo_limit>' + mapOfInput.get('geo_limit') + '</geo_limit>'; //Bug 17531 - Rural Geo Fencing
      RDLBody += '</element></Demographic>'; //Check

      RDLBody += '<existingLoan><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><total_home_loan_amount>' + mapOfInput.get('total_home_loan_amount') + '</total_home_loan_amount><total_lap_loan_amount>' + mapOfInput.get('total_lap_loan_amount') + '</total_lap_loan_amount><total_auto_loan_amount>' + mapOfInput.get('total_auto_loan_amount') + '</total_auto_loan_amount>';
      if (mapOfInput.get('total_home_loan_amount_co') != null) {
        RDLBody += '<total_home_loan_amount_co>' + mapOfInput.get('total_home_loan_amount_co') + '</total_home_loan_amount_co>';
      }

      if (mapOfInput.get('total_auto_loan_amount_co') != null) {
        RDLBody += '<total_auto_loan_amount_co>' + mapOfInput.get('total_auto_loan_amount_co') + '</total_auto_loan_amount_co>';
      }

      if (mapOfInput.get('total_lap_loan_amount_co') != null) {
        RDLBody += '<total_lap_loan_amount_co>' + mapOfInput.get('total_lap_loan_amount_co') + '</total_lap_loan_amount_co>';
      }

      RDLBody += '</element> </existingLoan></input>';

      //Added by mahima - 11678- ---End---
      body = RDLBody;

    }
    //Code added by Rasika Dated 26 Sep 2016 for Bug 8310 E

    // Start of Champion Challenger changes
    /*BUG-16959 added Prod condition for DBOL by Rajesh*/
    if (mapOfInput.get('product') != null && setPSBLProdName.contains(mapOfInput.get('product'))) {
      System.debug('<== Inside PSBL deviation parameter construction ==>');
      String PSBLBody = '<input><Cibil_lst><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><CIBIL_Score>' + mapOfInput.get('CIBIL_Score') + '</CIBIL_Score><_30dpd>' + mapOfInput.get('_30dpd') + '</_30dpd><loanCardCharges>' + mapOfInput.get('loanCardCharges') + '</loanCardCharges></element></Cibil_lst>';
      PSBLBody += '<generic><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><branch_Name>' + mapOfInput.get('branch_Name') + '</branch_Name></generic>';
      PSBLBody += '<Demographic><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><type_of_Constitution>' + mapOfInput.get('type_of_Constitution') + '</type_of_Constitution><first_Name>' + mapOfInput.get('first_Name') + '</first_Name><last_Name>' + mapOfInput.get('last_Name') + '</last_Name><loan_id>' + mapOfInput.get('loan_id') + '</loan_id></element></Demographic>';
      PSBLBody += '<Loan_Parameter><product>' + mapOfInput.get('product') + '</product><requested_Loan_Amount>' + mapOfInput.get('requested_Loan_Amount') + '</requested_Loan_Amount><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><program_type>' + mapOfInput.get('program_type') + '</program_type><financierName>' + mapOfInput.get('financierName') + '</financierName></Loan_Parameter>';
      PSBLBody += '<profitLossStatement><py_sales_turnover>' + mapOfInput.get('py_sales_turnover') + '</py_sales_turnover><cy_sales_turnover>' + mapOfInput.get('cy_sales_turnover') + '</cy_sales_turnover><cy_depriciation>' + mapOfInput.get('cy_depriciation') + '</cy_depriciation></profitLossStatement>';

      //Changes done by Rohan on 05-12-2017 for Banking Scorecard Deviation-Start- 14508
      PSBLBody += '<bank_summary><element><applicant_Type>' + mapOfInput.get('applicant_Type') + '</applicant_Type><avg_OD_CC_utilisation>' + mapOfInput.get('avg_OD_CC_utilisation') + '</avg_OD_CC_utilisation></element></bank_summary></input>';
      //Changes done by Rohan on 05-12-2017 for Banking Scorecard Deviation-End- 14508
      body = PSBLBody;
    }
    // End of Champion Challenger changes

    body = body.replaceAll('null', '');

    List < Mid_office_BRE_flow__c > BRE_FlowList = Mid_office_BRE_flow__c.getall().values();
    if (BRE_FlowList.size() > 0) {
      username = BRE_FlowList[0].Username__c;
      password = BRE_FlowList[0].Password__c;
    }

    username = Mid_office_BRE_flow__c.getValues('BRE Flow').Username__c;
    password = Mid_office_BRE_flow__c.getValues('BRE Flow').Password__c;
    if (Mid_office_BRE_flow__c.getValues('FAS') != null)
      endpointURL = Mid_office_BRE_flow__c.getValues('FAS').EndpointURL__c;


    System.debug('*********body: ' + body);
    HttpRequest req = new HttpRequest();

    if (mapOfInput.get('product') != 'FAS') {
      // Start of MSME BL and Champion Challenger changes    
      if (Mid_office_BRE_flow__c.getValues('BRE Deviation') != null)
        endpointURL = Mid_office_BRE_flow__c.getValues('BRE Deviation').EndpointURL__c;
      req.setEndpoint(endpointURL);
      // End of MSME BL and Champion Challenger changes
    } else {
      req.setEndpoint(endpointURL);
    }

    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('output', null);
      mapOfMCPResult = parseResponseBLDeviation(root);
    }
    return mapOfMCPResult;

  }

  public MAP < String, String > callBREStandardDocuments(Map < String, String > mapOfInput) {

    /*
if (mapOfInput.get('emailConfirmation') == null) mapOfInput.put('emailConfirmation', '');
if (mapOfInput.get('eKYC') == null) mapOfInput.put('eKYC', '');
if (mapOfInput.get('perfios') == null) mapOfInput.put('perfios', '');
if (mapOfInput.get('loan_id') == null) mapOfInput.put('loan_id', '');
     */
    //String body = '<input><Demographic><element><perfiosBankingIntegration>' + mapOfInput.get('perfiosBankingIntegration') + '</perfiosBankingIntegration><customer_segment>' + mapOfInput.get('customer_segment') + '</customer_segment><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><applicant_type>' + mapOfInput.get('ApplicantType') + '</applicant_type><customer_type>' + mapOfInput.get('customer_type') + '</customer_type><perfios>' + mapOfInput.get('perfios') + '</perfios>';
    //body = body + '<eKYC>' + mapOfInput.get('eKYC') + '</eKYC><emailConfirmation>' + mapOfInput.get('emailConfirmation') + '</emailConfirmation><plbtFlag>' + mapOfInput.get('plbtFlag') + '</plbtFlag><rentalIncomeFlag>' + mapOfInput.get('rentalIncomeFlag') + '</rentalIncomeFlag><hlFlag>' + mapOfInput.get('hlFlag') + '</hlFlag><reimbursementFlag>' + mapOfInput.get('reimbursementFlag') + '</reimbursementFlag><loanClosureFlag>' + mapOfInput.get('loanClosureFlag') + '</loanClosureFlag><incentiveFlag>' + mapOfInput.get('incentiveFlag') + '</incentiveFlag><addressMatchWithPrevoiusLoanAddress>' + mapOfInput.get('addressMatchWithPrevoiusLoanAddress') + '</addressMatchWithPrevoiusLoanAddress><coApplicantFlag>' + mapOfInput.get('coApplicantFlag') + '</coApplicantFlag><customerSegment>' + mapOfInput.get('customerSegment') + '</customerSegment><existingCustomerFlag>' + mapOfInput.get('existingCustomerFlag') + '</existingCustomerFlag><constitutionType>'+mapOfInput.get('constitutionType')+'</constitutionType><professionType>'+mapOfInput.get('professionType')+'</professionType><practiceType>'+mapOfInput.get('practiceType')+'</practiceType><type_of_degree>'+mapOfInput.get('type_of_degree')+'</type_of_degree></element></Demographic><Loan_Parameter><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><product>' + mapOfInput.get('product') + '</product><stage>' + mapOfInput.get('stage') + '</stage><processType>' + mapOfInput.get('processType') + '</processType><programType>'+mapOfInput.get('programType')+'</programType><processType>' + mapOfInput.get('processType') + '</processType></Loan_Parameter><generic><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><branch_Type>' + mapOfInput.get('branch_Type') + '</branch_Type></generic></input>';
    //OTP V3 added riskSegmentClassification in body
    //Changed for RSL
    String body = '<input><Demographic><element><riskSegmentClassification>' + mapOfInput.get('riskSegmentClassification') + '</riskSegmentClassification><office_Email_Id>' + mapOfInput.get('office_Email_Id') + '</office_Email_Id><salaryDelay>' + mapOfInput.get('salaryDelay') + '</salaryDelay><coPerfiosFlag>' + mapOfInput.get('coPerfiosFlag') + '</coPerfiosFlag><plusCustomer>' + mapOfInput.get('plusCustomer') + '</plusCustomer><perfiosBankingIntegration>' + mapOfInput.get('perfiosBankingIntegration') + '</perfiosBankingIntegration><customer_segment>' + mapOfInput.get('customer_segment') + '</customer_segment><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><applicant_type>' + mapOfInput.get('ApplicantType') + '</applicant_type><customer_type>' + mapOfInput.get('customer_type') + '</customer_type><perfios>' + mapOfInput.get('perfios') + '</perfios>';
    //Mortgage Re-Engg Change added Baseloan and FullUnderwritting tag
    body = body + '<eKYC>' + mapOfInput.get('eKYC') + '</eKYC><emailConfirmation>' + mapOfInput.get('emailConfirmation') + '</emailConfirmation><plbtFlag>' + mapOfInput.get('plbtFlag') + '</plbtFlag><rentalIncomeFlag>' + mapOfInput.get('rentalIncomeFlag') + '</rentalIncomeFlag><hlFlag>' + mapOfInput.get('hlFlag') + '</hlFlag><reimbursementFlag>' + mapOfInput.get('reimbursementFlag') + '</reimbursementFlag><loanClosureFlag>' + mapOfInput.get('loanClosureFlag') + '</loanClosureFlag><incentiveFlag>' + mapOfInput.get('incentiveFlag') + '</incentiveFlag><addressMatchWithPrevoiusLoanAddress>' + mapOfInput.get('addressMatchWithPrevoiusLoanAddress') + '</addressMatchWithPrevoiusLoanAddress><coApplicantFlag>' + mapOfInput.get('coApplicantFlag') + '</coApplicantFlag><customerSegment>' + mapOfInput.get('customerSegment') + '</customerSegment><existingCustomerFlag>' + mapOfInput.get('existingCustomerFlag') + '</existingCustomerFlag><constitutionType>' + mapOfInput.get('constitutionType') + '</constitutionType><professionType>' + mapOfInput.get('professionType') + '</professionType><practiceType>' + mapOfInput.get('practiceType') + '</practiceType><type_of_degree>' + mapOfInput.get('type_of_degree') + '</type_of_degree><first_name>' + mapOfInput.get('first_name') + '</first_name><last_name>' + mapOfInput.get('last_name') + '</last_name></element></Demographic><Loan_Parameter><baseLoan>' + mapOfInput.get('baseLoan') + '</baseLoan><fullUnderwritingFlag>' + mapOfInput.get('fullUnderwritingFlag') + '</fullUnderwritingFlag><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><product>' + mapOfInput.get('product') + '</product><stage>' + mapOfInput.get('stage') + '</stage><processType>' + mapOfInput.get('processType') + '</processType><programType>' + mapOfInput.get('programType') + '</programType><processType>' + mapOfInput.get('processType') + '</processType><requested_Loan_Amount>' + mapOfInput.get('requested_Loan_Amount') + '</requested_Loan_Amount></Loan_Parameter><bankSummary><element><applicant_type>' + mapOfInput.get('ApplicantType') + '</applicant_type><btBankType>' + mapOfInput.get('btBankType') + '</btBankType></element></bankSummary><generic><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><branch_Type>' + mapOfInput.get('branch_Type') + '</branch_Type></generic><Cibil_lst><element><applicant_Type>' + mapOfInput.get('ApplicantType') + '</applicant_Type><CIBIL_Score>' + mapOfInput.get('CIBIL_Score') + '</CIBIL_Score><_30dpd>' + mapOfInput.get('_30dpd') + '</_30dpd><smaSubDbtLssValue>' + mapOfInput.get('smaSubDbtLssValue') + '</smaSubDbtLssValue></element></Cibil_lst><CAMS><element><totalExposure></totalExposure><loan_id></loan_id><adjusted_Rental_Income></adjusted_Rental_Income><average_Net_Salary></average_Net_Salary><total_Net_Salary></total_Net_Salary><diff_Date_ITRs></diff_Date_ITRs><eligibility_Multiplier_Formula></eligibility_Multiplier_Formula><EMI_on_Proposed_Loan_TO></EMI_on_Proposed_Loan_TO><gross_Salary_Month1></gross_Salary_Month1><gross_Salary_Month2></gross_Salary_Month2><gross_Salary_Month3></gross_Salary_Month3><imputed_Income_Capped_at_50></imputed_Income_Capped_at_50><loan_eligibility></loan_eligibility><max_Loan_Amt_NAS_Multi></max_Loan_Amt_NAS_Multi><net_Salary_for_Month1></net_Salary_for_Month1><proposed_Loan_Amt></proposed_Loan_Amt><rental_Income></rental_Income><sal_MUE_Funding></sal_MUE_Funding><final_FOIR></final_FOIR><tenor></tenor><applicable_FOIR1></applicable_FOIR1><average_Monthly_Net_Income1></average_Monthly_Net_Income1><type_of_CAM_Entity></type_of_CAM_Entity><emiBounceInLast3Months>' + mapOfInput.get('emiBounceInLast3Months') + '</emiBounceInLast3Months><maxLoanAmountAsPerFoir>' + mapOfInput.get('maxLoanAmountAsPerFoir') + '</maxLoanAmountAsPerFoir><maxLoanAmountAsPerMultiplier>' + mapOfInput.get('maxLoanAmountAsPerMultiplier') + '</maxLoanAmountAsPerMultiplier></element></CAMS></input>';


    body = body.replaceAll('null', '');
    // 7515 change body = body.replaceAll('000-1', '0');
    body = body.replaceAll('<CIBIL_Score>000-1</CIBIL_Score>', '<CIBIL_Score>0</CIBIL_Score>');

    System.debug('*********body: ' + body);
    HttpRequest req = new HttpRequest();
    Mid_office_BRE_flow__c BRE_seg = Mid_office_BRE_flow__c.getValues('BRE Documentation');
    if (BRE_seg != null) {
      // username = BRE_Flow.Username__c;
      //password = BRE_Flow.Password__c;
      endpointURL = '';
      endpointURL = BRE_seg.EndpointURL__c;
    }
    req.setEndpoint(endpointURL); //http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Document/versions/0.0.1-SNAPSHOT/rules/Document/documentMain/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('output', null);
      mapOfMCPResult = parseResponse1(root);
    }
    return mapOfMCPResult;
  }

  public MAP < String, String > callBREStandardDocumentsBL(Map < String, String > mapOfInput) {
    if (mapOfInput.get('loan_id') == null) mapOfInput.put('loan_id', '');
    String body = '<input xmlns="http://www.visual-rules.com/vrpath/Document/documentMain/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Demographic><element><customer_segment>' + mapOfInput.get('customer_segment') + '</customer_segment>';
    //Mortgage Re-Engg Change added Baseloan and FullUnderwritting tag and bank summery and btBanktype   
    body = body + '<applicant_type>Primary</applicant_type><customer_type>' + mapOfInput.get('customer_type') + '</customer_type></element></Demographic><Loan_Parameter><stage>' + mapOfInput.get('stage') + '</stage><baseLoan>' + mapOfInput.get('baseLoan') + '</baseLoan><fullUnderwritingFlag>' + mapOfInput.get('fullUnderwritingFlag') + '</fullUnderwritingFlag><product>' + mapOfInput.get('product') + '</product>';
    body = body + '<programType>' + mapOfInput.get('programType') + '</programType><surrogateType>' + mapOfInput.get('surrogateType') + '</surrogateType><lastDoneDate>' + mapOfInput.get('lastDoneDate') + '</lastDoneDate><loan_id>' + mapOfInput.get('loan_id') + '</loan_id></Loan_Parameter><bankSummary><element><applicant_type>' + mapOfInput.get('ApplicantType') + '</applicant_type><btBankType>' + mapOfInput.get('btBankType') + '</btBankType><loan_id>1</loan_id><applicant_id></applicant_id>';
    body = body + '<applicant_type>Primary</applicant_type><isOdccLimitMention>' + mapOfInput.get('isOdccLimitMention') + '</isOdccLimitMention></element></bankSummary></input>';

    body = body.replaceAll('null', '');

    List < Mid_office_BRE_flow__c > BRE_FlowList = Mid_office_BRE_flow__c.getall().values();
    if (BRE_FlowList.size() > 0) {
      username = BRE_FlowList[0].Username__c;
      password = BRE_FlowList[0].Password__c;
    }

    username = Mid_office_BRE_flow__c.getValues('BRE Flow').Username__c;
    password = Mid_office_BRE_flow__c.getValues('BRE Flow').Password__c;
    if (Mid_office_BRE_flow__c.getValues('BRE Documentation') != null)
      endpointURL = Mid_office_BRE_flow__c.getValues('BRE Documentation').EndpointURL__c;
    System.debug('*********body: ' + body);
    HttpRequest req = new HttpRequest();

    req.setEndpoint(endpointURL); //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Document/versions/0.0.1-SNAPSHOT/rules/Document/documentMain/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('output', null);
      mapOfMCPResult = parseResponse1(root);
    }
    return mapOfMCPResult;
  }
  //Verification and telepd
  public MAP < String, String > callBREVerification(Map < String, String > mapOfInput) {
    /*
if (mapOfInput.get('emailConfirmation') == null) mapOfInput.put('emailConfirmation', '');
if (mapOfInput.get('eKYC') == null) mapOfInput.put('eKYC', '');
if (mapOfInput.get('perfios') == null) mapOfInput.put('perfios', '');

if (mapOfInput.get('customer_type') == null) mapOfInput.put('customer_type', '');
if (mapOfInput.get('addressMatchWithPrevoiusLoanAddress') == null) mapOfInput.put('addressMatchWithPrevoiusLoanAddress', '');
if (mapOfInput.get('company_category') == null) mapOfInput.put('company_category', '');
if (mapOfInput.get('average_net_salary') == null) mapOfInput.put('average_net_salary', '');
if (mapOfInput.get('branch_name') == null) mapOfInput.put('branch_name', '');
if (mapOfInput.get('branch_type') == null) mapOfInput.put('branch_type', '');
if (mapOfInput.get('requested_loan_amount') == null) mapOfInput.put('requested_loan_amount', '');
if (mapOfInput.get('number_of_hl_loans') == null) mapOfInput.put('number_of_hl_loans', '');
if (mapOfInput.get('loan_id') == null) mapOfInput.put('loan_id', '');

if (mapOfInput.get('product') == null) mapOfInput.put('product', '');
if (mapOfInput.get('customer_segment') == null) mapOfInput.put('customer_segment', '');
if (mapOfInput.get('stage') == null) mapOfInput.put('stage', '');
if (mapOfInput.get('odccUtilization') == null) mapOfInput.put('odccUtilization', '');
if (mapOfInput.get('cy_sales_turnover') == null) mapOfInput.put('cy_sales_turnover', '');
if (mapOfInput.get('py_sales_turnover') == null) mapOfInput.put('py_sales_turnover', '');
if (mapOfInput.get('odccChange') == null) mapOfInput.put('odccChange', '');
if (mapOfInput.get('primaryBankerChange') == null) mapOfInput.put('primaryBankerChange', '');
if (mapOfInput.get('annualizedBTO') == null) mapOfInput.put('annualizedBTO', '');
if (mapOfInput.get('caChange') == null) mapOfInput.put('caChange', '');
if (mapOfInput.get('caNegative') == null) mapOfInput.put('caNegative', '');
if (mapOfInput.get('differenceInAnnualFilling') == null) mapOfInput.put('differenceInAnnualFilling', '');
if (mapOfInput.get('last3MonthBounce') == null) mapOfInput.put('last3MonthBounce', '');
if (mapOfInput.get('existingBajajHLLAPCustomer') == null) mapOfInput.put('existingBajajHLLAPCustomer', '');
     */
    /*  String body = '<input><Loan_Parameter><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><requested_loan_amount>' + mapOfInput.get('requested_loan_amount') + '</requested_loan_amount><product>' + mapOfInput.get('product') + '</product>';
      body = body + '<programType>'+mapOfInput.get('programType')+'</programType><process_type>'+mapOfInput.get('processType')+'</process_type></Loan_Parameter><Demographic><element><perfiosBankingIntegration>' + mapOfInput.get('perfiosBankingIntegration') + '</perfiosBankingIntegration>';
      body = body + '<customer_segment>' + mapOfInput.get('customer_segment') + '</customer_segment><residence_type>' + mapOfInput.get('residence_type') + '</residence_type><applicant_type>' + mapOfInput.get('applicant_type') + '</applicant_type><company_category>' + mapOfInput.get('company_category') + '</company_category>';
      body = body + '<customer_type>' + mapOfInput.get('customer_type') + '</customer_type><perfios>' + mapOfInput.get('perfios') + '</perfios><eKYC>' + mapOfInput.get('eKYC') + '</eKYC><emailConfirmation>' + mapOfInput.get('emailConfirmation') + '</emailConfirmation><addressMatchWithPrevoiusLoanAddress>' + mapOfInput.get('addressMatchWithPrevoiusLoanAddress') + '</addressMatchWithPrevoiusLoanAddress><existingCustomerFlag>' + mapOfInput.get('existingCustomerFlag') + '</existingCustomerFlag><constitutionType>'+mapOfInput.get('constitutionType')+'</constitutionType><professionType>'+ mapOfInput.get('professionType') +'</professionType><customerSegment>'+mapOfInput.get('customerSegment')+'</customerSegment><practiceType>'+ mapOfInput.get('practiceType') +'</practiceType><type_of_degree>'+ mapOfInput.get('type_of_degree') +'</type_of_degree></element></Demographic><bankSummary><element><applicant_type>' + mapOfInput.get('applicant_type') + '</applicant_type></element></bankSummary>';
      body = body + '<cibli><element><applicant_Type>' + mapOfInput.get('applicant_type') + '</applicant_Type></element></cibli><CAMS><element><average_net_salary>' + mapOfInput.get('average_net_salary') + '</average_net_salary></element></CAMS><Generics><branch_type>' + mapOfInput.get('branch_type') + '</branch_type><branch_name>' + mapOfInput.get('branch_name') + '</branch_name></Generics><existingLoan><element>><applicant_type>' + mapOfInput.get('applicant_type') + '</applicant_type>';
      body = body + '<number_of_hl_loans>' + mapOfInput.get('number_of_hl_loans') + '</number_of_hl_loans></element></existingLoan></input>';
     */

    /*Employee loan verification task ***/
    if (mapOfInput.get('application_source') == null) mapOfInput.put('application_source', '');
    /** end **/

    //Employee Loan Verification (application_source) added
    // verification trigger :: added :: <date_of_birth>' + mapOfInput.get('date_of_birth') + '</date_of_birth>
    // <application_source>' + mapOfInput.get('application_source') + '</application_source>
    //RSL Tier III sal policy added <staying__Since_Year>' + mapOfInput.get('staying__Since_Year') + '</staying__Since_Year> to demographic senction   


    /******
     * @Gaurav: Added lan_creation_date & cibil_address_date to body
     * DG Enhancement: Automated Decision Resi CPV
     * 9 Feb 2017 - Start
     ******/


    String body = '<input><Loan_Parameter><lan_creation_date>' + mapOfInput.get('lan_creation_date') + '</lan_creation_date><application_source>' + mapOfInput.get('application_source') + '</application_source><offer_amount>' + mapOfInput.get('offer_amount') + '</offer_amount><loan_id>' + mapOfInput.get('loan_id') + '</loan_id><requested_loan_amount>' + mapOfInput.get('requested_loan_amount') + '</requested_loan_amount><product>' + mapOfInput.get('product') + '</product>';
    body = body + '<programType>' + mapOfInput.get('programType') + '</programType><process_type>' + mapOfInput.get('processType') + '</process_type><stage>' + mapOfInput.get('stage') + '</stage></Loan_Parameter><Demographic><element><date_of_birth>' + mapOfInput.get('date_of_birth') + '</date_of_birth><plusCustomer>' + mapOfInput.get('plusCustomer') + '</plusCustomer><perfiosBankingIntegration>' + mapOfInput.get('perfiosBankingIntegration') + '</perfiosBankingIntegration>';
    body = body + '<customer_segment>' + mapOfInput.get('customer_segment') + '</customer_segment><residence_type>' + mapOfInput.get('residence_type') + '</residence_type><applicant_type>' + mapOfInput.get('applicant_type') + '</applicant_type><company_category>' + mapOfInput.get('company_category') + '</company_category>';
    body = body + '<customer_type>' + mapOfInput.get('customer_type') + '</customer_type><perfios>' + mapOfInput.get('perfios') + '</perfios><eKYC>' + mapOfInput.get('eKYC') + '</eKYC><emailConfirmation>' + mapOfInput.get('emailConfirmation') + '</emailConfirmation><addressMatchWithPrevoiusLoanAddress>' + mapOfInput.get('addressMatchWithPrevoiusLoanAddress') + '</addressMatchWithPrevoiusLoanAddress><existingCustomerFlag>' + mapOfInput.get('existingCustomerFlag') + '</existingCustomerFlag><constitutionType>' + mapOfInput.get('constitutionType') + '</constitutionType><professionType>' + mapOfInput.get('professionType') + '</professionType><customerSegment>' + mapOfInput.get('customerSegment') + '</customerSegment><practiceType>' + mapOfInput.get('practiceType') + '</practiceType><type_of_degree>' + mapOfInput.get('type_of_degree') + '</type_of_degree><first_name>' + mapOfInput.get('first_name') + '</first_name><last_name>' + mapOfInput.get('last_name') + '</last_name><staying__Since_Year>' + mapOfInput.get('staying__Since_Year') + '</staying__Since_Year></element></Demographic><bankSummary><element><applicant_type>' + mapOfInput.get('applicant_type') + '</applicant_type></element></bankSummary>';
    body = body + '<cibli><element><cibil_address_date>' + mapOfInput.get('cibil_address_date') + '</cibil_address_date><applicant_Type>' + mapOfInput.get('applicant_type') + '</applicant_Type></element></cibli><CAMS><element><average_net_salary>' + mapOfInput.get('average_net_salary') + '</average_net_salary></element></CAMS><Generics><branch_type>' + mapOfInput.get('branch_type') + '</branch_type><branch_name>' + mapOfInput.get('branch_name') + '</branch_name></Generics><existingLoan><element><applicant_type>' + mapOfInput.get('applicant_type') + '</applicant_type>';
    body = body + '<number_of_hl_loans>' + mapOfInput.get('number_of_hl_loans') + '</number_of_hl_loans></element></existingLoan></input>';


    /******
     * @Gaurav: Added lan_creation_date & cibil_address_date to body
     * DG Enhancement: Automated Decision Resi CPV
     * 9 Feb 2017 - End
     ******/

    body = body.replaceAll('null', '');
    // 7515 change body = body.replaceAll('000-1', '0');
    body = body.replaceAll('<CIBIL_Score>000-1</CIBIL_Score>', '<CIBIL_Score>0</CIBIL_Score>');

    System.debug('*********body: ' + body);
    HttpRequest req = new HttpRequest();
    Mid_office_BRE_flow__c BRE_seg = Mid_office_BRE_flow__c.getValues('BRE Verification');
    if (BRE_seg != null) {
      // username = BRE_Flow.Username__c;
      //password = BRE_Flow.Password__c;
      endpointURL = '';
      endpointURL = BRE_seg.EndpointURL__c;
    }
    req.setEndpoint(endpointURL);

    //req.setEndpoint('http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Verifications/versions/0.0.1-SNAPSHOT/rules/Verifications/verificationMain/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('output', null);
      mapOfMCPResult = parseResponse1(root);
    }
    system.debug('result is -->>>> mapOfMCPResult ' + mapOfMCPResult);
    return mapOfMCPResult;
  }
  public MAP < String, String > callBREVerificationBL(Map < String, String > mapOfInput) {
    /*
if (mapOfInput.get('emailConfirmation') == null) mapOfInput.put('emailConfirmation', '');
if (mapOfInput.get('eKYC') == null) mapOfInput.put('eKYC', '');
if (mapOfInput.get('perfios') == null) mapOfInput.put('perfios', '');

if (mapOfInput.get('product') == null) mapOfInput.put('product', '');
if (mapOfInput.get('customer_segment') == null) mapOfInput.put('customer_segment', '');
if (mapOfInput.get('stage') == null) mapOfInput.put('stage', '');
if (mapOfInput.get('odccUtilization') == null) mapOfInput.put('odccUtilization', '');
if (mapOfInput.get('cy_sales_turnover') == null) mapOfInput.put('cy_sales_turnover', '');
if (mapOfInput.get('py_sales_turnover') == null) mapOfInput.put('py_sales_turnover', '');
if (mapOfInput.get('odccChange') == null) mapOfInput.put('odccChange', '');
if (mapOfInput.get('primaryBankerChange') == null) mapOfInput.put('primaryBankerChange', '');
if (mapOfInput.get('annualizedBTO') == null) mapOfInput.put('annualizedBTO', '');
if (mapOfInput.get('caChange') == null) mapOfInput.put('caChange', '');
if (mapOfInput.get('caNegative') == null) mapOfInput.put('caNegative', '');
if (mapOfInput.get('differenceInAnnualFilling') == null) mapOfInput.put('differenceInAnnualFilling', '');
if (mapOfInput.get('last3MonthBounce') == null) mapOfInput.put('last3MonthBounce', '');
if (mapOfInput.get('existingBajajHLLAPCustomer') == null) mapOfInput.put('existingBajajHLLAPCustomer', '');
if (mapOfInput.get('loan_id') == null) mapOfInput.put('loan_id', '1');
     */
    String body = '<input><Loan_Parameter><product>' + mapOfInput.get('product') + '</product><stage>' + mapOfInput.get('stage') + '</stage><caChange>' + mapOfInput.get('caChange') + '</caChange><itReturnFillingPreviousYear>' + mapOfInput.get('itReturnFillingPreviousYear') + '</itReturnFillingPreviousYear><itReturnFillingCurrentYear>' + mapOfInput.get('itReturnFillingCurrentYear') + '</itReturnFillingCurrentYear><loan_id>' + mapOfInput.get('loan_id') + '</loan_id></Loan_Parameter><Demographic><element><customer_segment>' + mapOfInput.get('customer_segment') + '</customer_segment><applicant_type>Primary</applicant_type></element></Demographic><bankSummary><element><applicant_type>Primary</applicant_type><odccChange>' + mapOfInput.get('odccChange') + '</odccChange><primaryBankerChange>' + mapOfInput.get('primaryBankerChange') + '</primaryBankerChange><odccUtilization>' + mapOfInput.get('odccUtilization') + '</odccUtilization>';
    body = body + '</element></bankSummary><profitLossStatement><growthInSalesTurnover>' + mapOfInput.get('growthInSalesTurnover') + '</growthInSalesTurnover></profitLossStatement><cibli><element><applicant_Type>Primary</applicant_Type></element></cibli></input>';

    body = body.replaceAll('null', '');

    System.debug('*********body: ' + body);

    //Added By Mahima- Ip Address Changes-S
    Mid_office_BRE_flow__c BRE_Verification = Mid_office_BRE_flow__c.getValues('BRE Verification');
    if (BRE_Verification != null) {
      username = BRE_Verification.Username__c;
      password = BRE_Verification.Password__c;
      endpointURL = '';
      endpointURL = BRE_Verification.EndpointURL__c;
    }
    //Added By Mahima- Ip Address Changes-S

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Verifications/versions/0.0.1-SNAPSHOT/rules/Verifications/verificationMain/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('*********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('*************root: ' + root);
      refNo = root.getattribute('output', null);
      mapOfMCPResult = parseResponse1(root);
    }
    return mapOfMCPResult;
  }
  //Bug 4326 Crisil
  public Map < String, String > callBREGridMishmatch(MAP < String, String > mapOfGridMismatchParameters) {
    System.debug('*************mapOfGridMismatchParameters: ' + mapOfGridMismatchParameters);
    if (mapOfGridMismatchParameters.get('Sales_Turnover') == null) mapOfGridMismatchParameters.put('Sales_Turnover', '');
    if (mapOfGridMismatchParameters.get('Type_of_Rating') == null) mapOfGridMismatchParameters.put('Type_of_Rating', '');
    String body = '<input><Sales_Turnover>' + mapOfGridMismatchParameters.get('Sales_Turnover') + '</Sales_Turnover> <Type_of_Rating>' + mapOfGridMismatchParameters.get('Type_of_Rating') + '</Type_of_Rating></input>';

    body = body.replaceAll('null', '');
    System.debug('*********body: ' + body);

    //Added By Mahima- Ip Address Changes-S
    Mid_office_BRE_flow__c BREGridMishmatch = Mid_office_BRE_flow__c.getValues('BREGridMishmatch');
    if (BREGridMishmatch != null) {
      username = BREGridMishmatch.Username__c;
      password = BREGridMishmatch.Password__c;
      endpointURL = '';
      endpointURL = BREGridMishmatch.EndpointURL__c;
    }
    //Added By Mahima- Ip Address Changes-S

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Grid_Mismatch/versions/0.0.1-SNAPSHOT/rules/Grid_Mismatch/Grid_Mismatch/Grid_Mismatch/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);

    //String username='DEFAULT\Admin';
    //String password='Admin';

    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    // req.setHeader('Authorization', 'Basic REVGQVVMVFxBZG1pbjpBZG1pbg==');

    Http http = new Http();
    System.debug('*****BRE call start Crisil Changes in Fee and Calling wsdl from BRE:-' + system.now());
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*****BRE call end Crisil Changes in Fee and Calling wsdl from BRE:-' + system.now());
      System.debug('*****req:-' + req.getBody());
      System.debug(res.getBody());
      String result = res.getBody();
      mapOfGridMismatchResult = processResponsetoGridMismatch(result);
    }
    System.debug('*********final****mapOfGridMismatchResult: ' + mapOfGridMismatchResult);

    return mapOfGridMismatchResult;
  }
  public Map < String, String > processResponsetoGridMismatch(String response) {
    String result, refNo;
    System.debug('*************response: ' + response);
    DOM.Document doc = new DOM.Document();
    doc.load(response);
    DOM.XMLNode root = doc.getRootElement();
    System.debug('*************root: ' + root);
    refNo = root.getattribute('output', null);
    result = result + root.getText();
    mapOfGridMismatchResult = parseResponseGridMismatch(root);
    System.debug('*************mapOfGridMismatchResult: ' + mapOfGridMismatchResult);
    return mapOfGridMismatchResult;
  }
  public Map < String, String > parseResponseGridMismatch(DOM.XMLNode root) {
    System.debug('************root ' + root.getChildElements());
    for (Dom.XMLNode obj: root.getChildElements()) {
      System.debug('*************obj: ' + obj);
      System.debug('*************objobj.getName: ' + obj.getName());

      if (obj.getName() == 'TO_Grid_Mismatch_Output') {
        System.debug('****TO_Grid_Mismatch_Output result: ' + obj.getText());
        scoreResultGridMismatch = obj.getText();
        mapOfGridMismatchResult.put('TO_Grid_Mismatch_Output', scoreResultGridMismatch);
      }
    }
    System.debug('*************mapOfGridMismatchResult: ' + mapOfGridMismatchResult);
    return mapOfGridMismatchResult;
  }
  //Bug 4326 Crisil
  public MAP < String, String > callBREForFinancialMCP(Map < String, String > mapOfInput) {
    String body = '<input     xmlns="http://www.visual-rules.com/vrpath/MCP/mcp/"     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">     <loan_parameter>         <product>' + mapOfInput.get('product') + '</product>         <sourcing_channel_type>' + mapOfInput.get('sourcing_channel_type') + '</sourcing_channel_type>         <existing_product>' + mapOfInput.get('existing_product') + '</existing_product>         <offerProduct>' + mapOfInput.get('offerProduct') + '</offerProduct>         <employmentType>' + mapOfInput.get('employmentType') + '</employmentType>         <mcpType>' + mapOfInput.get('mcpType') + '</mcpType>         <type_of_loan>' + mapOfInput.get('type_of_loan') + '</type_of_loan>     </loan_parameter>     <CAMS>         <element>             <BLInLast6MonthsFlag>' + mapOfInput.get('BLInLast6MonthsFlag') + '</BLInLast6MonthsFlag>             <net_Salary_for_Month1>' + mapOfInput.get('net_Salary_for_Month1') + '</net_Salary_for_Month1>         </element>     </CAMS>     <generic_info>         <branch_type>' + mapOfInput.get('branch_type') + '</branch_type>     </generic_info>     <Existing_Loan>         <element>             <monthly_loan_obligations>' + mapOfInput.get('monthly_loan_obligations') + '</monthly_loan_obligations>         </element>     </Existing_Loan>     <demographic>         <element>             <years_in_business_job>' + mapOfInput.get('years_in_business_job') + '</years_in_business_job>             <applicant_type>' + mapOfInput.get('applicant_type') + '</applicant_type>             <customer_type>' + mapOfInput.get('customer_type') + '</customer_type>             <profession>' + mapOfInput.get('profession') + '</profession>             <doctorsFlag>' + mapOfInput.get('doctorsFlag') + '</doctorsFlag>             <specialisation>' + mapOfInput.get('specialisation') + '</specialisation>         </element>     </demographic>     <Cibil_lst>         <element>             <unsecuredLiveLoans>' + mapOfInput.get('unsecuredLiveLoans') + '</unsecuredLiveLoans>         </element>     </Cibil_lst>     <profit_loss_statement>         <py_sales_turnover>' + mapOfInput.get('py_sales_turnover') + '</py_sales_turnover>         <cy_sales_turnover>' + mapOfInput.get('cy_sales_turnover') + '</cy_sales_turnover>         <py_profit_before_tax>' + mapOfInput.get('cy_profit_before_tax') + '</py_profit_before_tax>         <cy_profit_before_tax>' + mapOfInput.get('cy_profit_before_tax') + '</cy_profit_before_tax>     </profit_loss_statement>     <bank_summary>         <element>             <avg_od_cc_utilisation>' + mapOfInput.get('avg_od_cc_utilisation') + '</avg_od_cc_utilisation>             <noOfBounceForBTInLast3months>' + mapOfInput.get('noOfBounceForBTInLast3months') + '</noOfBounceForBTInLast3months>         </element>     </bank_summary> </input>';

    body = body.replaceAll('null', '');

    System.debug('*********body: ' + body);

    //Added By Mahima- Ip Address Changes-S
    Mid_office_BRE_flow__c BREFinancialMCP = Mid_office_BRE_flow__c.getValues('BREFinancialMCP');
    if (BREFinancialMCP != null) {
      username = BREFinancialMCP.Username__c;
      password = BREFinancialMCP.Password__c;
      endpointURL = '';
      endpointURL = BREFinancialMCP.EndpointURL__c;
    }
    //Added By Mahima- Ip Address Changes-S

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/MCP/versions/0.0.1-SNAPSHOT/rules/MCP/mcp/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('RM *********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('RM *************root: ' + root);
      refNo = root.getattribute('RMOutput', null);
      mapOfMCPResult = parseResponseRM(root);
    }
    return mapOfMCPResult;
  }

  public MAP < String, String > callBREForPropertyMCP(Map < String, String > mapOfInput) {

    String body = '<input xmlns="http://www.visual-rules.com/vrpath/MCP/mcp/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><loan_parameter><product>' + mapOfInput.get('product') + '</product><sourcing_channel_type>' + mapOfInput.get('sourcing_channel_type') + '</sourcing_channel_type><offerProduct>' + mapOfInput.get('offerProduct') + '</offerProduct><geoLimitFlag>' + mapOfInput.get('geoLimitFlag') + '</geoLimitFlag><propertyUsedAs>' + mapOfInput.get('propertyUsedAs') + '</propertyUsedAs><employmentType>' + mapOfInput.get('employmentType') + '</employmentType><mcpType>' + mapOfInput.get('mcpType') + '</mcpType></loan_parameter><demographic><element><applicant_type>' + mapOfInput.get('applicant_type') + '</applicant_type><customer_type>' + mapOfInput.get('customer_type') + '</customer_type><profession>' + mapOfInput.get('profession') + '</profession><propertyOwnerType>' + mapOfInput.get('propertyOwnerType') + '</propertyOwnerType><negativeAreaPropertyFlag>' + mapOfInput.get('negativeAreaPropertyFlag') + '</negativeAreaPropertyFlag><propertyOwnerRelationsAsPerPolicyFlag>' + mapOfInput.get('propertyOwnerRelationsAsPerPolicyFlag') + '</propertyOwnerRelationsAsPerPolicyFlag><developerNameFlag>' + mapOfInput.get('developerNameFlag') + '</developerNameFlag><propertyType>' + mapOfInput.get('propertyType') + '</propertyType><noOfBedsInHospital>' + mapOfInput.get('noOfBedsInHospital') + '</noOfBedsInHospital><propertyCity>' + mapOfInput.get('propertyCity') + '</propertyCity><propertyAreaInSQFT>' + mapOfInput.get('propertyAreaInSQFT') + '</propertyAreaInSQFT></element></demographic></input>';
    //String  body = '<input xmlns="http://www.visual-rules.com/vrpath/MCP/mcp/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><loan_parameter><product>'+ mapOfInput.get('product') +'</product><sourcing_channel_type>'+ mapOfInput.get('sourcing_channel_type') +'</sourcing_channel_type><offerProduct>'+ mapOfInput.get('offerProduct') +'</offerProduct><geoLimitFlag>'+ mapOfInput.get('geoLimitFlag') +'</geoLimitFlag><propertyUsedAs>'+ mapOfInput.get('propertyUsedAs') +'</propertyUsedAs><employmentType>'+ mapOfInput.get('employmentType') +'</employmentType><mcpType>'+ mapOfInput.get('mcpType') +'</mcpType></loan_parameter><demographic><element><applicant_type>'+ mapOfInput.get('applicant_type') +'</applicant_type><customer_type>'+ mapOfInput.get('customer_type') +'</customer_type><profession>'+ mapOfInput.get('profession') +'</profession><doctorsFlag>'+ mapOfInput.get('doctorsFlag') +'</doctorsFlag><propertyOwnerType>'+ mapOfInput.get('propertyOwnerType') +'</propertyOwnerType><negativeAreaPropertyFlag>'+ mapOfInput.get('negativeAreaPropertyFlag') +'</negativeAreaPropertyFlag><propertyOwnerRelationsAsPerPolicyFlag>'+ mapOfInput.get('propertyOwnerRelationsAsPerPolicyFlag') +'</propertyOwnerRelationsAsPerPolicyFlag><developerNameFlag>'+ mapOfInput.get('developerNameFlag') +'</developerNameFlag><propertyType>'+ mapOfInput.get('propertyType') +'</propertyType><noOfBedsInHospital>'+ mapOfInput.get('noOfBedsInHospital') +'</noOfBedsInHospital><propertyCity>'+ mapOfInput.get('propertyCity') +'</propertyCity><propertyAreaInSQFT>'+ mapOfInput.get('propertyAreaInSQFT') +'</propertyAreaInSQFT></element></demographic></input>';

    body = body.replaceAll('null', '');
    System.debug('*********body: ' + body);
    //Added by Mahima- IP Changes-- start--
    Mid_office_BRE_flow__c BRE_Property_MCP = Mid_office_BRE_flow__c.getValues('BRE Property MCP');
    if (BRE_Property_MCP != null) {
      username = BRE_Property_MCP.Username__c;
      password = BRE_Property_MCP.Password__c;
      endpointURL = BRE_Property_MCP.EndpointURL__c;
    }
    //Added by Mahima- IP Changes-- end--
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/MCP/versions/0.0.1-SNAPSHOT/rules/MCP/mcp/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      String result = res.getBody();
      System.debug('RM *********result: ' + result);
      DOM.Document doc = new DOM.Document();
      doc.load(result);
      DOM.XMLNode root = doc.getRootElement();
      System.debug('RM *************root: ' + root);
      refNo = root.getattribute('RMOutput', null);
      mapOfMCPResult = parseResponseRM(root);
    }
    return mapOfMCPResult;
  }

  //WA start

  public Map < String, String > callBREWeakAccount(MAP < String, String > mapOfScoreCardParameters) {
    System.debug('*************mapOfScoreCardParameters: ' + mapOfScoreCardParameters);

    if (mapOfScoreCardParameters.get('bounce') == null) mapOfScoreCardParameters.put('bounce', '');
    if (mapOfScoreCardParameters.get('CCODUtilization') == null) mapOfScoreCardParameters.put('CCODUtilization', '');
    if (mapOfScoreCardParameters.get('endUse') == null) mapOfScoreCardParameters.put('endUse', '');
    if (mapOfScoreCardParameters.get('foir') == null) mapOfScoreCardParameters.put('foir', '');
    if (mapOfScoreCardParameters.get('highRiskTrigger') == null) mapOfScoreCardParameters.put('highRiskTrigger', '');
    if (mapOfScoreCardParameters.get('iInwardBounceAcquisition') == null) mapOfScoreCardParameters.put('iInwardBounceAcquisition', '');
    if (mapOfScoreCardParameters.get('ltv') == null) mapOfScoreCardParameters.put('ltv', '');
    if (mapOfScoreCardParameters.get('mob') == null) mapOfScoreCardParameters.put('mob', '');
    if (mapOfScoreCardParameters.get('nob') == null) mapOfScoreCardParameters.put('nob', '');
    if (mapOfScoreCardParameters.get('pdpPendency') == null) mapOfScoreCardParameters.put('pdpPendency', '');
    if (mapOfScoreCardParameters.get('product') == null) mapOfScoreCardParameters.put('product', '');
    if (mapOfScoreCardParameters.get('propertyType') == null) mapOfScoreCardParameters.put('propertyType', '');
    if (mapOfScoreCardParameters.get('smeScorecard') == null) mapOfScoreCardParameters.put('smeScorecard', '');
    if (mapOfScoreCardParameters.get('vintage') == null) mapOfScoreCardParameters.put('vintage', '');
    if (mapOfScoreCardParameters.get('industry') == null) mapOfScoreCardParameters.put('industry', '');


    String body = '<input> <weakAccountInput>  <bounce>' + mapOfScoreCardParameters.get('bounce') + '</bounce> <CCODUtilization>' + mapOfScoreCardParameters.get('CCODUtilization') + '</CCODUtilization> <endUse>' + mapOfScoreCardParameters.get('endUse') + '</endUse> <foir>' + mapOfScoreCardParameters.get('foir') + '</foir> <highRiskTrigger>' + mapOfScoreCardParameters.get('highRiskTrigger') + '</highRiskTrigger> <iInwardBounceAcquisition>' + mapOfScoreCardParameters.get('iInwardBounceAcquisition') + '</iInwardBounceAcquisition> <ltv>' + mapOfScoreCardParameters.get('ltv') + '</ltv> <mob>' + mapOfScoreCardParameters.get('mob') + '</mob> <nob>' + mapOfScoreCardParameters.get('nob') + '</nob> <pdpPendency>' + mapOfScoreCardParameters.get('pdpPendency') + '</pdpPendency> <product>' + mapOfScoreCardParameters.get('product') + '</product> <propertyType>' + mapOfScoreCardParameters.get('propertyType') + '</propertyType> <smeScorecard>' + mapOfScoreCardParameters.get('smeScorecard') + '</smeScorecard> <vintage>' + mapOfScoreCardParameters.get('vintage') + '</vintage> <industry>' + mapOfScoreCardParameters.get('industry') + '</industry> </weakAccountInput></input>';
    //Added by Mahima- IP Changes-- start--
    Mid_office_BRE_flow__c BREWeakAccount = Mid_office_BRE_flow__c.getValues('BREWeakAccount');
    if (BREWeakAccount != null) {
      username = BREWeakAccount.Username__c;
      password = BREWeakAccount.Password__c;
      endpointURL = BREWeakAccount.EndpointURL__c;
    }
    //Added by Mahima- IP Changes-- end--


    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    //'http://138.91.38.234:8087/executionserver/rest/1/ruleServices/WeakAccountScoreCard/versions/0.0.1-SNAPSHOT/rules/WeakAccountScoreCard/weakAccountScoreCard/executions');
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);

    //String username='DEFAULT\Admin';
    //String password='Admin';

    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    // req.setHeader('Authorization', 'Basic REVGQVVMVFxBZG1pbjpBZG1pbg==');

    Http http = new Http();
    System.debug('*****BRE call start Weak Account:-' + system.now());

    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*****BRE call end Weak Account:-' + system.now());
      System.debug('*****req:-' + req.getBody());
      System.debug(res.getBody());
      String result = res.getBody();

      mapOfWeakAccountResult = processResponseWeakAccount(result);
    }
    System.debug('*********final****mapOfWeakAccountResult: ' + mapOfWeakAccountResult);

    return mapOfWeakAccountResult;
  }


  public Map < String, String > processResponseWeakAccount(String response) {
    String result, refNo;
    System.debug('*************response: ' + response);
    DOM.Document doc = new DOM.Document();
    doc.load(response);
    DOM.XMLNode root = doc.getRootElement();
    System.debug('*************root: ' + root);

    refNo = root.getattribute('output', null);

    result = result + root.getText();
    mapOfWeakAccountResult = parseResponseWeakAccount(root);
    System.debug('*************mapOfWeakAccountResult: ' + mapOfWeakAccountResult);

    return mapOfWeakAccountResult;
  }

  public Map < String, String > parseResponseWeakAccount(DOM.XMLNode root) {

    System.debug('************root ' + root.getChildElements());

    for (Dom.XMLNode obj: root.getChildElements()) {
      System.debug('*************obj: ' + obj);
      System.debug('*************objobj.getName: ' + obj.getName());

      if (obj.getName() == 'weakAccountOutput') {
        System.debug('*************objobj.getName: ' + obj.getChildElements());
        for (Dom.XMLNode obj1: obj.getChildElements()) {
          if (obj1.getName() == 'score') {
            System.debug('****score result: ' + obj1.getText());
            scoreResult = obj1.getText();
            mapOfWeakAccountResult.put('Score', scoreResult);
          }

          if (obj1.getName() == 'riskClassification') {
            System.debug('****riskClassification result: ' + obj1.getText());
            scoreResult = obj1.getText();
            mapOfWeakAccountResult.put('RiskClassification', scoreResult);
          }
        }

      }
    }

    System.debug('*************mapOfWeakAccountResult: ' + mapOfWeakAccountResult);

    return mapOfWeakAccountResult;

  }

  //WA end
  //OPEN ECS
  public static Map < string, string > RestAPICallForOpenECS(String body) {
    System.debug('body---' + body);
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
    Map < string, string > parsedResponseMap = new Map < string, string > ();
    req.setEndpoint(label.OpenECSEndpoint);
    req.setMethod('POST');
    req.setBody(body);
    try {
      if (!Test.isRunningTest()) {
        res = http.send(req);
      }
      String result = res.getBody();
      System.debug('Response:--' + res);
      System.debug('result---' + result);
      parsedResponseMap = parseResponse(result);
      System.debug('parsedResponseMap---' + parsedResponseMap);

    } catch (System.CalloutException e) {
      System.debug('Callout error: ' + e);
      System.debug(res.toString());
    }
    return parsedResponseMap;
  }

  private static Map < string, string > parseResponse(String result) {
    JSONParser parser = JSON.createParser(result);
    Map < string, string > responseMap = new Map < string, string > ();
    while (parser.nextToken() != null) {
      if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
        String fieldName = parser.getText();
        parser.nextToken();
        responseMap.put(fieldName, parser.getText());
      }
    }
    return responseMap;
  }

  //SAL IM Sampling change start
  public Map < String, String > SamplingBRECall(MAP < String, String > mapOfInvisibleMonitoringParams) {
    Map < String, String > mapOfResults;

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeFieldName('loanParameter');
    gen.writeStartObject();
    gen.writeStringField('loan_id', mapOfInvisibleMonitoringParams.get('loan_id') != null ? mapOfInvisibleMonitoringParams.get('loan_id') : '');
    //gen.writeStringField('product', mapOfInvisibleMonitoringParams.get('product') != null ? mapOfInvisibleMonitoringParams.get('product') : '');
    gen.writeStringField('product', 'SAL');
    gen.writeEndObject();

    gen.writeFieldName('cibil');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeStringField('applicant_Type', mapOfInvisibleMonitoringParams.get('applicant_Type') != null ? mapOfInvisibleMonitoringParams.get('applicant_Type') : 'Primary');
    gen.writeNumberField('total_no_of_loans_excl_cc', mapOfInvisibleMonitoringParams.get('total_no_of_loans_excl_cc') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('total_no_of_loans_excl_cc')) : 0);
    gen.writeNumberField('CIBIL_Score', mapOfInvisibleMonitoringParams.get('CIBIL_Score') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('CIBIL_Score')) : 0);
    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('demographic');
    gen.writeStartArray();
    gen.writeStartObject();
    System.debug('rohit36 ' + mapOfInvisibleMonitoringParams.get('company_type'));
    gen.writeStringField('applicant_Type', mapOfInvisibleMonitoringParams.get('applicant_Type') != null ? mapOfInvisibleMonitoringParams.get('applicant_Type') : 'Primary');
    gen.writeStringField('company_Type', mapOfInvisibleMonitoringParams.get('company_Type') != null ? mapOfInvisibleMonitoringParams.get('company_Type') : '');
    //gen.writeNumberField('current_Employment_Vintage', mapOfInvisibleMonitoringParams.get('current_Employment_Vintage') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('current_Employment_Vintage')) : 0);
    System.debug('mapOfInvisibleMonitoringParams' + mapOfInvisibleMonitoringParams.get('businessVintage'));
    gen.writeNumberField('businessVintage', mapOfInvisibleMonitoringParams.get('businessVintage') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('businessVintage')) : 0);
    gen.writeStringField('PAN', mapOfInvisibleMonitoringParams.get('PAN') != null ? mapOfInvisibleMonitoringParams.get('PAN') : '');
    System.debug('rohit39 ' + mapOfInvisibleMonitoringParams.get('total_Employment_Vintage'));
    gen.writeNumberField('total_Employment_Vintage', mapOfInvisibleMonitoringParams.get('total_Employment_Vintage') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('total_Employment_Vintage')) : 0);
    gen.writeNumberField('current_Employment_Vintage', mapOfInvisibleMonitoringParams.get('current_Employment_Vintage') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('current_Employment_Vintage')) : 0);
    gen.writeStringField('residence_Type', mapOfInvisibleMonitoringParams.get('residence_type'));
    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('generic');
    gen.writeStartObject();
    gen.writeStringField('loan_id', mapOfInvisibleMonitoringParams.get('loan_id') != null ? mapOfInvisibleMonitoringParams.get('loan_id') : '');
    gen.writeStringField('branch_Type', mapOfInvisibleMonitoringParams.get('branch_Type') != null ? mapOfInvisibleMonitoringParams.get('branch_Type') : 'Tier I');
    gen.writeEndObject();

    gen.writeFieldName('cam');
    gen.writeStartObject();
    gen.writeNumberField('net_Salary_for_Month1', mapOfInvisibleMonitoringParams.get('net_Salary_for_Month1') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('net_Salary_for_Month1')) : 0);
    gen.writeEndObject();

    gen.writeFieldName('existingLoan');
    gen.writeStartArray();
    gen.writeStartObject();
    //SAL IM rohit 13479 & 13483 start      
    gen.writeNumberField('noofMortgageLoan', mapOfInvisibleMonitoringParams.get('noofMortgageLoan') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('noofMortgageLoan')) : 0);
    gen.writeNumberField('mortgageLoanAmt', mapOfInvisibleMonitoringParams.get('mortgageLoanAmt') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('mortgageLoanAmt')) : 0);
    //SAL IM rohit 13479 & 13483 end
    gen.writeStringField('applicant_Type', mapOfInvisibleMonitoringParams.get('applicant_type') != null ? mapOfInvisibleMonitoringParams.get('applicant_type') : '');
    //gen.writeNumberField('CIBIL_Score', mapOfInvisibleMonitoringParams.get('CIBIL_Score') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('CIBIL_Score')) : 0);
    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeEndObject();
    String jsonString = gen.getAsString();
    Mid_office_BRE_flow__c BRE_Samp = Mid_office_BRE_flow__c.getValues('BRE_Sampling');
    if (BRE_Samp != null) {
      //endpointURL = 'http://52.172.206.229:8087/executionserver/rest/1/ruleServices/Sampling_Process/versions/0.0.1-SNAPSHOT/rules/Sampling_Process/SamplingMain/executions';
      endpointURL = BRE_Samp.EndpointURL__c;
      //username = 'DEFAULT\\Admin';
      //password = 'Admin';
      username = BRE_Samp.Username__c;
      password = BRE_Samp.Password__c;

    }
    //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/Verifications/versions/0.0.1-SNAPSHOT/rules/Verifications/verificationMain/executions';
    System.debug('********Endpoint for IM********' + endpointURL);
    System.debug('********Username for IM********' + username);
    System.debug('********Passowrd for IM********' + password);
    System.debug('jsonstring' + jsonString);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res;
    if (!Test.isRunningTest()) {
      res = http.send(req);
      if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
        // Proper Response
        System.debug('Request -----> ' + req.getBody());
        String result = res.getBody();
        System.debug('Result ----->' + result);
        //mapOfResults = parseResponseForIM(result);
        mapOfResults = parseResponseForSampling(result);
        System.debug('Map of result -----> ' + mapOfResults);
      } else {
        // Error in getting response
        System.debug('<-----CONNECTION ERROR----->');
      }
    }
    return mapOfResults;
  }


  //SAL IM Sampling change end

  // Start of invisible monitoring changes
  public Map < String, String > remoteInvisibleMonitoringCheck(MAP < String, String > mapOfInvisibleMonitoringParams) {

    Map < String, String > mapOfResults;
    String jsonString;
    try {
      JSONGenerator gen = JSON.createGenerator(true);

      gen.writeStartObject();
      gen.writeFieldName('Loan_Parameter');
      gen.writeStartObject();
      //Invisible monitoring mortgage Anjali-start
      // if(Mortgageflag)
      //  {    
      //  gen.writeStringField('pincode_mismatch__in_cibil', mapOfInvisibleMonitoringParams.get('pincode_mismatch__in_cibil') != null ? mapOfInvisibleMonitoringParams.get('pincode_mismatch__in_cibil') : '');
      //  gen.writeStringField('cy_total_assets', mapOfInvisibleMonitoringParams.get('cy_total_assets') != null ? mapOfInvisibleMonitoringParams.get('loan_id') : '');
      //  }
      //Invisible monitoring mortgage Anjali-end
      gen.writeStringField('loan_id', mapOfInvisibleMonitoringParams.get('loan_id') != null ? mapOfInvisibleMonitoringParams.get('loan_id') : '');

      gen.writeNumberField('reqested_roi', mapOfInvisibleMonitoringParams.get('reqested_roi') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('reqested_roi')) : 0);

      gen.writeStringField('product', mapOfInvisibleMonitoringParams.get('product') != null ? mapOfInvisibleMonitoringParams.get('product') : '');

      //Chetan Mortgage IM Start
      gen.writeStringField('invisibleMonitoringProduct', mapOfInvisibleMonitoringParams.get('invisibleMonitoringProduct') != null ? mapOfInvisibleMonitoringParams.get('invisibleMonitoringProduct') : '');
      gen.writeStringField('baseProduct', mapOfInvisibleMonitoringParams.get('baseProduct') != null ? mapOfInvisibleMonitoringParams.get('baseProduct') : '');
      gen.writeStringField('green_channel_flag', mapOfInvisibleMonitoringParams.get('green_channel_flag') != null ? mapOfInvisibleMonitoringParams.get('green_channel_flag') : '');
      //Chetan Mortgage IM End

      gen.writeStringField('programType', mapOfInvisibleMonitoringParams.get('programType') != null ? mapOfInvisibleMonitoringParams.get('programType') : ''); // Bug 23129 -- added parameter of Program_type 


      gen.writeStringField('groupCode', mapOfInvisibleMonitoringParams.get('groupCode') != null ? mapOfInvisibleMonitoringParams.get('groupCode') : '');
      gen.writeStringField('type_of_loan', mapOfInvisibleMonitoringParams.get('type_of_loan') != null ? mapOfInvisibleMonitoringParams.get('type_of_loan') : '');
      gen.writeStringField('FRNnumber', mapOfInvisibleMonitoringParams.get('FRNnumber') != null ? mapOfInvisibleMonitoringParams.get('FRNnumber') : '');
      // invisible monitoring for dl by akshata start 25th july 2016
      gen.writeStringField('invisibleMonitoringProduct', mapOfInvisibleMonitoringParams.get('invisibleMonitoringProduct') != null ? mapOfInvisibleMonitoringParams.get('invisibleMonitoringProduct') : '');
      gen.writeNumberField('offer_amount', mapOfInvisibleMonitoringParams.get('offer_amount') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('offer_amount')) : 0);
      gen.writeNumberField('requested_loan_amount', mapOfInvisibleMonitoringParams.get('requested_loan_amount') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('requested_loan_amount')) : 0);
      gen.writeStringField('verificationCode', mapOfInvisibleMonitoringParams.get('verificationCode') != null ? mapOfInvisibleMonitoringParams.get('verificationCode') : '');
      gen.writeStringField('sourcingChannelFlag', mapOfInvisibleMonitoringParams.get('sourcingChannelFlag') != null ? mapOfInvisibleMonitoringParams.get('sourcingChannelFlag') : '');
      gen.writeStringField('scheme_invisible_code', mapOfInvisibleMonitoringParams.get('scheme_invisible_code') != null ? mapOfInvisibleMonitoringParams.get('scheme_invisible_code') : '');
      //invisible monitoring for dl by akshata end
      //System.debug('---mapOfInvisibleMonitoringParams.get(totalEMI)---' + mapOfInvisibleMonitoringParams.get('totalEMI'));
      //System.debug('---double.valueOf(mapOfInvisibleMonitoringParams.get(approved_rate))---'+double.valueOf(mapOfInvisibleMonitoringParams.get('approved_rate')));
      gen.writeNumberField('approved_rate', mapOfInvisibleMonitoringParams.get('approved_rate') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('approved_rate')) : 0);

      gen.writeStringField('decision_date', mapOfInvisibleMonitoringParams.get('decision_date') != null ? mapOfInvisibleMonitoringParams.get('decision_date') : '');
      gen.writeNumberField('approved_loan_amount', mapOfInvisibleMonitoringParams.get('approved_loan_amount') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('approved_loan_amount')) : 0);
      gen.writeStringField('stage', mapOfInvisibleMonitoringParams.get('stage') != null ? mapOfInvisibleMonitoringParams.get('stage') : '');
      gen.writeNumberField('totalEMI', CommonUtility.isEmpty(mapOfInvisibleMonitoringParams.get('totalEMI')) != true ? Double.valueOf(mapOfInvisibleMonitoringParams.get('totalEMI')) : 0);
      gen.writeStringField('loanApplicationName', mapOfInvisibleMonitoringParams.get('loanApplicationName') != null ? mapOfInvisibleMonitoringParams.get('loanApplicationName') : '');
      gen.writeStringField('scheme_name', mapOfInvisibleMonitoringParams.get('scheme_name') != null ? mapOfInvisibleMonitoringParams.get('scheme_name') : '');
      gen.writeStringField('sourcingChannelMobile', mapOfInvisibleMonitoringParams.get('sourcingChannelMobile') != null ? mapOfInvisibleMonitoringParams.get('sourcingChannelMobile') : '');

      gen.writeNumberField('premiumAmount', mapOfInvisibleMonitoringParams.get('premiumAmount') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('premiumAmount')) : 0.0);



      gen.writeStringField('sourcingChannel', mapOfInvisibleMonitoringParams.get('sourcingChannel') != null ? mapOfInvisibleMonitoringParams.get('sourcingChannel') : '');
      gen.writeBooleanField('riskyDSA', (mapOfInvisibleMonitoringParams.get('riskyDSA') != null) ? (mapOfInvisibleMonitoringParams.get('riskyDSA') == 'true' ? true : false) : false);


      gen.writeNumberField('maximumSanctionedAmount', mapOfInvisibleMonitoringParams.get('maximumSanctionedAmount') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('maximumSanctionedAmount')) : 0.0);
      // Added by Chetan 03-Jan-2017 S
      gen.writeStringField('baseProductProgram', mapOfInvisibleMonitoringParams.get('baseProductProgram') != null ? mapOfInvisibleMonitoringParams.get('baseProductProgram') : '');
      gen.writeStringField('sourcingChannelFlag', mapOfInvisibleMonitoringParams.get('sourcingChannelFlag') != null ? mapOfInvisibleMonitoringParams.get('sourcingChannelFlag') : '');

      // Added by Chetan 03-Jan-2017 E

      /* Added By Ankush - Bug ID 14128 start */
      gen.writeStringField('cmr_score', mapOfInvisibleMonitoringParams.get('cmr_score') != null ? mapOfInvisibleMonitoringParams.get('cmr_score') : '');
      /* Added By Ankush - Bug ID 14128 End */

      gen.writeEndObject();

      gen.writeFieldName('Demographic');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeStringField('type_of_constitution', mapOfInvisibleMonitoringParams.get('type_of_constitution') != null ? mapOfInvisibleMonitoringParams.get('type_of_constitution') : '');
      gen.writeStringField('constitutionType', mapOfInvisibleMonitoringParams.get('constitutionType') != null ? mapOfInvisibleMonitoringParams.get('constitutionType') : '');
      //Rohit Bug 13399 start
      gen.writeStringField('customer_category', mapOfInvisibleMonitoringParams.get('customer_category') != null ? mapOfInvisibleMonitoringParams.get('customer_category') : '');

      // Added By Ankush Provided PSBL Product condition for total_employment_vintage 
      /* Changed By Ankush Bug 16588 - Invalid Score Stamping for Invisible Monitoring RANDOM call */

      if (mapOfInvisibleMonitoringParams.get('invisibleMonitoringProduct') != null && mapOfInvisibleMonitoringParams.get('invisibleMonitoringProduct').equalsIgnoreCase('PSBL'))
        gen.writeNumberField('total_employment_vintage', mapOfInvisibleMonitoringParams.get('total_employment_vintage') != null ? Decimal.valueOf(mapOfInvisibleMonitoringParams.get('total_employment_vintage')) : 0);
      else {
        //Rohit Bug 13399 end
        gen.writeNumberField('total_employment_vintage', mapOfInvisibleMonitoringParams.get('total_Employment_Vintage') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('total_Employment_Vintage')) : 0);
      }

      //Mortgage Feb changes S
      gen.writeNumberField('current_employment_vintage', mapOfInvisibleMonitoringParams.get('current_employment_vintage') != null ? Decimal.valueOf(mapOfInvisibleMonitoringParams.get('current_employment_vintage')) : 0);

      //Mortgage Feb changes S

      // Added by Chetan 03-Jan-2017 S
      //system.debug('---total_employment_vintageHL---' + mapOfInvisibleMonitoringParams.get('total_employment_vintageHL'));
      gen.writeNumberField('total_employment_vintageHL', mapOfInvisibleMonitoringParams.get('total_employment_vintageHL') != null ? decimal.valueOf(mapOfInvisibleMonitoringParams.get('total_employment_vintageHL')) : 0);
      // Added by Chetan 03-Jan-2017 E


      //Added by Anjali-new parameter for SHL and SHOL Product

      gen.writeNumberField('years_in_business_job', mapOfInvisibleMonitoringParams.get('years_in_business_job') != null ? Integer.valueOf(mapOfInvisibleMonitoringParams.get('years_in_business_job')) : 0);
      gen.writeStringField('residence_type', mapOfInvisibleMonitoringParams.get('residence_type') != null ? mapOfInvisibleMonitoringParams.get('residence_type') : '');
      gen.writeStringField('nature_of_business', mapOfInvisibleMonitoringParams.get('nature_of_business') != null ? mapOfInvisibleMonitoringParams.get('nature_of_business') : '');
      gen.writeStringField('industry', mapOfInvisibleMonitoringParams.get('industry') != null ? mapOfInvisibleMonitoringParams.get('industry') : '');
      gen.writeStringField('industrySector', mapOfInvisibleMonitoringParams.get('industrySector') != null ? mapOfInvisibleMonitoringParams.get('industrySector') : '');
      gen.writeStringField('mainIndustry', mapOfInvisibleMonitoringParams.get('mainIndustry') != null ? mapOfInvisibleMonitoringParams.get('mainIndustry') : '');
      gen.writeStringField('sub_industry', mapOfInvisibleMonitoringParams.get('sub_industry') != null ? mapOfInvisibleMonitoringParams.get('sub_industry') : '');

      gen.writeStringField('applicant_type', mapOfInvisibleMonitoringParams.get('applicant_type') != null ? mapOfInvisibleMonitoringParams.get('applicant_type') : '');

      gen.writeStringField('pdType', mapOfInvisibleMonitoringParams.get('pdType') != null ? mapOfInvisibleMonitoringParams.get('pdType') : '');


      gen.writeStringField('existingCustomerFlag', mapOfInvisibleMonitoringParams.get('existingCustomerFlag') == 'true' ? 'true' : 'false');

      gen.writeStringField('pan', mapOfInvisibleMonitoringParams.get('pan') != null ? mapOfInvisibleMonitoringParams.get('pan') : '');

      gen.writeNumberField('SMEScore', mapOfInvisibleMonitoringParams.get('SMEScore') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('SMEScore')) : 0);
      gen.writeStringField('customer_segment', mapOfInvisibleMonitoringParams.get('customer_segment') != null ? mapOfInvisibleMonitoringParams.get('customer_segment') : '');
      gen.writeStringField('customer_type', mapOfInvisibleMonitoringParams.get('customer_type') != null ? mapOfInvisibleMonitoringParams.get('customer_type') : '');

      gen.writeStringField('residence_city', mapOfInvisibleMonitoringParams.get('residence_city') != null ? mapOfInvisibleMonitoringParams.get('residence_city') : '');
      gen.writeBooleanField('existingCDCustFlag', (mapOfInvisibleMonitoringParams.get('existingCDCustFlag') == 'true') ? true : false);
      gen.writeBooleanField('existingBLCustFlag', (mapOfInvisibleMonitoringParams.get('existingBLCustFlag') == 'true') ? true : false);


      //invisible monitoring for dl by akshata 30th june 2016 start
      gen.writeStringField('first_name', mapOfInvisibleMonitoringParams.get('first_name') != null ? mapOfInvisibleMonitoringParams.get('first_name') : '');
      gen.writeStringField('last_name', mapOfInvisibleMonitoringParams.get('last_name') != null ? mapOfInvisibleMonitoringParams.get('last_name') : '');
      gen.writeNumberField('years_in_business_job', mapOfInvisibleMonitoringParams.get('years_in_business_job') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('years_in_business_job')) : 0);
      gen.writeStringField('date_of_birth', mapOfInvisibleMonitoringParams.get('date_of_birth') != null ? mapOfInvisibleMonitoringParams.get('date_of_birth') : '');
      gen.writeStringField('type_of_degree', mapOfInvisibleMonitoringParams.get('type_of_degree') != null ? mapOfInvisibleMonitoringParams.get('type_of_degree') : '');
      gen.writeStringField('residence_ownership', mapOfInvisibleMonitoringParams.get('residence_ownership') != null ? mapOfInvisibleMonitoringParams.get('residence_ownership') : '');
      gen.writeStringField('officeOwnership', mapOfInvisibleMonitoringParams.get('officeOwnership') != null ? mapOfInvisibleMonitoringParams.get('officeOwnership') : '');
      gen.writeStringField('officeMismatchWithCibil', mapOfInvisibleMonitoringParams.get('officeMismatchWithCibil') != null ? mapOfInvisibleMonitoringParams.get('officeMismatchWithCibil') : '');
      gen.writeStringField('mobileMismatchWithCibil', mapOfInvisibleMonitoringParams.get('mobileMismatchWithCibil') != null ? mapOfInvisibleMonitoringParams.get('mobileMismatchWithCibil') : '');
      gen.writeStringField('residenceMismatchWithCibil', mapOfInvisibleMonitoringParams.get('residenceMismatchWithCibil') != null ? mapOfInvisibleMonitoringParams.get('residenceMismatchWithCibil') : '');
      gen.writeStringField('numberOf30DpdTradeLine', mapOfInvisibleMonitoringParams.get('numberOf30DpdTradeLine') != null ? mapOfInvisibleMonitoringParams.get('numberOf30DpdTradeLine') : '');

      //Chetan Mortgage IM Start
      gen.writeStringField('residence_ownership', mapOfInvisibleMonitoringParams.get('residence_ownership') != null ? mapOfInvisibleMonitoringParams.get('residence_ownership') : '');
      gen.writeStringField('customer_category', mapOfInvisibleMonitoringParams.get('customer_category') != null ? mapOfInvisibleMonitoringParams.get('customer_category') : '');
      gen.writeStringField('address_change_flag', mapOfInvisibleMonitoringParams.get('address_change_flag') != null ? mapOfInvisibleMonitoringParams.get('address_change_flag') : '');
      //Chetan Mortgage IM End
      //Mahima Gandhe Mortgage IM Start  
      gen.writeStringField('company_category', mapOfInvisibleMonitoringParams.get('company_category') != null ? mapOfInvisibleMonitoringParams.get('company_category') : '');
      //Mahima Gandhe Mortgage IM End

      /* Added By Ankush - Bug ID 14128 start */
      gen.writeStringField('constitution', mapOfInvisibleMonitoringParams.get('constitution') != null ? mapOfInvisibleMonitoringParams.get('constitution') : '');
      /* Added By Ankush - Bug ID 14128 End */
      //15506 Pro Doc Invisible Monitoring 
      gen.writeNumberField('age', mapOfInvisibleMonitoringParams.get('age') != null ? Integer.valueOf(mapOfInvisibleMonitoringParams.get('age')) : 0);


      gen.writeEndObject();
      gen.writeEndArray();
      // Added by Chetan 03-Jan-2017 S
      gen.writeFieldName('propertyDetails');
      gen.writeStartArray();
      gen.writeStartObject();
      // Added by Chetan 03-Jan-2017 S
      gen.writeNumberField('top_up_percentage', mapOfInvisibleMonitoringParams.get('top_up_percentage') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('top_up_percentage')) : 0);
      // Added by Chetan 03-Jan-2017 E
      gen.writeEndObject();
      gen.writeEndArray();
      // Added by Chetan 03-Jan-2017 E



      gen.writeFieldName('bankSummary');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeNumberField('total_bounce_inward', mapOfInvisibleMonitoringParams.get('total_bounce_inward') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('total_bounce_inward')) : 0);
      gen.writeNumberField('total_bounce_outward', mapOfInvisibleMonitoringParams.get('total_bounce_outward') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('total_bounce_outward')) : 0);
      gen.writeNumberField('odccUtilization', mapOfInvisibleMonitoringParams.get('odccUtilization') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('odccUtilization')) : 0);
      gen.writeNumberField('avg_od_cc_utilisation', mapOfInvisibleMonitoringParams.get('avg_od_cc_utilisation') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('avg_od_cc_utilisation')) : 0);
      gen.writeNumberField('credit_trans_banking_count', mapOfInvisibleMonitoringParams.get('credit_trans_banking_count') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('credit_trans_banking_count')) : 0);
      gen.writeStringField('typeofBanking', mapOfInvisibleMonitoringParams.get('typeofBanking') != null ? mapOfInvisibleMonitoringParams.get('typeofBanking') : '');
      gen.writeStringField('applicant_type', mapOfInvisibleMonitoringParams.get('applicant_type') != null ? mapOfInvisibleMonitoringParams.get('applicant_type') : '');
      gen.writeNumberField('debit_trans_banking_count', mapOfInvisibleMonitoringParams.get('debit_trans_banking_count') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('debit_trans_banking_count')) : 0);



      gen.writeStringField('bankAccountNumber', mapOfInvisibleMonitoringParams.get('bankAccountNumber') != null ? mapOfInvisibleMonitoringParams.get('bankAccountNumber') : '');
      gen.writeStringField('bankAccountType', mapOfInvisibleMonitoringParams.get('bankAccountType') != null ? mapOfInvisibleMonitoringParams.get('bankAccountType') : '');
      // Added by Chetan 03-Jan-2017 S
      gen.writeNumberField('btBankMOB', mapOfInvisibleMonitoringParams.get('btBankMOB') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('btBankMOB')) : 0);
      gen.writeStringField('btBankName', mapOfInvisibleMonitoringParams.get('btBankName') != null ? mapOfInvisibleMonitoringParams.get('btBankName') : null);
      // Added by Chetan 03-Jan-2017 E



      gen.writeNumberField('annualizedBTO', mapOfInvisibleMonitoringParams.get('annualizedBTO') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('annualizedBTO')) : 0);
      gen.writeStringField('odccFlag', mapOfInvisibleMonitoringParams.get('odccFlag') != null ? mapOfInvisibleMonitoringParams.get('odccFlag') : 'NO');

      //Added by Anjali Mortgage-start
      gen.writeStringField('btType', mapOfInvisibleMonitoringParams.get('btType') != null ? mapOfInvisibleMonitoringParams.get('btType') : '');
      //Added by anjali-end
      //Mahima Gandhe Mortgage IM Start  
      gen.writeStringField('type_of_transaction', mapOfInvisibleMonitoringParams.get('type_of_transaction') != null ? mapOfInvisibleMonitoringParams.get('type_of_transaction') : '');
      //Mahima Gandhe Mortgage IM End 

      /* Added By Ankush Bug 16588 - Invalid Score Stamping for Invisible Monitoring RANDOM call */
      gen.writeNumberField('avg_od_cc_limit', mapOfInvisibleMonitoringParams.get('avg_od_cc_limit') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('avg_od_cc_limit')) : 0);

      gen.writeEndObject();
      gen.writeEndArray();

      gen.writeFieldName('profitLossStatement');
      gen.writeStartObject();
      gen.writeNumberField('py_sales_turnover', mapOfInvisibleMonitoringParams.get('py_sales_turnover') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('py_sales_turnover')) : 0);
      gen.writeNumberField('cy_sales_turnover', mapOfInvisibleMonitoringParams.get('cy_sales_turnover') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('cy_sales_turnover')) : 0);
      gen.writeNumberField('cy_net_profit', mapOfInvisibleMonitoringParams.get('cy_net_profit') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('cy_net_profit')) : 0);
      gen.writeNumberField('py_net_profit', mapOfInvisibleMonitoringParams.get('py_net_profit') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('py_net_profit')) : 0);


      gen.writeStringField('creditProgram', mapOfInvisibleMonitoringParams.get('creditProgram') != null ? mapOfInvisibleMonitoringParams.get('creditProgram') : '');

      gen.writeNumberField('cy_total_networth', mapOfInvisibleMonitoringParams.get('cy_total_networth') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('cy_total_networth')) : 0);
      gen.writeNumberField('py_depriciation', mapOfInvisibleMonitoringParams.get('py_depriciation') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('py_depriciation')) : 0);
      gen.writeNumberField('cy_depriciation', mapOfInvisibleMonitoringParams.get('cy_depriciation') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('cy_depriciation')) : 0);
      gen.writeNumberField('growthInSalesTurnover', mapOfInvisibleMonitoringParams.get('growthInSalesTurnover') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('growthInSalesTurnover')) : 0);
      //Chetan Mortgage IM Start
      gen.writeNumberField('gross_receipts', mapOfInvisibleMonitoringParams.get('gross_receipts') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('gross_receipts')) : 0);
      gen.writeNumberField('cy_total_assets', mapOfInvisibleMonitoringParams.get('cy_total_assets') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('cy_total_assets')) : 0);
      //Chetan Mortgage IM End


      gen.writeEndObject();

      gen.writeFieldName('cibli');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeNumberField('CIBIL_Score', mapOfInvisibleMonitoringParams.get('CIBIL_Score') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('CIBIL_Score')) : 0);
      gen.writeNumberField('total_no_of_loans', mapOfInvisibleMonitoringParams.get('total_no_of_loans') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('total_no_of_loans')) : 0);
      gen.writeNumberField('bureauHistory', mapOfInvisibleMonitoringParams.get('bureauHistory') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('bureauHistory')) : 0);
      gen.writeStringField('applicant_Type', mapOfInvisibleMonitoringParams.get('applicant_type') != null ? mapOfInvisibleMonitoringParams.get('applicant_type') : '');
      gen.writeNumberField('total_no_of_loans_enquiry', mapOfInvisibleMonitoringParams.get('total_no_of_loans_enquiry') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('total_no_of_loans_enquiry')) : 0);

      // Tags added by Chetan 03-Jan-2017 S
      gen.writeStringField('cibilType', mapOfInvisibleMonitoringParams.get('cibilType') != null ? mapOfInvisibleMonitoringParams.get('cibilType') : '');
      // Tags added by Chetan 03-Jan-2017 E

      //Chetan Mortgage IM Start
      gen.writeStringField('pincode_mismatch__in_cibil', mapOfInvisibleMonitoringParams.get('pincode_mismatch__in_cibil') != null ? mapOfInvisibleMonitoringParams.get('pincode_mismatch__in_cibil') : '');
      gen.writeStringField('secondary_match_in_cibil', mapOfInvisibleMonitoringParams.get('secondary_match_in_cibil') != null ? mapOfInvisibleMonitoringParams.get('secondary_match_in_cibil') : 'NO');
      gen.writeNumberField('cibil_enquiries_last3_month', mapOfInvisibleMonitoringParams.get('cibil_enquiries_last3_month') != null ? Integer.valueOf(mapOfInvisibleMonitoringParams.get('cibil_enquiries_last3_month')) : 0);
      //Chetan Mortgage IM End


      gen.writeStringField('maxLoanType', mapOfInvisibleMonitoringParams.get('maxLoanType') != null ? mapOfInvisibleMonitoringParams.get('maxLoanType') : '');
      //invisible monitoring for dl by akshata 30th june 2016 start
      gen.writeNumberField('cibilHistory', mapOfInvisibleMonitoringParams.get('cibilHistory') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('cibilHistory')) : 0);
      //invisible monitoring for dl by akshata 30th june 2016 end
      gen.writeFieldName('accountInfo');
      gen.writeStartObject();
      for (integer i = 1; i <= 20; i++) {
        gen.writeStringField('accountInfo' + i, mapOfInvisibleMonitoringParams.get('accountInfo' + i) != null ? mapOfInvisibleMonitoringParams.get('accountInfo' + i) : '');
      }
      gen.writeEndObject();

      gen.writeFieldName('accountType');
      gen.writeStartObject();
      for (integer i = 1; i <= 20; i++) {
        gen.writeStringField('accountType' + i, mapOfInvisibleMonitoringParams.get('accountType' + i) != null ? mapOfInvisibleMonitoringParams.get('accountType' + i) : '');
      }
      gen.writeEndObject();

      gen.writeFieldName('amountOverdue');
      gen.writeStartObject();
      for (integer i = 1; i <= 20; i++) {
        gen.writeStringField('amountOverdue' + i, mapOfInvisibleMonitoringParams.get('amountOverdue' + i) != null ? mapOfInvisibleMonitoringParams.get('amountOverdue' + i) : '');
      }
      gen.writeEndObject();

      gen.writeFieldName('currentBalance');
      gen.writeStartObject();
      for (integer i = 1; i <= 20; i++) {

        gen.writeNumberField('currentBalance' + i, mapOfInvisibleMonitoringParams.get('currentBalance' + i) != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('currentBalance' + i)) : 0);



      }
      gen.writeEndObject();

      gen.writeFieldName('dateClosed');
      gen.writeStartObject();
      for (integer i = 1; i <= 20; i++) {
        gen.writeStringField('dateClosed' + i, mapOfInvisibleMonitoringParams.get('dateClosed' + i) != null ? mapOfInvisibleMonitoringParams.get('dateClosed' + i) : '');
      }
      gen.writeEndObject();

      gen.writeFieldName('sanctionedAmount');
      gen.writeStartObject();
      for (integer i = 1; i <= 20; i++) {

        gen.writeNumberField('sanctionedAmount' + i, mapOfInvisibleMonitoringParams.get('sanctionedAmount' + i) != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('sanctionedAmount' + i)) : 0);


      }
      gen.writeEndObject();



      gen.writeEndObject();
      gen.writeEndArray();


      gen.writeFieldName('CAMS');
      gen.writeStartArray();
      gen.writeStartObject();
      //added by akshata invisible monitoring for dl S
      gen.writeNumberField('average_net_salary', mapOfInvisibleMonitoringParams.get('average_net_salary') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('average_net_salary')) : 0);
      //added by akshata invisible monitoring for dl E 

      //added by prashant for SAL IM S
      gen.writeNumberField('net_Salary_for_Month1', mapOfInvisibleMonitoringParams.get('net_Salary_for_Month1') != null ? double.valueOf(mapOfInvisibleMonitoringParams.get('net_Salary_for_Month1')) : 0);
      //added by prashant for SAL IM E

      gen.writeNumberField('debtorsTurnoverDays', mapOfInvisibleMonitoringParams.get('debtorsTurnoverDays') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('debtorsTurnoverDays')) : 0);
      gen.writeNumberField('creditSMEScore', mapOfInvisibleMonitoringParams.get('creditSMEScore') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('creditSMEScore')) : 0);


      gen.writeNumberField('creditorsTurnoverDays', mapOfInvisibleMonitoringParams.get('creditorsTurnoverDays') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('creditorsTurnoverDays')) : 0);

      gen.writeNumberField('stockTurnoverDays', mapOfInvisibleMonitoringParams.get('stockTurnoverDays') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('stockTurnoverDays')) : 0);

      gen.writeNumberField('cashConversionCycle', mapOfInvisibleMonitoringParams.get('cashConversionCycle') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('cashConversionCycle')) : 0);

      gen.writeNumberField('currentRatio', mapOfInvisibleMonitoringParams.get('currentRatio') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('currentRatio')) : 0);

      gen.writeNumberField('networkingCapital', mapOfInvisibleMonitoringParams.get('networkingCapital') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('networkingCapital')) : 0);

      gen.writeNumberField('netProfitMargin', mapOfInvisibleMonitoringParams.get('netProfitMargin') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('netProfitMargin')) : 0);

      gen.writeNumberField('odccLimit', mapOfInvisibleMonitoringParams.get('odccLimit') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('odccLimit')) : 0);
      //Anjali mortagge start
      //
      gen.writeNumberField('average_net_salary', mapOfInvisibleMonitoringParams.get('average_net_salary') != null ? Integer.valueOf(mapOfInvisibleMonitoringParams.get('average_net_salary')) : 0);
      //Anajli mortgage end







      gen.writeEndObject();
      gen.writeEndArray();



      gen.writeFieldName('Generics');
      gen.writeStartObject();
      gen.writeStringField('branch_type', mapOfInvisibleMonitoringParams.get('branch_type') != null ? mapOfInvisibleMonitoringParams.get('branch_type') : '');
      gen.writeStringField('branch_name', mapOfInvisibleMonitoringParams.get('branch_name') != null ? mapOfInvisibleMonitoringParams.get('branch_name') : '');
      gen.writeEndObject();

      gen.writeFieldName('existingLoan');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeStringField('applicant_type', mapOfInvisibleMonitoringParams.get('applicant_type') != null ? mapOfInvisibleMonitoringParams.get('applicant_type') : '');
      //added by akshata for invisible monitoring for dl  number_of_hl_loans 
      gen.writeNumberField('number_of_hl_loans', (mapOfInvisibleMonitoringParams.get('number_of_hl_loans') != null && double.valueOf(mapOfInvisibleMonitoringParams.get('number_of_hl_loans')) != null) ? Integer.valueOf(mapOfInvisibleMonitoringParams.get('number_of_hl_loans')) : 0);
      gen.writeNumberField('totalLoanAmount', (mapOfInvisibleMonitoringParams.get('totalLoanAmount') != null) ? double.valueOf(mapOfInvisibleMonitoringParams.get('totalLoanAmount')) : 0);

      /* Added By Ankush Bug ID 14128 start */

      List < integer > loanAmthousing = New List < Integer > ();
      if (mapOfInvisibleMonitoringParams.get('housing_loan') != null) {
        String housingLoanStr = mapOfInvisibleMonitoringParams.get('housing_loan');
        if (housingLoanStr != null && (!String.isEmpty(housingLoanStr))) {
          if (housingLoanStr.contains(' ,')) {
            List < String > housingLoanLst = housingLoanStr.split(' ,');
            for (String str: housingLoanLst) {
              loanAmthousing.add(Integer.valueOf(str.trim()));
            }
          } else
            loanAmthousing.add(Integer.valueOf(housingLoanStr.trim()));
        }
      }
      //System.debug('loanAmthousing >>>>' + loanAmthousing);
      gen.writeObjectField('housing_loan', loanAmthousing);

      // For Propery Loan 
      List < integer > loanAmtProperty = New List < Integer > ();
      if (mapOfInvisibleMonitoringParams.get('property_loan') != null) {
        String propertyLoanStr = mapOfInvisibleMonitoringParams.get('property_loan');
        if (propertyLoanStr != null && (!String.isEmpty(propertyLoanStr))) {
          if (propertyLoanStr.contains(' ,')) {
            List < String > propertyLoanLst = propertyLoanStr.split(' ,');
            for (String str: propertyLoanLst) {
              loanAmtProperty.add(Integer.valueOf(str.trim()));
            }
          } else
            loanAmtProperty.add(Integer.valueOf(propertyLoanStr.trim()));
        }
      }

      gen.writeObjectField('property_loan', loanAmtProperty);

      // For Business Loan 
      List < Decimal > loanAmtBusiness = New List < Decimal > ();
      if (mapOfInvisibleMonitoringParams.get('business_loan') != null) {
        String businessLoanStr = mapOfInvisibleMonitoringParams.get('business_loan');
        if (businessLoanStr != null && (!String.isEmpty(businessLoanStr))) {
          if (businessLoanStr.contains(' ,')) {
            List < String > businessLoanLst = businessLoanStr.split(' ,');
            for (String str: businessLoanLst) {
              loanAmtBusiness.add(Decimal.valueOf(str.trim()));
              //gopika added decimal
            }
          } else
            loanAmtBusiness.add(Decimal.valueOf(businessLoanStr.trim()));
        }
      }

      gen.writeObjectField('business_loan', loanAmtBusiness);

      /* Added By Ankush Bug ID 14128 End */

      //15506 Pro Doc Invisible Monitoring start   
      // For education loan 
      List < Decimal > loanAmountEdu = New List < Decimal > ();
      if (mapOfInvisibleMonitoringParams.containsKey('education_loan') && mapOfInvisibleMonitoringParams.get('education_loan') != null) {
        String EduLoanString = mapOfInvisibleMonitoringParams.get('education_loan');
        if (EduLoanString != null && (!String.isEmpty(EduLoanString))) {
          if (EduLoanString.contains(' ,')) {
            for (String str: EduLoanString.split(' ,')) {
              if (str != null)
                loanAmountEdu.add(Decimal.valueOf(str.trim()));
            }
          } else
            loanAmountEdu.add(Decimal.valueOf(EduLoanString.trim()));
        }
      }
      gen.writeObjectField('education_loan', loanAmountEdu);



      // For loan to professional
      List < Decimal > loanAmountPro = New List < Decimal > ();
      if (mapOfInvisibleMonitoringParams.containsKey('loan_to_professional') && mapOfInvisibleMonitoringParams.get('loan_to_professional') != null) {
        String ProLoanString = mapOfInvisibleMonitoringParams.get('loan_to_professional');
        if (ProLoanString != null && (!String.isEmpty(ProLoanString))) {
          if (ProLoanString.contains(' ,')) {
            for (String str: ProLoanString.split(' ,')) {
              if (str != null)
                loanAmountPro.add(Decimal.valueOf(str.trim()));
            }
          } else
            loanAmountPro.add(Decimal.valueOf(ProLoanString.trim()));
        }
      }
      gen.writeObjectField('loan_to_professional', loanAmountPro);
      //15506 Pro Doc Invisible Monitoring end


      gen.writeEndObject();
      gen.writeEndArray();

      /* Added By Ankush Bug ID 14128 start */
      // New verification BRE Request

      System.debug('Verifications Record Start >');
      gen.writeFieldName('verificationInputs');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeFieldName('loanParameter');
      gen.writeStartObject();
      gen.writeStringField('dummy_member1', '');
      gen.writeStringField('dummy_member2', '');
      gen.writeStringField('dummy_member3', '');
      gen.writeStringField('dummy_member4', '');
      gen.writeStringField('dummy_member5', '');
      gen.writeStringField('dummy_member6', '');
      gen.writeStringField('dummy_member7', '');
      gen.writeStringField('dummy_member8', '');
      gen.writeStringField('dummy_member9', '');
      gen.writeStringField('dummy_member10', '');

      if (mapOfInvisibleMonitoringParams.containsKey('loan_application_number')) {
        //System.debug('LAN' + decimal.valueOf(mapOfInvisibleMonitoringParams.get('loan_application_number')));
        gen.writeObjectField('loan_application_number', decimal.valueOf(mapOfInvisibleMonitoringParams.get('loan_application_number')));
      }

      gen.writeStringField('cmr_score', mapOfInvisibleMonitoringParams.get('cmr_score') != null ? mapOfInvisibleMonitoringParams.get('cmr_score') : '');
      gen.writeStringField('sourcingChannel', mapOfInvisibleMonitoringParams.get('sourcingChannel') != null ? mapOfInvisibleMonitoringParams.get('sourcingChannel') : '');
      gen.writeStringField('scheme_name', mapOfInvisibleMonitoringParams.get('scheme_name') != null ? mapOfInvisibleMonitoringParams.get('scheme_name') : '');
      gen.writeEndObject();

      gen.writeFieldName('demographic');

      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeStringField('customer_type', mapOfInvisibleMonitoringParams.get('customer_type') != null ? mapOfInvisibleMonitoringParams.get('customer_type') : '');
      gen.writeStringField('date_of_birth', mapOfInvisibleMonitoringParams.get('date_of_birth') != null ? mapOfInvisibleMonitoringParams.get('date_of_birth') : '');
      gen.writeStringField('constitution', mapOfInvisibleMonitoringParams.get('constitution') != null ? mapOfInvisibleMonitoringParams.get('constitution') : '');
      gen.writeStringField('nature_of_business', mapOfInvisibleMonitoringParams.get('nature_of_business') != null ? mapOfInvisibleMonitoringParams.get('nature_of_business') : '');
      gen.writeStringField('industry', mapOfInvisibleMonitoringParams.get('industry') != null ? mapOfInvisibleMonitoringParams.get('industry') : '');
      /* Changed By Ankush Bug 16588 - Invalid Score Stamping for Invisible Monitoring RANDOM call, Changes total_employment_vintage value  */
      gen.writeNumberField('total_employment_vintage', mapOfInvisibleMonitoringParams.get('total_employment_vintage') != null ? Decimal.valueOf(mapOfInvisibleMonitoringParams.get('total_employment_vintage')) : 0);
      gen.writeStringField('pan', mapOfInvisibleMonitoringParams.get('pan') != null ? mapOfInvisibleMonitoringParams.get('pan') : '');
      gen.writeStringField('dummy_member1', '');
      gen.writeStringField('dummy_member2', '');
      gen.writeStringField('dummy_member3', '');
      gen.writeStringField('dummy_member4', '');
      gen.writeStringField('dummy_member5', '');
      gen.writeStringField('dummy_member6', '');
      gen.writeStringField('dummy_member7', '');
      gen.writeStringField('dummy_member8', '');
      gen.writeStringField('dummy_member9', '');
      gen.writeStringField('dummy_member10', '');

      gen.writeEndObject();
      gen.writeEndArray();

      gen.writeFieldName('bankSummary');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeNumberField('avg_od_cc_limit', mapOfInvisibleMonitoringParams.get('avg_od_cc_limit') != null ? Double.valueOf(mapOfInvisibleMonitoringParams.get('avg_od_cc_limit')) : 0);
      gen.writeStringField('dummy_member5', '');
      gen.writeStringField('dummy_member6', '');
      gen.writeStringField('dummy_member7', '');
      gen.writeStringField('dummy_member8', '');
      gen.writeStringField('dummy_member9', '');
      gen.writeStringField('dummy_member10', '');


      gen.writeEndObject();
      gen.writeEndArray();
      /* Added By Ankush Bug ID 14128 End */


      gen.writeEndObject();

      jsonString = gen.getAsString();

      System.debug('********JSON string to be passed for IM********' + jsonString);



      Mid_office_BRE_flow__c BRE_ver = Mid_office_BRE_flow__c.getValues('BRE Verification');

      if (BRE_ver != null) {
        endpointURL = BRE_ver.EndpointURL__c;
      }

      username = 'DEFAULT\\Admin';
      password = 'Admin';
      //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/Verifications/versions/0.0.1-SNAPSHOT/rules/Verifications/verificationMain/executions';
      //System.debug('********Endpoint for IM********' + endpointURL);
      //System.debug('********Username for IM********' + username);
      //System.debug('********Passowrd for IM********' + password);

      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      Http http = new Http();
      HTTPResponse res;
      if (!Test.isRunningTest()) {
        res = http.send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          // Proper Response
          // System.debug('Request -----> ' + req);
          String result = res.getBody();
          //System.debug('Result ----->' + result);
          mapOfResults = parseResponseForIM(result);
          System.debug('Map of result -----> ' + mapOfResults);
        } else {
          // Error in getting response
          System.debug('<-----CONNECTION ERROR----->');
        }
      }
    } catch (exception e) {
      system.debug('exception :-' + e.getmessage() + '       line no -----------' + e.getLineNumber() + ' stack ======' + e.getStackTraceString());
    }
    return mapOfResults;
  }

  //SAL Sampling parse response Rohit start
  public Map < String, String > parseResponseForSampling(String responseOfInvisibleMonitoringParams) {
    Map < String, String > mapOfResults = new Map < String, String > ();
    BRECallout.JSONParserForSampling jsonParser = new BRECallout.JSONParserForSampling();
    BRECallout.JSONParserForSampling reponse = jsonParser.parse(responseOfInvisibleMonitoringParams);
    mapOfResults.put('weightedScore', String.valueOf(reponse.output.weightedScore));
    mapOfResults.put('weightedScoretoMaxWeight', String.valueOf(reponse.output.weightedScoretoMaxWeight));
    //new parameter in place of weightedScoretoMaxWeight
    mapOfResults.put('maxWeight', String.valueOf(reponse.output.maxWeight));
    //mapOfResults.put('weightedScoretoMaxWeight',String.valueOf(reponse.output.weightedScoretoMaxWeight)); 
    System.debug('rohit12 ' + mapOfResults);
    return mapOfResults;
  }
  //SAL SAmpling Rohit end
  public Map < String, String > parseResponseForIM(String responseOfInvisibleMonitoringParams) {
    Map < String, String > mapOfResults = new Map < String, String > ();

    JSONResponse reponse = JSONResponse.parse(responseOfInvisibleMonitoringParams);
    System.debug('*****Response*****' + reponse);
    String verlist = '';
    //added by akshata for invisible monitoring for dl
    String status = '';
    for (JSONResponse.cls_verificationList ver: reponse.verificationList) {
      verlist += ver.verification_code + ',';
      //added by akshata for invisible monitoring for dl
      status += ver.verification_status + ',';
    }
    String[] verificationsArray = verlist.split(',');
    String verlist1 = '';
    for (Integer i = 0; i < verificationsArray.size(); i++) {
      if (i < (verificationsArray.size() - 1))
        verlist1 += verificationsArray[i] + ',';
      else
        verlist1 += verificationsArray[i];
    }
    System.debug('*****Verification List*****' + verlist1);
    mapOfResults.put('verificationList', verlist1);
    //added by akshata for invisible monitoring for dl
    mapOfResults.put('verificationstatus', status);
    mapOfResults.put('message', reponse.output.message);
    mapOfResults.put('GTRDLCount', String.valueOf(reponse.output.GTRDLCount));
    mapOfResults.put('GTRPPCount', String.valueOf(reponse.output.GTRPPCount));
    mapOfResults.put('GTRPSCount', String.valueOf(reponse.output.GTRPSCount));
    mapOfResults.put('GTCount', String.valueOf(reponse.output.GTCount));

    mapOfResults.put('RTCount', String.valueOf(reponse.output.RTCount));
    mapOfResults.put('address_change_flag', String.valueOf(reponse.output.address_change_flag));
    mapOfResults.put('cibil_enquiries_last3_month', String.valueOf(reponse.output.cibil_enquiries_last3_month));
    mapOfResults.put('btType', String.valueOf(reponse.output.btType));
    mapOfResults.put('average_net_salary', String.valueOf(reponse.output.average_net_salary));
    mapOfResults.put('years_in_business_job', String.valueOf(reponse.output.years_in_business_job));

    System.debug('map ------->' + mapOfResults);


    //invisible monitoring mortgage Anjali-start
    if (String.valueOf(reponse.output.Invisible_mandatory) != null)
      mapOfResults.put('Invisible_mandatory', String.valueOf(reponse.output.Invisible_mandatory));
    if (String.valueOf(reponse.output.Buro_Score) != null)
      mapOfResults.put('Buro_Score', String.valueOf(reponse.output.Buro_Score));
    mapOfResults.put('secondary_match_in_cibil', String.valueOf(reponse.output.secondary_match_in_cibil));
    //invisible monitoring mortgage Anjali-end

    //invisible monitoring mortgage Mahima-start
    if (String.valueOf(reponse.output.mandatoryFlag) != null)
      mapOfResults.put('mandatoryFlag', String.valueOf(reponse.output.mandatoryFlag));
    //invisible monitoring mortgage Mahima-end


    /* Added By Ankush Bug ID 14128 start */
    String invisibleRuleKeyStr = '';
    if (reponse.output.invisibleMonitoringHistory != null) {
      for (JSONResponse.cls_invisibleMonitoringHistory ver: reponse.output.invisibleMonitoringHistory) {
        System.debug('Key >>>' + ver.key);
        invisibleRuleKeyStr += ver.Key + ':';
        invisibleRuleKeyStr += ver.Value + ',';
      }
      if (invisibleRuleKeyStr.contains(','))
        invisibleRuleKeyStr = invisibleRuleKeyStr.removeEnd(',');
    }
    mapOfResults.put('invisibleMonitoringHistory', String.valueOf(invisibleRuleKeyStr));
    /* Added By Ankush Bug ID 14128 End*/




    return mapOfResults;
  }

  // End of invisible monitoring changes

  //Start of MSME BL changes
  public String RecommendedPDType(Map < string, string > mapOfPDParams) {
    String pdType;
    Map < string, string > mapOfPDParamsNew;
    String body = '<input xmlns="http://www.visual-rules.com/vrpath/RBL_PD/rblPd/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
    body += '<input><branchType>' + mapOfPDParams.get('branchType') + '</branchType><segment>' + mapOfPDParams.get('segment') + '</segment><loanAmount>' + mapOfPDParams.get('loanAmount') + '</loanAmount></input></input>';
    System.debug('Body==>' + body);

    body = body.replaceAll('null', '');
    // 7515 change body = body.replaceAll('000-1', '0');
    body = body.replaceAll('<CIBIL_Score>000-1</CIBIL_Score>', '<CIBIL_Score>0</CIBIL_Score>');
    System.debug('*********body: ' + body);

    Mid_office_BRE_flow__c RBL_PD = Mid_office_BRE_flow__c.getValues('RBL PD');
    if (RBL_PD != null) {
      username = RBL_PD.Username__c;
      password = RBL_PD.Password__c;
      endpointURL = '';
      endpointURL = RBL_PD.EndpointURL__c;
    }

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(body);
    req.setTimeout(120000);
    System.debug('UserName--->' + username + ' ###  Password---->' + password);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    System.debug('*****BRE call start:-' + system.now());
    if (!Test.isRunningTest()) {
      HTTPResponse res = http.send(req);
      System.debug('*****BRE call end:-' + system.now());
      System.debug('*****req:-' + req.getBody());
      System.debug(res.getBody());
      String result = res.getBody();
      System.debug('*********result : ' + result);
      mapOfPDParamsNew = processResponse1(result);
      System.debug('Map of PD response : ' + mapOfPDParamsNew);
      pdType = mapOfPDParamsNew.get('pdType');
      System.debug('Recommended PD type : ' + pdType);
    }

    return pdType;
  }
  //End of MSME BL changes

  // Start of MSME BL and Champion Challenger changes
  public Map < String, String > callBREMCPCheckBL(Map < String, String > mapOfPolicyParameters) {

    JSONGenerator gen = JSON.createGenerator(true);

    gen.writeStartObject();

    gen.writeFieldName('loan_parameter');
    gen.writeStartObject();

    gen.writeStringField('product', mapOfPolicyParameters.get('product') != null ? mapOfPolicyParameters.get('product') : '');
    gen.writeStringField('program_type', mapOfPolicyParameters.get('program_type') != null ? mapOfPolicyParameters.get('program_type') : '');
    gen.writeNumberField('reqested_roi', mapOfPolicyParameters.get('reqested_roi') != null ? Double.valueOf(mapOfPolicyParameters.get('reqested_roi')) : 0);
    gen.writeNumberField('requested_loan_amount', mapOfPolicyParameters.get('requested_loan_amount') != null ? Double.valueOf(mapOfPolicyParameters.get('requested_loan_amount')) : 0);
    gen.writeNumberField('requested_tenor', mapOfPolicyParameters.get('requested_tenor') != null ? Double.valueOf(mapOfPolicyParameters.get('requested_tenor')) : 0);

    if (mapOfPolicyParameters.get('product') != null && mapOfPolicyParameters.get('product') == 'RDL') {
      gen.writeNumberField('loan_application_number', mapOfPolicyParameters.get('loan_id') != null ? Integer.valueOf(mapOfPolicyParameters.get('loan_id')) : 0);
    }
    if (mapOfPolicyParameters.get('product') != null && mapOfPolicyParameters.get('product') == 'RBL') {
      gen.writeStringField('stage', mapOfPolicyParameters.get('stage') != null ? mapOfPolicyParameters.get('stage') : '');
    }

    /*BUG-16959 by Rajesh added Prod condition for DBOL*/
    System.debug('setPSBLProdName' + setPSBLProdName);
    if (mapOfPolicyParameters.get('product') != null && setPSBLProdName.contains(mapOfPolicyParameters.get('product'))) {
      gen.writeStringField('financierName', mapOfPolicyParameters.get('financierName') != null ? mapOfPolicyParameters.get('financierName') : '');
      gen.writeNumberField('targetLoanAmount', mapOfPolicyParameters.get('targetLoanAmount') != null ? Double.valueOf(mapOfPolicyParameters.get('targetLoanAmount')) : 0);
      gen.writeStringField('targetLoanAmountMaturityDate', mapOfPolicyParameters.get('targetLoanAmountMaturityDate') != null ? mapOfPolicyParameters.get('targetLoanAmountMaturityDate') : '');
      gen.writeNumberField('existing_mob', mapOfPolicyParameters.get('existing_mob') != null ? Double.valueOf(mapOfPolicyParameters.get('existing_mob')) : 0);
      gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id') != null ? mapOfPolicyParameters.get('loan_id') : '1');
    }

    gen.writeEndObject();

    //if(mapOfPolicyParameters.get('product') != null && (mapOfPolicyParameters.get('product') == 'PSBL' || mapOfPolicyParameters.get('product') == 'RBL')) {
    gen.writeFieldName('generic_info');
    gen.writeStartObject();

    gen.writeStringField('branch_type', mapOfPolicyParameters.get('branch_type') != null ? mapOfPolicyParameters.get('branch_type') : '');
    gen.writeStringField('branch_name', mapOfPolicyParameters.get('branch_name') != null ? mapOfPolicyParameters.get('branch_name') : '');
    gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id') != null ? mapOfPolicyParameters.get('loan_id') : '1');

    gen.writeEndObject();
    //}

    gen.writeFieldName('demographic');
    gen.writeStartArray();
    gen.writeStartObject();

    gen.writeNumberField('years_in_business_job', mapOfPolicyParameters.get('years_in_business_job') != null ? Double.valueOf(mapOfPolicyParameters.get('years_in_business_job')) : 0);
    gen.writeNumberField('years_in_current_business_job', mapOfPolicyParameters.get('years_in_current_business_job') != null ? Double.valueOf(mapOfPolicyParameters.get('years_in_current_business_job')) : 0);
    gen.writeNumberField('vintage', mapOfPolicyParameters.get('vintage') != null ? Double.valueOf(mapOfPolicyParameters.get('vintage')) : 0);

    gen.writeStringField('type_of_constitution', mapOfPolicyParameters.get('type_of_constitution') != null ? mapOfPolicyParameters.get('type_of_constitution') : '');
    gen.writeStringField('constitutionType', mapOfPolicyParameters.get('constitutionType') != null ? mapOfPolicyParameters.get('constitutionType') : '');
    gen.writeStringField('constitution', mapOfPolicyParameters.get('constitution') != null ? mapOfPolicyParameters.get('constitution') : '');
    gen.writeStringField('customer_type', mapOfPolicyParameters.get('customer_type') != null ? mapOfPolicyParameters.get('customer_type') : '');
    gen.writeStringField('costomer_type', mapOfPolicyParameters.get('costomer_type') != null ? mapOfPolicyParameters.get('costomer_type') : '');
    gen.writeStringField('nature_of_business', mapOfPolicyParameters.get('nature_of_business') != null ? mapOfPolicyParameters.get('nature_of_business') : '');

    if (mapOfPolicyParameters.get('product') != null && mapOfPolicyParameters.get('product') == 'RBL') {
      gen.writeStringField('applicant_type', mapOfPolicyParameters.get('applicant_type') != null ? mapOfPolicyParameters.get('applicant_type') : '');
      gen.writeStringField('first_name', mapOfPolicyParameters.get('first_name') != null ? mapOfPolicyParameters.get('first_name') : '');
      gen.writeStringField('last_name', mapOfPolicyParameters.get('last_name') != null ? mapOfPolicyParameters.get('last_name') : '');
      gen.writeStringField('coApplicantFlag', mapOfPolicyParameters.get('coApplicantFlag') != null ? mapOfPolicyParameters.get('coApplicantFlag') : '');
    }

    /*BUG-16959 by Rajesh added Prod condition for DBOL*/
    if (mapOfPolicyParameters.get('product') != null && setPSBLProdName.contains(mapOfPolicyParameters.get('product'))) {
      gen.writeStringField('applicant_type', mapOfPolicyParameters.get('applicant_type') != null ? mapOfPolicyParameters.get('applicant_type') : '');
      gen.writeNumberField('bankingVintage', mapOfPolicyParameters.get('bankingVintage') != null ? Integer.valueOf(mapOfPolicyParameters.get('bankingVintage')) : 0);
      gen.writeStringField('ratingReportDate', mapOfPolicyParameters.get('ratingReportDate') != null ? mapOfPolicyParameters.get('ratingReportDate') : '');
      gen.writeStringField('ratingAgency', mapOfPolicyParameters.get('ratingAgency') != null ? mapOfPolicyParameters.get('ratingAgency') : '');
      gen.writeStringField('ratingType', mapOfPolicyParameters.get('ratingType') != null ? mapOfPolicyParameters.get('ratingType') : '');
      gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id') != null ? mapOfPolicyParameters.get('loan_id') : '1');
    }
    //bug 8310: RDL implementation by rasika
    if (mapOfPolicyParameters.get('product') != null && mapOfPolicyParameters.get('product') == 'RDL') {
      System.debug('RDL in BRECallout');
      gen.writeStringField('applicant_type', mapOfPolicyParameters.get('applicant_type') != null ? mapOfPolicyParameters.get('applicant_type') : '');
      gen.writeStringField('program_type', mapOfPolicyParameters.get('program_type') != null ? mapOfPolicyParameters.get('program_type') : '');
      gen.writeNumberField('total_employment_vintage', (mapOfPolicyParameters.get('total_employment_vintage') != null) ? Double.valueOf(mapOfPolicyParameters.get('total_employment_vintage')) : 0);
      // gen.writeStringField('tenor', (mapOfPolicyParameters.get('tenor') != null) ? mapOfPolicyParameters.get('tenor') : '');
      gen.writeStringField('type_of_degree', mapOfPolicyParameters.get('type_of_degree') != null ? mapOfPolicyParameters.get('type_of_degree') : '');
      gen.writeStringField('date_of_birth', mapOfPolicyParameters.get('date_of_birth') != null ? mapOfPolicyParameters.get('date_of_birth') : '');
      gen.writeStringField('state', mapOfPolicyParameters.get('state') != null ? mapOfPolicyParameters.get('state') : '');
    }
    //bug 8310 end
    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('bank_summary');
    gen.writeStartArray();
    gen.writeStartObject();

    gen.writeNumberField('avg_od_cc_limit', Double.valueOf(mapOfPolicyParameters.get('avg_od_cc_limit')) != null ? Double.valueOf(mapOfPolicyParameters.get('avg_od_cc_limit')) : 0);

    if (mapOfPolicyParameters.get('product') != null && mapOfPolicyParameters.get('product') == 'RBL') {
      gen.writeStringField('applicant_type', mapOfPolicyParameters.get('applicant_type') != null ? mapOfPolicyParameters.get('applicant_type') : '');
    }

    /*BUG-16959 by Rajesh added Prod condition for DBOL*/
    if (mapOfPolicyParameters.get('product') != null && setPSBLProdName.contains(mapOfPolicyParameters.get('product'))) {
      gen.writeStringField('applicant_type', mapOfPolicyParameters.get('applicant_type') != null ? mapOfPolicyParameters.get('applicant_type') : '');

      gen.writeNumberField('bankingCreditM1', Double.valueOf(mapOfPolicyParameters.get('bankingCreditM1')) != null ? Double.valueOf(mapOfPolicyParameters.get('bankingCreditM1')) : 0);
      gen.writeNumberField('bankingCreditM2', Double.valueOf(mapOfPolicyParameters.get('bankingCreditM2')) != null ? Double.valueOf(mapOfPolicyParameters.get('bankingCreditM2')) : 0);
      gen.writeNumberField('bankingCreditM3', Double.valueOf(mapOfPolicyParameters.get('bankingCreditM3')) != null ? Double.valueOf(mapOfPolicyParameters.get('bankingCreditM3')) : 0);

      gen.writeNumberField('bankingCreditM4', Double.valueOf(mapOfPolicyParameters.get('bankingCreditM4')) != null ? Double.valueOf(mapOfPolicyParameters.get('bankingCreditM4')) : 0);
      gen.writeNumberField('bankingCreditM5', Double.valueOf(mapOfPolicyParameters.get('bankingCreditM5')) != null ? Double.valueOf(mapOfPolicyParameters.get('bankingCreditM5')) : 0);
      gen.writeNumberField('bankingCreditM6', Double.valueOf(mapOfPolicyParameters.get('bankingCreditM6')) != null ? Double.valueOf(mapOfPolicyParameters.get('bankingCreditM6')) : 0);

      gen.writeNumberField('_10ThBalanceM1', Double.valueOf(mapOfPolicyParameters.get('_10ThBalanceM1')) != null ? Double.valueOf(mapOfPolicyParameters.get('_10ThBalanceM1')) : 0);
      gen.writeNumberField('_10ThBalanceM2', Double.valueOf(mapOfPolicyParameters.get('_10ThBalanceM2')) != null ? Double.valueOf(mapOfPolicyParameters.get('_10ThBalanceM2')) : 0);
      gen.writeNumberField('_10ThBalanceM3', Double.valueOf(mapOfPolicyParameters.get('_10ThBalanceM3')) != null ? Double.valueOf(mapOfPolicyParameters.get('_10ThBalanceM3')) : 0);

      gen.writeNumberField('_20ThBalanceM1', Double.valueOf(mapOfPolicyParameters.get('_20ThBalanceM1')) != null ? Double.valueOf(mapOfPolicyParameters.get('_20ThBalanceM1')) : 0);
      gen.writeNumberField('_20ThBalanceM2', Double.valueOf(mapOfPolicyParameters.get('_20ThBalanceM2')) != null ? Double.valueOf(mapOfPolicyParameters.get('_20ThBalanceM2')) : 0);
      gen.writeNumberField('_20ThBalanceM3', Double.valueOf(mapOfPolicyParameters.get('_20ThBalanceM3')) != null ? Double.valueOf(mapOfPolicyParameters.get('_20ThBalanceM3')) : 0);

      gen.writeNumberField('_30ThBalanceM1', Double.valueOf(mapOfPolicyParameters.get('_30ThBalanceM1')) != null ? Double.valueOf(mapOfPolicyParameters.get('_30ThBalanceM1')) : 0);
      gen.writeNumberField('_30ThBalanceM2', Double.valueOf(mapOfPolicyParameters.get('_30ThBalanceM2')) != null ? Double.valueOf(mapOfPolicyParameters.get('_30ThBalanceM2')) : 0);
      gen.writeNumberField('_30ThBalanceM3', Double.valueOf(mapOfPolicyParameters.get('_30ThBalanceM3')) != null ? Double.valueOf(mapOfPolicyParameters.get('_30ThBalanceM3')) : 0);

      gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id') != null ? mapOfPolicyParameters.get('loan_id') : '1');

    }

    gen.writeEndObject();
    gen.writeEndArray();

    /*BUG-16959 by Rajesh added Prod condition for DBOL*/
    if (mapOfPolicyParameters.get('product') != null && setPSBLProdName.contains(mapOfPolicyParameters.get('product'))) {
      gen.writeFieldName('CAMS');
      gen.writeStartArray();
      gen.writeStartObject();

      gen.writeNumberField('cyIncomefromBusinessandProfession', Double.valueOf(mapOfPolicyParameters.get('cyIncomefromBusinessandProfession')) != null ? Double.valueOf(mapOfPolicyParameters.get('cyIncomefromBusinessandProfession')) : 0);
      gen.writeNumberField('pyIncomefromBusinessandProfession', Double.valueOf(mapOfPolicyParameters.get('pyIncomefromBusinessandProfession')) != null ? Double.valueOf(mapOfPolicyParameters.get('pyIncomefromBusinessandProfession')) : 0);
      gen.writeStringField('cyFilingDate', mapOfPolicyParameters.get('cyFilingDate') != null ? mapOfPolicyParameters.get('cyFilingDate') : '');
      gen.writeStringField('pyFilingDate', mapOfPolicyParameters.get('pyFilingDate') != null ? mapOfPolicyParameters.get('pyFilingDate') : '');
      gen.writeNumberField('tenor', Double.valueOf(mapOfPolicyParameters.get('tenor')) != null ? Double.valueOf(mapOfPolicyParameters.get('tenor')) : 0);

      gen.writeEndObject();
      gen.writeEndArray();
    }

    gen.writeFieldName('profit_loss_statement');
    gen.writeStartObject();


    gen.writeNumberField('py_depriciation', Double.valueOf(mapOfPolicyParameters.get('py_depriciation')) != null ? Double.valueOf(mapOfPolicyParameters.get('py_depriciation')) : 0);
    gen.writeNumberField('cy_depriciation', Double.valueOf(mapOfPolicyParameters.get('cy_depriciation')) != null ? Double.valueOf(mapOfPolicyParameters.get('cy_depriciation')) : 0);

    gen.writeNumberField('cy_sales_turnover', Double.valueOf(mapOfPolicyParameters.get('cy_sales_turnover')) != null ? Double.valueOf(mapOfPolicyParameters.get('cy_sales_turnover')) : 0);
    gen.writeNumberField('py_sales_turnover', Double.valueOf(mapOfPolicyParameters.get('py_sales_turnover')) != null ? Double.valueOf(mapOfPolicyParameters.get('py_sales_turnover')) : 0);

    gen.writeNumberField('cy_net_profit', Double.valueOf(mapOfPolicyParameters.get('cy_net_profit')) != null ? Double.valueOf(mapOfPolicyParameters.get('cy_net_profit')) : 0);
    gen.writeNumberField('py_net_profit', Double.valueOf(mapOfPolicyParameters.get('py_net_profit')) != null ? Double.valueOf(mapOfPolicyParameters.get('py_net_profit')) : 0);

    gen.writeNumberField('py_cash_profit', Double.valueOf(mapOfPolicyParameters.get('py_cash_profit')) != null ? Double.valueOf(mapOfPolicyParameters.get('py_cash_profit')) : 0);

    if (mapOfPolicyParameters.get('product') != null && mapOfPolicyParameters.get('product') == 'RBL') {
      gen.writeNumberField('py_salary_to_partner', Double.valueOf(mapOfPolicyParameters.get('py_salary_to_partner')) != null ? Double.valueOf(mapOfPolicyParameters.get('py_salary_to_partner')) : 0);
      gen.writeNumberField('cy_salary_to_partner', Double.valueOf(mapOfPolicyParameters.get('cy_salary_to_partner')) != null ? Double.valueOf(mapOfPolicyParameters.get('cy_salary_to_partner')) : 0);

      gen.writeNumberField('py_interest_to_partner', Double.valueOf(mapOfPolicyParameters.get('py_interest_to_partner')) != null ? Double.valueOf(mapOfPolicyParameters.get('py_interest_to_partner')) : 0);
      gen.writeNumberField('cy_interest_to_partner', Double.valueOf(mapOfPolicyParameters.get('cy_interest_to_partner')) != null ? Double.valueOf(mapOfPolicyParameters.get('cy_interest_to_partner')) : 0);
    }

    //if(mapOfPolicyParameters.get('product') != null && mapOfPolicyParameters.get('product') == 'PSBL') {
    gen.writeNumberField('cy_total_networth', Double.valueOf(mapOfPolicyParameters.get('cy_total_networth')) != null ? Double.valueOf(mapOfPolicyParameters.get('cy_total_networth')) : 0);
    //gen.writeNumberField('cy_sales_turnover', Integer.valueOf(mapOfPolicyParameters.get('cy_sales_turnover')) != null ? Integer.valueOf(mapOfPolicyParameters.get('cy_sales_turnover')) : 0);
    //}
    /*BUG-16959 by Rajesh added Prod condition for DBOL*/
    if (mapOfPolicyParameters.get('product') != null && setPSBLProdName.contains(mapOfPolicyParameters.get('product'))) {
      gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id') != null ? mapOfPolicyParameters.get('loan_id') : '1');
    }

    gen.writeEndObject();

    //Bug 15854 - December_2017_RTR Calculator By Rajesh Start
    gen.writeFieldName('Existing_Loan');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeNumberField('number_of_business_loans', mapOfPolicyParameters.get('number_of_personal_loans') != null ? Double.valueOf(mapOfPolicyParameters.get('number_of_business_loans')) : 0);
    gen.writeNumberField('number_of_personal_loans', mapOfPolicyParameters.get('number_of_personal_loans') != null ? Double.valueOf(mapOfPolicyParameters.get('number_of_personal_loans')) : 0);
    gen.writeEndObject();
    gen.writeEndArray();

    //Bug 15854 - December_2017_RTR Calculator By Rajesh End

    gen.writeEndObject();

    String jsonString = gen.getAsString();

    System.debug('********JSON string to be passed for MCP********');
    System.debug(jsonString);

    Mid_office_BRE_flow__c BRE_MCP = Mid_office_BRE_flow__c.getValues('BRE MCP');
    if (BRE_MCP != null) {
      username = BRE_MCP.Username__c;
      password = BRE_MCP.Password__c;
      endpointURL = '';
      endpointURL = BRE_MCP.EndpointURL__c;
    }


    System.debug('********Endpoint for MCP********' + endpointURL);
    System.debug('********Username for MCP********' + username);
    System.debug('********Passowrd for MCP********' + password);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);

    Http http = new Http();
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {
      res = http.send(req);
    }
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response
      System.debug('Request -----> ' + req);
      String result = res.getBody();
      System.debug('Result ----->' + result);
      mapOfMCPResult = parseMCPResponseForBL(result);
      System.debug('Map of result -----> ' + mapOfMCPResult);
    } else {
      // Error in getting response
      System.debug('<-----CONNECTION ERROR----->');
    }


    return mapOfMCPResult;
  }

  // Response handling for new implementation of MCP for RBL and PSBL
  public Map < String, String > parseMCPResponseForBL(String result) {
    Map < String, String > responseMap = new Map < String, String > ();

    MCPResponseWrapper reponse = MCPResponseWrapper.parse(result);
    System.debug('*****Response*****' + reponse);

    String mcpList = '';
    for (MCPResponseWrapper.cls_mcp_list mcp: reponse.mcp_list) {
      mcpList += mcp.mcpDesc + ',';
    }

    String[] mcpListArray = mcpList.split(',');

    for (Integer i = 0; i < mcpListArray.size(); i++) {
      if (i < (mcpListArray.size() - 1))
        mcpResultdesc += mcpListArray[i] + ',';
      else
        mcpResultdesc += mcpListArray[i];
    }

    System.debug('*****MCP List*****' + mcpResultdesc);
    responseMap.put('MCPList', mcpResultdesc);

    String FinalResult = reponse.mcp_policy;
    responseMap.put('FinalResult', FinalResult);

    System.debug('Final response map ------->' + responseMap);

    return responseMap;
  }
  // End of MSME BL and Champion Challenger

  // Added for Champion Challenger surrogate WADL call
  public Map < String, String > callSurrogateEligibilityBL(Map < String, String > mapOfEligibility) {
    Map < String, String > mapOfResults;

    JSONGenerator gen = JSON.createGenerator(true);

    gen.writeStartObject();

    gen.writeFieldName('Cibil_lst');
    gen.writeStartArray();
    gen.writeStartObject();

    gen.writeNumberField('unsecured_live_loan_balance', mapOfEligibility.get('unsecured_live_loan_balance') != null ? Double.valueOf(mapOfEligibility.get('unsecured_live_loan_balance')) : 0);
    gen.writeStringField('applicant_Type', mapOfEligibility.get('applicant_type') != null ? mapOfEligibility.get('applicant_type') : '');
    gen.writeNumberField('CIBIL_Score', mapOfEligibility.get('CIBIL_Score') != null ? Double.valueOf(mapOfEligibility.get('CIBIL_Score')) : 0);
    gen.writeNumberField('dpdinLast24Months', mapOfEligibility.get('dpdinLast24Months') != null ? Double.valueOf(mapOfEligibility.get('dpdinLast24Months')) : 0);  // Bug Id : 20187
    gen.writeNumberField('overdueAmountGT5000', mapOfEligibility.get('overdueAmountGT5000') != null ? Double.valueOf(mapOfEligibility.get('overdueAmountGT5000')) : 0);  // Bug Id : 20187

    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('Loan_Parameter');
    gen.writeStartObject();

    gen.writeStringField('product', mapOfEligibility.get('product') != null ? mapOfEligibility.get('product') : '');
    gen.writeStringField('loan_id', mapOfEligibility.get('loan_id') != null ? mapOfEligibility.get('loan_id') : '');
    //gen.writeStringField('loan_application_number', mapOfEligibility.get('loan_id') != null ? mapOfEligibility.get('loan_id') : '');
    gen.writeNumberField('requested_loan_amount', mapOfEligibility.get('requested_loan_amount') != null ? Double.valueOf(mapOfEligibility.get('requested_loan_amount')) : 0);
    gen.writeNumberField('requested_tenor', mapOfEligibility.get('requested_tenor') != null ? Double.valueOf(mapOfEligibility.get('requested_tenor')) : 0);
    gen.writeNumberField('reqested_roi', mapOfEligibility.get('reqested_roi') != null ? Double.valueOf(mapOfEligibility.get('reqested_roi')) : 0);
    gen.writeStringField('stage', mapOfEligibility.get('stage') != null ? mapOfEligibility.get('stage') : '');
    gen.writeStringField('sub_stage', mapOfEligibility.get('sub_stage') != null ? mapOfEligibility.get('sub_stage') : '');

    gen.writeEndObject();

    gen.writeFieldName('Generic');
    gen.writeStartObject();

    gen.writeStringField('branch_name', mapOfEligibility.get('branch_name') != null ? mapOfEligibility.get('branch_name') : '');
    gen.writeStringField('branch_type', mapOfEligibility.get('branch_type') != null ? mapOfEligibility.get('branch_type') : '');
    gen.writeEndObject();

    gen.writeFieldName('profit_loss_statement');
    gen.writeStartObject();

    gen.writeNumberField('py_sales_turnover', mapOfEligibility.get('py_sales_turnover') != null ? Double.valueOf(mapOfEligibility.get('py_sales_turnover')) : 0);
    gen.writeNumberField('cy_sales_turnover', mapOfEligibility.get('cy_sales_turnover') != null ? Double.valueOf(mapOfEligibility.get('cy_sales_turnover')) : 0);
    gen.writeNumberField('py_depriciation', mapOfEligibility.get('py_depriciation') != null ? Double.valueOf(mapOfEligibility.get('py_depriciation')) : 0);
    gen.writeNumberField('cy_depriciation', mapOfEligibility.get('cy_depriciation') != null ? Double.valueOf(mapOfEligibility.get('cy_depriciation')) : 0);
    gen.writeNumberField('cy_net_profit', mapOfEligibility.get('cy_net_profit') != null ? Double.valueOf(mapOfEligibility.get('cy_net_profit')) : 0);
    gen.writeNumberField('py_net_profit', mapOfEligibility.get('py_net_profit') != null ? Double.valueOf(mapOfEligibility.get('py_net_profit')) : 0);
    //gen.writeNumberField('cy_cash_profit', mapOfEligibility.get('cy_cash_profit') != null ? Double.valueOf(mapOfEligibility.get('cy_cash_profit')) : 0);
    //gen.writeNumberField('py_cash_profit', mapOfEligibility.get('py_cash_profit') != null ? Double.valueOf(mapOfEligibility.get('py_cash_profit')) : 0);
    gen.writeStringField('ratingAgency', mapOfEligibility.get('ratingAgency') != null ? mapOfEligibility.get('ratingAgency') : '');
    gen.writeStringField('rating', mapOfEligibility.get('rating') != null ? mapOfEligibility.get('rating') : '');
    gen.writeStringField('typeOfRating', mapOfEligibility.get('typeOfRating') != null ? mapOfEligibility.get('typeOfRating') : '');
    gen.writeStringField('creditProgram', mapOfEligibility.get('creditProgram') != null ? mapOfEligibility.get('creditProgram') : '');
    gen.writeNumberField('mob', mapOfEligibility.get('mob') != null ? Double.valueOf(mapOfEligibility.get('mob')) : 0);
    gen.writeNumberField('autoLoanEMI', mapOfEligibility.get('autoLoanEMI') != null ? Double.valueOf(mapOfEligibility.get('autoLoanEMI')) : 0);
    gen.writeNumberField('targetLoanAmount', mapOfEligibility.get('targetLoanAmount') != null ? Double.valueOf(mapOfEligibility.get('targetLoanAmount')) : 0);
    gen.writeNumberField('cy_income_as_per_itr', mapOfEligibility.get('cy_income_as_per_itr') != null ? Double.valueOf(mapOfEligibility.get('cy_income_as_per_itr')) : 0);
    gen.writeNumberField('py_income_as_per_itr', mapOfEligibility.get('py_income_as_per_itr') != null ? Double.valueOf(mapOfEligibility.get('py_income_as_per_itr')) : 0);

    gen.writeEndObject();
    gen.writeFieldName('Demographic');
    gen.writeStartArray();
    gen.writeStartObject();

    gen.writeStringField('nature_of_business', mapOfEligibility.get('nature_of_business') != null ? mapOfEligibility.get('nature_of_business') : '');
    gen.writeStringField('type_of_constitution', mapOfEligibility.get('type_of_constitution') != null ? mapOfEligibility.get('type_of_constitution') : '');
    gen.writeStringField('constitution', mapOfEligibility.get('constitution') != null ? mapOfEligibility.get('constitution') : '');
    gen.writeStringField('costomer_type', mapOfEligibility.get('costomer_type') != null ? mapOfEligibility.get('costomer_type') : '');
    gen.writeStringField('customer_type', mapOfEligibility.get('customer_type') != null ? mapOfEligibility.get('customer_type') : '');
    gen.writeStringField('applicant_type', mapOfEligibility.get('applicant_type') != null ? mapOfEligibility.get('applicant_type') : '');
    gen.writeStringField('first_name', mapOfEligibility.get('first_name') != null ? mapOfEligibility.get('first_name') : '');
    gen.writeStringField('last_name', mapOfEligibility.get('last_name') != null ? mapOfEligibility.get('last_name') : '');
    gen.writeStringField('customer_segment', mapOfEligibility.get('customer_segment') != null ? mapOfEligibility.get('customer_segment') : '');
    gen.writeNumberField('years_in_business_job', mapOfEligibility.get('years_in_business_job') != null ? Double.valueOf(mapOfEligibility.get('years_in_business_job')) : 0);
    gen.writeStringField('date_of_incorporation', mapOfEligibility.get('date_of_incorporation') != null ? mapOfEligibility.get('date_of_incorporation') : '');
    gen.writeStringField('lastDoneDate', mapOfEligibility.get('lastDoneDate') != null ? mapOfEligibility.get('lastDoneDate') : '');

    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('existing_loan');
    gen.writeStartArray();
    gen.writeStartObject();

    gen.writeStringField('applicant_type', mapOfEligibility.get('applicant_type') != null ? mapOfEligibility.get('applicant_type') : '');
    gen.writeNumberField('monthly_loan_obligations', mapOfEligibility.get('monthly_loan_obligations') != null ? Double.valueOf(mapOfEligibility.get('monthly_loan_obligations')) : 0);
    //gen.writeNumberField('securedLoanAmount', Double.valueOf(mapOfEligibility.get('securedLoanAmount')) != null ? Double.valueOf(mapOfEligibility.get('securedLoanAmount')) : 0);
    //gen.writeNumberField('securedMOB', Integer.valueOf(mapOfEligibility.get('securedMOB')) != null ? Integer.valueOf(mapOfEligibility.get('securedMOB')) : 0);
    gen.writeNumberField('maxAL', mapOfEligibility.get('maxAL') != null ? Double.valueOf(mapOfEligibility.get('maxAL')) : 0);
    gen.writeNumberField('maxPL', mapOfEligibility.get('maxPL') != null ? Double.valueOf(mapOfEligibility.get('maxPL')) : 0);
    gen.writeNumberField('maxBL', mapOfEligibility.get('maxBL') != null ? Double.valueOf(mapOfEligibility.get('maxBL')) : 0);
    gen.writeNumberField('maxHL', mapOfEligibility.get('maxHL') != null ? Double.valueOf(mapOfEligibility.get('maxHL')) : 0);
    gen.writeNumberField('maxLAP', mapOfEligibility.get('maxLAP') != null ? Double.valueOf(mapOfEligibility.get('maxLAP')) : 0);
    gen.writeNumberField('annual_obligations', mapOfEligibility.get('annual_obligations') != null ? Double.valueOf(mapOfEligibility.get('annual_obligations')) : 0);
    gen.writeNumberField('number_of_live_AL', mapOfEligibility.get('number_of_live_AL') != null ? Double.valueOf(mapOfEligibility.get('number_of_live_AL')) : 0); // Bug Id : 20187
    gen.writeNumberField('number_of_live_HL', mapOfEligibility.get('number_of_live_HL') != null ? Double.valueOf(mapOfEligibility.get('number_of_live_HL')) : 0);
    gen.writeNumberField('number_of_live_LAP', mapOfEligibility.get('number_of_live_LAP') != null ? Double.valueOf(mapOfEligibility.get('number_of_live_LAP')) : 0);
    gen.writeNumberField('sanction_amount_AL', mapOfEligibility.get('sanction_amount_AL') != null ? Double.valueOf(mapOfEligibility.get('sanction_amount_AL')) : 0);
    gen.writeNumberField('sanction_amount_BL', mapOfEligibility.get('sanction_amount_BL') != null ? Double.valueOf(mapOfEligibility.get('sanction_amount_BL')) : 0);
    gen.writeNumberField('sanction_amount_PL', mapOfEligibility.get('sanction_amount_PL') != null ? Double.valueOf(mapOfEligibility.get('sanction_amount_PL')) : 0);
    gen.writeNumberField('sanction_amount_HL', mapOfEligibility.get('sanction_amount_HL') != null ? Double.valueOf(mapOfEligibility.get('sanction_amount_HL')) : 0);
    gen.writeNumberField('sanction_amount_LAP', mapOfEligibility.get('sanction_amount_LAP') != null ? Double.valueOf(mapOfEligibility.get('sanction_amount_LAP')) : 0);  // Bug Id : 20187
    // Bug Id : 21890 tag name of personal loans
    gen.writeNumberField('number_of_bl_loans', mapOfEligibility.get('number_of_bl_loans') != null ? Integer.valueOf(mapOfEligibility.get('number_of_bl_loans')) : 0);  // Bug Id : 20187 
    gen.writeNumberField('number_of_personal_loans', mapOfEligibility.get('number_of_personal_loans') != null ? Integer.valueOf(mapOfEligibility.get('number_of_personal_loans')) : 0);  // Bug Id : 20187

    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('Bank_summary');
    gen.writeStartArray();
    gen.writeStartObject();

    gen.writeStringField('applicant_type', mapOfEligibility.get('applicant_type') != null ? mapOfEligibility.get('applicant_type') : '');
    gen.writeNumberField('avg_od_cc_limit', mapOfEligibility.get('avg_od_cc_limit') != null ? Double.valueOf(mapOfEligibility.get('avg_od_cc_limit')) : 0);
    gen.writeStringField('_10th_balance', mapOfEligibility.get('_10th_balance') != null ? mapOfEligibility.get('_10th_balance') : '0');
    gen.writeStringField('_20th_balance', mapOfEligibility.get('_20th_balance') != null ? mapOfEligibility.get('_20th_balance') : '0');
    gen.writeStringField('last_day_balance', mapOfEligibility.get('last_day_balance') != null ? mapOfEligibility.get('last_day_balance') : '0');
    gen.writeNumberField('bankingCreditM1', mapOfEligibility.get('bankingCreditM1') != null ? Double.valueOf(mapOfEligibility.get('bankingCreditM1')) : 0);
    gen.writeNumberField('bankingCreditM2', mapOfEligibility.get('bankingCreditM2') != null ? Double.valueOf(mapOfEligibility.get('bankingCreditM2')) : 0);
    gen.writeNumberField('bankingCreditM3', mapOfEligibility.get('bankingCreditM3') != null ? Double.valueOf(mapOfEligibility.get('bankingCreditM3')) : 0);
    gen.writeNumberField('bankingCreditM4', mapOfEligibility.get('bankingCreditM4') != null ? Double.valueOf(mapOfEligibility.get('bankingCreditM4')) : 0);
    gen.writeNumberField('bankingCreditM5', mapOfEligibility.get('bankingCreditM5') != null ? Double.valueOf(mapOfEligibility.get('bankingCreditM5')) : 0);
    gen.writeNumberField('bankingCreditM6', mapOfEligibility.get('bankingCreditM6') != null ? Double.valueOf(mapOfEligibility.get('bankingCreditM6')) : 0);
    gen.writeNumberField('odccLimit', mapOfEligibility.get('odccLimit') != null ? Double.valueOf(mapOfEligibility.get('odccLimit')) : 0);

    gen.writeEndObject();
    gen.writeEndArray();
    gen.writeFieldName('CAMS');

    gen.writeStartArray();
    gen.writeStartObject();

    gen.writeNumberField('pyIncomeFromBusinessandProfession', mapOfEligibility.get('pyIncomeFromBusinessandProfession') != null ? Double.valueOf(mapOfEligibility.get('pyIncomeFromBusinessandProfession')) : 0);
    gen.writeNumberField('cyIncomeFromBusinessandProfession', mapOfEligibility.get('cyIncomeFromBusinessandProfession') != null ? Double.valueOf(mapOfEligibility.get('cyIncomeFromBusinessandProfession')) : 0);

    gen.writeEndObject();
    gen.writeEndArray();

    String jsonString = gen.getAsString();

    System.debug('********JSON string to be passed for Eligibility********');
    System.debug(jsonString);

    Mid_office_BRE_flow__c BRE_Eligibility = Mid_office_BRE_flow__c.getValues('BRE Surrogate Eligibility');
    if (BRE_Eligibility != null) {
      username = BRE_Eligibility.Username__c;
      password = BRE_Eligibility.Password__c;
      endpointURL = BRE_Eligibility.EndpointURL__c;
    }

    //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/Surrogate/versions/0.0.1-SNAPSHOT/rules/Surrogate/surrogateMain/executions';
    System.debug('********Endpoint for Eligibility********' + endpointURL);
    System.debug('********Username for Eligibility********' + username);
    System.debug('********Passowrd for Eligibility********' + password);


    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);

    if (!Test.isRunningTest()) {
      Http http = new Http();
      HTTPResponse res = http.send(req);

      if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
        // Proper Response
        System.debug('Request -----> ' + req);
        String result = res.getBody();
        System.debug('Result ----->' + result);
        mapOfResults = parseSurrogateResponseForBL(result);
        System.debug('Map of result -----> ' + mapOfResults);
      } else {
        // Error in getting response
        System.debug('<-----CONNECTION ERROR----->');
      }
    }
    return mapOfResults;
  }


  public Map < String, String > parseSurrogateResponseForBL(String result) {
    Map < String, String > mapOfResults = new Map < String, String > ();

    BLSurrogateEligibilityWrapper reponse = BLSurrogateEligibilityWrapper.parse(result);
    System.debug('*****Response*****' + reponse);

    if (reponse != null && reponse.Eligibility != null && reponse.Eligibility.size() > 0) {
      mapOfResults.put('eligibleLoanAmountLAP', reponse.Eligibility[0].eligibleLoanAmountLAP);
      mapOfResults.put('eligibleLoanAmountHL', reponse.Eligibility[0].eligibleLoanAmountHL);
      mapOfResults.put('eligibleLoanAmountAL', reponse.Eligibility[0].eligibleLoanAmountAL);
      mapOfResults.put('eligibleLoanAmountODCC', reponse.Eligibility[0].eligibleLoanAmountODCC);
      mapOfResults.put('eligibleLoanAmountCACCOUNT', reponse.Eligibility[0].eligibleLoanAmountCACCOUNT);
      mapOfResults.put('eligibleLoanAmountITR', reponse.Eligibility[0].eligibleLoanAmountITR);
      mapOfResults.put('eligibleLoanAmountRTR', reponse.Eligibility[0].eligibleLoanAmountRTR);
      mapOfResults.put('eligibleAmount', reponse.Eligibility[0].eligibleAmount);
      mapOfResults.put('eligibleLoanAmountCRISIL', reponse.Eligibility[0].eligibleLoanAmountCRISIL);
      mapOfResults.put('eligibleLoanAmountCC', reponse.Eligibility[0].eligibleLoanAmountCC);
    }
    System.debug('*****Eligibility List*****');
    for (String key: mapOfResults.keySet()) {
      System.debug('Key ==> ' + key + ' Value ==> ' + mapOfResults.get(key));
    }

    return mapOfResults;
  }
  // End of Champion Challenger surrogate WADL call

  //CIBIL_Score
  //PRO DSS NEW CREDIT PROGRAM FOR CA SEP start
  //code added by Leena-13487 Engineering Program start added null checks valuesIndMap.containsKey
  public Map < String, String > callBREMcpCheckCASEP(Map < string, string > valuesIndMap) {
    Map < String, String > mapMCPResult = new Map < String, String > ();
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeFieldName('loan_parameter');
    gen.writeStartObject();
    if (valuesIndMap.containsKey('product'))
      gen.writeObjectField('product', valuesIndMap.get('product'));
    if (valuesIndMap.containsKey('process_type'))
      gen.writeObjectField('process_type', valuesIndMap.get('process_type'));
    if (valuesIndMap.containsKey('program_type'))
      gen.writeObjectField('program_type', valuesIndMap.get('program_type'));
    gen.writeEndObject();
    System.debug('::1::');

    /*gen.writeFieldName('CAMS');
gen.writeStartArray();
for(Integer i =0 ; i<1 ;i++){
    gen.writeStartObject(); 
        gen.writeNumberField('gross_Salary_Month1', Decimal.valueof(valuesIndMap.get('gross_Salary_Month1')));  
        gen.writeNumberField('gross_Salary_Month2', Decimal.valueof(valuesIndMap.get('gross_Salary_Month2')));
    gen.writeEndObject();
}
gen.writeEndArray();
System.debug('::2::');*/

    gen.writeFieldName('Cibil_lst');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      integer cibiliScore = 0;
      if (valuesIndMap.containsKey('CIBIL_Score'))
        if (valuesIndMap.get('CIBIL_Score').isNumeric())
          if (valuesIndMap.containsKey('CIBIL_Score'))
            cibiliScore = Integer.valueof(valuesIndMap.get('CIBIL_Score'));
      gen.writeNumberField('CIBIL_Score', cibiliScore);
      if (valuesIndMap.containsKey('applicant_Type'))
        gen.writeObjectField('applicant_Type', valuesIndMap.get('applicant_Type'));
      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::3::');

    gen.writeFieldName('demographic');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      //leena changes integer to decimal.valueOf
      // system.debug('valuesIndMap.get===>'+valuesIndMap.get('total_employment_vintage'));
      if (valuesIndMap.containsKey('total_employment_vintage'))
        gen.writeNumberField('total_employment_vintage', valuesIndMap.get('total_employment_vintage') != null ? Decimal.valueof(valuesIndMap.get('total_employment_vintage')) : 0);
      //gen.writeObjectField('company_category', valuesIndMap.get('company_category'));         
      if (valuesIndMap.containsKey('customer_type'))
        gen.writeObjectField('customer_type', valuesIndMap.get('customer_type'));
      if (valuesIndMap.containsKey('practiceType'))
        gen.writeObjectField('practiceType', valuesIndMap.get('practiceType'));
      if (valuesIndMap.containsKey('professionType'))
        gen.writeObjectField('professionType', valuesIndMap.get('professionType'));
      //code added by Leena-13487 Engineering Program start
      if (valuesIndMap.containsKey('profession')) {
        gen.writeObjectField('profession', valuesIndMap.get('profession'));
      }
      if (valuesIndMap.containsKey('post_qualification_exp')) {
        gen.writeNumberField('post_qualification_exp', Integer.valueof(valuesIndMap.get('post_qualification_exp')));
      }
      //code added by Leena-13487 Engineering Program end
      //code added by Rohan-17655 Diploma Engineering Program start
      if (valuesIndMap.containsKey('type_of_degree')) {
        gen.writeObjectField('type_of_degree', valuesIndMap.get('type_of_degree'));
      }
      if (valuesIndMap.containsKey('years_in_business_job')) {
        gen.writeNumberField('years_in_business_job', Decimal.valueof(valuesIndMap.get('years_in_business_job')));
      }
      //code added by Rohan-17655 Diploma Engineering Program end
      if (valuesIndMap.containsKey('applicant_type'))
        gen.writeObjectField('applicant_type', valuesIndMap.get('applicant_type'));
      if (valuesIndMap.containsKey('date_of_birth'))
        gen.writeObjectField('date_of_birth', valuesIndMap.get('date_of_birth'));
      if (valuesIndMap.containsKey('ownershipType'))
        gen.writeObjectField('ownershipType', valuesIndMap.get('ownershipType'));
      if (valuesIndMap.containsKey('fullTimeCop'))
        gen.writeObjectField('fullTimeCop', valuesIndMap.get('fullTimeCop'));
      if (valuesIndMap.containsKey('copStatus'))
        gen.writeObjectField('copStatus', valuesIndMap.get('copStatus'));
      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::::4::::');

    String jsonString = gen.getAsString();
    System.debug('::jsonString::' + jsonString);


    HTTPResponse res = createRequest(jsonString, 'BRE MCP');


    System.debug('::Response' + res);
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response        
      String result = res.getBody();
      System.debug('Result ----->' + result);
      //Parse response         
      Map < String, Object > mapDesJson = (Map < String, Object > ) JSON.deserializeUntyped(result);
      System.debug('::::' + mapDesJson);
      String policyRes = (String) mapDesJson.get('mcp_policy');
      System.debug('::::' + policyRes);


      // Changes added for Bug 14601 Failed policy getting fom mcp_list
      //Map < String, Object > mcpDescMap = (Map < String, Object >) mapDesJson.get('mcp_list');
      list < Object > mcpDescMap = (list < Object > ) mapDesJson.get('mcp_list');
      System.debug('*************** mcpDescMap: ' + mcpDescMap);
      string failedPolicyName = ';';
      List < String > Failepolicylist = new List < String > ();
      for (Object listDesc: mcpDescMap) {
        Map < String, Object > mapdesc = (Map < String, Object > ) listDesc;
        String outputresult = (String) mapdesc.get('mcpOutput');
        if (outputresult == 'MCP FAIL') {
          String failedpol = (String) mapdesc.get('mcpDesc');
          failedPolicyName = failedPolicyName + failedpol + ';';
        }
      }
      mapMCPResult.put('Status', 'Success');
      mapMCPResult.put('mcp_policy', policyRes);
      mapMCPResult.put('failed_Policy_Name', failedPolicyName);

    } else {
      mapMCPResult.put('Status', 'Failed');
      System.debug('<-----CONNECTION ERROR----->');
    }
    System.debug('mapMCPResultBRE::' + mapMCPResult);
    return mapMCPResult;


  }



  //PRO DSS NEW CREDIT PROGRAM FOR CA SEP end

  /*
Code added by Rakesh Shinde. Date: 22 March 2016
Purpose :Bug :6217. PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED. Added method to call MCP WADL
   */
  public Map < String, String > callBREMcpCheckCASalaried(Map < string, string > valuesIndMap) {

    System.debug('::callBREMcpCheckCASalaried::');
    System.debug('::valuesIndMap::' + valuesIndMap);

    //Map<String,Object> mcpObj = new  Map<String,Object>(); date_of_birth
    Map < String, String > mapMCPResult = new Map < String, String > ();
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();

    gen.writeFieldName('loan_parameter');
    gen.writeStartObject();
    gen.writeObjectField('product', valuesIndMap.get('product'));
    gen.writeObjectField('process_type', valuesIndMap.get('process_type'));
    if (valuesIndMap.containsKey('program_type'))
      gen.writeObjectField('program_type', valuesIndMap.get('program_type'));
    gen.writeEndObject();
    System.debug('::1::');

    gen.writeFieldName('CAMS');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      gen.writeNumberField('gross_Salary_Month1', Decimal.valueof(valuesIndMap.get('gross_Salary_Month1')));
      gen.writeNumberField('gross_Salary_Month2', Decimal.valueof(valuesIndMap.get('gross_Salary_Month2')));
      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::2::');

    gen.writeFieldName('Cibil_lst');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      integer cibiliScore = 0;
      if (valuesIndMap.get('CIBIL_Score').isNumeric())
        cibiliScore = Integer.valueof(valuesIndMap.get('CIBIL_Score'));
      gen.writeNumberField('CIBIL_Score', cibiliScore);
      gen.writeObjectField('applicant_Type', valuesIndMap.get('applicant_Type'));
      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::3::');

    gen.writeFieldName('demographic');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      gen.writeNumberField('total_employment_vintage', Integer.valueof(valuesIndMap.get('total_employment_vintage')));
      gen.writeObjectField('company_category', valuesIndMap.get('company_category'));
      gen.writeObjectField('customer_type', valuesIndMap.get('customer_type'));
      gen.writeObjectField('practiceType', valuesIndMap.get('practiceType'));
      gen.writeObjectField('professionType', valuesIndMap.get('professionType'));
      gen.writeObjectField('applicant_type', valuesIndMap.get('applicant_type'));
      if (valuesIndMap.containsKey('date_of_birth'))
        gen.writeObjectField('date_of_birth', valuesIndMap.get('date_of_birth'));
      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::::4::::');

    String jsonString = gen.getAsString();
    System.debug('::jsonString::' + jsonString);
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {
      res = createRequest(jsonString, 'BRE MCP');
    }

    System.debug('::Response' + res);
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response        
      String result = res.getBody();
      System.debug('Result ----->' + result);
      //Parse response         
      Map < String, Object > mapDesJson = (Map < String, Object > ) JSON.deserializeUntyped(result);
      System.debug('::::' + mapDesJson);
      String policyRes = (String) mapDesJson.get('mcp_policy');
      System.debug('::::' + policyRes);


      Map < String, Object > mcpDescMap = (Map < String, Object > ) mapDesJson.get('mcp_obj');
      String failedPolicyName = (String) mcpDescMap.get('mcpDesc');
      System.debug('::::failedPolicyName' + failedPolicyName);

      mapMCPResult.put('Status', 'Success');
      mapMCPResult.put('mcp_policy', policyRes);
      mapMCPResult.put('failed_Policy_Name', failedPolicyName);
    } else {
      mapMCPResult.put('Status', 'Failed');
      System.debug('<-----CONNECTION ERROR----->');
    }
    System.debug('mapMCPResultBRE::' + mapMCPResult);
    return mapMCPResult;
  }

  /*
Code added by Rakesh Shinde. Date: 22 March 2016
Purpose :Bug :6217. PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED. Added method to call Eligibility WADL
   */
  public Map < String, String > callBREEligibilityCASal(Map < string, string > valuesIndMap) {
    System.debug('::callBREEligibilityCASald::');
    System.debug('::valuesIndMap::' + valuesIndMap);

    Map < String, String > mapEligibilityResult = new Map < String, String > ();
    String foir = '';
    String eligibleLoanAmount = '';
    String roi = '';
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();

    gen.writeFieldName('Loan_Parameter');
    gen.writeStartObject();
    //SAL PLTB Pritha adding tag
    if (valuesIndMap.containsKey('offer_amount'))
      gen.writeNumberField('offer_amount', Decimal.valueof(valuesIndMap.get('offer_amount')));
    gen.writeNumberField('requested_tenor', Decimal.valueof(valuesIndMap.get('requested_tenor')));
    gen.writeNumberField('reqested_roi', Decimal.valueof(valuesIndMap.get('reqested_roi')));

    gen.writeObjectField('product', valuesIndMap.get('product'));
    gen.writeObjectField('processType', valuesIndMap.get('processType'));
    if (valuesIndMap.containsKey('practiceType'))
      gen.writeObjectField('practiceType', valuesIndMap.get('practiceType'));
    if (valuesIndMap.containsKey('program_type'))
      gen.writeObjectField('program_type', valuesIndMap.get('program_type'));
    if (valuesIndMap.containsKey('requested_loan_amount'))
      gen.writeNumberField('requested_loan_amount', Decimal.valueof(valuesIndMap.get('requested_loan_amount')));
    if (valuesIndMap.containsKey('approved_loan_amount'))
      gen.writeObjectField('approved_loan_amount', Decimal.valueof(valuesIndMap.get('approved_loan_amount')));
    gen.writeEndObject();
    System.debug('::1::');

    gen.writeFieldName('CAMS');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      gen.writeNumberField('applicant_net_salary_m1', Decimal.valueof(valuesIndMap.get('applicant_net_salary_m1')));
      gen.writeNumberField('applicant_net_salary_m2', Decimal.valueof(valuesIndMap.get('applicant_net_salary_m2')));
      //added for call center S
      if (valuesIndMap.containsKey('applicant_net_salary_m3')) {
        if (Decimal.valueof(valuesIndMap.get('applicant_net_salary_m3')) != null) {
          gen.writeNumberField('applicant_net_salary_m3', Decimal.valueof(valuesIndMap.get('applicant_net_salary_m3')));
        }
      }
      //SAL PLTB Pritha S
      if (valuesIndMap.containsKey('co_applicant_net_salary_m1')) {
        gen.writeNumberField('co_applicant_net_salary_m1', valuesIndMap.get('co_applicant_net_salary_m1') == null ? 0 : Decimal.valueof(valuesIndMap.get('co_applicant_net_salary_m1')));
      }
      if (valuesIndMap.containsKey('co_applicant_net_salary_m2')) {
        gen.writeNumberField('co_applicant_net_salary_m2', valuesIndMap.get('co_applicant_net_salary_m2') == null ? 0 : Decimal.valueof(valuesIndMap.get('co_applicant_net_salary_m2')));
      }
      if (valuesIndMap.containsKey('co_applicant_net_salary_m3')) {
        gen.writeNumberField('co_applicant_net_salary_m3', valuesIndMap.get('co_applicant_net_salary_m3') == null ? 0 : Decimal.valueof(valuesIndMap.get('co_applicant_net_salary_m3')));
      }
      if (valuesIndMap.containsKey('lta_medical_amount')) {
        gen.writeNumberField('lta_medical_amount', valuesIndMap.get('lta_medical_amount') == null ? 0 : Decimal.valueof(valuesIndMap.get('lta_medical_amount')));
      }

      //SAL PLTB Pritha E
      if (valuesIndMap.containsKey('avgIncentive')) {
        if (Decimal.valueof(valuesIndMap.get('avgIncentive')) != null) {
          gen.writeNumberField('avgIncentive', Decimal.valueof(valuesIndMap.get('avgIncentive')));
        }
      }
      if (valuesIndMap.containsKey('reimbursement')) {
        if (Decimal.valueof(valuesIndMap.get('reimbursement')) != null) {
          gen.writeNumberField('reimbursement', Decimal.valueof(valuesIndMap.get('reimbursement')));
        }
      }
      if (valuesIndMap.containsKey('rental_Income')) {
        if (Decimal.valueof(valuesIndMap.get('rental_Income')) != null) {
          gen.writeNumberField('rental_Income', Decimal.valueof(valuesIndMap.get('rental_Income')));
        }
      }
      if (valuesIndMap.containsKey('adjusted_rental_income')) {
        if (Decimal.valueof(valuesIndMap.get('adjusted_rental_income')) != null) {
          gen.writeNumberField('adjusted_rental_income', Decimal.valueof(valuesIndMap.get('adjusted_rental_income')));
        }
      }
      //added for call center E
      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::2::');

    gen.writeFieldName('existing_loan');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      gen.writeNumberField('monthly_loan_obligations', Decimal.valueof(valuesIndMap.get('monthly_loan_obligations')));
      gen.writeObjectField('applicant_type', valuesIndMap.get('applicant_type'));
      gen.writeObjectField('mortgageLoan', valuesIndMap.get('mortgageLoan'));
      //SAL PLTB Pritha S //SAL PLTB number_of_hl_loans case changed by priya
      if (valuesIndMap.containsKey('number_of_hl_loans')) {
        gen.writeObjectField('number_of_hl_loans', Decimal.valueof(valuesIndMap.get('number_of_hl_loans')));
      }
      //SAL PLTB Pritha E
      //SAL PLTB added by priya Start
      if (valuesIndMap.containsKey('bajaj_loan_obligations')) {
        gen.writeObjectField('bajaj_loan_obligations', Decimal.valueof(valuesIndMap.get('bajaj_loan_obligations')));
      }
      //SAL PLTB added by priya End
      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::3::');

    gen.writeFieldName('Generic');
    gen.writeStartObject();
    gen.writeObjectField('branch_type', valuesIndMap.get('branch_type'));
    if (valuesIndMap.containsKey('branch_name')) //SAL PLTB Pritha
      gen.writeObjectField('branch_name', valuesIndMap.get('branch_name')); //SAL PLTB Pritha
    gen.writeEndObject();
    System.debug('::4::');

    gen.writeFieldName('Cibil_lst');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      integer cibiliScore = 0;
      if (valuesIndMap.get('CIBIL_Score').isNumeric())
        cibiliScore = Integer.valueof(valuesIndMap.get('CIBIL_Score'));
      gen.writeNumberField('CIBIL_Score', cibiliScore);
      gen.writeObjectField('applicant_Type', valuesIndMap.get('applicant_type'));
      //PRO DSS CA SEP start
      if (valuesIndMap.containsKey('securedLoanAmount'))
        gen.writeObjectField('securedLoanAmount', Decimal.valueof(valuesIndMap.get('securedLoanAmount')));
      if (valuesIndMap.containsKey('unSecuredLoanAmount'))
        gen.writeObjectField('unSecuredLoanAmount', Decimal.valueof(valuesIndMap.get('unSecuredLoanAmount')));
      if (valuesIndMap.containsKey('securedMob'))
        gen.writeObjectField('securedMob', Decimal.valueof(valuesIndMap.get('securedMob')));
      if (valuesIndMap.containsKey('unsecuredMob'))
        gen.writeObjectField('unsecuredMob', Decimal.valueof(valuesIndMap.get('unsecuredMob')));
      //PRO DSS CA SEP end
      //code added by Leena-13487 Engineering Program start 
      if (valuesIndMap.containsKey('maxCreditCardAmount'))
        gen.writeObjectField('credit_card_amount', Decimal.valueof(valuesIndMap.get('maxCreditCardAmount')));
      if (valuesIndMap.containsKey('autoLoan'))
        gen.writeObjectField('autoLoan', Decimal.valueof(valuesIndMap.get('autoLoan')));
      if (valuesIndMap.containsKey('autoLoanMob'))
        gen.writeObjectField('autoLoanMob', Decimal.valueof(valuesIndMap.get('autoLoanMob')));
      //code added by Leena-13487 Engineering Program end
      /*SAL PLTB Changes 14951 added by Anshita Start*/
      if (valuesIndMap.containsKey('overdueAmtinLast24Month'))
        gen.writeObjectField('overdueAmtinLast24Month', Decimal.valueof(valuesIndMap.get('overdueAmtinLast24Month')));
      if (valuesIndMap.containsKey('dpdinLast3Months'))
        gen.writeObjectField('dpdinLast3Months', valuesIndMap.get('dpdinLast3Months'));
      if (valuesIndMap.containsKey('dpdinLast6Months'))
        gen.writeObjectField('dpdinLast6Months', valuesIndMap.get('dpdinLast6Months'));
      /*SAL PLTB Changes 14951 added by Anshita End*/
      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::5::');

    gen.writeFieldName('Demographic');
    gen.writeStartArray();
    for (Integer i = 0; i < 1; i++) {
      //added riskSegmentClassification for OTP V3 wadl change
      gen.writeStartObject();
      if (valuesIndMap.containsKey('riskSegmentClassification'))
        gen.writeObjectField('riskSegmentClassification', valuesIndMap.get('riskSegmentClassification'));
      if (valuesIndMap.containsKey('profession'))
        gen.writeObjectField('profession', valuesIndMap.get('profession'));
      if (valuesIndMap.containsKey('applicant_type'))
        gen.writeObjectField('applicant_type', valuesIndMap.get('applicant_type'));
      if (valuesIndMap.containsKey('date_of_birth'))
        gen.writeObjectField('date_of_birth', valuesIndMap.get('date_of_birth'));

      //code added by Leena-13487 Engineering Program start added if
      if (valuesIndMap.containsKey('post_qualification_exp')) {
        system.debug('contains key post_qualification_ex');
        gen.writeNumberField('post_qualification_exp', Integer.valueof(valuesIndMap.get('post_qualification_exp')));
      }
      //code added by Leena-13487 Engineering Program start 
      //Leena PO work experience change integer to decimal
      if (valuesIndMap.containsKey('total_employment_vintage'))
        gen.writeNumberField('total_employment_vintage', valuesIndMap.get('total_employment_vintage') != null ? Decimal.valueof(valuesIndMap.get('total_employment_vintage')) : 0);
      if (valuesIndMap.containsKey('customer_segment'))
        gen.writeObjectField('customer_segment', valuesIndMap.get('customer_segment'));
      if (valuesIndMap.containsKey('company_category'))
        gen.writeObjectField('company_category', valuesIndMap.get('company_category')); //SAL PLTB Pritha
      if (valuesIndMap.containsKey('type_of_degree'))
        gen.writeObjectField('type_of_degree', valuesIndMap.get('type_of_degree'));
      if (valuesIndMap.containsKey('professionType'))
        gen.writeObjectField('professionType', valuesIndMap.get('professionType'));
      if (valuesIndMap.containsKey('years_in_business_job'))
        gen.writeNumberField('years_in_business_job', Integer.valueof(valuesIndMap.get('years_in_business_job')));
      /*SAL PLTB Changes 14951 added by Anshita Start*/
      if (valuesIndMap.containsKey('specialProfile'))
        gen.writeObjectField('specialProfile', Boolean.valueof(valuesIndMap.get('specialProfile')));
      /*SAL PLTB Changes 14951 added by Anshita End*/
      //Added by Mahima 17073- PD 4 Tat- start
      if (valuesIndMap.containsKey('specialisation'))
        gen.writeObjectField('specialisation', string.valueof(valuesIndMap.get('specialisation')));
      //Added by Mahima 17073- PD 4 Tat- end


      gen.writeEndObject();
    }
    gen.writeEndArray();
    System.debug('::6::');
    //code added by Leena-13487 Engineering Program start
    gen.writeFieldName('College_details');

    for (Integer i = 0; i < 1; i++) {
      gen.writeStartObject();
      if (valuesIndMap.containsKey('college_name'))
        gen.writeObjectField('college_name', valuesIndMap.get('college_name'));
      if (valuesIndMap.containsKey('college_city'))
        gen.writeObjectField('college_city', valuesIndMap.get('college_city'));
      if (valuesIndMap.containsKey('stream'))
        gen.writeObjectField('stream', valuesIndMap.get('stream'));
      gen.writeEndObject();
    }
    //code added by Leena-13487 Engineering Program end
    system.debug('::7::');
    String jsonString = gen.getAsString();
    System.debug('::jsonString::' + jsonString);
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {
      res = createRequest(jsonString, 'BRE Eligibility');
    }
    System.debug('::Response' + res);
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response        
      String result = res.getBody();
      System.debug('Result ----->' + result);
      //Parse response        
      Map < String, Object > root = (Map < String, Object > ) JSON.deserializeUntyped(result);
      List < Object > items = (List < Object > ) root.get('Eligibility');
      for (Object item: items) {
        Map < String, Object > eligibilityTag = (Map < String, Object > ) item;
        // SAL PLTB --Pritha for Eligibility Start
        mapEligibilityResult.put('applicable_FOIR', (eligibilityTag.get('applicable_FOIR') == null ? '' : String.valueOf(eligibilityTag.get('applicable_FOIR'))));
        mapEligibilityResult.put('eligible_loan_amount', (eligibilityTag.get('applicable_FOIR') == null ? '' : String.valueOf(eligibilityTag.get('eligible_loan_amount'))));

        mapEligibilityResult.put('offer_roi', (eligibilityTag.get('offer_roi') == null ? '' : String.valueOf(eligibilityTag.get('offer_roi'))));
        mapEligibilityResult.put('offer_pf', (eligibilityTag.get('offer_pf') == null ? '' : String.valueOf(eligibilityTag.get('offer_pf'))));
        mapEligibilityResult.put('offer_insurance', (eligibilityTag.get('offer_insurance') == null ? '' : String.valueOf(eligibilityTag.get('offer_insurance'))));
        mapEligibilityResult.put('offer_tenor', (eligibilityTag.get('offer_tenor') == null ? '' : String.valueOf(eligibilityTag.get('offer_tenor'))));
        mapEligibilityResult.put('flat_offer_roi', (eligibilityTag.get('flat_offer_roi') == null ? '' : String.valueOf(eligibilityTag.get('flat_offer_roi'))));
        mapEligibilityResult.put('flat_offer_pf', (eligibilityTag.get('flat_offer_pf') == null ? '' : String.valueOf(eligibilityTag.get('flat_offer_pf'))));
        mapEligibilityResult.put('flat_offer_insurance', (eligibilityTag.get('flat_offer_insurance') == null ? '' : String.valueOf(eligibilityTag.get('flat_offer_insurance'))));
        mapEligibilityResult.put('roi', (eligibilityTag.get('roi') == null ? '' : String.valueOf(eligibilityTag.get('roi'))));
        mapEligibilityResult.put('max_loan_as_per_multiplier', (eligibilityTag.get('max_loan_as_per_multiplier') == null ? '' : String.valueOf(eligibilityTag.get('max_loan_as_per_multiplier'))));
        mapEligibilityResult.put('max_loan_as_per_FOIR_12', (eligibilityTag.get('max_loan_as_per_FOIR_12') == null ? '' : String.valueOf(eligibilityTag.get('max_loan_as_per_FOIR_12'))));
        mapEligibilityResult.put('max_loan_as_per_FOIR_24', (eligibilityTag.get('max_loan_as_per_FOIR_24') == null ? '' : String.valueOf(eligibilityTag.get('max_loan_as_per_FOIR_24'))));
        mapEligibilityResult.put('max_loan_as_per_FOIR_36', (eligibilityTag.get('max_loan_as_per_FOIR_36') == null ? '' : String.valueOf(eligibilityTag.get('max_loan_as_per_FOIR_36'))));
        mapEligibilityResult.put('max_loan_as_per_FOIR_48', (eligibilityTag.get('max_loan_as_per_FOIR_48') == null ? '' : String.valueOf(eligibilityTag.get('max_loan_as_per_FOIR_48'))));
        mapEligibilityResult.put('max_loan_as_per_FOIR_60', (eligibilityTag.get('max_loan_as_per_FOIR_60') == null ? '' : String.valueOf(eligibilityTag.get('max_loan_as_per_FOIR_60'))));
        mapEligibilityResult.put('max_loan_as_per_FOIR_72', (eligibilityTag.get('max_loan_as_per_FOIR_72') == null ? '' : String.valueOf(eligibilityTag.get('max_loan_as_per_FOIR_72'))));
        mapEligibilityResult.put('eligible_loan_amount_12', (eligibilityTag.get('eligible_loan_amount_12') == null ? '' : String.valueOf(eligibilityTag.get('eligible_loan_amount_12'))));
        mapEligibilityResult.put('eligible_loan_amount_24', (eligibilityTag.get('eligible_loan_amount_24') == null ? '' : String.valueOf(eligibilityTag.get('eligible_loan_amount_24'))));
        mapEligibilityResult.put('eligible_loan_amount_36', (eligibilityTag.get('eligible_loan_amount_36') == null ? '' : String.valueOf(eligibilityTag.get('eligible_loan_amount_36'))));
        mapEligibilityResult.put('eligible_loan_amount_48', (eligibilityTag.get('eligible_loan_amount_48') == null ? '' : String.valueOf(eligibilityTag.get('eligible_loan_amount_48'))));
        mapEligibilityResult.put('eligible_loan_amount_60', (eligibilityTag.get('eligible_loan_amount_60') == null ? '' : String.valueOf(eligibilityTag.get('eligible_loan_amount_60'))));
        mapEligibilityResult.put('eligible_loan_amount_72', (eligibilityTag.get('eligible_loan_amount_72') == null ? '' : String.valueOf(eligibilityTag.get('eligible_loan_amount_72'))));
        mapEligibilityResult.put('np_tenor_wise_eligibility_12', (eligibilityTag.get('np_tenor_wise_eligibility_12') == null ? '' : String.valueOf(eligibilityTag.get('np_tenor_wise_eligibility_12'))));
        mapEligibilityResult.put('np_tenor_wise_eligibility_24', (eligibilityTag.get('np_tenor_wise_eligibility_24') == null ? '' : String.valueOf(eligibilityTag.get('np_tenor_wise_eligibility_24'))));
        mapEligibilityResult.put('np_tenor_wise_eligibility_36', (eligibilityTag.get('np_tenor_wise_eligibility_36') == null ? '' : String.valueOf(eligibilityTag.get('np_tenor_wise_eligibility_36'))));
        mapEligibilityResult.put('np_tenor_wise_eligibility_48', (eligibilityTag.get('np_tenor_wise_eligibility_48') == null ? '' : String.valueOf(eligibilityTag.get('np_tenor_wise_eligibility_48'))));
        mapEligibilityResult.put('np_tenor_wise_eligibility_60', (eligibilityTag.get('np_tenor_wise_eligibility_60') == null ? '' : String.valueOf(eligibilityTag.get('np_tenor_wise_eligibility_60'))));
        mapEligibilityResult.put('np_tenor_wise_eligibility_72', (eligibilityTag.get('np_tenor_wise_eligibility_72') == null ? '' : String.valueOf(eligibilityTag.get('np_tenor_wise_eligibility_72'))));
        mapEligibilityResult.put('plusEmi', (eligibilityTag.get('plusEmi') == null ? '' : String.valueOf(eligibilityTag.get('plusEmi'))));
        mapEligibilityResult.put('plusOfferAmount', (eligibilityTag.get('plusOfferAmount') == null ? '' : String.valueOf(eligibilityTag.get('plusOfferAmount'))));
        mapEligibilityResult.put('emi', (eligibilityTag.get('max_emi_can_be_offered') == null ? '' : String.valueOf(eligibilityTag.get('max_emi_can_be_offered'))));
        mapEligibilityResult.put('eligibleForPLOC', (eligibilityTag.get('eligibleForPLOC') == null ? '' : String.valueOf(eligibilityTag.get('eligibleForPLOC'))));
        mapEligibilityResult.put('LOCInterestComponent', (eligibilityTag.get('EMIForPLOC') == null ? '' : String.valueOf(eligibilityTag.get('EMIForPLOC'))));
        mapEligibilityResult.put('rate_processed_normal', (eligibilityTag.get('rate_processed_normal') == null ? '' : String.valueOf(eligibilityTag.get('rate_processed_normal'))));
        mapEligibilityResult.put('rate_processed_flexi', (eligibilityTag.get('rate_processed_flexi') == null ? '' : String.valueOf(eligibilityTag.get('rate_processed_flexi'))));
        mapEligibilityResult.put('rate_processed_loc', (eligibilityTag.get('rate_processed_loc') == null ? '' : String.valueOf(eligibilityTag.get('rate_processed_loc'))));
        mapEligibilityResult.put('eligible_loan_amount_line', (eligibilityTag.get('eligible_loan_amount_line') == null ? '' : String.valueOf(eligibilityTag.get('eligible_loan_amount_line'))));
        // SAL PLTB --Pritha for Eligibility End
        /*SAL PLTB Changes 14951 added by Anshita Start */
        mapEligibilityResult.put('codifiedCibil', (eligibilityTag.get('codifiedCibil') == null ? '' : String.valueOf(eligibilityTag.get('codifiedCibil'))));
        mapEligibilityResult.put('codified_cibil_policy', (eligibilityTag.get('codified_cibil_policy') == null ? '' : String.valueOf(eligibilityTag.get('codified_cibil_policy'))));
        mapEligibilityResult.put('ews_rule_policy', (eligibilityTag.get('ews_rule_policy') == null ? '' : String.valueOf(eligibilityTag.get('ews_rule_policy'))));
        /*SAL PLTB Changes 14951 added by Anshita End */

        //Added by Mahima- 17073- PD 4 Tat-start
        mapEligibilityResult.put('pdFlag', (eligibilityTag.get('pdFlag') == null ? '' : String.valueOf(eligibilityTag.get('pdFlag'))));
        //Added by Mahima- 17073- PD 4 Tat-start
      }

      mapEligibilityResult.put('Status', 'Success');

      /*String policyRes =(String) mapDesJson.get('mcp_policy');
System.debug('::::'+policyRes);        
if(policyRes == 'MCP PASS')
    mcpResult =true ;
else
    mcpResult =false ;*/
    } else {
      mapEligibilityResult.put('Status', 'Failed');
      System.debug('<-----CONNECTION ERROR----->');
    }

    return mapEligibilityResult;
  }

  /*
Code added by Rakesh Shinde. Date: 22 March 2016
Purpose :Bug :6217. PRO DSS NEW CREDIT PROGRAM FOR CA SALARIED. Added method  for REST callout
   */
  public HTTPResponse createRequest(String jsonString, String custSettingName) {
    Mid_office_BRE_flow__c breSegment = Mid_office_BRE_flow__c.getValues(custSettingName);
    if (breSegment != null) {
      username = breSegment.Username__c;
      password = breSegment.Password__c;
      endpointURL = '';
      endpointURL = breSegment.EndpointURL__c;
    }
    System.debug('********Endpoint for IM********' + endpointURL);
    System.debug('********Username for IM********' + username);
    System.debug('********Passowrd for IM********' + password);


    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setTimeout(120000);
    req.setbody(jsonString);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    System.debug('Request -----> ' + req);
    Http http = new Http();

    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {
      res = http.send(req);
    } else {
      res.setStatusCode(220);
      res.setBody('{"mcp_obj":{"mcpOutput":null,"mcpDesc":null,"loanId":null},"mcp_list":[],"mcp_policy":"MCP PASS","sellerOutputs":{"mcpResult":null,"score":null,"sellerCategarization":null,"multiplier":null,"category":null,"eligibleAmount":null,"salesCategoryMap":null,"returnCategoryMap":null,"returnPercentage":null,"cancelCategoryMap":null,"cancelPercentage":null,"zeroBusiness":null,"averageMonthlyPayments":null,"growthPercentage":null,"vintage":null,"mcpList":[]},"Action":true}');

    }
    return res;
  }

  // Start of RBL Policy changes   
  public Map < String, String > callBRESegmentIndustryRBL(Map < string, string > valuesSegmentIndMap) {
    //Map <String,String> mapOfResults;
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    System.debug('****valuesSegmentIndMap--  : ' + valuesSegmentIndMap);
    if (valuesSegmentIndMap.get('branchName') == null) valuesSegmentIndMap.put('branchName', '');
    //  System.debug('****valuesSegmentIndMap branchName --  : ' + (valuesSegmentIndMap.get('branchName') < > null ? valuesSegmentIndMap.get('branchName') : ''));
    // System.debug('****valuesSegmentIndMap natureOfBusiness --  : ' + (valuesSegmentIndMap.get('natureOfBusiness') < > null ? valuesSegmentIndMap.get('natureOfBusiness') : ''));
    gen.writeStringField('branchName', valuesSegmentIndMap.get('branchName'));
    gen.writeStringField('natureOfBusiness', valuesSegmentIndMap.get('natureOfBusiness'));
    gen.writeStringField('lanNo', valuesSegmentIndMap.get('lanNo'));
    gen.writeEndObject();
    String jsonString = gen.getAsString();
    System.debug('********JSON string to be passed for Segment Industry********' + jsonString);

    Mid_office_BRE_flow__c RBL_Industry_Segment = Mid_office_BRE_flow__c.getValues('RBL Segment Industry');
    if (RBL_Industry_Segment != null) {
      username = RBL_Industry_Segment.Username__c;
      password = RBL_Industry_Segment.Password__c;
      endpointURL = '';
      endpointURL = RBL_Industry_Segment.EndpointURL__c;
    }

    System.debug('********Endpoint for IM********' + endpointURL);
    System.debug('********Username for IM********' + username);
    System.debug('********Passowrd for IM********' + password);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setTimeout(120000);
    req.setbody(jsonString);

    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {
      res = http.send(req);
    }
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response
      System.debug('Request -----> ' + req);
      String result = res.getBody();
      System.debug('Result ----->' + result);
      mapOfSegmentIndResult = parseResponseForSegmentInd(result);
      System.debug('Map of result -----> ' + mapOfSegmentIndResult);
    } else {
      // Error in getting response
      System.debug('<-----CONNECTION ERROR----->');
    }
    return mapOfSegmentIndResult;
  }
  public Map < String, String > parseResponseForSegmentInd(String responseOfSegmentIndParams) {
    Map < String, String > mapOfResults = new Map < String, String > ();
    String mainIndustry, subIndustry;
    System.debug('responseOfSegmentIndParams----' + responseOfSegmentIndParams);
    Map < String, String > segmentValueMap = new Map < String, String > ();
    SegmentIndustryJSON response = SegmentIndustryJSON.parse(responseOfSegmentIndParams);
    System.debug('*****Response*****' + response);

    if (response != null && response.output != null) {
      for (Integer i = 0; i < response.output.size(); i++) {
        mainIndustry = response.output[i].industry;
        subIndustry = response.output[i].subIndustries;
        segmentValueMap.put(mainIndustry, subIndustry);
      }
    }
    System.debug('segmentValueMap --> ' + segmentValueMap);
    return segmentValueMap;
  }
  // End of RBL Policy changes

  public List < String > callBREFinalSegmentRBL(Map < String, String > finalSegmentationMapTemp) {
    System.debug('BRE Call For Final Segmentation');
    System.debug('finalSegmentationMapTemp ----------->>>>>>>>>' + finalSegmentationMapTemp);
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();

    gen.writeStringField('lanNo', finalSegmentationMapTemp.get('lanNo'));
    gen.writeStringField('segmentedIndustry', finalSegmentationMapTemp.get('segmentedIndustry'));
    gen.writeNumberField('noOfEmployess', Integer.valueOf(finalSegmentationMapTemp.get('noOfEmployess')));
    gen.writeStringField('stockSeen', finalSegmentationMapTemp.get('stockSeen'));
    gen.writeStringField('ownedBusinessPremises', finalSegmentationMapTemp.get('ownedBusinessPremises'));
    gen.writeStringField('ownedResidencePremises', finalSegmentationMapTemp.get('ownedResidencePremises'));
    gen.writeNumberField('odccUtilization', Double.valueOf(finalSegmentationMapTemp.get('odccUtilization')));
    gen.writeStringField('hubName', finalSegmentationMapTemp.get('hubName'));
    gen.writeStringField('businessSince', finalSegmentationMapTemp.get('businessSince'));
    gen.writeNumberField('loanAmount', Double.valueOf(finalSegmentationMapTemp.get('loanAmount')));
    gen.writeNumberField('tenor', Double.valueOf(finalSegmentationMapTemp.get('tenor')));
    gen.writeNumberField('roi', Double.valueOf(finalSegmentationMapTemp.get('roi')));
    gen.writeNumberField('avgBalance', Double.valueOf(finalSegmentationMapTemp.get('avgBalance')));
    gen.writeNumberField('machinerySeen', Integer.valueOf(finalSegmentationMapTemp.get('machinerySeen')));
    gen.writeNumberField('productCapacity', Integer.valueOf(finalSegmentationMapTemp.get('productCapacity')));
    //Code added by Rasika Dated 12 Sep 2016 for Bug 8310 S
    if (finalSegmentationMapTemp.get('product') != null && finalSegmentationMapTemp.get('product') == 'RDL') {
      gen.writeStringField('type_of_degree', finalSegmentationMapTemp.get('type_of_degree'));
      gen.writeNumberField('total_Employment_Vintage', Integer.valueOf(finalSegmentationMapTemp.get('total_Employment_Vintage')));
      gen.writeNumberField('CIBIL_Score', Integer.valueOf(finalSegmentationMapTemp.get('CIBIL_Score')));
    }
    //Code added by Rasika Dated 12 Sep 2016 for Bug 8310 E

    gen.writeEndObject();

    String jsonString = gen.getAsString();
    System.debug('********JSON string to be passed for Segment Industry********' + jsonString);

    Mid_office_BRE_flow__c RBL_Segmentation = Mid_office_BRE_flow__c.getValues('RBL Segmentation');
    if (RBL_Segmentation != null) {
      username = RBL_Segmentation.Username__c;
      password = RBL_Segmentation.Password__c;
      endpointURL = '';
      endpointURL = RBL_Segmentation.EndpointURL__c;
    }
    //username = 'DEFAULT\\Admin';
    //password = 'Admin';
    //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/RBL_Segmentation/versions/0.0.1-SNAPSHOT/rules/RBL_Segmentation/RblSegmentationMain/executions';
    System.debug('********Endpoint for IM********' + endpointURL);
    System.debug('********Username for IM********' + username);
    System.debug('********Passowrd for IM********' + password);
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {
      res = http.send(req);
    }
    //res.setStatusCode(220);
    //res.setBody('{ "lanNo" : "ABC123","segmentedIndustry" : "abs123", "noOfEmployess" : 1, "stockSeen" : "stockSeen","ownedBusinessPremises" : "ownedBusinessPremises","odccUtilization" : 123.0,"businessSince" : "twoyear",loanAmount" : 123.0, "tenor" : 123.0, "roi" : 123.0, "avgBalance" : 123.0, "machinerySeen" : 123, "productCapacity" : 123}');                                                             
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response
      System.debug('Request -----> ' + req);
      String result = res.getBody();
      System.debug('Result ----->' + result);
      mapOfFinalSegmentationResult = parseResponseForFinalSegmentation(result);
      System.debug('List of result -----> ' + mapOfFinalSegmentationResult);
    } else {
      // Error in getting response
      System.debug('<-----CONNECTION ERROR----->');
    }
    return mapOfFinalSegmentationResult;

  }
  //Code added by Rasika Dated 12 Sep 2016 for Bug 8310 s

  public List < String > callBREFinalSegmentRDL(Map < String, String > finalRDLSegmentationMapTemp) {
    System.debug('BRE Call For RDL Segmentation');
    System.debug('finalRDLSegmentationMapTemp ----------->>>>>>>>>' + finalRDLSegmentationMapTemp);
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeFieldName('Demographic');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeNumberField('total_Employment_Vintage', (finalRDLSegmentationMapTemp.get('total_Employment_Vintage') != null) ? Double.valueOf(finalRDLSegmentationMapTemp.get('total_Employment_Vintage')) : 0);
    gen.writeStringField('type_of_degree', (finalRDLSegmentationMapTemp.get('type_of_degree') != null) ? String.valueOf(finalRDLSegmentationMapTemp.get('type_of_degree')) : '');
    gen.writeStringField('applicant_Type', (finalRDLSegmentationMapTemp.get('applicant_Type') != null) ? String.valueOf(finalRDLSegmentationMapTemp.get('applicant_Type')) : '');
    gen.writeEndObject();
    gen.writeEndArray();
    gen.writeFieldName('Cibil_lst');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeNumberField('CIBIL_Score', (finalRDLSegmentationMapTemp.get('CIBIL_Score') != null) ? Double.valueOf(finalRDLSegmentationMapTemp.get('CIBIL_Score')) : 0);
    gen.writeStringField('applicant_Type', (finalRDLSegmentationMapTemp.get('applicant_Type') != null) ? String.valueOf(finalRDLSegmentationMapTemp.get('applicant_Type')) : '');
    gen.writeEndObject();
    gen.writeEndArray();
    gen.writeFieldName('Loan_Parameter');
    gen.writeStartObject();
    gen.writeStringField('product', (finalRDLSegmentationMapTemp.get('product') != null) ? String.valueOf(finalRDLSegmentationMapTemp.get('product')) : '');
    gen.writeStringField('loan_id', (finalRDLSegmentationMapTemp.get('loan_id') != null) ? finalRDLSegmentationMapTemp.get('loan_id') : '');
    gen.writeEndObject();
    gen.writeEndObject();

    String jsonString = gen.getAsString();
    System.debug('********JSON string to be passed for RDL Segmentation********' + jsonString);

    Mid_office_BRE_flow__c RDL_Segmentation = Mid_office_BRE_flow__c.getValues('RDL Segmentation');
    if (RDL_Segmentation != null) {
      username = RDL_Segmentation.Username__c;
      password = RDL_Segmentation.Password__c;
      endpointURL = '';
      endpointURL = RDL_Segmentation.EndpointURL__c;
    }
    System.debug('********Endpoint for IM********' + endpointURL);
    System.debug('********Username for IM********' + username);
    System.debug('********Passowrd for IM********' + password);
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {
      res = http.send(req);
    }
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response
      System.debug('Request -----> ' + req);
      String result = res.getBody();
      System.debug('Result ----->' + result);
      mapOfFinalSegmentationResult = parseResponseForRDLSegmentation(result);
      System.debug('List of result -----> ' + mapOfFinalSegmentationResult);
    } else {
      // Error in getting response
      System.debug('<-----CONNECTION ERROR----->');
    }
    return mapOfFinalSegmentationResult;
  }

  public List < String > parseResponseForRDLSegmentation(String mapoffinalsegmentationTemp) {
    List < String > segmentationValueList = new List < String > ();
    String[] finalSegmentationArray;
    System.debug('Segmentation JSON RDL: ' + mapoffinalsegmentationTemp);
    RDLSegmentationJSON reponse = RDLSegmentationJSON.RDLSegmentationparse(mapoffinalsegmentationTemp);
    System.debug('*****Response*****' + reponse);
    if (reponse != null && reponse.output != null && reponse.output.customerSegment != null) {
      finalSegmentationArray = reponse.output.customerSegment.split(';');
      if (finalSegmentationArray != null && finalSegmentationArray.size() > 0) {
        for (String segmentStr: finalSegmentationArray) {
          segmentationValueList.add(segmentStr);
        }
      }
    }
    System.debug('Final Segmentation List' + segmentationValueList);
    return segmentationValueList;
  }
  public MAP < string, string > callBREEligibilityRDL(Map < string, string > valuesRDLEligibilityMap) {
    System.debug('valuesRDLEligibilityMap->' + valuesRDLEligibilityMap);
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();

    //Added by mahima- 12501- RDl RSl flexi--start
    gen.writeFieldName('Demographic');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeStringField('programType', (valuesRDLEligibilityMap.get('program_type') != null) ? valuesRDLEligibilityMap.get('program_type') : '');
    gen.writeStringField('applicant_type', (valuesRDLEligibilityMap.get('applicant_type') != null) ? valuesRDLEligibilityMap.get('applicant_type') : '');
    /*Bug Id: 14509, Start*/
    gen.writeStringField('type_of_degree', (valuesRDLEligibilityMap.get('type_of_degree') != null) ? valuesRDLEligibilityMap.get('type_of_degree') : '');
    gen.writeNumberField('total_employment_vintage', (Integer.valueOf(valuesRDLEligibilityMap.get('total_Employment_Vintage')) != null) ? Integer.valueOf(valuesRDLEligibilityMap.get('total_Employment_Vintage')) : 0);
    gen.writeStringField('customer_type', (valuesRDLEligibilityMap.get('customer_type') != null) ? valuesRDLEligibilityMap.get('customer_type') : '');

    /*Bug Id: 14509, End*/
    gen.writeEndObject();
    gen.writeEndArray();
    //Added by mahima- 12501- RDl RSl flexi--end

    gen.writeFieldName('CAMS');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeNumberField('average_net_salary', (valuesRDLEligibilityMap.get('average_net_salary') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('average_net_salary')) : 0);
    gen.writeNumberField('average_Monthly_Net_Income1', (valuesRDLEligibilityMap.get('average_Monthly_Net_Income1') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('average_Monthly_Net_Income1')) : 0);

    gen.writeEndObject();
    gen.writeEndArray();
    gen.writeFieldName('Loan_Parameter');
    gen.writeStartObject();
    gen.writeStringField('program_type', (valuesRDLEligibilityMap.get('program_type') != null) ? valuesRDLEligibilityMap.get('program_type') : '');
    gen.writeStringField('product', (valuesRDLEligibilityMap.get('product') != null) ? valuesRDLEligibilityMap.get('product') : '');
    gen.writeStringField('loan_id', (valuesRDLEligibilityMap.get('loan_id') != null) ? valuesRDLEligibilityMap.get('loan_id') : '');
    gen.writeNumberField('requested_tenor', (valuesRDLEligibilityMap.get('requested_tenor') != null) ? Double.valueOF(valuesRDLEligibilityMap.get('requested_tenor')) : 0);

    //gen.writeNumberField('loan_application_number', (valuesRDLEligibilityMap.get('loan_application_number') != null) ? valuesRDLEligibilityMap.get('loan_application_number') : 0);
    gen.writeStringField('process_type', (valuesRDLEligibilityMap.get('process_Type') != null) ? valuesRDLEligibilityMap.get('process_Type') : ''); // Bug 14509
    gen.writeEndObject();
    gen.writeFieldName('existing_loan');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeNumberField('monthly_loan_obligations', (valuesRDLEligibilityMap.get('monthly_loan_obligations') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('monthly_loan_obligations')) : 0);
    gen.writeStringField('applicant_type', (valuesRDLEligibilityMap.get('applicant_type') != null) ? valuesRDLEligibilityMap.get('applicant_type') : '');
    gen.writeNumberField('total_home_loan_amount', (valuesRDLEligibilityMap.get('total_home_loan_amount') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('total_home_loan_amount')) : 0);
    gen.writeNumberField('total_auto_loan_amount', (valuesRDLEligibilityMap.get('total_auto_loan_amount') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('total_auto_loan_amount')) : 0);
    gen.writeNumberField('total_lap_loan_amount', (valuesRDLEligibilityMap.get('total_lap_loan_amount') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('total_lap_loan_amount')) : 0);
    //Bug 14509 S - RDL Eligibility calculation
    gen.writeStringField('securedLoan_20lacs', (valuesRDLEligibilityMap.get('Sec_Loan_20L_12M_Vintage__c')) != null ? valuesRDLEligibilityMap.get('Sec_Loan_20L_12M_Vintage__c') : '');
    gen.writeStringField('unsecuredLoan_5lacs', (valuesRDLEligibilityMap.get('UnSec_Loan_5L_9M_Vintage__c')) != null ? valuesRDLEligibilityMap.get('UnSec_Loan_5L_9M_Vintage__c') : '');
    //Bug 14509 E - RDL Eligibility calculation
    gen.writeEndObject();
    gen.writeEndArray();



    gen.writeFieldName('profit_loss_statement');
    gen.writeStartObject();
    gen.writeNumberField('cy_profit_after_tax', (valuesRDLEligibilityMap.get('cy_profit_after_tax') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('cy_profit_after_tax')) : 0);
    gen.writeNumberField('cy_income_as_per_itr', (valuesRDLEligibilityMap.get('cy_income_as_per_itr') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('cy_income_as_per_itr')) : 0);
    gen.writeNumberField('cy_depriciation', (valuesRDLEligibilityMap.get('cy_depriciation') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('cy_depriciation')) : 0);
    gen.writeNumberField('gross_receipts', (valuesRDLEligibilityMap.get('gross_receipts') != null) ? Double.valueOf(valuesRDLEligibilityMap.get('gross_receipts')) : 0);
    gen.writeEndObject();

    //Added by mahima- 12501- RDl RSl flexi--start
    gen.writeFieldName('Cibil_lst');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeStringField('applicant_Type', (valuesRDLEligibilityMap.get('applicant_type') != null) ? valuesRDLEligibilityMap.get('applicant_type') : '');
    //Added by Rohan for 13236(12501) on 20/06/2017
    if (valuesRDLEligibilityMap.get('CIBIL_Score') != null && valuesRDLEligibilityMap.get('CIBIL_Score') == '000-1') gen.writeNumberField('CIBIL_Score', -1);
    else gen.writeNumberField('CIBIL_Score', (valuesRDLEligibilityMap.get('CIBIL_Score') != null) ? Double.valueof(valuesRDLEligibilityMap.get('CIBIL_Score')) : 0);
    //Ended by Rohan for 13236(12501) on 20/06/2017
    gen.writeEndObject();
    gen.writeEndArray();
    //Added by mahima- 12501- RDl RSl flexi--end

    gen.writeEndObject();

    String jsonString = gen.getAsString();
    System.debug('********JSON string to be passed for Eligibility********' + jsonString);

    Mid_office_BRE_flow__c RDL_Eligibility = Mid_office_BRE_flow__c.getValues('RDL Eligibility');
    if (RDL_Eligibility != null) {
      username = RDL_Eligibility.Username__c;
      password = RDL_Eligibility.Password__c;
      endpointURL = '';
      endpointURL = RDL_Eligibility.EndpointURL__c;
    }
    //username = 'DEFAULT\\Admin';
    //password = 'Admin';
    //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/Loan_Eligibility/versions/0.0.1-SNAPSHOT/rules/Loan_Eligibility/loanEligibilityMain/executions';
    System.debug('********Endpoint for IM********' + endpointURL);
    System.debug('********Username for IM********' + username);
    System.debug('********Passowrd for IM********' + password);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {

      res = http.send(req);
    }
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response
      System.debug('Request -----> ' + req);
      String result = res.getBody();
      System.debug('Result ----->' + result);
      RDLeliVal = parseResponseForRDLEligibility(result);
      System.debug('Eligible Amount -----> ' + RDLeliVal);
    } else {
      // Error in getting response
      System.debug('<-----CONNECTION ERROR----->');
    }

    return RDLeliVal;
  }
  public map < string, string > parseResponseForRDLEligibility(String responseOfeligibilityParams) {
    Map < String, String > mapOfResults = new Map < String, String > ();
    //String[] segmentValueArrayTemp;
    system.debug('responseOfeligibilityParams----' + responseOfeligibilityParams);
    Double AmountEligibility;
    Map < string, string > RDLEligibilityval = new Map < string, string > ();
    RDLEligibilityJSON reponse = RDLEligibilityJSON.RDLEligibilityparse(responseOfeligibilityParams);
    // AmountEligibility = Double.valueOf(reponse.Eligibility[0].eligible_loan_amount);
    system.debug('*****Response*****' + reponse);
    if (reponse != null && reponse.Eligibility != null) {
      if (reponse.Eligibility[0].eligible_loan_amount != null)
        RDLEligibilityval.put('eleAmt', string.valueOf(reponse.Eligibility[0].eligible_loan_amount));
      if (reponse.Eligibility[0].gross_receipt_eligible_amount != null)
        RDLEligibilityval.put('GReligibilityAmt', string.valueOf(reponse.Eligibility[0].gross_receipt_eligible_amount));
      if (reponse.Eligibility[0].cash_profit_eligible_amount != null)
        RDLEligibilityval.put('CPeligibilityAmt', string.valueOf(reponse.Eligibility[0].cash_profit_eligible_amount));
      if (reponse.Eligibility[0].itr_eligible_amount != null)
        RDLEligibilityval.put('ItreligibilityAmt', string.valueOf(reponse.Eligibility[0].itr_eligible_amount));
      if (reponse.Eligibility[0].salary_base_eligible_amount != null)
        RDLEligibilityval.put('SBeligibilityAmt', string.valueOf(reponse.Eligibility[0].salary_base_eligible_amount));
      if (reponse.Eligibility[0].home_loan_eligible_amount != null)
        RDLEligibilityval.put('HLeligibilityAmt', string.valueOf(reponse.Eligibility[0].home_loan_eligible_amount));
      if (reponse.Eligibility[0].lap_loan_eligible_amount != null)
        RDLEligibilityval.put('LapLoaneligibilityAmt', string.valueOf(reponse.Eligibility[0].lap_loan_eligible_amount));
      if (reponse.Eligibility[0].auto_loan_eligible_amount != null)
        RDLEligibilityval.put('ALeligibilityAmt', string.valueOf(reponse.Eligibility[0].auto_loan_eligible_amount));
      //added by mahima- 12501-- start
      if (reponse.Eligibility[0].pureFlexi != null)
        RDLEligibilityval.put('pureFlexi', reponse.Eligibility[0].pureFlexi);
      //added by mahima- 12501-- end
      system.debug('AmountEligibility Pramod ==> ' + RDLEligibilityval);


    }
    return RDLEligibilityval;
  }
  //Code added by Rasika Dated 12 Sep 2016 for Bug 8310 E
  public List < String > parseResponseForFinalSegmentation(String mapoffinalsegmentationTemp) {
    List < String > segmentationValueList = new List < String > ();
    String[] finalSegmentationArray;
    finalsegmentation reponse = finalsegmentation.parse(mapoffinalsegmentationTemp);
    System.debug('*****Response*****' + reponse);
    if (reponse != null && reponse.output != null && reponse.output.finalSegment != null) {
      finalSegmentationArray = reponse.output.finalSegment.split(';');
      if (finalSegmentationArray != null && finalSegmentationArray.size() > 0) {
        for (String segmentStr: finalSegmentationArray) {
          segmentationValueList.add(segmentStr);
        }
      }
    }
    System.debug('Final Segmentation List' + segmentationValueList);
    return segmentationValueList;
  }

  public Double callBREEligibilityRBL(Map < string, string > valueseligibilityMap) {

    /*
System.debug('****valueseligibilityMap****');
for(String key : valueseligibilityMap.keySet()) {
        System.debug('Key ==> ' + key + ' Value ==> ' + valueseligibilityMap.get(key));
}
     */

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();

    // Start of RBL Policy changes
    gen.writeFieldName('Generic');
    gen.writeStartObject();
    gen.writeStringField('branch_name', (valueseligibilityMap.get('branch_name') != null) ? valueseligibilityMap.get('branch_name') : '');
    gen.writeEndObject();
    // End of RBL Policy changes

    gen.writeFieldName('Loan_Parameter');
    gen.writeStartObject();
    gen.writeNumberField('requested_loan_amount', (valueseligibilityMap.get('requested_loan_amount') != null) ? Double.valueOf(valueseligibilityMap.get('requested_loan_amount')) : 0);
    gen.writeStringField('product', (valueseligibilityMap.get('product') != null) ? valueseligibilityMap.get('product') : '');
    gen.writeStringField('program_type', (valueseligibilityMap.get('program_type') != null) ? valueseligibilityMap.get('program_type') : '');
    gen.writeNumberField('loanEMI', (valueseligibilityMap.get('loanEMI') != null) ? Double.valueOf(valueseligibilityMap.get('loanEMI')) : 0);
    gen.writeNumberField('reqested_roi', (valueseligibilityMap.get('reqested_roi') != null) ? Double.valueOf(valueseligibilityMap.get('reqested_roi')) : 0);
    gen.writeNumberField('bankingCredit', (valueseligibilityMap.get('bankingCredit') != null) ? Double.valueOf(valueseligibilityMap.get('bankingCredit')) : 0);
    gen.writeStringField('type_of_loan', (valueseligibilityMap.get('type_of_loan') != null) ? valueseligibilityMap.get('type_of_loan') : '');
    gen.writeNumberField('requested_tenor', (valueseligibilityMap.get('requested_tenor') != null) ? Double.valueOf(valueseligibilityMap.get('requested_tenor')) : 0);
    gen.writeNumberField('industryMargin', (valueseligibilityMap.get('industryMargin') != null) ? Double.valueOf(valueseligibilityMap.get('industryMargin')) : 0);
    gen.writeStringField('industry', (valueseligibilityMap.get('industry') != null) ? valueseligibilityMap.get('industry') : '');
    gen.writeStringField('sub_industry', (valueseligibilityMap.get('sub_industry') != null) ? valueseligibilityMap.get('sub_industry') : ''); // Added for RBL Policy changes
    gen.writeNumberField('alLoanAmount', (valueseligibilityMap.get('alLoanAmount') != null) ? Double.valueOf(valueseligibilityMap.get('alLoanAmount')) : 0);
    gen.writeStringField('loan_id', (valueseligibilityMap.get('loan_id') != null) ? valueseligibilityMap.get('loan_id') : ''); // Added for RBL Policy changes  

    gen.writeEndObject();

    gen.writeFieldName('profit_loss_statement');
    gen.writeStartObject();
    gen.writeNumberField('cy_income_as_per_itr', (valueseligibilityMap.get('cy_income_as_per_itr') != null) ? Double.valueOf(valueseligibilityMap.get('cy_income_as_per_itr')) : 0);
    gen.writeNumberField('py_income_as_per_itr', (valueseligibilityMap.get('py_income_as_per_itr') != null) ? Double.valueOf(valueseligibilityMap.get('py_income_as_per_itr')) : 0);
    gen.writeNumberField('py_depriciation', (valueseligibilityMap.get('py_depriciation') != null) ? Double.valueOf(valueseligibilityMap.get('py_depriciation')) : 0);
    gen.writeNumberField('cy_depriciation', (valueseligibilityMap.get('cy_depriciation') != null) ? Double.valueOf(valueseligibilityMap.get('cy_depriciation')) : 0);
    gen.writeNumberField('cy_salary_to_partner', (valueseligibilityMap.get('cy_salary_to_partner') != null) ? Double.valueOf(valueseligibilityMap.get('cy_salary_to_partner')) : 0);
    gen.writeNumberField('py_salary_to_partner', (valueseligibilityMap.get('py_salary_to_partner') != null) ? Double.valueOf(valueseligibilityMap.get('py_salary_to_partner')) : 0);
    gen.writeNumberField('py_interest_to_partner', (valueseligibilityMap.get('py_interest_to_partner') != null) ? Double.valueOf(valueseligibilityMap.get('py_interest_to_partner')) : 0);
    gen.writeNumberField('cy_interest_to_partner', (valueseligibilityMap.get('cy_interest_to_partner') != null) ? Double.valueOf(valueseligibilityMap.get('cy_interest_to_partner')) : 0);

    gen.writeNumberField('cy_net_profit', (valueseligibilityMap.get('cy_net_profit') != null) ? Double.valueOf(valueseligibilityMap.get('cy_net_profit')) : 0);
    gen.writeNumberField('py_net_profit', (valueseligibilityMap.get('py_net_profit') != null) ? Double.valueOf(valueseligibilityMap.get('py_net_profit')) : 0);
    gen.writeNumberField('py_sales_turnover', (valueseligibilityMap.get('py_sales_turnover') != null) ? Double.valueOf(valueseligibilityMap.get('py_sales_turnover')) : 0);
    gen.writeNumberField('cy_sales_turnover', (valueseligibilityMap.get('cy_sales_turnover') != null) ? Double.valueOf(valueseligibilityMap.get('cy_sales_turnover')) : 0);


    gen.writeEndObject();

    gen.writeFieldName('existing_loan');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeNumberField('monthly_loan_obligations', (valueseligibilityMap.get('monthly_loan_obligations') != null) ? Double.valueOf(valueseligibilityMap.get('monthly_loan_obligations')) : 0);
    gen.writeStringField('applicant_type', (valueseligibilityMap.get('applicant_type') != null) ? valueseligibilityMap.get('applicant_type') : '');
    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('Cibil_lst');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeNumberField('mob', (valueseligibilityMap.get('mob') != null) ? Double.valueOf(valueseligibilityMap.get('mob')) : 0);
    gen.writeStringField('applicant_Type', (valueseligibilityMap.get('applicant_type') != null) ? valueseligibilityMap.get('applicant_type') : '');

    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('Bank_summary');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeNumberField('avg_bank_balance', (valueseligibilityMap.get('avg_bank_balance') != null) ? Double.valueOf(valueseligibilityMap.get('avg_bank_balance')) : 0);
    gen.writeNumberField('avg_od_cc_limit', (valueseligibilityMap.get('avg_od_cc_limit') != null) ? Double.valueOf(valueseligibilityMap.get('avg_od_cc_limit')) : 0);
    gen.writeStringField('applicant_type', (valueseligibilityMap.get('applicant_type') != null) ? valueseligibilityMap.get('applicant_type') : '');
    gen.writeStringField('_10th_balance', (valueseligibilityMap.get('_10th_balance') != null) ? valueseligibilityMap.get('_10th_balance') : '0');
    gen.writeStringField('_20th_balance', (valueseligibilityMap.get('_20th_balance') != null) ? valueseligibilityMap.get('_20th_balance') : '0');
    gen.writeStringField('last_day_balance', (valueseligibilityMap.get('last_day_balance') != null) ? valueseligibilityMap.get('last_day_balance') : '0');

    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeFieldName('Demographic');
    gen.writeStartArray();
    gen.writeStartObject();
    gen.writeStringField('customer_segment', (valueseligibilityMap.get('customer_segment') != null) ? valueseligibilityMap.get('customer_segment') : '');
    gen.writeStringField('nature_of_business', (valueseligibilityMap.get('nature_of_business') != null) ? valueseligibilityMap.get('nature_of_business') : '');
    gen.writeStringField('constitutionType', (valueseligibilityMap.get('constitutionType') != null) ? valueseligibilityMap.get('constitutionType') : '');
    gen.writeStringField('applicant_type', (valueseligibilityMap.get('applicant_type') != null) ? valueseligibilityMap.get('applicant_type') : '');
    gen.writeStringField('typeofBusiness', (valueseligibilityMap.get('typeofBusiness') != null) ? valueseligibilityMap.get('typeofBusiness') : '');
    gen.writeStringField('customer_type', (valueseligibilityMap.get('customer_type') != null) ? valueseligibilityMap.get('customer_type') : '');
    gen.writeStringField('industry', (valueseligibilityMap.get('industry') != null) ? valueseligibilityMap.get('industry') : '');

    gen.writeEndObject();
    gen.writeEndArray();

    gen.writeEndObject();

    String jsonString = gen.getAsString();
    System.debug('********JSON string to be passed for Eligibility********' + jsonString);

    Mid_office_BRE_flow__c BRE_Eligibility = Mid_office_BRE_flow__c.getValues('BRE Eligibility');
    if (BRE_Eligibility != null) {
      username = BRE_Eligibility.Username__c;
      password = BRE_Eligibility.Password__c;
      endpointURL = '';
      endpointURL = BRE_Eligibility.EndpointURL__c;
    }
    //username = 'DEFAULT\\Admin';
    //password = 'Admin';
    //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/Loan_Eligibility/versions/0.0.1-SNAPSHOT/rules/Loan_Eligibility/loanEligibilityMain/executions';
    System.debug('********Endpoint for IM********' + endpointURL);
    System.debug('********Username for IM********' + username);
    System.debug('********Passowrd for IM********' + password);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {

      res = http.send(req);
    } else {
      res.setStatusCode(230);
      res.setBody('{  "Loan_Parameter" : { "industry" : "", "practiceType" : "", "processType" : "", "loan_application_stage" : "DSA/PSF Login", "approved_rate" : 0.0, "loan_id" : "23203006479", "decision_date" : "",  "approved_loan_amount" : 0.0, "requested_loan_amount" : 10.0, "requested_tenor" : 36.0, "reqested_roi" : 10.0, "loan_application_number" : 23203006479, "product" : "SHL", "scheme_name" : "", "type_of_loan" : "", "stage" : "DSA/PSF Login", "sourcing_channel_type" : "DSA", "sub_stage" : "", "offer_amount" : 0.0, "program_type" : "", "UWProgram" : "", "loanAmountHL" : 0.0, "loanAmountTopUp" : 0.0, "roiHL" : 0.0, "tenorHL" : 0.0, "roiTopUp" : 0.0, "tenorTopUp" : 0.0, "topUp_cashOut" : 0.0, "topUp_cashOut_roi" : 0.0, "topUp_cashOut_tenor" : 0.0, "fullUnderwritingFlag" : "true", "eligibilityType" : "Financial" }, "Generic" : { "loan_id" : "23203006479",  "branch_type" : "Tier I", "branch_name" : "PUNE" }, "Bank_summary" : [ ],  "existing_loan" : [ { "loan_id" : "23203006479", "applicant_type" : "Primary", "monthly_loan_obligations" : 0.0, "bajaj_loan_obligations" : 0.0} ], "profit_loss_statement" : [ { "py_sales_turnover" : 0.0, "cy_sales_turnover" : 0.0, "py_profit_before_tax" : 0.0,"cy_profit_before_tax" : 0.0, "loan_id" : "23203006479", "applicant_type" : "Primary"} ], "Demographic" : [ { "type_of_constitution" : "", "professionType" : "", "constitutionType" : "", "educational_qualification" : "", "total_employment_vintage" : 0.0, "date_of_birth" : "1980-08-17", "date_of_incorporation" : "", "age" : 36.04,"constitution" : "", "customer_segment" : "", "loan_id" : "23203006479", "years_in_business_job" : 0, "first_name" : "", "last_name" : "persistent", "residence_type" : "", "marital_status" : "", "applicant_type" : "Primary", "company_category" : "", "company_type" : "", "type_of_degree" : "", "office_email_id" : "", "name_of_employer" : "Aarti Steels Ltd.", "gender" : "", "pan" : "AWEPL7766Y", "residence_city" : "", "office_city" : "", "residence_pin_code" : 0, "office_pin_code" : 0, "nature_of_business" : "", "industry" : "", "sub_industry" : "", "e_mail_id" : "", "customer_type" : "Individual", "specialisation" : "",  "practiceType" : "", "profession" : "", "expPostGradSuperSpecialist" : 0, "case_type" : "TOP 13"} ], "applicantList" : [ { "coApplicantType" : "Primary", "name" : "PSL Test", "dob" : "1980-08-17", "monthly_net_salary" : 80000, "monthly_rental_income" : 0, "incentiveAmt" : 0, "incentiveFrequency" : "", "reImbursement" : 0, "other_monthly_income" : 0, "monthlyObligations" : 0, "applicant_type" : "Primary", "propertyOwner" : "N" } ], "BTDetails" : [ ],  "Property_Details" : [ ],  "cam" : { "loan_id" : "23203006479", "average_net_salary" : 26666.666666666668, "total_net_salary" : 80000.0, "gross_Salary_Month1" : 80000.0, "gross_Salary_Month2" : 0.0,"gross_Salary_Month3" : 0.0, "proposed_Loan_Amt" : 10.0, "rental_Income" : 0.0, "tenor" : 36.0, "monthly_net_Rental_Income" : 0.0, "total_monthly_obligations" : 0.0 } } ');
    }
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response
      System.debug('Request -----> ' + req);
      String result = res.getBody();
      System.debug('Result ----->' + result);
      EligibleAmount = parseResponseForEligibility(result);
      System.debug('Eligible Amount -----> ' + EligibleAmount);
    } else {
      // Error in getting response
      System.debug('<-----CONNECTION ERROR----->');
    }

    return EligibleAmount;
  }
  public Double parseResponseForEligibility(String responseOfeligibilityParams) {
    Map < String, String > mapOfResults = new Map < String, String > ();
    //String[] segmentValueArrayTemp;
    System.debug('responseOfeligibilityParams----' + responseOfeligibilityParams);
    Double AmountEligibility;
    EligibilityAmt reponse = EligibilityAmt.parse(responseOfeligibilityParams);
    System.debug('*****Response*****' + reponse);
    //System.debug('reponse.segment Pramod'+reponse.output.segment);
    //if (reponse.eligibility_amount != null) {
    //    AmountEligibility = reponse.eligibility_amount;
    if (reponse != null && reponse.Eligibility != null && reponse.Eligibility[0].eligible_loan_amount != null) {
      AmountEligibility = Double.valueOf(reponse.Eligibility[0].eligible_loan_amount);


      /*segmentValueArrayTemp = reponse.output.industries.split(';');
    if(segmentValueArrayTemp != null && segmentValueArrayTemp.size() > 0){
        for(String segmentStr : segmentValueArrayTemp){
            AmountEligibility.add(segmentStr);
        }
    }*/
    }
    System.debug('AmountEligibility Pramod ==> ' + AmountEligibility);
    //System.debug('*****segmentValueArrayTemp  List*****' + segmentValueArrayTemp);
    return AmountEligibility;
  }
  // End of MSME BL changes  

  public String callBREOfferDetails(String jsonString) {
    System.debug('********JSON string to be passed for IM********' + jsonString);
    String result = '';
    Mid_office_BRE_flow__c BRE_Flow = Mid_office_BRE_flow__c.getValues('BRE offer calculation');
    if (BRE_Flow != null) {
      username = BRE_Flow.Username__c;
      password = BRE_Flow.Password__c;
      endpointURL = BRE_Flow.EndpointURL__c;
    }
    //username = 'DEFAULT\\Admin';
    //password = 'Admin';
    //endpointURL = 'http://138.91.38.234:8087/ruleServices/Verifications/versions/0.0.1-SNAPSHOT/rules/Verifications/verificationMain/executions';  
    //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/OfferCalculation/versions/0.0.1-SNAPSHOT/rules/OfferCalculation/offerCalculationMain/executions';
    System.debug('********Endpoint for IM********' + endpointURL);
    System.debug('********Username for IM********' + username);
    System.debug('********Passowrd for IM********' + password);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();

    HTTPResponse res = new HTTPResponse();

    if (!Test.isRunningTest()) {
      res = http.send(req);
      System.debug('res---->' + res);
    } else {
      res.setStatusCode(240);
      res.setBody('{"output":{"loanId":null,"offerAmountList":[{"existingProduct":"HL","offerAmount":0,"multiplier":0,"documents":"APPLICATION FORM;KYC","offerAIdentifier":"NORMAL","offerProductId":"","legalFlag":"Y","technicalFlag":"Y","physicalPDFlag":"Y"},{"existingProduct":"LAP","offerAmount":0,"multiplier":0,"documents":"APPLICATION FORM;KYC","offerAIdentifier":"NORMAL","offerProductId":"","legalFlag":"Y","technicalFlag":"Y","physicalPDFlag":"Y"}],"calculatedOffer":"BLS NORMAL OFFER","noOfferReason":"No ODCC account","calculatedOfferRevisedFor":null,"segment":null},"Action":true}');
    }
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      // Proper Response
      System.debug('Request -----> ' + req);
      result = res.getBody();
      System.debug('result----->' + result);
      //finalResult = parseResponseForProcessDetails(result);
      // System.debug('finalResult ----->' + finalResult);
      // System.debug('Map of result -----> ' + mapOfResults);
    } else {
      // Error in getting response
      System.debug('<-----CONNECTION ERROR----->');
    }

    return result;


  }


  //Mortgage Re-Engg Start
  public String callMortgagePropEquity(Property_Details__c objProp) {

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    if (objProp.Area_Locality__c != null) {
      if (objProp.Area_Locality__r.LocalityId__c != null) {
        gen.writeStringField('LocalityId', objProp.Area_Locality__r.LocalityId__c);
      } else {
        gen.writeStringField('LocalityId', 'null');
      }
      if (objProp.Area_Locality__r.City__c != null) {
        if (objProp.Area_Locality__r.City__r.cityId__c != null) {
          gen.writeStringField('CityId', objProp.Area_Locality__r.City__r.cityId__c);
        } else {
          gen.writeStringField('CityId', 'null');
        }
      } else {
        gen.writeStringField('CityId', 'null');
      }
    } else {
      gen.writeStringField('LocalityId', 'null');
      gen.writeStringField('CityId', 'null');
    }
    if (objProp.project_name__r != null) {
      if (objProp.project_name__r.ProjectId__c != null) {
        gen.writeStringField('ProjectId', objProp.project_name__r.ProjectId__c);
      } else {
        gen.writeStringField('ProjectId', 'null');
      }
    } else {
      gen.writeStringField('ProjectId', 'null');
    }
    if (objProp.Developer_Name__r != null) {
      if (objProp.Developer_Name__r.DeveloperId__c != null) {
        gen.writeStringField('DeveloperId', objProp.Developer_Name__r.DeveloperId__c);
      } else {
        gen.writeStringField('DeveloperId', 'null');
      }
    } else {
      gen.writeStringField('DeveloperId', 'null');
    }

    gen.writeFieldName('userCredential');
    gen.writeStartObject();
    gen.writeStringField('UniqueId', '43970897-DFBC-4DDC-8CA7-796F89466107');
    gen.writeStringField('Password', 'hgdn8js7om880j');
    String jsonString = gen.getAsString();
    String response = '';
    String result = '';
    System.debug('---jsonString---' + jsonString);
    HttpRequest req = new HttpRequest();
    req.setEndpoint('http://bajajfinserv.propequity.in/PE_BajajApi.svc/GetRealtyInfo');
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    Http http = new Http();
    HTTPResponse res = new HTTPResponse();
    if (!Test.isRunningTest()) {

      res = http.send(req);
    } else {
      res.setBody('{ "GetRealtyInfoResult": { "CityDetail": { "AbsorptionSqft": 273.2286, "AbsorptionUnit": 205579, "CityName": "Mumbai","NoOfDeveloper": 878,"SupplyMnsqft": 369.5546, "SupplyUnits": 271429, "TotalProjectlast5years": 1198, "Wtavgprice": 18114, "salesvelocity": 44.87 }, "DeveloperDetail": { "AbsorptionAvailability": 1077, "DeveloperAvailability": 743, "DeveloperName": "Gundecha Builders", "Magnitude": 1820, "TotalProjectlast5years": 5 }, "LocalityDetail": { "AbsnUnitsInLast6month": 552, "AbsorptionSqft": 11.9966879, "AbsorptionUnit": 10241, "LocalityName": "Andheri(E)", "NoOfDeveloper": 67, "SupplyMnsqft": 16.479, "SupplyUnits": 13586, "TotalProjectlast5years": 48, "WtMicroMarketRate": 18341, "salesvelocity": 41.83 }, "ProjectDetail": { "APFDetails": "", "BHK": "1-2", "CityName": "Mumbai", "CompletionDate": "Jun-2009", "ConstructionStatusofProject": "", "CurrentPriceRange": "6500", "CurrentPrimaryPriceMax": 0, "CurrentPrimaryPriceMin": 6500, "CurrentStatus": "Sold", "DelayInMonths": 18, "DeveloperName": "GHP Group", "InfraCharges": "", "LaunchDate": "Jun-2006", "LaunchPrice": 5100, "LaunchSqft": 44000, "LocalityName": "Andheri(E)", "Name": "Saki Vihar", "Nooffloors": "0 to 0", "PriceBasedOn": "Builtup", "ProjectSegment": "Mid", "ProjectSizeInSqft": 44000, "ProjectSubType": "Apartment Cmplx", "Projectlevelabsorptionrate": 1, "ResalepriceMax": 15300, "ResalepriceMin": 14800, "ReselPriceRange": "14800-15300", "SoldUnits": 60, "TotalSqft": 44000, "TotalUnits": 60, "UnitSizeRange": "570-890", "UpdateDate": "Dec-2015", "WtMicroMarketRate": 18341 } }  } ');
      res.setStatusCode(250);
    }

    System.debug('res---->' + res);
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
      System.debug('Request -----> ' + req);
      response = res.getBody();
      result = 'Sucess';
      System.debug('response----->' + response);
      if (response != null) {
        Map < String, Object > PropEquityResponse = new Map < String, Object > ();
        PropEquityResponse = (Map < String, Object > ) JSON.deserializeUntyped(response);
        System.debug('---PropEquityResponse===>' + PropEquityResponse);
        objProp.PE_Responce__c = response;

        System.debug('---PropEquityResponse.get(GetRealtyInfoResult)===>' + PropEquityResponse.get('GetRealtyInfoResult'));
        Map < String, Object > PropEquityResponseObj = (Map < String, Object > ) PropEquityResponse.get('GetRealtyInfoResult');
        System.debug('---PropEquityResponseObj===>' + PropEquityResponseObj);


        Map < String, Object > PropEquityRespCity = (Map < String, Object > ) PropEquityResponseObj.get('CityDetail');
        System.debug('---PropEquityRespCity===>' + PropEquityResponseObj.get('CityDetail'));
        Map < String, Object > PropEquityRespLoacality = (Map < String, Object > ) PropEquityResponseObj.get('LocalityDetail');
        System.debug('---PropEquityRespLoacality===>' + PropEquityResponseObj.get('LocalityDetail'));
        Map < String, Object > PropEquityRespDeveloper = (Map < String, Object > ) PropEquityResponseObj.get('DeveloperDetail');
        System.debug('---PropEquityRespDeveloper===>' + PropEquityResponseObj.get('DeveloperDetail'));
        Map < String, Object > PropEquityRespProject = (Map < String, Object > ) PropEquityResponseObj.get('ProjectDetail');
        System.debug('---PropEquityRespProject===>' + PropEquityResponseObj.get('ProjectDetail'));

        if (PropEquityRespCity == null && PropEquityRespLoacality == null && PropEquityRespDeveloper == null && PropEquityRespProject == null) {
          //Do not update PE flag
          result = 'Fail'; // added for prod Issue
          System.debug('---PE response is NULL for all four Parameters !!!---');
        } else {
          // Update PE Flag
          objProp.Property_Equity_Done__c = true;
          objProp.Type_of_Valuation__c = 'Internal';
          update objProp;
        }


        //Update City Master
        if (PropEquityRespCity != null) {
          if (objProp.Area_Locality__r.City__c != null) {
            objProp.Area_Locality__r.City__r.Absorption_in_Sqft__c = Double.ValueOf(PropEquityRespCity.get('AbsorptionSqft'));
            objProp.Area_Locality__r.City__r.Absorption_in_Unit__c = Double.ValueOf(PropEquityRespCity.get('AbsorptionUnit'));
            objProp.Area_Locality__r.City__r.No_Of_Developer__c = Double.ValueOf(PropEquityRespCity.get('NoOfDeveloper'));
            objProp.Area_Locality__r.City__r.Sales_Velocity__c = Double.ValueOf(PropEquityRespCity.get('salesvelocity'));
            objProp.Area_Locality__r.City__r.Supply_Mn_sqft__c = Double.ValueOf(PropEquityRespCity.get('SupplyMnsqft'));
            objProp.Area_Locality__r.City__r.Supply_Units__c = Double.ValueOf(PropEquityRespCity.get('SupplyUnits'));
            objProp.Area_Locality__r.City__r.Total_Projects_in_last_5_years__c = Double.ValueOf(PropEquityRespCity.get('TotalProjectlast5years'));
            objProp.Area_Locality__r.City__r.WT_AVG_Price__c = Double.ValueOf(PropEquityRespCity.get('Wtavgprice'));

            //Update City Master
            try {
              update objProp.Area_Locality__r.City__r;
              System.debug('---City(Demographic Mappings) Master Updated---' + objProp.Area_Locality__r.City__c);
            } catch (DMLException e) {
              System.debug('---Exception---' + e.getMessage());
            }
          }
        } else {
          System.debug('---PropEquityRespCity is NULL---');
        }
        //System.debug('PropEquityRespLoacality --->' + PropEquityRespLoacality.keySet());

        //Update Locality Master
        if (PropEquityRespLoacality != null) {
          if (objProp.Area_Locality__c != null) {
            System.debug('trytrytry' + Double.ValueOf(PropEquityRespLoacality.get('AbsnUnitsInLast6month')));
            System.debug('trytrytry' + objProp.Area_Locality__r.Absn_Units_In_Last_6_Month__c);
            objProp.Area_Locality__r.Absn_Units_In_Last_6_Month__c = Double.ValueOf(PropEquityRespLoacality.get('AbsnUnitsInLast6month'));
            objProp.Area_Locality__r.Absorption_in_Sqft__c = Double.ValueOf(PropEquityRespLoacality.get('AbsorptionSqft'));
            objProp.Area_Locality__r.Absorption_in_Unit__c = Double.ValueOf(PropEquityRespLoacality.get('AbsorptionUnit'));
            objProp.Area_Locality__r.No_Of_Developer__c = Double.ValueOf(PropEquityRespLoacality.get('NoOfDeveloper'));
            objProp.Area_Locality__r.Supply_in_sqft__c = Double.ValueOf(PropEquityRespLoacality.get('SupplyMnsqft'));
            objProp.Area_Locality__r.Supplyin_Units__c = Double.ValueOf(PropEquityRespLoacality.get('SupplyUnits'));
            objProp.Area_Locality__r.Total_Projects_in_last_5_years__c = Double.ValueOf(PropEquityRespLoacality.get('TotalProjectlast5years'));
            objProp.Area_Locality__r.WT_Micro_Market_Rate__c = Double.ValueOf(PropEquityRespLoacality.get('WtMicroMarketRate'));
            try {
              // objProp.Area_Locality__r.Sales_Velocity__c = Double.valueOf(string.valueof(PropEquityRespLoacality.get('salesvelocity')));//bug 13596 comenting this field and using below new created field
              objProp.Area_Locality__r.Sales_velocity_Text__c = string.valueof(PropEquityRespLoacality.get('salesvelocity'));
            } catch (exception e) {
              System.debug('---Exception---' + e.getmessage());
              objProp.Area_Locality__r.Sales_Velocity__c = null;
              objProp.Area_Locality__r.Sales_velocity_Text__c = ''; // bug 13596
            }
            //Update Locality Master
            try {
              update objProp.Area_Locality__r;
              System.debug('---Area/Locatlity Master Updated---' + objProp.Area_Locality__c);
            } catch (DMLException e) {
              System.debug('---Exception---' + e.getMessage());
            }
          }
        } else {
          System.debug('---PropEquityRespLoacality is NULL---');
        }


        //Update Builder Master
        if (PropEquityRespDeveloper != null) {
          if (objProp.Developer_Name__c != null) {
            objProp.Developer_Name__r.Absorption_Availability__c = Double.ValueOf(PropEquityRespDeveloper.get('AbsorptionAvailability'));
            objProp.Developer_Name__r.Developer_Availability__c = Double.ValueOf(PropEquityRespDeveloper.get('DeveloperAvailability'));
            objProp.Developer_Name__r.Total_Projects_in_last_5_years__c = Double.ValueOf(PropEquityRespDeveloper.get('TotalProjectlast5years'));
            objProp.Developer_Name__r.Magnitude__c = Double.ValueOf(PropEquityRespDeveloper.get('Magnitude'));

            //Update Developer Master
            try {
              update objProp.Developer_Name__r;
              System.debug('---Builder(Developer) Master Updated---' + objProp.Developer_Name__c);
            } catch (DMLException e) {
              System.debug('---Exception---' + e.getMessage());
            }
          }

        } else {
          System.debug('---PropEquityRespDeveloper is NULL---');
        }


        //Update Project Master
        if (PropEquityRespProject != null) {
          if (objProp.project_name__c != null && (objProp.project_name__r.Name != 'Others' && objProp.project_name__r.Name != 'OTHERS')) { // bug 13606

            //objProp.Project_Master__r.APF_Number__c =  String.valueof(PropEquityRespProject.get('APFDetails'));
            //objProp.project_name__r.Project_segmentation__c =  String.valueof(PropEquityRespProject.get('ProjectSegment'));
            objProp.project_name__r.PE_Project_Segment__c = String.valueof(PropEquityRespProject.get('ProjectSegment'));

            objProp.project_name__r.Nature_of_Proposed_Development__c = String.valueof(PropEquityRespProject.get('ProjectSubType'));
            objProp.project_name__r.Sold_Units__c = Double.ValueOf(PropEquityRespProject.get('SoldUnits'));
            objProp.project_name__r.Total_Units__c = Double.ValueOf(PropEquityRespProject.get('TotalUnits'));
            objProp.project_name__r.BHK__c = String.valueof(PropEquityRespProject.get('BHK'));
            objProp.project_name__r.Completion_Date__c = String.ValueOf(PropEquityRespProject.get('CompletionDate'));
            objProp.project_name__r.Construction_Status_of_Project__c = String.ValueOf(PropEquityRespProject.get('ConstructionStatusofProject'));
            objProp.project_name__r.Current_Price_Range__c = String.valueof(PropEquityRespProject.get('CurrentPriceRange'));
            objProp.project_name__r.Current_Primary_Price_Max__c = Double.ValueOf(PropEquityRespProject.get('CurrentPrimaryPriceMax'));
            objProp.project_name__r.Current_Primary_Price_Min__c = Double.ValueOf(PropEquityRespProject.get('CurrentPrimaryPriceMin'));
            objProp.project_name__r.Current_Status__c = String.ValueOf(PropEquityRespProject.get('CurrentStatus'));
            objProp.project_name__r.Delay_In_Months__c = Double.ValueOf(PropEquityRespProject.get('DelayInMonths'));
            objProp.project_name__r.Infra_Charges__c = String.ValueOf(PropEquityRespProject.get('InfraCharges'));
            objProp.project_name__r.Launch_Date__c = String.ValueOf(PropEquityRespProject.get('LaunchDate'));
            objProp.project_name__r.Launch_Price__c = Double.ValueOf(PropEquityRespProject.get('LaunchPrice'));
            objProp.project_name__r.Launch_Sqft__c = Double.ValueOf(PropEquityRespProject.get('LaunchSqft'));
            objProp.project_name__r.No_of_floors__c = String.ValueOf(PropEquityRespProject.get('Nooffloors'));
            objProp.project_name__r.Price_Based_On__c = String.ValueOf(PropEquityRespProject.get('PriceBasedOn'));
            objProp.project_name__r.Project_level_absorption_rate__c = Double.ValueOf(PropEquityRespProject.get('Projectlevelabsorptionrate'));
            objProp.project_name__r.Project_Size_In_Sqft__c = Double.ValueOf(PropEquityRespProject.get('ProjectSizeInSqft'));
            objProp.project_name__r.Resale_Price_Max__c = Double.ValueOf(PropEquityRespProject.get('ResalepriceMax'));
            objProp.project_name__r.Resale_Price_Min__c = Double.ValueOf(PropEquityRespProject.get('ResalepriceMin'));
            objProp.project_name__r.Resel_Price_Range__c = String.ValueOf(PropEquityRespProject.get('ReselPriceRange'));
            objProp.project_name__r.Total_Sqft__c = Double.ValueOf(PropEquityRespProject.get('TotalSqft'));
            objProp.project_name__r.Unit_Size_Range__c = String.ValueOf(PropEquityRespProject.get('UnitSizeRange'));
            objProp.project_name__r.Update_Date__c = String.ValueOf(PropEquityRespProject.get('UpdateDate'));
            objProp.project_name__r.WT_Micro_Market_Rate__c = Double.ValueOf(PropEquityRespProject.get('WtMicroMarketRate'));
            System.debug('in BRE callout Rasika efore');

            //newely added bug 13606
            //if(objProp.project_name__r.Current_Primary_Price_Max__c!=0  || objProp.project_name__r.Resale_Price_Min__c != 0 || objProp.project_name__r.Resale_Price_Max__c != 0 || objProp.project_name__r.Current_Primary_Price_Min__c != 0 )  { // bug 15170 condition comented
            System.debug('in BRE callout');
            if ((objProp.project_name__r.Resale_Price_Max__c != null && objProp.project_name__r.Resale_Price_Max__c != 0) && objProp.Nature_of_property__c == 'Flat') {
              System.debug('in resale');
              if (objProp.project_name__r.Resale_Price_Min__c != null && objProp.project_name__r.Resale_Price_Min__c != 0) {
                objProp.project_name__r.Current_Rate_per_Sq_Ft__c = string.valueOF(((objProp.project_name__r.Resale_Price_Max__c + objProp.project_name__r.Resale_Price_Min__c) / 2));
              } else {
                objProp.project_name__r.Current_Rate_per_Sq_Ft__c = string.valueOF(objProp.project_name__r.Resale_Price_Max__c);
              }
            } else {
              if ((objProp.project_name__r.Resale_Price_Min__c != null && objProp.project_name__r.Resale_Price_Min__c != 0) && objProp.Nature_of_property__c == 'Flat') {
                objProp.project_name__r.Current_Rate_per_Sq_Ft__c = string.valueOF(objProp.project_name__r.Resale_Price_Min__c);
              }

            }
            System.debug('after resale: ' + objProp.project_name__r.Current_Rate_per_Sq_Ft__c);
            if ((objProp.project_name__r.Resale_Price_Max__c == null || objProp.project_name__r.Resale_Price_Max__c == 0) && (objProp.project_name__r.Resale_Price_Min__c == null || objProp.project_name__r.Resale_Price_Min__c == 0) && objProp.Nature_of_property__c == 'Flat') { // bug 15170 condition added
              if ((objProp.project_name__r.Current_Primary_Price_Max__c != null && objProp.project_name__r.Current_Primary_Price_Max__c != 0) && objProp.Nature_of_property__c == 'Flat') {
                System.debug('in current primary: ');
                if ((objProp.project_name__r.Current_Primary_Price_Min__c != null && objProp.project_name__r.Current_Primary_Price_Min__c != 0) && objProp.Nature_of_property__c == 'Flat') {
                  objProp.project_name__r.Current_Rate_per_Sq_Ft__c = string.valueOF(((objProp.project_name__r.Current_Primary_Price_Max__c + objProp.project_name__r.Current_Primary_Price_Min__c) / 2));
                } else {
                  objProp.project_name__r.Current_Rate_per_Sq_Ft__c = string.valueOF(objProp.project_name__r.Current_Primary_Price_Max__c);
                }
              } else {
                If((objProp.project_name__r.Current_Primary_Price_Min__c != null && objProp.project_name__r.Current_Primary_Price_Min__c != 0) && objProp.Nature_of_property__c == 'Flat') {
                  objProp.project_name__r.Current_Rate_per_Sq_Ft__c = string.valueOF(objProp.project_name__r.Current_Primary_Price_Min__c);
                }
                else {
                  objProp.project_name__r.Current_Rate_per_Sq_Ft__c = '0';
                }
              }
            }
            // }                  

            //objProp.Total_valuation_As_per_PE_PPIV2__c = Double.valueof(PropEquityRespProject.get('CurrentPriceRange'));
            //                        System.debug('---objProp.Total_valuation_As_per_PE_PPIV2__c---'+objProp.Total_valuation_As_per_PE_PPIV2__c);


            //Update Project Master
            try {
              update objProp.project_name__r;
              System.debug('---Project Master Updated---' + objProp.project_name__c);
            } catch (DMLException e) {
              System.debug('---Exception---' + e.getMessage());
            }
          }
        } else {
          System.debug('---PropEquityRespProject is NULL---');
        }

        /* Bug 13596
            //Update PPIV2 Master
            if (objProp != null && objProp.Property_Type__c != null && objProp.Nature_of_property__c != null) {
                String propertyNatureAndTransaction = '';
                double averagePropPricePPI = 0;
                Map < String, String > mapOfAverageRate = new Map < String, String > ();
                propertyNatureAndTransaction = objProp.Property_Type__c + '-' + objProp.Nature_of_property__c;
                System.debug('Key combination ----> ' + propertyNatureAndTransaction);

                mapOfAverageRate.put('SORP-Flat', 'Average_Price_Individual_Flat__c');
                mapOfAverageRate.put('SORP-Bungalow', 'Average_Price_Individual_Bungalow__c');
                mapOfAverageRate.put('SORP-Floor', 'Average_Price_Builder_Floor__c');
                mapOfAverageRate.put('Mixed usage-Flat', 'Average_Price_Individual_Flat__c');
                mapOfAverageRate.put('Mixed usage-Bungalow', 'Average_Price_Individual_Bungalow__c');
                mapOfAverageRate.put('Vacant Residential-Flat', 'Average_Price_Individual_Flat__c');
                mapOfAverageRate.put('Vacant Residential-Bungalow', 'Average_Price_Individual_Bungalow__c');
                mapOfAverageRate.put('Vacant Residential-Floor', 'Average_Price_Builder_Floor__c');
                mapOfAverageRate.put('Individual Property-Flat', 'Average_Price_Individual_Flat__c');
                mapOfAverageRate.put('Individual Property-Plot', 'Average_Price_Individual_Plot__c');
                mapOfAverageRate.put('Individual Property-Bungalow', 'Average_Price_Individual_Bungalow__c');
                mapOfAverageRate.put('Individual Property-Floor', 'Average_Price_Builder_Floor__c');
                mapOfAverageRate.put('Rented Property-Flat', 'Average_Rented_Price_Individual_Flat__c');
                mapOfAverageRate.put('Rented Property-Bungalow', 'Avg_Rented_Price_Individual_Bungalow__c');
                mapOfAverageRate.put('Rented Property-Floor', 'Average_Rented_Price_Builder_Floor__c');
                mapOfAverageRate.put('Construction Property-Flat', 'Average_Price_Individual_Flat__c');
                mapOfAverageRate.put('Construction Property-Bungalow', 'Average_Price_Individual_Bungalow__c');

                mapOfAverageRate.put('Plot-Plot', 'Average_Price_Individual_Plot__c');

                String fieldName = mapOfAverageRate.get(propertyNatureAndTransaction);
                System.debug('---fieldName---' + fieldName);

                if (fieldName != null) {
                    if (objProp.Area_Locality__c != null) {
                        ID ppiid = objProp.Area_Locality__c;
                        System.debug('---ppiid---' + ppiid);

                        String query = 'Select id, name, Area_Locality__c, Primary_partner_value__c,Average_construction_rate_per_sqr_feet__c,Average_Price_Individual_Plot__c, ' + fieldName + ' from Property_Price_Index__c where Area_Locality__c = : ppiid and Primary_partner_value__c = true AND From_Date__c <= TODAY AND Till_Date__c >= TODAY';
                        System.debug('Query ---> ' + query);
                        List < sObject > ppiList = Database.query(query);
                        System.debug('ppiList ---> ' + ppiList);
                        if (ppiList.size() > 0) {
                            Property_Price_Index__c objPPI = (Property_Price_Index__c) ppiList[0];
                            System.debug('---objPPI---' + objPPI);

                            if (PropEquityRespProject != null) {
                                objPPI.put(fieldName, Double.valueof(PropEquityRespProject.get('CurrentPriceRange')));
                                try {
                                    update objPPI;
                                    System.debug('---PPIV2 Master Updated---' + objPPI);
                                } catch (DMLException e) {
                                    System.debug('---Exception---' + e.getMessage());
                                }
                            } else {
                                System.debug('---PropEquityRespProject is NULL---');
                            }
                        }
                    }
                }
            }*/
      }
    } else {
      result = 'Fail'; // added for prod issue
      System.debug('<-----CONNECTION ERROR----->');
    }
    return result;
  }


  //public Map<String,String> callMortgageMCP(Map <string,string> MCPMortgageValueMap, List <Property_Details__c> PropertyList) {
  public Map < String, String > callMortgageMCP(Map < String, Object > reqMap) {
    Map < String, String > mortgageMCPResult = new Map < String, String > ();
    try {

      Map < string, string > MCPMortgageValueMap = reqMap.containsKey('generic_map') ? (Map < String, String > ) reqMap.get('generic_map') : new Map < String, String > ();
      List < Property_Details__c > PropertyList = reqMap.containsKey('prop_lst') ? (List < Property_Details__c > ) reqMap.get('prop_lst') : new List < Property_Details__c > ();

      JSONGenerator gen = JSON.createGenerator(true);

      gen.writeStartObject();
      /*gen.writeFieldName('Verification');
    gen.writeStartArray();
        for(integer i=0;i<1;i++){
            gen.writeStartObject();
                if(MCPMortgageValueMap.containsKey('applicant_type'))
                    gen.writeObjectField('applicant_type',MCPMortgageValueMap.get('applicant_type'));                       
            gen.writeEndObject();
        }   
    gen.writeEndArray();                    
System.debug('##1##');*/

      gen.writeFieldName('loan_parameter');
      gen.writeStartObject();
      if (MCPMortgageValueMap.containsKey('requested_loan_amount'))
        gen.writeNumberField('requested_loan_amount', decimal.valueOf(MCPMortgageValueMap.get('requested_loan_amount')));
      if (MCPMortgageValueMap.containsKey('requested_tenor'))
        gen.writeNumberField('requested_tenor', double.valueOf(MCPMortgageValueMap.get('requested_tenor')));
      if (MCPMortgageValueMap.containsKey('reqested_roi'))
        gen.writeNumberField('reqested_roi', double.valueOf(MCPMortgageValueMap.get('reqested_roi')));
      if (MCPMortgageValueMap.containsKey('product'))
        gen.writeObjectField('product', MCPMortgageValueMap.get('product'));
      if (MCPMortgageValueMap.containsKey('stage'))
        gen.writeObjectField('stage', MCPMortgageValueMap.get('stage'));

      if (MCPMortgageValueMap.containsKey('type_of_loan'))
        gen.writeObjectField('type_of_loan', MCPMortgageValueMap.get('type_of_loan'));
      if (MCPMortgageValueMap.containsKey('sourcing_channel_type'))
        gen.writeObjectField('sourcing_channel_type', MCPMortgageValueMap.get('sourcing_channel_type'));
      if (MCPMortgageValueMap.containsKey('existing_product'))
        gen.writeObjectField('existing_product', MCPMortgageValueMap.get('existing_product'));
      if (MCPMortgageValueMap.containsKey('offer_amount'))
        gen.writeObjectField('offer_amount', decimal.valueOf(MCPMortgageValueMap.get('offer_amount')));
      if (MCPMortgageValueMap.containsKey('offer_tenor'))
        gen.writeObjectField('offer_tenor', double.valueOf(MCPMortgageValueMap.get('offer_tenor')));
      if (MCPMortgageValueMap.containsKey('offer_rate'))
        gen.writeObjectField('offer_rate', double.valueOf(MCPMortgageValueMap.get('offer_rate')));
      if (MCPMortgageValueMap.containsKey('offerProduct'))
        gen.writeObjectField('offerProduct', MCPMortgageValueMap.get('offerProduct'));
      if (MCPMortgageValueMap.containsKey('baseProduct'))
        gen.writeObjectField('baseProduct', MCPMortgageValueMap.get('baseProduct'));

      if (MCPMortgageValueMap.containsKey('mcpType'))
        gen.writeObjectField('mcpType', MCPMortgageValueMap.get('mcpType'));

      gen.writeEndObject();
      System.debug('##2##');

      gen.writeFieldName('CAMS');
      gen.writeStartArray();
      for (integer i = 0; i < 1; i++) {
        gen.writeStartObject();
        if (MCPMortgageValueMap.containsKey('net_Salary_for_Month1'))
          gen.writeNumberField('net_Salary_for_Month1', double.valueOf(MCPMortgageValueMap.get('net_Salary_for_Month1')));

        if (MCPMortgageValueMap.containsKey('average_net_salary'))
          gen.writeNumberField('average_net_salary', double.valueOf(MCPMortgageValueMap.get('average_net_salary')));


        if (MCPMortgageValueMap.containsKey('proposed_Loan_Amt'))
          gen.writeNumberField('proposed_Loan_Amt', double.valueOf(MCPMortgageValueMap.get('proposed_Loan_Amt')));
        if (MCPMortgageValueMap.containsKey('tenor'))
          gen.writeNumberField('tenor', double.valueOf(MCPMortgageValueMap.get('tenor')));
        gen.writeEndObject();
      }
      gen.writeEndArray();

      System.debug('##3##');
      gen.writeFieldName('generic_info');
      gen.writeStartObject();
      if (MCPMortgageValueMap.containsKey('branch_type'))
        gen.writeObjectField('branch_type', MCPMortgageValueMap.get('branch_type'));
      if (MCPMortgageValueMap.containsKey('branch_name'))
        gen.writeObjectField('branch_name', MCPMortgageValueMap.get('branch_name'));

      gen.writeEndObject();
      System.debug('##4##');

      gen.writeFieldName('demographic');
      gen.writeStartArray();
      for (integer i = 0; i < 1; i++) {
        gen.writeStartObject();
        if (MCPMortgageValueMap.containsKey('educational_qualification'))
          gen.writeObjectField('educational_qualification', MCPMortgageValueMap.get('educational_qualification'));
        if (MCPMortgageValueMap.containsKey('total_employment_vintage'))
          gen.writeObjectField('total_employment_vintage', double.valueOf(MCPMortgageValueMap.get('total_employment_vintage')));
        if (MCPMortgageValueMap.containsKey('date_of_birth'))
          gen.writeObjectField('date_of_birth', MCPMortgageValueMap.get('date_of_birth'));
        if (MCPMortgageValueMap.containsKey('constitution'))
          gen.writeObjectField('constitution', MCPMortgageValueMap.get('constitution'));
        if (MCPMortgageValueMap.containsKey('name_of_employer'))
          gen.writeObjectField('name_of_employer', MCPMortgageValueMap.get('name_of_employer'));

        if (MCPMortgageValueMap.containsKey('years_in_business_job'))
          gen.writeNumberField('years_in_business_job', double.valueOf(MCPMortgageValueMap.get('years_in_business_job')));
        if (MCPMortgageValueMap.containsKey('first_name'))
          gen.writeObjectField('first_name', MCPMortgageValueMap.get('first_name'));
        if (MCPMortgageValueMap.containsKey('last_name'))
          gen.writeObjectField('last_name', MCPMortgageValueMap.get('last_name'));
        if (MCPMortgageValueMap.containsKey('applicant_type'))
          gen.writeObjectField('applicant_type', MCPMortgageValueMap.get('applicant_type'));
        if (MCPMortgageValueMap.containsKey('pan'))
          gen.writeObjectField('pan', MCPMortgageValueMap.get('pan'));
        if (MCPMortgageValueMap.containsKey('nature_of_business'))
          gen.writeObjectField('nature_of_business', MCPMortgageValueMap.get('nature_of_business'));
        if (MCPMortgageValueMap.containsKey('e_mail_id'))
          gen.writeObjectField('e_mail_id', MCPMortgageValueMap.get('e_mail_id'));


        if (MCPMortgageValueMap.containsKey('profession'))
          gen.writeObjectField('profession', MCPMortgageValueMap.get('profession'));
        if (MCPMortgageValueMap.containsKey('specialisation'))
          gen.writeObjectField('specialisation', MCPMortgageValueMap.get('specialisation'));

        if (MCPMortgageValueMap.containsKey('customer_type'))
          gen.writeObjectField('customer_type', MCPMortgageValueMap.get('customer_type'));

        if (MCPMortgageValueMap.containsKey('doctorsFlag'))
          gen.writeObjectField('doctorsFlag', MCPMortgageValueMap.get('doctorsFlag'));
        if (MCPMortgageValueMap.containsKey('employerType'))
          gen.writeObjectField('employerType', MCPMortgageValueMap.get('employerType'));

        if (MCPMortgageValueMap.containsKey('mcpBaseLoan'))
          gen.writeObjectField('mcpBaseLoan', MCPMortgageValueMap.get('mcpBaseLoan'));
        gen.writeEndObject();
      }
      gen.writeEndArray();
      System.debug('##5##');

      /*gen.writeFieldName('Cibil_lst');
    gen.writeStartArray();
        for(integer i=0;i<1;i++){
            gen.writeStartObject();
            if(MCPMortgageValueMap.containsKey('applicant_type'))
                gen.writeObjectField('applicant_type',MCPMortgageValueMap.get('applicant_type'));

            gen.writeEndObject();
        }   
    gen.writeEndArray();                        
System.debug('##6##');  
       */
      gen.writeFieldName('Existing_Loan');
      gen.writeStartArray();
      for (integer i = 0; i < 1; i++) {
        gen.writeStartObject();
        if (MCPMortgageValueMap.containsKey('applicant_type'))
          gen.writeObjectField('applicant_type', MCPMortgageValueMap.get('applicant_type'));

        gen.writeEndObject();
      }
      gen.writeEndArray();
      System.debug('##7##');

      gen.writeFieldName('profit_loss_statement');
      gen.writeStartObject();
      if (MCPMortgageValueMap.containsKey('py_sales_turnover'))
        gen.writeNumberField('py_sales_turnover', double.valueOf(MCPMortgageValueMap.get('py_sales_turnover')));
      if (MCPMortgageValueMap.containsKey('cy_sales_turnover'))
        gen.writeNumberField('cy_sales_turnover', double.valueOf(MCPMortgageValueMap.get('cy_sales_turnover')));
      if (MCPMortgageValueMap.containsKey('py_profit_before_tax'))
        gen.writeNumberField('py_profit_before_tax', double.valueOf(MCPMortgageValueMap.get('py_profit_before_tax')));
      if (MCPMortgageValueMap.containsKey('cy_profit_before_tax'))
        gen.writeNumberField('cy_profit_before_tax', double.valueOf(MCPMortgageValueMap.get('cy_profit_before_tax')));
      if (MCPMortgageValueMap.containsKey('cy_gross_receipts'))
        gen.writeNumberField('cy_gross_receipts', double.valueOf(MCPMortgageValueMap.get('cy_gross_receipts')));
      if (MCPMortgageValueMap.containsKey('py_gross_receipts'))
        gen.writeNumberField('py_gross_receipts', double.valueOf(MCPMortgageValueMap.get('py_gross_receipts')));

      gen.writeEndObject();
      System.debug('##8##');

      gen.writeFieldName('bank_summary');
      gen.writeStartArray();
      for (integer i = 0; i < 1; i++) {
        gen.writeStartObject();
        if (MCPMortgageValueMap.containsKey('applicant_type'))
          gen.writeObjectField('applicant_type', MCPMortgageValueMap.get('applicant_type'));
        if (MCPMortgageValueMap.containsKey('avg_od_cc_utilisation'))
          gen.writeNumberField('avg_od_cc_utilisation', double.valueOf(MCPMortgageValueMap.get('avg_od_cc_utilisation')));
        if (MCPMortgageValueMap.containsKey('BTLoanBounceInLast6months'))
          gen.writeNumberField('BTLoanBounceInLast6months', double.valueOf(MCPMortgageValueMap.get('BTLoanBounceInLast6months')));
        if (MCPMortgageValueMap.containsKey('odccFlag'))
          gen.writeObjectField('odccFlag', string.valueOf(MCPMortgageValueMap.get('odccFlag')));
        if (MCPMortgageValueMap.containsKey('odccLimit'))
          gen.writeNumberField('odccLimit', double.valueOf(MCPMortgageValueMap.get('odccLimit')));
        if (MCPMortgageValueMap.containsKey('odccbankName'))
          gen.writeObjectField('odccbankName', MCPMortgageValueMap.get('odccbankName'));

        gen.writeEndObject();
      }
      gen.writeEndArray();
      System.debug('##9##');

      /*gen.writeFieldName('eCommerce');
    gen.writeStartObject();


    gen.writeEndObject();

System.debug('##10##');*/

      gen.writeFieldName('Property_Details');
      gen.writeStartArray();
      if (MCPMortgageValueMap.containsKey('mcpType') && MCPMortgageValueMap.get('mcpType').equalsIgnoreCase('Property')) {
        if (PropertyList != null && PropertyList.size() > 0) {
          for (Property_Details__c property: PropertyList) {
            gen.writeStartObject();

            /*if(PropertyMap.get(propertyId).Property_Land_Area_Val1__c != null)
        gen.writeObjectField('property_land_area',double.valueof(PropertyMap.get(propertyId).Land_Area_units__c)); */

            if (property.Property_Land_Area_In_Sq_Ft__c != null)
              gen.writeObjectField('property_land_area', double.valueof(property.Property_Land_Area_In_Sq_Ft__c));

            if (property.Construction_Area_SBU__c != null)
              gen.writeObjectField('construction_area', double.valueof(property.Construction_Area_SBU__c));

            if (property.Construction_Valuation_1__c != null)
              gen.writeObjectField('construction_valuation1', string.valueOf(property.Construction_Valuation_1__c));

            if (property.Construction_Valuation_2__c != null)
              gen.writeObjectField('construction_valuation2', string.valueOf(property.Construction_Valuation_2__c));

            if (property.Property_Age__c != null)
              gen.writeObjectField('property_age', string.valueOf(property.Property_Age__c));
            else
              gen.writeObjectField('property_age', 0);

            if (property.Value_of_Furniture_and_fixture__c != null)
              gen.writeObjectField('fandf_amount', property.Value_of_Furniture_and_fixture__c);

            if (property.Property_Identified__c != null)
              gen.writeObjectField('property_identified', string.valueOf(property.Property_Identified__c));

            if (property.Address__c != null)
              gen.writeObjectField('property_address', string.valueOf(property.Address__c));

            if (property.Property_City__c != null)
              gen.writeObjectField('property_city', string.valueOf(property.Property_City__c));

            if (property.Nature_of_property__c != null)
              gen.writeObjectField('property_type', string.valueOf(property.Nature_of_property__c));

            if (property.Type_Of_Measurement__c != null)
              gen.writeObjectField('type_of_measurement', string.valueOf(property.Type_Of_Measurement__c));

            if (property.Property_Address_Line_1__c != null)
              gen.writeObjectField('address_line1', string.valueOf(property.Property_Address_Line_1__c));

            if (property.Property_Address_Line_2__c != null)
              gen.writeObjectField('address_line2', string.valueOf(property.Property_Address_Line_2__c));

            if (property.Property_Address_Line_3__c != null)
              gen.writeObjectField('address_line3', string.valueOf(property.Property_Address_Line_3__c));

            //System.debug('PropertyMap.contains(propertyId)='+PropertyMap.containsKey(propertyId));
            //System.debug('=PropertyMap.get(propertyId).Area_Locality__c.Name='+PropertyMap.get(propertyId).Area_Locality__r.Name);
            if (property.Area_Locality__c != null && property.Area_Locality__r.Name != null)
              gen.writeObjectField('locality', property.Area_Locality__r.Name);
            else if (MCPMortgageValueMap.containsKey('locality') && MCPMortgageValueMap.get('locality') != null)
              gen.writeObjectField('locality', MCPMortgageValueMap.get('locality'));
            else
              gen.writeObjectField('locality', '');

            if (property.Land_Area_as_per_Sale_Deed__c != null)
              gen.writeNumberField('property_land_area_asPer_sale', double.valueof(property.Land_Area_as_per_Sale_Deed__c));


            if (property.Developer_Name__c != null && property.Developer_Name__r.Name != null)
              gen.writeObjectField('developer_name', property.Developer_Name__r.Name);
            else if (MCPMortgageValueMap.containsKey('developer_name') && MCPMortgageValueMap.get('developer_name') != null)
              gen.writeObjectField('developer_name', MCPMortgageValueMap.get('developer_name'));
            else
              gen.writeObjectField('developer_name', '');


            if (property.Project_Name__c != null && property.Project_Name__r.Name != null)
              gen.writeObjectField('project_name', property.Project_Name__r.Name);
            else if (MCPMortgageValueMap.containsKey('project_name') && MCPMortgageValueMap.get('project_name') != null)
              gen.writeObjectField('project_name', MCPMortgageValueMap.get('project_name'));
            else
              gen.writeObjectField('project_name', '');

            if (property.Property_Type__c != null)
              gen.writeObjectField('property_usage', property.Property_Type__c);

            if (property.id != null)
              gen.writeObjectField('property_id', property.id);

            if (property.Hospital_Property__c != null)
              gen.writeObjectField('no_of_beds', double.valueof(property.Hospital_Property__c));

            System.debug('Builder_Maintenance__r=' + property.Developer_Name__r.Builder_Segmentation__c);
            System.debug('Project==' + property.Project_Name__r.Project_segmentation__c);

            if (property.Developer_Name__c != null && property.Developer_Name__r.Builder_Segmentation__c != null)
              gen.writeObjectField('dedupeBuilders', property.Developer_Name__r.Builder_Segmentation__c);
            else if (MCPMortgageValueMap.containsKey('dedupeBuilders') && MCPMortgageValueMap.get('dedupeBuilders') != null)
              gen.writeObjectField('dedupeBuilders', MCPMortgageValueMap.get('dedupeBuilders'));
            else
              gen.writeObjectField('dedupeBuilders', '');

            if (property.Project_Name__c != null && property.Project_Name__r.Project_segmentation__c != null)
              gen.writeObjectField('dedupeProjects', property.Project_Name__r.Project_segmentation__c);
            else if (MCPMortgageValueMap.containsKey('dedupeProjects') && MCPMortgageValueMap.get('dedupeProjects') != null)
              gen.writeObjectField('dedupeProjects', MCPMortgageValueMap.get('dedupeProjects'));
            else
              gen.writeObjectField('dedupeProjects', '');

            //gen.writeObjectField('property_id',propertyId);


            gen.writeEndObject();
          }
        }
      }
      gen.writeEndArray();



      gen.writeEndObject();

      String jsonInput = gen.getAsString();
      System.debug('Input=' + jsonInput);

      endpointURL = '';

      Mid_office_BRE_flow__c BRE_ver = Mid_office_BRE_flow__c.getValues('Mortgage MCP');

      if (BRE_ver != null) {
        endpointURL = BRE_ver.EndpointURL__c;
      }

      //username = 'DEFAULT\\Admin';
      //password = 'Admin';

      System.debug('********Endpoint for IM********' + endpointURL);
      System.debug('********Username for IM********' + username);
      System.debug('********Passowrd for IM********' + password);

      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonInput);
      req.setTimeout(120000);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      System.debug('authorizationHeader ---' + authorizationHeader);
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      Http http = new Http();
      HTTPResponse res = new HTTPResponse();
      if (!Test.isRunningTest()) {
        res = http.send(req);
      } else {
        res.setStatusCode(250);

        res.setBody('{ "mcp_obj": { "mcpOutput": " FINANCIAL MCP PASS ", "mcpDesc": "AVERAGE NET SALARY FAIL", "loanId": null }, "mcp_list": [{ "mcpOutput": "FINANCIAL MCP PASS", "mcpDesc": "AVERAGE NET SALARY FAIL", "loanId": null }], "mcp_policy": "PASS", "sellerOutputs": { "mcpResult": null, "score": null, "sellerCategarization": null, "multiplier": null, "category": null, "eligibleAmount": null, "salesCategoryMap": null, "returnCategoryMap": null, "returnPercentage": null, "cancelCategoryMap": null, "cancelPercentage": null, "zeroBusiness": null, "averageMonthlyPayments": null, "growthPercentage": null, "vintage": null, "mcpList": [] }, "mcp_list_property": [], "mcp_property_obj": { "mcpOutput": null, "mcpDesc": null, "loanId": null, "property": null }, "Action": true} ');
      }
      System.debug('::Response' + res);
      if (res.getStatusCode() >= 200 && res.getStatusCode() < 900) {
        // Proper Response        
        String result = res.getBody();
        System.debug('Result ----->' + result);
        result = result.replaceAll('\\s+', '');
        System.debug('Result ----->' + result);
        //mortgageMCPResult = processResponse1(result);
        String mcpDesc;
        Set < String > mcpOutSet = new Set < String > ();
        Set < String > mcpDescSet = new Set < String > ();

        JSONParser parser = JSON.createParser(result);
        Double grandTotal = 0.0;
        while (parser.nextToken() != null) {
          if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'mcpOutput' || parser.getText() == 'mcp_policy' || parser.getText() == 'mcpDesc')) {
            String key = parser.getText();
            parser.nextToken();

            if (key == 'mcp_policy') {
              mortgageMCPResult.put('mcp_policy', parser.getText());
            }
            if (key == 'mcpDesc') {
              mcpDescSet.add(parser.getText());
            }
            if (key == 'mcpOutput') {
              mcpOutSet.add(parser.getText());
            }
          }

        }
        String mcpOutput;
        for (String s: mcpOutSet) {
          mcpOutput += (mcpOutput == '' ? '' : ',') + s;
        }
        //String mcpDesc;
        for (String s: mcpDescSet) {
          mcpDesc += (mcpDesc == '' ? '' : ',') + s;
        }
        mortgageMCPResult.put('mcpDesc', mcpDesc);
        mortgageMCPResult.put('mcpOutput', mcpOutput);
        mortgageMCPResult.put('Status', 'PASS');
        System.debug(mortgageMCPResult + '=mortgageMCPResult');

      } else {
        mortgageMCPResult.put('Status', 'Failed');
        System.debug('<-----CONNECTION ERROR----->');
      }



    } catch (Exception e) {
      System.debug(e.getMessage() + ' Line number==>' + e.getLineNumber());
    }
    return mortgageMCPResult;



  }

  // rasika: Deviation Bug:11151

  Public Map < string, string > callMortgageDeviation(map < string, Object > reqMap) {
    Map < String, String > MortgageDeviationResult = new Map < String, String > ();
    set < string > deviationcodes = new Set < String > ();
    string approver = '';
    string strDevCodes = '';
    string strcode = '';
    string Doclist = '';
    if (!CommonUtility.isEmpty(reqMap)) {

      Map < string, string > MortDeviationValMap = reqMap.containsKey('generic_map') ? (Map < String, String > ) reqMap.get('generic_map') : new Map < String, String > ();
      List < Property_Details__c > PropertyList = reqMap.containsKey('prop_lst') ? (List < Property_Details__c > ) reqMap.get('prop_lst') : new List < Property_Details__c > ();
      List < Applicant__c > applicantList = reqMap.containsKey('app_lst') ? (List < Applicant__c > ) reqMap.get('app_lst') : new List < Applicant__c > ();
      System.debug('Pro[erty list: ' + PropertyList);
      JSONGenerator gen = JSON.createGenerator(true);
      gen.writeStartObject();
      gen.writeFieldName('Cibil_lst');
      gen.writeStartArray();
      for (integer i = 0; i < 1; i++) {
        gen.writeStartObject();
        if (MortDeviationValMap.containsKey('loan_id'))
          gen.writeObjectField('loan_id', (MortDeviationValMap.get('loan_id') != null) ? string.valueOf(MortDeviationValMap.get('loan_id')) : '');
        if (MortDeviationValMap.containsKey('applicant_id'))
          gen.writeObjectField('applicant_id', (MortDeviationValMap.get('applicant_id') != Null) ? string.valueOf(MortDeviationValMap.get('applicant_id')) : '');
        if (MortDeviationValMap.containsKey('CIBIL_Score'))
          // added for 17096(invalid integer exception)

          if (MortDeviationValMap.get('CIBIL_Score') != null) {
            String CIBILScore;
            CIBILScore = MortDeviationValMap.get('CIBIL_Score');
            if (CIBILScore == '000-1') {
              CIBILScore = CIBILScore.replaceAll('000-1', '0');

            }
            gen.writeNumberField('CIBIL_Score', (MortDeviationValMap.get('CIBIL_Score') != null) ? Integer.valueOf(CIBILScore) : 0);
          }
        if (MortDeviationValMap.containsKey('applicant_Type'))
          gen.writeStringField('applicant_Type', (MortDeviationValMap.get('applicant_Type') != null) ? string.valueof(MortDeviationValMap.get('applicant_Type')) : '');
        gen.writeEndObject();
      }
      gen.writeEndArray();
      System.debug('#1#');
      gen.writeFieldName('Loan_Parameter');
      gen.writeStartObject();
      if (MortDeviationValMap.containsKey('loan_id'))
        gen.writeObjectField('loan_id', string.valueOf(MortDeviationValMap.get('loan_id')));
      if (MortDeviationValMap.containsKey('Product'))
        gen.writestringField('Product', string.valueOf(MortDeviationValMap.get('Product')));
      if (MortDeviationValMap.containsKey('requested_tenor'))
        gen.writeNumberField('requested_tenor', (MortDeviationValMap.get('requested_tenor') != null) ? Integer.valueOf(MortDeviationValMap.get('requested_tenor')) : 0);
      if (MortDeviationValMap.containsKey('approved_Loan_Amount'))
        gen.writeNumberField('approved_Loan_Amount', (MortDeviationValMap.get('approved_Loan_Amount') != Null) ? Integer.valueof(MortDeviationValMap.get('approved_Loan_Amount')) : 0);
      if (MortDeviationValMap.containsKey('product'))
        gen.writeStringField('product', (MortDeviationValMap.get('product') != null) ? string.valueof(MortDeviationValMap.get('product')) : '');
      gen.writeEndObject();
      gen.writeFieldName('CAMS');
      gen.writeStartArray();
      for (integer i = 0; i < 1; i++) {
        gen.writeStartObject();
        if (MortDeviationValMap.containsKey('applicable_FOIR1'))
          gen.writeNumberField('applicable_FOIR1', Integer.valueof(MortDeviationValMap.get('applicable_FOIR1')));
        if (MortDeviationValMap.containsKey('final_FOIR'))
          gen.writeNumberField('final_FOIR', decimal.valueof(MortDeviationValMap.get('final_FOIR')));
        if (MortDeviationValMap.containsKey('average_Net_Salary'))
          gen.writeNumberField('average_Net_Salary', decimal.valueof(MortDeviationValMap.get('average_Net_Salary')));
        gen.writeEndObject();
      }
      gen.writeEndArray();
      gen.writeFieldName('generic');
      gen.writeStartObject();
      if (MortDeviationValMap.containsKey('branch_Name'))
        gen.writeStringField('branch_Name', (MortDeviationValMap.get('branch_Name') != null) ? string.valueOf(MortDeviationValMap.get('branch_Name')) : '');
      gen.writeEndObject();
      gen.writeFieldName('Demographic');
      gen.writeStartArray();
      for (integer i = 0; i < 1; i++) {
        gen.writeStartObject();
        if (MortDeviationValMap.containsKey('date_of_Birth'))
          gen.writeStringField('date_of_Birth', string.valueOf(MortDeviationValMap.get('date_of_Birth')));
        if (MortDeviationValMap.containsKey('office_Email_Id_flag'))
          gen.writeStringField('office_Email_Id_flag', string.valueOf(MortDeviationValMap.get('office_Email_Id_flag')));
        if (MortDeviationValMap.containsKey('company_Category'))
          gen.writeStringField('company_Category', string.valueOf(MortDeviationValMap.get('company_Category')));
        /*Uncommented code for Bug: 21699: To raise Minimum Work Experience Deviation S*/
        if (MortDeviationValMap.containsKey('total_Employment_Vintage'))
          gen.writeNumberField('total_Employment_Vintage', !CommonUtility.isEmpty(MortDeviationValMap.get('total_Employment_Vintage')) ? Integer.valueOf(MortDeviationValMap.get('total_Employment_Vintage')) : 0);
        /*Uncommented code for Bug: 21699: To raise Minimum Work Experience Deviation E*/
        if (MortDeviationValMap.containsKey('domain_created_date'))
          gen.writeStringField('domain_created_date', (MortDeviationValMap.get('domain_created_date') != null) ? string.valueOf(MortDeviationValMap.get('domain_created_date')) : '');
        if (MortDeviationValMap.containsKey('dedup'))
          gen.writeStringField('dedup', (MortDeviationValMap.get('dedup') != null) ? string.valueOf(MortDeviationValMap.get('dedup')) : '');
        if (MortDeviationValMap.containsKey('applicant_Type'))
          gen.writeStringField('applicant_Type', (MortDeviationValMap.get('applicant_Type') != null) ? string.valueof(MortDeviationValMap.get('applicant_Type')) : '');
        gen.writeEndObject();
      }
      gen.writeEndArray();
      /* gen.writeFieldName('profitLossStatement');
        gen.writeStartObject(); 

        gen.writeEndObject();   
    gen.writeFieldName('existingLoan');
        gen.writeStartObject(); 

        gen.writeEndObject();   
    gen.writeFieldName('bank_summary');
        gen.writeStartObject(); 

        gen.writeEndObject();*/

      // Gaurav added Property details for SALLAP 18 Aug START

      gen.writeFieldName('PropertyDetails');
      gen.writeStartArray();
      if (propertyList != null) {
        for (Property_Details__c property: propertyList) {
          gen.writeStartObject();
          if (property.id != null)
            gen.writeObjectField('property_id', property.id);
          if (property.Property_Type__c != null)
            gen.writeObjectField('property_type', property.Property_Type__c);
          if (property.Construction_Area_SBU__c != null)
            gen.writeObjectField('property_area', property.Construction_Area_SBU__c);
          if (property.Final_Valuation__c != null)
            gen.writeObjectField('propertyValue', (property.Final_Valuation__c != null) ? property.Final_Valuation__c : property.Total_valuation_As_per_PE_PPIV2__c);
          if (property.Standard_LTV__c != null)
            gen.writeObjectField('standard_ltv', property.Standard_LTV__c);
          if (MortDeviationValMap.containsKey('product') &&
              string.valueOf(MortDeviationValMap.get('product')).equalsIgnoreCase('SALLAP')) {
            system.debug('in sallap');
            if (property.Area_Locality__c != null &&
                property.Area_Locality__r.Cluster__c != null) {
              system.debug('in cluster');
              gen.writeObjectField('cluster_name', property.Area_Locality__r.Cluster__c);
            }
            if (property.Total_valuation_As_per_PE_PPIV2__c != null)
              gen.writeObjectField('collateral_amount', property.Total_valuation_As_per_PE_PPIV2__c / 100000);
            gen.writeObjectField('loan_amount', (MortDeviationValMap.get('approved_Loan_Amount') != null) ? (decimal.valueof(MortDeviationValMap.get('approved_Loan_Amount'))) / 100000 : 0);
            if (property.Construction_Area_SBU__c != null)
              gen.writeObjectField('residential_area', property.Construction_Area_SBU__c);
            gen.writeObjectField('total_Net_Salary', (MortDeviationValMap.get('total_Net_Salary') != null) ? (decimal.valueof(MortDeviationValMap.get('total_Net_Salary'))) / 100000 : 0);
          }
          gen.writeEndObject();
        }

      }
      // Gaurav added Property details for SALLAP 18 Aug END
      gen.writeEndArray();
      String jsonInput = gen.getAsString();
      System.debug('Input=' + jsonInput);
      HttpRequest req = new HttpRequest();
      Mid_office_BRE_flow__c BRE_seg = Mid_office_BRE_flow__c.getValues('BRE Deviation');
      if (BRE_seg != null) {
        // username = BRE_Flow.Username__c;
        //password = BRE_Flow.Password__c;
        endpointURL = '';
        endpointURL = BRE_seg.EndpointURL__c;
      }
      req.setEndpoint(endpointURL);
      //req.setEndpoint('http://138.91.38.234:8087/executionserver/rest/1/ruleServices/Deviations/versions/0.0.1-SNAPSHOT/rules/Deviations/deviationsMain/executions');
      req.setMethod('POST');
      req.setbody(jsonInput);
      req.setTimeout(120000);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      Http http = new Http();
      if (!Test.isRunningTest()) {
        HTTPResponse res = http.send(req);
        String result = res.getBody();
        System.debug('*********result: ' + result);

        Map < String, Object > root = (Map < String, Object > ) JSON.deserializeUntyped(result);
        Map < String, Object > EligibilityObjTag = (Map < String, Object > ) root.get('deviations');
        List < Object > items = (List < Object > ) root.get('deviationsList');
        System.debug('MAP items: ' + items);
        for (Object item: items) {
          Map < String, Object > DevTag = (Map < String, Object > ) item;
          if (DevTag.containsKey('approver')) {
            approver = String.valueOf(DevTag.get('approver'));
          }
          if (DevTag.containsKey('deviation')) {
            deviationcodes.add(String.valueOf(DevTag.get('deviation')));
            strcode = String.valueOf(DevTag.get('deviation'));
          }
          MortgageDeviationResult.put(strcode, approver);
        }
        List < Object > Propitems = (List < Object > ) root.get('propertyDeviationsList');
        for (Object item: Propitems) {
          Map < String, Object > propDevTag = (Map < String, Object > ) item;
          if (propDevTag.containsKey('approver')) {
            approver = String.valueOf(propDevTag.get('approver'));
          }
          if (propDevTag.containsKey('deviation')) {
            deviationcodes.add(String.valueOf(propDevTag.get('deviation')));
            strcode = String.valueOf(propDevTag.get('deviation'));
          }
          if (!MortgageDeviationResult.containsKey(strcode))
            MortgageDeviationResult.put(strcode, approver);
        }
        System.debug('MAP rasika: ' + MortgageDeviationResult);
        for (string str: deviationcodes) {
          strDevCodes = strDevCodes + ',' + str;
        }


      }
    }
    if (deviationcodes != null) MortgageDeviationResult.put('BRECodes', strDevCodes);


    System.debug('RAsika SHL devation BRE codes map: ' + MortgageDeviationResult);
    return MortgageDeviationResult;
  }

  public Map < String, String > callMortgageEligibility(Map < String, Object > reqMap) {

    Map < String, String > mortgageEligibilityResult = new Map < String, String > ();
    decimal stampReg = 0;
    System.debug('Inside BRE');

    try {

      if (!CommonUtility.isEmpty(reqMap)) {

        Map < string, string > MortEligibilityValMap = reqMap.containsKey('generic_map') ? (Map < String, String > ) reqMap.get('generic_map') : new Map < String, String > ();
        List < Property_Details__c > PropertyList = reqMap.containsKey('prop_lst') ? (List < Property_Details__c > ) reqMap.get('prop_lst') : new List < Property_Details__c > ();
        List < Applicant__c > applicantList = reqMap.containsKey('app_lst') ? (List < Applicant__c > ) reqMap.get('app_lst') : new List < Applicant__c > ();
        List < Bank_Account__c > bankAccountList = reqMap.containsKey('bankacc_lst') ? (List < Bank_Account__c > ) reqMap.get('bankacc_lst') : new List < Bank_Account__c > ();
        List < CAM__c > MortCamList = reqMap.containsKey('cam_lst') ? (List < CAM__c > ) reqMap.get('cam_lst') : new List < CAM__c > ();
        List < PODetail__c > poDetailList = reqMap.containsKey('podetail_lst') ? (List < PODetail__c > ) reqMap.get('podetail_lst') : new List < PODetail__c > ();


        //Bank_Account__c bankAccBRE;
        List < Bank_Transaction__c > bankTransList = new List < Bank_Transaction__c > ();
        Map < Id, List < Bank_Transaction__c >> bankMap = new Map < Id, List < Bank_Transaction__c >> ();
        Map < Id, CAM__c > applicantCAMMap = new Map < Id, CAM__c > ();
        Map < Id, Id > applicantPropertyMap = new Map < Id, Id > ();


        for (Property_Details__c property: PropertyList) {
          for (Applicant__c app: applicantList) {
            if (property.Current_Property_Owner__c != null && app.Customer_Name__c != null && property.Current_Property_Owner__c.contains(app.Customer_Name__c)) {
              applicantPropertyMap.put(app.Id, property.Id);
              break;
            }
          }
        }

        if (MortEligibilityValMap.containsKey('product') && (MortEligibilityValMap.get('product') == 'SHL' || MortEligibilityValMap.get('product') == 'HFC SHL' || MortEligibilityValMap.get('product') == 'SHOL' || MortEligibilityValMap.get('product') == 'HSL' || MortEligibilityValMap.get('product') == 'SALLAP' || MortEligibilityValMap.get('product') == 'HPLS' || MortEligibilityValMap.get('product') == 'SBS CS SHL')) {
          for (Applicant__c app: applicantList) {
            for (CAM__c cam: MortCamList) {
              if (cam.Applicant__c == app.Id) {
                applicantCAMMap.put(app.Id, cam);
              } else if (cam.Applicant__c == null && app.Applicant_Type__c == 'Primary') {
                applicantCAMMap.put(app.Id, cam);
              }
            }
          }
        }

        if (MortEligibilityValMap.containsKey('Id'))
          bankTransList = SelectQueriesHelperClass.bankTranList(MortEligibilityValMap.get('Id'));



        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();

        gen.writeFieldName('Loan_Parameter');
        gen.writeStartObject();
        if (MortEligibilityValMap.containsKey('industry'))
          gen.writeObjectField('industry', MortEligibilityValMap.get('industry'));
        if (MortEligibilityValMap.containsKey('practiceType'))
          gen.writeObjectField('practiceType', MortEligibilityValMap.get('practiceType'));
        if (MortEligibilityValMap.containsKey('processType'))
          gen.writeObjectField('processType', MortEligibilityValMap.get('processType'));
        if (MortEligibilityValMap.containsKey('loan_application_stage'))
          gen.writeObjectField('loan_application_stage', MortEligibilityValMap.get('loan_application_stage'));
        if (MortEligibilityValMap.containsKey('approved_rate'))
          gen.writeObjectField('approved_rate', double.valueOf(MortEligibilityValMap.get('approved_rate')));
        if (MortEligibilityValMap.containsKey('loan_id'))
          gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));
        if (MortEligibilityValMap.containsKey('decision_date'))
          gen.writeObjectField('decision_date', MortEligibilityValMap.get('decision_date'));
        if (MortEligibilityValMap.containsKey('approved_loan_amount'))
          gen.writeObjectField('approved_loan_amount', double.valueOf(MortEligibilityValMap.get('approved_loan_amount')));
        System.debug('done till 1..');
        if (MortEligibilityValMap.containsKey('requested_loan_amount'))
          gen.writeObjectField('requested_loan_amount', double.valueOf(MortEligibilityValMap.get('requested_loan_amount')));
        if (MortEligibilityValMap.containsKey('requested_tenor'))
          gen.writeObjectField('requested_tenor', double.valueOf(MortEligibilityValMap.get('requested_tenor')));
        if (MortEligibilityValMap.containsKey('reqested_roi'))
          gen.writeObjectField('reqested_roi', double.valueOf(MortEligibilityValMap.get('reqested_roi')));
        if (MortEligibilityValMap.containsKey('loan_application_number'))
          gen.writeObjectField('loan_application_number', decimal.valueOf(MortEligibilityValMap.get('loan_application_number')));
        if (MortEligibilityValMap.containsKey('product'))
          gen.writeObjectField('product', MortEligibilityValMap.get('product'));
        if (MortEligibilityValMap.containsKey('scheme_name'))
          gen.writeObjectField('scheme_name', MortEligibilityValMap.get('scheme_name'));
        if (MortEligibilityValMap.containsKey('type_of_loan'))
          gen.writeObjectField('type_of_loan', MortEligibilityValMap.get('type_of_loan'));
        if (MortEligibilityValMap.containsKey('stage'))
          gen.writeObjectField('stage', MortEligibilityValMap.get('stage'));
        if (MortEligibilityValMap.containsKey('sourcing_channel_type'))
          gen.writeObjectField('sourcing_channel_type', MortEligibilityValMap.get('sourcing_channel_type'));
        if (MortEligibilityValMap.containsKey('sub_stage'))
          gen.writeObjectField('sub_stage', MortEligibilityValMap.get('sub_stage'));
        if (MortEligibilityValMap.containsKey('offer_amount'))
          gen.writeObjectField('offer_amount', decimal.valueOf(MortEligibilityValMap.get('offer_amount')));
        if (MortEligibilityValMap.containsKey('program_type'))
          gen.writeObjectField('program_type', MortEligibilityValMap.get('program_type'));
        if (MortEligibilityValMap.containsKey('loanEMI'))
          gen.writeObjectField('loanEMI', decimal.valueOf(MortEligibilityValMap.get('loanEMI')));
        if (MortEligibilityValMap.containsKey('UWProgram'))
          gen.writeObjectField('UWProgram', MortEligibilityValMap.get('UWProgram'));
        if (MortEligibilityValMap.containsKey('offerFlag'))
          gen.writeObjectField('offerFlag', MortEligibilityValMap.get('offerFlag'));
        if (MortEligibilityValMap.containsKey('offerType'))
          gen.writeObjectField('offerType', MortEligibilityValMap.get('offerType'));
        if (MortEligibilityValMap.containsKey('btAmount'))
          gen.writeObjectField('btAmount', Decimal.valueOf(MortEligibilityValMap.get('btAmount')));

        if (MortEligibilityValMap.containsKey('loanAmountHL'))
          gen.writeObjectField('loanAmountHL', decimal.valueOf(MortEligibilityValMap.get('loanAmountHL')));
        else
          gen.writeObjectField('loanAmountHL', 0.0);
        if (MortEligibilityValMap.containsKey('loanAmountTopUp'))
          gen.writeObjectField('loanAmountTopUp', decimal.valueOf(MortEligibilityValMap.get('loanAmountTopUp')));
        else
          gen.writeObjectField('loanAmountTopUp', 0.0);
        if (MortEligibilityValMap.containsKey('roiHL'))
          gen.writeObjectField('roiHL', decimal.valueOf(MortEligibilityValMap.get('roiHL')));
        else
          gen.writeObjectField('roiHL', 0.0);
        if (MortEligibilityValMap.containsKey('tenorHL'))
          gen.writeObjectField('tenorHL', decimal.valueOf(MortEligibilityValMap.get('tenorHL')));
        else
          gen.writeObjectField('tenorHL', 0.0);
        if (MortEligibilityValMap.containsKey('roiTopUp'))
          gen.writeObjectField('roiTopUp', decimal.valueOf(MortEligibilityValMap.get('roiTopUp')));
        else
          gen.writeObjectField('roiTopUp', 0.0);
        if (MortEligibilityValMap.containsKey('tenorTopUp'))
          gen.writeObjectField('tenorTopUp', decimal.valueOf(MortEligibilityValMap.get('tenorTopUp')));
        else
          gen.writeObjectField('tenorTopUp', 0.0);
        if (MortEligibilityValMap.containsKey('topUp_cashOut'))
          gen.writeObjectField('topUp_cashOut', decimal.valueOf(MortEligibilityValMap.get('topUp_cashOut')));
        else
          gen.writeObjectField('topUp_cashOut', 0.0);
        if (MortEligibilityValMap.containsKey('topUp_cashOut_roi'))
          gen.writeObjectField('topUp_cashOut_roi', decimal.valueOf(MortEligibilityValMap.get('topUp_cashOut_roi')));
        else
          gen.writeObjectField('topUp_cashOut_roi', 0.0);
        if (MortEligibilityValMap.containsKey('topUp_cashOut_tenor'))
          gen.writeObjectField('topUp_cashOut_tenor', decimal.valueOf(MortEligibilityValMap.get('topUp_cashOut_tenor')));
        else
          gen.writeObjectField('topUp_cashOut_tenor', 0.0);


        if (MortEligibilityValMap.containsKey('fullUnderwritingFlag'))
          gen.writeObjectField('fullUnderwritingFlag', MortEligibilityValMap.get('fullUnderwritingFlag'));

        if (MortEligibilityValMap.containsKey('eligibilityType'))
          gen.writeObjectField('eligibilityType', MortEligibilityValMap.get('eligibilityType'));

        //SHL Requirement
        if (MortEligibilityValMap.containsKey('pls_roi'))
          gen.writeObjectField('pls_roi', decimal.valueOf(MortEligibilityValMap.get('pls_roi')));
        if (MortEligibilityValMap.containsKey('pls_tenor'))
          gen.writeObjectField('pls_tenor', decimal.valueOf(MortEligibilityValMap.get('pls_tenor')));

        if (MortEligibilityValMap.containsKey('product_case_type'))
          gen.writeObjectField('product_case_type', MortEligibilityValMap.get('product_case_type'));

        //SHL Issue point 19 - 10902
        if (MortEligibilityValMap.containsKey('incomeToBeConsidered')) {
          if (MortEligibilityValMap.get('incomeToBeConsidered') == 'true')
            gen.writeObjectField('incomeToBeConsidered', 'TRUE');
          if (MortEligibilityValMap.get('incomeToBeConsidered') == 'false')
            gen.writeObjectField('incomeToBeConsidered', 'FALSE');
        }

        gen.writeEndObject();
        System.debug('##1##');

        gen.writeFieldName('Generic');
        gen.writeStartObject();
        if (MortEligibilityValMap.containsKey('loan_id'))
          gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));
        if (MortEligibilityValMap.containsKey('branch_type'))
          gen.writeObjectField('branch_type', MortEligibilityValMap.get('branch_type'));
        if (MortEligibilityValMap.containsKey('branch_name'))
          gen.writeObjectField('branch_name', MortEligibilityValMap.get('branch_name'));

        gen.writeEndObject();
        System.debug('#2#');

        for (Bank_Transaction__c bankTrans: bankTransList) {
          if (bankTrans.Balance_10th_of_month__c != null && bankTrans.Balance_20th_of_month__c != null && bankTrans.Balance_Ist_of_Month__c != null) {
            if (bankMap.containsKey(bankTrans.Bank_Account__r.Id)) {
              bankMap.get(bankTrans.Bank_Account__r.Id).add(bankTrans);
            } else {
              bankMap.put(bankTrans.Bank_Account__r.Id, new List < Bank_Transaction__c > {
                bankTrans
              });
            }
          }
        }

        gen.writeFieldName('Bank_summary');
        gen.writeStartArray();
        for (Id bankId: bankMap.keySet()) {
          Id bankAccBRE;
          double total_10th_balance = 0;
          double total_20th_balance = 0;
          double total_month_end_balance = 0;
          double total_ODCC_balance = 0;
          double totalBounceInward = 0;
          double totalCreditAmt = 0;
          double totalDebitAmt = 0;


          gen.writeStartObject();
          if (MortEligibilityValMap.containsKey('loan_id'))
            gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));

          if (bankMap.size() > 0 && bankMap.containsKey(bankId) && bankMap.get(bankId)[0].Applicant__c != null && bankMap.get(bankId)[0].Applicant__r.Applicant_Type__c != null)
            gen.writeObjectField('applicant_type', bankMap.get(bankId)[0].Applicant__r.Applicant_Type__c);

          if (MortEligibilityValMap.containsKey('bankMOB') && !CommonUtility.isEmpty(MortEligibilityValMap.get('bankMOB')))
            gen.writeObjectField('bankMOB', Decimal.valueOf(MortEligibilityValMap.get('bankMOB')));
          /*if(bankMap.get(bankId)[0].Bank_Account__r.Average_ODCC_Utilization__c != null)
    gen.writeObjectField('avg_od_cc_utilisation',double.valueOf(bankMap.get(bankId)[0].Bank_Account__r.Average_ODCC_Utilization__c));
           */
          if (MortEligibilityValMap.containsKey('avg_od_cc_utilisation'))
            gen.writeObjectField('avg_od_cc_utilisation', double.valueOf(MortEligibilityValMap.get('avg_od_cc_utilisation')));

          if (bankMap.size() > 0 && bankMap.containsKey(bankId) && bankMap.get(bankId).size() > 0) {
            for (Bank_Transaction__c bankObj: bankMap.get(bankId)) {


              total_10th_balance = total_10th_balance + bankObj.Balance_10th_of_month__c;
              total_20th_balance = total_20th_balance + bankObj.Balance_20th_of_month__c;
              total_month_end_balance = total_month_end_balance + bankObj.Balance_Ist_of_Month__c;

              if (bankObj.Bounce_IW__c != null) {
                totalBounceInward = totalBounceInward + bankObj.Bounce_IW__c;
              }

              if (bankObj.CRD_Amount__c != null) {
                totalCreditAmt = totalCreditAmt + bankObj.CRD_Amount__c;
              }

              if (bankObj.DB_Amount__c != null) {
                totalDebitAmt = totalDebitAmt + bankObj.DB_Amount__c;
              }
            }

            gen.writeObjectField('_10th_balance', (total_10th_balance != 0) ? total_10th_balance + '' : '0.0');
            gen.writeObjectField('_20th_balance', (total_20th_balance != 0) ? total_20th_balance + '' : '0.0');
            gen.writeObjectField('last_day_balance', (total_month_end_balance != 0) ? total_month_end_balance + '' : '0.0');

            gen.writeObjectField('total_bounce_inward', (totalBounceInward != 0) ? totalBounceInward : 0.0);
            gen.writeObjectField('total_credit_amount', (totalCreditAmt != 0) ? totalCreditAmt : 0.0);
            gen.writeObjectField('total_debit_amount', (totalDebitAmt != 0) ? totalDebitAmt : 0.0);


          }

          if (bankMap.size() > 0 && bankMap.containsKey(bankId) && bankMap.get(bankId)[0].Bank_Account__r.Account_Type__c == 'OD' || bankMap.get(bankId)[0].Bank_Account__r.Account_Type__c == 'CC') {
            bankAccBRE = bankMap.get(bankId)[0].Bank_Account__r.Id;
          }
          if (bankAccBRE != null)
            gen.writeObjectField('odccFlag', 'Y');
          else
            gen.writeObjectField('odccFlag', 'N');


          if (bankMap.size() > 0 && bankMap.containsKey(bankId) && bankMap.get(bankId)[0].Bank_Account__r.Bank_Name__c != null)
            gen.writeObjectField('bankName', bankMap.get(bankId)[0].Bank_Account__r.Bank_Name__c);


          gen.writeEndObject();
        }

        gen.writeEndArray();
        System.debug('##3##');

        gen.writeFieldName('existing_loan');
        gen.writeStartArray();
        for (integer i = 0; i < 1; i++) {
          gen.writeStartObject();

          if (MortEligibilityValMap.containsKey('securedLoanAmount'))
            gen.writeObjectField('securedLoanAmount', double.valueOf(MortEligibilityValMap.get('securedLoanAmount')));
          if (MortEligibilityValMap.containsKey('unsecuredLoanAmount'))
            gen.writeObjectField('unsecuredLoanAmount', double.valueOf(MortEligibilityValMap.get('unsecuredLoanAmount')));
          if (MortEligibilityValMap.containsKey('mortgageLoanAmount'))
            gen.writeObjectField('mortgageLoanAmount', double.valueOf(MortEligibilityValMap.get('mortgageLoanAmount')));

          if (MortEligibilityValMap.containsKey('loan_id'))
            gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));

          if (MortEligibilityValMap.containsKey('applicant_type'))
            gen.writeObjectField('applicant_type', MortEligibilityValMap.get('applicant_type'));
          if (MortEligibilityValMap.containsKey('monthly_loan_obligations'))
            gen.writeObjectField('monthly_loan_obligations', double.valueOf(MortEligibilityValMap.get('monthly_loan_obligations')));
          if (MortEligibilityValMap.containsKey('number_of_hl_loans'))
            gen.writeObjectField('number_of_hl_loans', double.valueOf(MortEligibilityValMap.get('number_of_hl_loans')));
          if (MortEligibilityValMap.containsKey('annual_obligations'))
            gen.writeObjectField('annual_obligations', double.valueOf(MortEligibilityValMap.get('annual_obligations')));
          if (MortEligibilityValMap.containsKey('bajaj_loan_obligations'))
            gen.writeObjectField('bajaj_loan_obligations', double.valueOf(MortEligibilityValMap.get('bajaj_loan_obligations')));
          if (MortEligibilityValMap.containsKey('securedMOB'))
            gen.writeObjectField('securedMOB', double.valueOf(MortEligibilityValMap.get('securedMOB')));


          gen.writeEndObject();
        }
        gen.writeEndArray();
        System.debug('##4##');

        //SHL SHOL Requirement
        if (MortEligibilityValMap.containsKey('product') && (MortEligibilityValMap.get('product') != 'SHL' && MortEligibilityValMap.get('product') != 'HFC SHL' && MortEligibilityValMap.get('product') != 'SHOL' && MortEligibilityValMap.get('product') != 'HSL' && MortEligibilityValMap.get('product') != 'SALLAP' && MortEligibilityValMap.get('product') != 'HPLS' && MortEligibilityValMap.get('product') != 'SBS CS SHL')) {
          gen.writeFieldName('profit_loss_statement');
          gen.writeStartArray();
          for (integer i = 0; i < 1; i++) {
            gen.writeStartObject();

            if (MortEligibilityValMap.containsKey('py_sales_turnover'))
              gen.writeObjectField('py_sales_turnover', double.valueOf(MortEligibilityValMap.get('py_sales_turnover')));
            if (MortEligibilityValMap.containsKey('cy_sales_turnover'))
              gen.writeObjectField('cy_sales_turnover', double.valueOf(MortEligibilityValMap.get('cy_sales_turnover')));
            if (MortEligibilityValMap.containsKey('py_profit_before_tax'))
              gen.writeObjectField('py_profit_before_tax', double.valueOf(MortEligibilityValMap.get('py_profit_before_tax')));
            if (MortEligibilityValMap.containsKey('cy_profit_before_tax'))
              gen.writeObjectField('cy_profit_before_tax', double.valueOf(MortEligibilityValMap.get('cy_profit_before_tax')));
            if (MortEligibilityValMap.containsKey('py_depriciation'))
              gen.writeObjectField('py_depriciation', double.valueOf(MortEligibilityValMap.get('py_depriciation')));
            if (MortEligibilityValMap.containsKey('cy_depriciation'))
              gen.writeObjectField('cy_depriciation', double.valueOf(MortEligibilityValMap.get('cy_depriciation')));


            if (MortEligibilityValMap.containsKey('py_ebitda'))
              gen.writeObjectField('py_ebitda', double.valueOf(MortEligibilityValMap.get('py_ebitda')));
            if (MortEligibilityValMap.containsKey('cy_ebitda'))
              gen.writeObjectField('cy_ebitda', double.valueOf(MortEligibilityValMap.get('cy_ebitda')));


            if (MortEligibilityValMap.containsKey('cy_total_networth'))
              gen.writeObjectField('cy_total_networth', double.valueOf(MortEligibilityValMap.get('cy_total_networth')));
            if (MortEligibilityValMap.containsKey('cy_debtors'))
              gen.writeObjectField('cy_debtors', double.valueOf(MortEligibilityValMap.get('cy_debtors')));
            if (MortEligibilityValMap.containsKey('cy_creditors'))
              gen.writeObjectField('cy_creditors', double.valueOf(MortEligibilityValMap.get('cy_creditors')));
            if (MortEligibilityValMap.containsKey('cy_net_profit'))
              gen.writeObjectField('cy_net_profit', double.valueOf(MortEligibilityValMap.get('cy_net_profit')));
            if (MortEligibilityValMap.containsKey('py_net_profit'))
              gen.writeObjectField('py_net_profit', double.valueOf(MortEligibilityValMap.get('py_net_profit')));
            if (MortEligibilityValMap.containsKey('gross_receipts'))
              gen.writeObjectField('gross_receipts', double.valueOf(MortEligibilityValMap.get('gross_receipts')));
            if (MortEligibilityValMap.containsKey('cy_Total_ouside_borrowings'))
              gen.writeObjectField('cy_Total_ouside_borrowings', double.valueOf(MortEligibilityValMap.get('cy_Total_ouside_borrowings')));
            if (MortEligibilityValMap.containsKey('cy_inventory'))
              gen.writeObjectField('cy_inventory', double.valueOf(MortEligibilityValMap.get('cy_inventory')));
            if (MortEligibilityValMap.containsKey('loan_id'))
              gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));
            if (MortEligibilityValMap.containsKey('cy_balance_sheet'))
              gen.writeObjectField('cy_balance_sheet', double.valueOf(MortEligibilityValMap.get('cy_balance_sheet')));
            if (MortEligibilityValMap.containsKey('cy_closing_stock'))
              gen.writeObjectField('cy_closing_stock', double.valueOf(MortEligibilityValMap.get('cy_closing_stock')));
            if (MortEligibilityValMap.containsKey('cy_bank_cash_balance'))
              gen.writeObjectField('cy_bank_cash_balance', double.valueOf(MortEligibilityValMap.get('cy_bank_cash_balance')));
            if (MortEligibilityValMap.containsKey('cy_capital'))
              gen.writeObjectField('cy_capital', double.valueOf(MortEligibilityValMap.get('cy_capital')));
            if (MortEligibilityValMap.containsKey('cy_reserve_surplus'))
              gen.writeObjectField('cy_reserve_surplus', double.valueOf(MortEligibilityValMap.get('cy_reserve_surplus')));
            if (MortEligibilityValMap.containsKey('cy_other_non_business_income'))
              gen.writeObjectField('cy_other_non_business_income', double.valueOf(MortEligibilityValMap.get('cy_other_non_business_income')));
            if (MortEligibilityValMap.containsKey('py_other_non_business_income'))
              gen.writeObjectField('py_other_non_business_income', double.valueOf(MortEligibilityValMap.get('py_other_non_business_income')));
            if (MortEligibilityValMap.containsKey('cy_interest_as_per_PandL'))
              gen.writeObjectField('cy_interest_as_per_PandL', double.valueOf(MortEligibilityValMap.get('cy_interest_as_per_PandL')));
            if (MortEligibilityValMap.containsKey('py_interest_as_per_PandL'))
              gen.writeObjectField('py_interest_as_per_PandL', double.valueOf(MortEligibilityValMap.get('py_interest_as_per_PandL')));
            if (MortEligibilityValMap.containsKey('cy_gross_profit'))
              gen.writeObjectField('cy_gross_profit', double.valueOf(MortEligibilityValMap.get('cy_gross_profit')));
            if (MortEligibilityValMap.containsKey('py_gross_profit'))
              gen.writeObjectField('py_gross_profit', double.valueOf(MortEligibilityValMap.get('py_gross_profit')));
            if (MortEligibilityValMap.containsKey('applicant_type'))
              gen.writeObjectField('applicant_type', MortEligibilityValMap.get('applicant_type'));

            gen.writeEndObject();
          }
          gen.writeEndArray();

          System.debug('##5##');
        }

        gen.writeFieldName('Demographic');
        gen.writeStartArray();
        for (integer i = 0; i < 1; i++) {
          gen.writeStartObject();
          if (MortEligibilityValMap.containsKey('type_of_constitution'))
            gen.writeObjectField('type_of_constitution', MortEligibilityValMap.get('type_of_constitution'));
          if (MortEligibilityValMap.containsKey('professionType'))
            gen.writeObjectField('professionType', MortEligibilityValMap.get('professionType'));
          if (MortEligibilityValMap.containsKey('constitutionType'))
            gen.writeObjectField('constitutionType', MortEligibilityValMap.get('constitutionType'));
          if (MortEligibilityValMap.containsKey('educational_qualification'))
            gen.writeObjectField('educational_qualification', MortEligibilityValMap.get('educational_qualification'));
          if (MortEligibilityValMap.containsKey('total_employment_vintage'))
            gen.writeObjectField('total_employment_vintage', decimal.valueOf(MortEligibilityValMap.get('total_employment_vintage')));
          if (MortEligibilityValMap.containsKey('date_of_birth'))
            gen.writeObjectField('date_of_birth', MortEligibilityValMap.get('date_of_birth'));
          if (MortEligibilityValMap.containsKey('date_of_incorporation'))
            gen.writeObjectField('date_of_incorporation', MortEligibilityValMap.get('date_of_incorporation'));
          if (MortEligibilityValMap.containsKey('age'))
            gen.writeObjectField('age', decimal.valueOf(MortEligibilityValMap.get('age')));
          if (MortEligibilityValMap.containsKey('constitution'))
            gen.writeObjectField('constitution', MortEligibilityValMap.get('constitution'));
          if (MortEligibilityValMap.containsKey('customer_segment'))
            gen.writeObjectField('customer_segment', MortEligibilityValMap.get('customer_segment'));
          if (MortEligibilityValMap.containsKey('clinic_hospital_type'))
            gen.writeObjectField('clinic_hospital_type', MortEligibilityValMap.get('clinic_hospital_type'));
          if (MortEligibilityValMap.containsKey('loan_id'))
            gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));
          if (MortEligibilityValMap.containsKey('years_in_business_job'))
            gen.writeObjectField('years_in_business_job', decimal.valueOf(MortEligibilityValMap.get('years_in_business_job')));
          else
            gen.writeObjectField('years_in_business_job', 0);
          if (MortEligibilityValMap.containsKey('first_name'))
            gen.writeObjectField('first_name', MortEligibilityValMap.get('first_name'));
          if (MortEligibilityValMap.containsKey('last_name'))
            gen.writeObjectField('last_name', MortEligibilityValMap.get('last_name'));
          if (MortEligibilityValMap.containsKey('residence_type'))
            gen.writeObjectField('residence_type', MortEligibilityValMap.get('residence_type'));
          if (MortEligibilityValMap.containsKey('marital_status'))
            gen.writeObjectField('marital_status', MortEligibilityValMap.get('marital_status'));

          if (MortEligibilityValMap.containsKey('applicant_type'))
            gen.writeObjectField('applicant_type', MortEligibilityValMap.get('applicant_type'));
          if (MortEligibilityValMap.containsKey('company_category'))
            gen.writeObjectField('company_category', MortEligibilityValMap.get('company_category'));
          if (MortEligibilityValMap.containsKey('company_type'))
            gen.writeObjectField('company_type', MortEligibilityValMap.get('company_type'));
          if (MortEligibilityValMap.containsKey('professional_qualification'))
            gen.writeObjectField('professional_qualification', MortEligibilityValMap.get('professional_qualification'));

          if (MortEligibilityValMap.containsKey('type_of_degree'))
            gen.writeObjectField('type_of_degree', MortEligibilityValMap.get('type_of_degree'));
          if (MortEligibilityValMap.containsKey('office_email_id'))
            gen.writeObjectField('office_email_id', MortEligibilityValMap.get('office_email_id'));

          if (MortEligibilityValMap.containsKey('name_of_employer'))
            gen.writeObjectField('name_of_employer', MortEligibilityValMap.get('name_of_employer'));
          if (MortEligibilityValMap.containsKey('gender'))
            gen.writeObjectField('gender', MortEligibilityValMap.get('gender'));

          if (MortEligibilityValMap.containsKey('pan'))
            gen.writeObjectField('pan', MortEligibilityValMap.get('pan'));
          if (MortEligibilityValMap.containsKey('residence_city'))
            gen.writeObjectField('residence_city', MortEligibilityValMap.get('residence_city'));
          if (MortEligibilityValMap.containsKey('office_city'))
            gen.writeObjectField('office_city', MortEligibilityValMap.get('office_city'));
          if (MortEligibilityValMap.containsKey('residence_pin_code'))
            gen.writeObjectField('residence_pin_code', decimal.valueOf(MortEligibilityValMap.get('residence_pin_code')));
          if (MortEligibilityValMap.containsKey('office_pin_code'))
            gen.writeObjectField('office_pin_code', decimal.valueOf(MortEligibilityValMap.get('office_pin_code')));

          if (MortEligibilityValMap.containsKey('nature_of_business'))
            gen.writeObjectField('nature_of_business', MortEligibilityValMap.get('nature_of_business'));
          if (MortEligibilityValMap.containsKey('industry'))
            gen.writeObjectField('industry', MortEligibilityValMap.get('industry'));
          if (MortEligibilityValMap.containsKey('sub_industry'))
            gen.writeObjectField('sub_industry', MortEligibilityValMap.get('sub_industry'));
          if (MortEligibilityValMap.containsKey('e_mail_id'))
            gen.writeObjectField('e_mail_id', MortEligibilityValMap.get('e_mail_id'));
          if (MortEligibilityValMap.containsKey('customer_type'))
            gen.writeObjectField('customer_type', MortEligibilityValMap.get('customer_type'));
          if (MortEligibilityValMap.containsKey('specialisation'))
            gen.writeObjectField('specialisation', MortEligibilityValMap.get('specialisation'));
          if (MortEligibilityValMap.containsKey('practiceType'))
            gen.writeObjectField('practiceType', MortEligibilityValMap.get('practiceType'));
          if (MortEligibilityValMap.containsKey('profession'))
            gen.writeObjectField('profession', MortEligibilityValMap.get('profession'));
          if (MortEligibilityValMap.containsKey('expPostGradSuperSpecialist'))
            gen.writeObjectField('expPostGradSuperSpecialist', decimal.valueOf(MortEligibilityValMap.get('expPostGradSuperSpecialist')));
          else
            gen.writeObjectField('expPostGradSuperSpecialist', 0);

          if (MortEligibilityValMap.containsKey('case_type'))
            gen.writeObjectField('case_type', MortEligibilityValMap.get('case_type'));
          else
            gen.writeObjectField('case_type', '');

          gen.writeEndObject();
        }
        gen.writeEndArray();

        System.debug('##6##');

        gen.writeFieldName('applicantList');
        gen.writeStartArray();
        for (Applicant__c app: applicantList) {
          gen.writeStartObject();
          if (app.Applicant_Type__c != null)
            gen.writeObjectField('coApplicantType', app.Applicant_Type__c);
          if (app.Contact_Name__c != null && app.Contact_Name__r.Name != null)
            gen.writeObjectField('name', app.Contact_Name__r.Name);
          if (app.Contact_Name__c != null && app.Contact_Name__r.Date_of_Birth__c != null)
            gen.writeObjectField('dob', String.valueOf(app.Contact_Name__r.Date_of_Birth__c));
          if (app.Company_Name__c != null)
            gen.writeObjectField('companyName', app.Company_Name__c);

          if (MortEligibilityValMap.containsKey('product') && (MortEligibilityValMap.get('product') == 'SHL' || MortEligibilityValMap.get('product') == 'HFC SHL' || MortEligibilityValMap.get('product') == 'SHOL' || MortEligibilityValMap.get('product') == 'HSL' || MortEligibilityValMap.get('product') == 'SALLAP' || MortEligibilityValMap.get('product') == 'HPLS' || MortEligibilityValMap.get('product') == 'SBS CS SHL')) {
            if (applicantCAMMap.containsKey(app.Id) && applicantCAMMap.get(app.Id) != null) {
              decimal avgMonSalary = 0;
              if (app.Applicant_Type__c == 'Primary') {
                if (app.Applicant_Type__c == 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c != null) {
                  avgMonSalary = (applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c) / 3;
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', avgMonSalary);
                } else if (app.Applicant_Type__c == 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c != null) {
                  avgMonSalary = (applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c) / 2;
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', avgMonSalary);
                } else if (app.Applicant_Type__c == 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c != null) {
                  avgMonSalary = (applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c) / 2;
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', avgMonSalary);
                } else if (app.Applicant_Type__c == 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null) {
                  avgMonSalary = (applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c) / 2;
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', avgMonSalary);
                } else if (app.Applicant_Type__c == 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null) {
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c);
                } else if (app.Applicant_Type__c == 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c != null) {
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c);
                } else if (app.Applicant_Type__c == 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c != null) {
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c);
                } else {
                  gen.writeObjectField('monthly_net_salary', 0);
                }

              }

              //co-applicant
              system.debug('applicantCAMMap.get(app.Id)' + applicantCAMMap.get(app.Id));
              if (app.Applicant_Type__c != 'Primary' && applicantCAMMap.get(app.Id) != null) {
                system.debug('inside if gopika');
                if (app.Applicant_Type__c != 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c != null) {
                  avgMonSalary = (applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c) / 3;
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', avgMonSalary);
                } else if (app.Applicant_Type__c != 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c != null) {
                  avgMonSalary = (applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c) / 2;
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', avgMonSalary);
                } else if (app.Applicant_Type__c != 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c != null) {
                  avgMonSalary = (applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c) / 2;
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', avgMonSalary);
                } else if (app.Applicant_Type__c != 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c != null && applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null) {
                  avgMonSalary = (applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c + applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c) / 2;
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', avgMonSalary);
                } else if (app.Applicant_Type__c != 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null) {
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c);
                } else if (app.Applicant_Type__c != 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c != null) {
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', applicantCAMMap.get(app.Id).Average_incentive_for_Q2__c);
                } else if (app.Applicant_Type__c != 'Primary' && applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c != null) {
                  System.debug('avgMonSalary=' + avgMonSalary);
                  gen.writeObjectField('monthly_net_salary', applicantCAMMap.get(app.Id).Average_incentive_for_Q3__c);
                } else {
                  gen.writeObjectField('monthly_net_salary', 0);
                }
              }
              //}//if ends

              //if (applicantCAMMap.get(app.Id).Average_incentive_for_Q1__c != null)

              /*els
        gen.writeObjectField('monthly_net_salary', 0);*/
              if (applicantCAMMap.get(app.Id).Rental_Income__c != null)
                gen.writeObjectField('monthly_rental_income', applicantCAMMap.get(app.Id).Rental_Income__c);
              else
                gen.writeObjectField('monthly_rental_income', 0);
              if (applicantCAMMap.get(app.Id).Avg_mthly_incntve_3mts__c != null)
                gen.writeObjectField('incentiveAmt', applicantCAMMap.get(app.Id).Avg_mthly_incntve_3mts__c);
              else
                gen.writeObjectField('incentiveAmt', 0);
              if (applicantCAMMap.get(app.Id).Incentive_Monthly_or_Quarterly__c != null)
                gen.writeObjectField('incentiveFrequency', applicantCAMMap.get(app.Id).Incentive_Monthly_or_Quarterly__c);
              else
                gen.writeObjectField('incentiveFrequency', '');
              if (applicantCAMMap.get(app.Id).Monthly_Reimbursement__c != null)
                gen.writeObjectField('reImbursement', applicantCAMMap.get(app.Id).Monthly_Reimbursement__c);
              else
                gen.writeObjectField('reImbursement', 0);
              if (applicantCAMMap.get(app.Id).GP_Other_income__c != null)
                gen.writeObjectField('other_monthly_income', applicantCAMMap.get(app.Id).GP_Other_income__c);
              else
                gen.writeObjectField('other_monthly_income', 0);

              if (app.Applicant_Type__c == 'Primary') {
                if (applicantCAMMap.get(app.Id).Average_Bank_Balance_GDP__c != null)
                  gen.writeObjectField('monthlyObligations', applicantCAMMap.get(app.Id).Average_Bank_Balance_GDP__c);
                else
                  gen.writeObjectField('monthlyObligations', 0);
              } else {
                if (applicantCAMMap.get(app.Id).Existing_Live_Obligations__c != null)
                  gen.writeObjectField('monthlyObligations', applicantCAMMap.get(app.Id).Existing_Live_Obligations__c);
                else
                  gen.writeObjectField('monthlyObligations', 0);
              }

            }
          }

          if (app.Applicant_Type__c != null) {
            if (app.Applicant_Type__c == 'Primary')
              gen.writeObjectField('applicant_type', 'Primary');
            else
              gen.writeObjectField('applicant_type', 'Co-Applicant');
          }

          /*if (applicantPropertyMap.containsKey(app.Id))
    gen.writeObjectField('propertyOwner', 'Y');
    else
    gen.writeObjectField('propertyOwner', 'N');*/

          if (app.Contact_Name__c != null && app.Contact_Name__r.Property_Owner__c != null)
            gen.writeObjectField('propertyOwner', app.Contact_Name__r.Property_Owner__c);
          else
            gen.writeObjectField('propertyOwner', '');

          //SHL Requirement
          if (MortEligibilityValMap.containsKey('product') && (MortEligibilityValMap.get('product') == 'SHL' || MortEligibilityValMap.get('product') == 'HFC SHL' || MortEligibilityValMap.get('product') == 'SHOL' || MortEligibilityValMap.get('product') == 'HSL' || MortEligibilityValMap.get('product') == 'SALLAP' || MortEligibilityValMap.get('product') == 'HPLS' || MortEligibilityValMap.get('product') == 'SBS CS SHL')) {
            if (app.Contact_Name__c != null && app.Contact_Name__r.Occupatipn__c != null) {
              gen.writeObjectField('customer_type', app.Contact_Name__r.Occupatipn__c);
              System.debug('%%%app.Contact_Name__r.Occupatipn__c' + app.Contact_Name__r.Occupatipn__c);
            } else {
              gen.writeObjectField('customer_type', '');
            }

            if (app.Contact_Name__c != null && app.Contact_Name__r.Employer__c != null && app.Contact_Name__r.Employer__r.Company_Category__c != null) {
              gen.writeObjectField('company_category', app.Contact_Name__r.Employer__r.Company_Category__c);
              System.debug('%%%app.Contact_Name__r.Employer__r.Company_Category__c' + app.Contact_Name__r.Employer__r.Company_Category__c);
            } else {
              gen.writeObjectField('company_category', '');
            }
          }

          gen.writeEndObject();
        }
        gen.writeEndArray();
        System.debug('##7##');

        //SHL SHOL Requirement
        if (MortEligibilityValMap.containsKey('product') && (MortEligibilityValMap.get('product') != 'SHL' && MortEligibilityValMap.get('product') != 'HFC SHL' && MortEligibilityValMap.get('product') != 'SHOL' && MortEligibilityValMap.get('product') != 'HSL' && MortEligibilityValMap.get('product') != 'SALLAP' && MortEligibilityValMap.get('product') != 'HPLS' && MortEligibilityValMap.get('product') != 'SBS CS SHL')) {
          gen.writeFieldName('BTDetails');
          gen.writeStartArray();
          if (poDetailList != null) {
            for (PODetail__c poDetail: poDetailList) {
              gen.writeStartObject();
              /*if(poDetail.Financier__c != null)
        gen.writeObjectField('bankName',poDetail.Financier__c);
    else
        gen.writeObjectField('bankName','');*/
              if (poDetail.Normal_Offer_Amount__c != null)
                gen.writeObjectField('sanctionedAmt', poDetail.Normal_Offer_Amount__c);
              else
                gen.writeObjectField('sanctionedAmt', 0);
              if (poDetail.Product_Offerings__r.Products__c != null)
                gen.writeObjectField('loanType', poDetail.Product_Offerings__r.Products__c);
              else
                gen.writeObjectField('loanType', '');

              gen.writeFieldName('bank_summary_obj');
              //gen.writeStartArray();
              //for(integer i=0;i<1;i++){
              gen.writeStartObject();
              if (MortEligibilityValMap.containsKey('loan_id'))
                gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));
              if (MortEligibilityValMap.containsKey('applicant_type'))
                gen.writeObjectField('applicant_type', MortEligibilityValMap.get('applicant_type'));
              if (poDetail.Offer_Identifier__c == 'ODCC')
                gen.writeObjectField('odccFlag', 'Y');
              else
                gen.writeObjectField('odccFlag', 'N');
              if (poDetail.Financier__c != null)
                gen.writeObjectField('bankName', poDetail.Financier__c);
              else
                gen.writeObjectField('bankName', '');
              if (poDetail.MOB__c != null)
                gen.writeObjectField('bankMOB', poDetail.MOB__c);
              else
                gen.writeObjectField('bankMOB', 0);
              if (poDetail.POS__c != null)
                gen.writeObjectField('pos', poDetail.POS__c);
              else
                gen.writeObjectField('pos', 0);
              gen.writeEndObject();
              // }
              //gen.writeEndArray();  


              gen.writeEndObject();
            }
          }

          /*for(Bank_Account__c bank:bankAccountList){
               gen.writeStartObject();
                   if(bank.Bank_Name__c != null)
                   gen.writeObjectField('bankName',bank.Bank_Name__c);

                   gen.writeFieldName('bank_summary_obj');

                   //gen.writeStartArray();
                       //for(Id bankId: bankMap.keySet()){
                           Id bankAccBRE;
                       double total_10th_balance = 0;
                           double total_20th_balance = 0;
                           double total_month_end_balance = 0;
                           double total_ODCC_balance = 0;
                           double totalBounceInward = 0;
                           double totalCreditAmt = 0;
                           double totalDebitAmt = 0;
                       System.debug('##8-1##');         

                           gen.writeStartObject();
                           if(MortEligibilityValMap.containsKey('loan_id'))
                           gen.writeObjectField('loan_id',string.valueOf(MortEligibilityValMap.get('loan_id')));

                           if(bank.Applicant__c != null && bank.Applicant__r.Applicant_Type__c != null)
                           gen.writeObjectField('applicant_type',bank.Applicant__r.Applicant_Type__c);                  

                           if(bank.Average_ODCC_Utilization__c != null)
                           gen.writeObjectField('avg_od_cc_utilisation',bank.Average_ODCC_Utilization__c);

                           if(bankMap.size()>0 && bankMap.containsKey(bank.id) && bankMap.get(bank.id).size()>0){
                           for (Bank_Transaction__c bankObj: bankMap.get(bank.Id)){                                  

                           total_10th_balance = total_10th_balance + bankObj.Balance_10th_of_month__c;
                           total_20th_balance = total_20th_balance + bankObj.Balance_20th_of_month__c;
                           total_month_end_balance = total_month_end_balance + bankObj.Balance_Ist_of_Month__c;

                           if(bankObj.Bounce_IW__c != null){
                               totalBounceInward = totalBounceInward + bankObj.Bounce_IW__c;
                           }

                           if(bankObj.CRD_Amount__c != null){
                               totalCreditAmt = totalCreditAmt + bankObj.CRD_Amount__c;
                           }

                           if(bankObj.DB_Amount__c != null){
                               totalDebitAmt = totalDebitAmt + bankObj.DB_Amount__c;
                           }
                           }

                           gen.writeObjectField('_10th_balance', (total_10th_balance != 0) ? total_10th_balance +'' : '0.0');
                           gen.writeObjectField('_20th_balance', (total_20th_balance != 0) ? total_20th_balance +'' : '0.0');
                           gen.writeObjectField('last_day_balance', (total_month_end_balance != 0) ? total_month_end_balance +'' : '0.0');

                           gen.writeObjectField('total_bounce_inward', (totalBounceInward != 0) ? totalBounceInward : 0.0);
                           gen.writeObjectField('total_credit_amount', (totalCreditAmt != 0) ? totalCreditAmt  : 0.0);      
                           gen.writeObjectField('total_debit_amount', (totalDebitAmt != 0) ? totalDebitAmt : 0.0);


                           }

                           if(bank.Account_Type__c == 'OD' || bank.Account_Type__c == 'CC'){
                           bankAccBRE = bank.Id;          
                           }
                           if(bankAccBRE != null)
                           gen.writeObjectField('odccFlag','Y');
                           else
                           gen.writeObjectField('odccFlag','N');


                           if(bank.Bank_Name__c!= null)
                           gen.writeObjectField('bankName',bank.Bank_Name__c);


                           gen.writeEndObject();
                       //}

                       //gen.writeEndArray();

               gen.writeEndObject();
               }*/
          gen.writeEndArray();
          System.debug('##8##');
        }

        System.debug('propertyList=' + propertyList.size());
        gen.writeFieldName('Property_Details');
        gen.writeStartArray();
        if (propertyList != null)
          for (Property_Details__c property: propertyList) {

            stampReg = 0;

            gen.writeStartObject();

            if (MortEligibilityValMap.containsKey('loan_id'))
              gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));

            if (property.Property_Land_Area_In_Sq_Ft__c != null) {
              gen.writeObjectField('property_land_area', double.valueof(property.Property_Land_Area_In_Sq_Ft__c));
              //gen.writeNumberField('land_area_unit',double.valueof(property.Land_Area_units__c));
            }

            if (property.Valuation_1__c != null)
              gen.writeObjectField('property_valuation1', property.Valuation_1__c);

            if (property.Valuation_2__c != null)
              gen.writeObjectField('property_valuation2', string.valueOf(property.Valuation_2__c));

            if (property.Construction_Area_SBU__c != null)
              gen.writeObjectField('construction_area', property.Construction_Area_SBU__c);
            else
              gen.writeObjectField('construction_area', 0.0);

            if (property.Construction_Valuation_1__c != null)
              gen.writeObjectField('construction_valuation1', property.Construction_Valuation_1__c);

            if (property.Construction_Valuation_2__c != null)
              gen.writeObjectField('construction_valuation2', property.Construction_Valuation_2__c);

            if (property.Property_Age__c != null)
              gen.writeObjectField('property_age', property.Property_Age__c);
            else
              gen.writeObjectField('property_age', 0);

            if (property.Value_of_Furniture_and_fixture__c != null)
              gen.writeObjectField('fandf_amount', property.Value_of_Furniture_and_fixture__c);

            if (property.Property_Identified__c != null)
              gen.writeObjectField('property_identified', string.valueOf(property.Property_Identified__c));

            if (property.Address__c != null)
              gen.writeObjectField('property_address', string.valueOf(property.Address__c));

            if (property.Property_City__c != null)
              gen.writeObjectField('property_city', string.valueOf(property.Property_City__c));
            else
              gen.writeObjectField('property_city', '');

            if (property.Nature_of_property__c != null)
              gen.writeObjectField('property_type', string.valueOf(property.Nature_of_property__c));
            else
              gen.writeObjectField('property_type', '');

            if (property.Type_Of_Measurement__c != null)
              gen.writeObjectField('type_of_measurement', property.Type_Of_Measurement__c);

            if (property.Property_Address_Line_1__c != null)
              gen.writeObjectField('address_line1', property.Property_Address_Line_1__c);
            if (property.Property_Address_Line_2__c != null)
              gen.writeObjectField('address_line2', property.Property_Address_Line_2__c);
            if (property.Property_Address_Line_3__c != null)
              gen.writeObjectField('address_line3', property.Property_Address_Line_3__c);

            if (property.Area_Locality__c != null)
              gen.writeObjectField('locality', property.Area_Locality__r.Name);
            else
              gen.writeObjectField('locality', '');

            if (property.Land_Area_as_per_Sale_Deed__c != null)
              gen.writeObjectField('property_land_area_asPer_sale', property.Land_Area_as_per_Sale_Deed__c);
            else
              gen.writeObjectField('property_land_area_asPer_sale', 0.0);


            if (property.Developer_Name__c != null && property.Developer_Name__r.Name != null) {
              gen.writeObjectField('developer_name', property.Developer_Name__r.Name);
              //gen.writeObjectField('developer_name_search',property.Developer_Name__r.Name);
            }

            if (property.Project_Name__c != null && property.Project_Name__r.Name != null)
              gen.writeObjectField('project_name', property.Project_Name__r.Name);
            else
              gen.writeObjectField('project_name', '');

            if (property.Property_Type__c != null)
              gen.writeObjectField('property_usage', property.Property_Type__c);
            else
              gen.writeObjectField('property_usage', '');

            gen.writeObjectField('property_id', property.id);

            if (property.Hospital_Property__c != null)
              gen.writeObjectField('no_of_beds', property.Hospital_Property__c);

            if (property.Developer_Name__c != null && property.Developer_Name__r.Name != null) {
              gen.writeObjectField('developer_name_search', property.Developer_Name__r.Name);
            }

            if (property.Property_Transaction_Type__c != null)
              gen.writeObjectField('type_of_transaction', property.Property_Transaction_Type__c);
            else
              gen.writeObjectField('type_of_transaction', '');

            if (property.Land_Area_units__c != null)
              gen.writeObjectField('land_area_unit', property.Land_Area_units__c);
            else
              gen.writeObjectField('land_area_unit', '');

            if (property.Construction_Area_units__c != null)
              gen.writeObjectField('construction_area_unit', string.ValueOf(property.Construction_Area_units__c));
            else
              gen.writeObjectField('construction_area_unit', '');

            if (property.Type_of_Area__c != null)
              gen.writeObjectField('type_of_area', property.Type_of_Area__c);
            else
              gen.writeObjectField('type_of_area', '');

            if (property.Land_Rate_As_per_Valuer_1__c != null)
              gen.writeObjectField('land_rate_asPer_value1', property.Land_Rate_As_per_Valuer_1__c);
            else
              gen.writeObjectField('land_rate_asPer_value1', 0.0);

            if (property.Land_Rate_As_per_Valuer_2__c != null)
              gen.writeObjectField('land_rate_asPer_value2', property.Land_Rate_As_per_Valuer_2__c);
            else
              gen.writeObjectField('land_rate_asPer_value2', 0.0);

            if (property.Construction_Rate_As_per_Valuer_1__c != null)
              gen.writeObjectField('construction_rate_asPer_value1', property.Construction_Rate_As_per_Valuer_1__c);
            else
              gen.writeObjectField('construction_rate_asPer_value1', 0.0);

            System.debug('@@@1');

            //BTSanctionAmount
            gen.writeObjectField('BTSanctionAmount', 0.0);

            if (property.Construction_Rate_As_per_Valuer_2__c != null)
              gen.writeObjectField('construction_rate_asPer_value2', property.Construction_Rate_As_per_Valuer_2__c);
            else
              gen.writeObjectField('construction_rate_asPer_value2', 0.0);

            if (property.Legal_Charges__c != null)
              gen.writeObjectField('otherCharges', property.Legal_Charges__c);
            else
              gen.writeObjectField('otherCharges', 0.0);

            if (property.Registration_Charge__c != null && property.PROCESSING_FEES_STAMP_DUTY_To_be_deduct__c != null) {

              stampReg = property.Registration_Charge__c + property.PROCESSING_FEES_STAMP_DUTY_To_be_deduct__c;

              gen.writeObjectField('stampDutyAndReg', double.valueOf(stampReg));
            }

            if (property.Basic_Agreement_Value__c != null)
              gen.writeObjectField('agreementValue', property.Basic_Agreement_Value__c);
            else
              gen.writeObjectField('agreementValue', 0.0);


            /* System.debug('Builder_Maintenance__r='+property.Developer_Name__r.Builder_Segmentation__c);
        System.debug('Project=='+property.Project_Name__r.Project_segmentation__c);

        if(property.Developer_Name__c != null && property.Developer_Name__r.Builder_Segmentation__c != null)
        gen.writeObjectField('dedupeBuilders',property.Developer_Name__r.Builder_Segmentation__c);
    else
        gen.writeObjectField('dedupeBuilders','');

        if(property.Project_Name__c != null && property.Project_Name__r.Project_segmentation__c != null)
        gen.writeObjectField('dedupeProjects',property.Project_Name__r.Project_segmentation__c);
    else
        gen.writeObjectField('dedupeProjects','');*/

            System.debug('@@@2');
            //---As per changes require for TSR/EC we have commented btDetails tag - SHL Issue 17-1-17 Amit
            /*if (MortEligibilityValMap.containsKey('product') && (MortEligibilityValMap.get('product') == 'SHL' || MortEligibilityValMap.get('product') == 'HFC SHL' || MortEligibilityValMap.get('product') == 'SHOL' || MortEligibilityValMap.get('product') == 'HSL')) {
    gen.writeFieldName('btDetails');
    gen.writeStartObject();
    gen.writeFieldName('bank_summary_obj');
    gen.writeStartObject();
    gen.writeObjectField('bankName', '');
    gen.writeEndObject();

    gen.writeEndObject();
    } else {*/
            gen.writeFieldName('bank_summary_obj');
            gen.writeStartObject();

            //---TSR/EC SHL Issue Amit
            if (property.Bank_Name__c != null)
              gen.writeObjectField('bankName', property.Bank_Name__c);
            else
              gen.writeObjectField('bankName', '');

            //gen.writeObjectField('bankName', '');

            gen.writeEndObject();
            //}

            System.debug('@@@3');


            /*
          //gen.writeStartArray();
          //for(Id bankId: bankMap.keySet()){
          Id bankAccBRE;
          double total_10th_balance = 0;
          double total_20th_balance = 0;
          double total_month_end_balance = 0;
          double total_ODCC_balance = 0;
          double totalBounceInward = 0;
          double totalCreditAmt = 0;
          double totalDebitAmt = 0;

          if(MortEligibilityValMap.containsKey('loan_id'))
          gen.writeObjectField('loan_id',string.valueOf(MortEligibilityValMap.get('loan_id')));

          if(bank.Applicant__c != null && bank.Applicant__r.Applicant_Type__c != null)
          gen.writeObjectField('applicant_type',bank.Applicant__r.Applicant_Type__c);                  

          if(bank.Average_ODCC_Utilization__c != null)
          gen.writeObjectField('avg_od_cc_utilisation',bank.Average_ODCC_Utilization__c);

          if(bankMap.get(bank.id).size()>0){
          for (Bank_Transaction__c bankObj: bankMap.get(bank.Id)){                                  

          total_10th_balance = total_10th_balance + bankObj.Balance_10th_of_month__c;
          total_20th_balance = total_20th_balance + bankObj.Balance_20th_of_month__c;
          total_month_end_balance = total_month_end_balance + bankObj.Balance_Ist_of_Month__c;

          if(bankObj.Bounce_IW__c != null){
              totalBounceInward = totalBounceInward + bankObj.Bounce_IW__c;
          }

          if(bankObj.CRD_Amount__c != null){
              totalCreditAmt = totalCreditAmt + bankObj.CRD_Amount__c;
          }

          if(bankObj.DB_Amount__c != null){
              totalDebitAmt = totalDebitAmt + bankObj.DB_Amount__c;
          }
          }

          gen.writeObjectField('_10th_balance', (total_10th_balance != 0) ? total_10th_balance + '' : '');
          gen.writeObjectField('_20th_balance', (total_20th_balance != 0) ? total_20th_balance + '' : '');
          gen.writeObjectField('last_day_balance', (total_month_end_balance != 0) ? total_month_end_balance + '' : '');

          gen.writeObjectField('total_bounce_inward', (totalBounceInward != 0) ? totalBounceInward  : 0.0);
          gen.writeObjectField('total_credit_amount', (totalCreditAmt != 0) ? totalCreditAmt  : 0.0);      
          gen.writeObjectField('total_debit_amount', (totalDebitAmt != 0) ? totalDebitAmt : 0.0);


          }

          if(bank.Account_Type__c == 'OD' || bank.Account_Type__c == 'CC'){
          bankAccBRE = bank.Id;          
          }
          if(bankAccBRE != null)
          gen.writeObjectField('odccFlag','Y');
          else
          gen.writeObjectField('odccFlag','N');


          if(bank.Bank_Name__c!= null)
          gen.writeObjectField('bankName',bank.Bank_Name__c);
             */


            if (MortEligibilityValMap.containsKey('requested_loan_amount'))
              gen.writeObjectField('appliedLoanAmount', double.valueOf(MortEligibilityValMap.get('requested_loan_amount')));
            else
              gen.writeObjectField('appliedLoanAmount', 0.0);

            if (MortEligibilityValMap.containsKey('preApprovedOfferAmount'))
              gen.writeObjectField('preApprovedOfferAmount', double.valueOf(MortEligibilityValMap.get('preApprovedOfferAmount')));

            if (property.LTV_Offered__c != null)
              gen.writeObjectField('ltvToBeConsidered', double.valueOf(property.LTV_Offered__c));
            else
              gen.writeObjectField('ltvToBeConsidered', 0.0);

            if (property.Existing_Loan_Funded_amount__c != null)
              gen.writeObjectField('loanAmountGiven', property.Existing_Loan_Funded_amount__c);
            else
              gen.writeObjectField('loanAmountGiven', 0.0);

            if (property.Value_of_Furniture_and_fixture__c != null)
              gen.writeObjectField('fandF_agreementValue', property.Value_of_Furniture_and_fixture__c);
            else
              gen.writeObjectField('fandF_agreementValue', 0.0);

            if (property.Parking_Cost__c != null)
              gen.writeObjectField('parkingCost', property.Parking_Cost__c);
            else
              gen.writeObjectField('parkingCost', 0.0);

            if (property.Land_Rate__c != null)
              gen.writeObjectField('landRate', property.Land_Rate__c);
            else
              gen.writeObjectField('landRate', 0.0);


            System.debug('@@@4');
            System.debug('Test Rasika: ' + MortEligibilityValMap.get('UWProgram'));

            if (property.Type_of_Valuation__c != null) {
              if (property.Type_of_Valuation__c == 'Internal') {
                gen.writeObjectField('valuationType', 'PE VALUATION');
                gen.writeObjectField('external_evaluation_initiated', 'N');
              } else if (property.Type_of_Valuation__c == 'External') {
                gen.writeObjectField('valuationType', 'Other');
                gen.writeObjectField('external_evaluation_initiated', 'Y');
              } else
                gen.writeObjectField('valuationType', '');
            } else {
              gen.writeObjectField('valuationType', '');
              gen.writeObjectField('external_evaluation_initiated', '');
            }

            if (property.Floor_Number__c != null)
              gen.writeObjectField('floor', decimal.valueof(property.Floor_Number__c));
            else
              gen.writeObjectField('floor', 0);


            if (property.Basic_Rate__c != null)
              gen.writeObjectField('constructionRateAsPerPE', property.Basic_Rate__c);
            else
              gen.writeObjectField('constructionRateAsPerPE', 0.0);

            if (property.Total_valuation_As_per_PE_PPIV2__c != null)
              gen.writeObjectField('collateralValueAsPerPE', property.Total_valuation_As_per_PE_PPIV2__c);
            else
              gen.writeObjectField('collateralValueAsPerPE', 0.0);

            if (MortEligibilityValMap.containsKey('UWProgram') && MortEligibilityValMap.get('UWProgram') != null)
              gen.writeObjectField('scheme', MortEligibilityValMap.get('UWProgram'));
            else
              gen.writeObjectField('scheme', '');

            // if(property.Property_Equity_Done__c!=null) // bug 12103
            gen.writeObjectField('prop_equity_done', string.valueOf(property.Property_Equity_Done__c));

            if (property.Grid_Value__c != null)
              gen.writeObjectField('offer_grid_amount', property.Grid_Value__c);
            else
              gen.writeObjectField('offer_grid_amount', 0.0);

            if (property.Project_Name__c != null && property.Project_Name__r.Kotak_APF__c != null) // bug 12103
              gen.writeObjectField('project_approved_by_bajaj', property.Project_Name__r.Kotak_APF__c);

            if (property.Property_Ownership__c != null)
              gen.writeObjectField('ownershipType', property.Property_Ownership__c);
            else
              gen.writeObjectField('ownershipType', '');

            //  bug 11154
            if (property.Product__c == 'SHL' || property.Product__c == 'HSL' || property.Product__c == 'SALLAP' || property.Product__c == 'HPLS' || property.Product__c == 'SBS CS SHL') {
              if (property.Builder_segmentaton__c != null)
                gen.writeObjectField('builderSegmentation', property.Builder_segmentaton__c);
              else
                gen.writeObjectField('builderSegmentation', '');

              // System.debug('rasika @@@@'+property.Builder_segmentaton__c);
            }

            //bug 11154: TSR/legal logic stamping is not correct end
            gen.writeEndObject();
          }
        gen.writeEndArray();

        //gen.writeEndObject();

        /*gen.writeFieldName('bank_summary_obj');                         
    gen.writeStartObject();

    gen.writeEndObject();*/

        gen.writeFieldName('cam');
        gen.writeStartObject();
        if (MortEligibilityValMap.containsKey('loan_id'))
          gen.writeObjectField('loan_id', string.valueOf(MortEligibilityValMap.get('loan_id')));
        if (MortEligibilityValMap.containsKey('average_net_salary'))
          gen.writeObjectField('average_net_salary', double.valueOf(MortEligibilityValMap.get('average_net_salary')));
        if (MortEligibilityValMap.containsKey('total_net_salary'))
          gen.writeObjectField('total_net_salary', double.valueOf(MortEligibilityValMap.get('total_net_salary')));
        if (MortEligibilityValMap.containsKey('gross_Salary_Month1'))
          gen.writeObjectField('gross_Salary_Month1', double.valueOf(MortEligibilityValMap.get('gross_Salary_Month1')));
        if (MortEligibilityValMap.containsKey('gross_Salary_Month2'))
          gen.writeObjectField('gross_Salary_Month2', double.valueOf(MortEligibilityValMap.get('gross_Salary_Month2')));
        if (MortEligibilityValMap.containsKey('gross_Salary_Month3'))
          gen.writeObjectField('gross_Salary_Month3', double.valueOf(MortEligibilityValMap.get('gross_Salary_Month3')));
        if (MortEligibilityValMap.containsKey('requested_loan_amount'))
          gen.writeObjectField('proposed_Loan_Amt', double.valueOf(MortEligibilityValMap.get('requested_loan_amount')));
        if (MortEligibilityValMap.containsKey('rental_Income'))
          gen.writeObjectField('rental_Income', double.valueOf(MortEligibilityValMap.get('rental_Income')));
        if (MortEligibilityValMap.containsKey('requested_tenor'))
          gen.writeObjectField('tenor', double.valueOf(MortEligibilityValMap.get('requested_tenor')));
        if (MortEligibilityValMap.containsKey('monthly_net_Rental_Income'))
          gen.writeObjectField('monthly_net_Rental_Income', double.valueOf(MortEligibilityValMap.get('monthly_net_Rental_Income')));
        else if (MortEligibilityValMap.containsKey('rental_Income'))
          gen.writeObjectField('monthly_net_Rental_Income', double.valueOf(MortEligibilityValMap.get('rental_Income')));

        if (MortEligibilityValMap.containsKey('total_monthly_obligations')) {
          System.debug('#####' + double.valueOf(MortEligibilityValMap.get('total_monthly_obligations')));
          gen.writeObjectField('total_monthly_obligations', double.valueOf(MortEligibilityValMap.get('total_monthly_obligations')));
        }

        /*  Prajyot : #10660 Pricing Logic START  */

        //gen.writeEndObject();
        if (MortEligibilityValMap.containsKey('product') && (MortEligibilityValMap.get('product') == 'Home Loan' || MortEligibilityValMap.get('product') == 'LAP')) {
          system.debug('inside praj');
          gen.writeEndObject();
          gen.writeFieldName('btDetailsObject');
          system.debug('1');
          gen.writeStartObject();
          system.debug('2');
          system.debug('btBanktype=' + string.valueOf(MortEligibilityValMap.get('btBankType')));
          /* 
             commenting as per comments from Mayuri #12467
             if (MortEligibilityValMap.containsKey('btBankType'))
             gen.writeObjectField('btBankType', string.valueOf(MortEligibilityValMap.get('btBankType')));
           */
          system.debug('3');
          if (MortEligibilityValMap.containsKey('loanType'))
            gen.writeObjectField('loanType', string.valueOf(MortEligibilityValMap.get('loanType')));
          system.debug('4');
          /*
             commenting as per comments from Mayuri #12467
             if (MortEligibilityValMap.containsKey('btBankType'))
           */
          if (MortEligibilityValMap.containsKey('btBankRoi'))
            gen.writeObjectField('btBankRoi', double.valueOf(MortEligibilityValMap.get('btBankRoi')));
          if (MortEligibilityValMap.containsKey('bt_bank_name'))
            gen.writeObjectField('bt_bank_name', string.valueOf(MortEligibilityValMap.get('bt_bank_name')));
          system.debug('5');


          system.debug('6');

        }
        /*  Prajyot : #10660 Pricing Logic END  */



        gen.writeEndObject();

        /* Bug 18185 - below parameter need from SHOL WADL to BRE start */
        gen.writeFieldName('Request');
        gen.writeStartObject();

        if (MortEligibilityValMap.containsKey('product'))
          gen.writeObjectField('product', MortEligibilityValMap.get('product'));
        //gen.writeStringField('dateOfBirth', valuesMap.get('dateOfBirth') != null ? valuesMap.get('dateOfBirth') : '');
        for (Applicant__c app: applicantList) {
          if (app.Contact_Name__c != null && app.Contact_Name__r.Date_of_Birth__c != null)
            gen.writeObjectField('dateOfBirth', String.valueOf(app.Contact_Name__r.Date_of_Birth__c));
        }
        gen.writeObjectField('incentiveFrequency', 'HALF YEARLY');
        gen.writeNumberField('annualRentalIncome', 0);
        //gen.writeStringField('product_required', 'LAP');
        gen.writeStringField('product_required', 'Home Loan');
        gen.writeStringField('base_product', 'SPL');
        if (MortEligibilityValMap.containsKey('customer_segment'))
          gen.writeObjectField('customer_segment', MortEligibilityValMap.get('customer_segment'));
        else
          gen.writeObjectField('customer_segment', '');
        gen.writeNumberField('maxPLAvailedBureau', 0);
        gen.writeStringField('financiar_name', 'ABN');
        /*Bug 18728 - Eligibility is not getting displayed start*/
        if (MortEligibilityValMap.containsKey('securedMOB'))
          gen.writeNumberField('mortgage_loan_mob', double.valueOf(MortEligibilityValMap.get('securedMOB')));
        else
          gen.writeObjectField('mortgage_loan_mob', 0);
        /*Bug 18728 - Eligibility is not getting displayed end*/
        if (MortEligibilityValMap.containsKey('offerType') && MortEligibilityValMap.get('offerType') == 'Fresh Home Loan')
          gen.writeStringField('transactionType', 'Non BT');
        else
          gen.writeStringField('transactionType', 'BT');
        if (MortEligibilityValMap.containsKey('branch_name'))
          gen.writeObjectField('branch_name', MortEligibilityValMap.get('branch_name'));
        else
          gen.writeObjectField('branch_name', '');

        if (MortEligibilityValMap.containsKey('monthlyNetSalary'))
          gen.writeObjectField('monthlyNetSalary', Decimal.valueOf(MortEligibilityValMap.get('monthlyNetSalary')));
        else
          gen.writeNumberField('monthlyNetSalary', 0);

        if (MortEligibilityValMap.containsKey('monthlyObligation'))
          gen.writeObjectField('monthlyObligation', Decimal.valueOf(MortEligibilityValMap.get('monthlyObligation')));
        else
          gen.writeNumberField('monthlyObligation', 0);



        gen.writeNumberField('annualIncentiveAmount', 0);
        if (MortEligibilityValMap.containsKey('btAmount'))
          gen.writeObjectField('mortgage_loan_sanc_amt', Decimal.valueOf(MortEligibilityValMap.get('btAmount')));
        gen.writeStringField('type_of_degree', '');
        gen.writeNumberField('maximumBLPLAmountL_C', 0);
        gen.writeNumberField('maximumoutofClosedMortgageLoan', 0);
        gen.writeNumberField('annualTurnoverShownonBooks', 0);
        gen.writeNumberField('annualNetProfit', 0);
        gen.writeNumberField('totalofLiveMortgageLoan', 0);

        gen.writeEndObject();
        /* Bug 18185 - below parameter need from SHOL WADL to BRE end */

        gen.writeEndObject();

        String jsonInput = gen.getAsString();
        System.debug('Input=' + jsonInput);
        // BRECallout.sendInputOnMail(jsonInput);

        Mid_office_BRE_flow__c BRE_ver = Mid_office_BRE_flow__c.getValues('Mortgage Eligibility');

        if (BRE_ver != null) {
          endpointURL = BRE_ver.EndpointURL__c;
        }

        //username = 'DEFAULT\\Admin';
        //password = 'Admin';

        System.debug('********Endpoint for IM********' + endpointURL);
        System.debug('********Username for IM********' + username);
        System.debug('********Passowrd for IM********' + password);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        req.setbody(jsonInput);
        req.setTimeout(120000);
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = EncodingUtil.base64Encode(headerValue);
        //System.debug('Input=' + jsonInput);
        System.debug('authorizationHeader ---' + authorizationHeader);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        if (!Test.isRunningTest()) {
          res = http.send(req);
        } else {
          res.setStatusCode(250);
          System.debug('::Response status code: ' + res.getStatusCode());
          res.setBody('{"eligibility_amount":0.00,"eligibilty":{"finalOfferAmount":-44.199999235570430755615234375,"valuation":null,"collateralValuationAsPerPE":null,"loan_id":"23203006206","loanAmountAsPerTopUpMultiplier":null,"loanAmountAsPerValuation":null,"loanAmountAsPerGrid":null,"maxLoanEligible":null,"totalLoanGiven":null,"loanAmountAsPerPE":null,"totalMonthlyObligations":null,"eligibilityAsPerProperty":[{"propertyId":"a0pp0000000SXi7AAG","fullUWEligibleAmt":0.100000001490116119384765625,"disposableIncome":8333.33333333333333333333,"appliedFoir":0.00,"emiFactor":1613.349570743157528340816497802734375,"emi":82280.8984375,"maxLoanEligibility":0.100000001490116119384765625,"totalMaxEligibleLoan":0.100000001490116119384765625,"standardLTV":0.0},{"propertyId":"a0pp0000000SaZlAAK","fullUWEligibleAmt":-44.299999237060546875,"disposableIncome":8333.33333333333333333333,"appliedFoir":1.30,"emiFactor":1613.349570743157528340816497802734375,"emi":82280.8984375,"maxLoanEligibility":-44.299999237060546875,"totalMaxEligibleLoan":-44.299999237060546875,"standardLTV":0.4}],"eligible_loan_amount":-44.20,"applicable_foir":null,"final_foir":null,"total_emi":null,"eligible_loan_amount_12":null,"eligible_loan_amount_24":null,"eligible_loan_amount_36":null,"eligible_loan_amount_48":null,"eligible_loan_amount_60":null,"eligible_loan_amount_72":null,"valuation1":null,"valuation2":null,"cop":null,"revised_offer_amount_final":null,"total_monthly_income":null},"Action":true}'); // bug 11156: added total_monthly_income
        }
        System.debug('::Response' + res);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          // Proper Response        
          String result = res.getBody();
          System.debug('Result ----->' + result);
          //Parse response

          Map < String, Object > root = (Map < String, Object > ) JSON.deserializeUntyped(result);
          String OfferAmount, UWEligibleAmt, loanId, maxLoanEligibility, finalFOIR, applicableFOIR, totalEMI, max_tenor, eligible_PLS_amount, revised_offer_amount_final, max_loan_as_per_FOIR;
          string totalInCon; // bug 11156 by rasika
          //List<Object> items = (List<Object>)root.get('eligibilty');
          //for (Object item : items) {
          Map < String, Object > EligibilityObjTag = (Map < String, Object > ) root.get('eligibilty');

          OfferAmount = String.valueOf(EligibilityObjTag.get('eligible_loan_amount'));
          //UWEligibleAmt = String.valueOf(EligibilityObjTag.get('finalOfferAmount'));
          maxLoanEligibility = String.valueOf(EligibilityObjTag.get('maxLoanEligible'));

          finalFOIR = String.valueOf(EligibilityObjTag.get('final_foir'));
          applicableFOIR = String.valueOf(EligibilityObjTag.get('applicable_foir'));
          totalInCon = String.valueOf(EligibilityObjTag.get('total_monthly_income')); // bug 11156 by rasika
          loanId = String.valueOf(EligibilityObjTag.get('loan_id'));

          totalEMI = String.valueOf(EligibilityObjTag.get('total_emi'));

          max_tenor = String.valueOf(EligibilityObjTag.get('max_tenor'));

          //SHL Requirement
          if (EligibilityObjTag.containsKey('pls_amount'))
            eligible_PLS_amount = String.valueOf(EligibilityObjTag.get('pls_amount'));

          if (EligibilityObjTag.containsKey('revised_offer_amount_final'))
            revised_offer_amount_final = String.valueOf(EligibilityObjTag.get('revised_offer_amount_final'));

          if (EligibilityObjTag.containsKey('max_loan_as_per_FOIR'))
            max_loan_as_per_FOIR = String.valueOf(EligibilityObjTag.get('max_loan_as_per_FOIR'));

          List < Object > items = (List < Object > ) EligibilityObjTag.get('eligibilityAsPerProperty');
          String stdLTV = '';

          /*  Prajyot : #10660 Pricing Logic START  */

          /* Added By Ankush Start For bug 13109*/
          String loanAppId = MortEligibilityValMap.get('Id');
          if (loanAppId != null) {
            try {
              String accountId = [select id, Account.id from Opportunity where id =: loanAppId].Account.Id;
              system.debug('Account Id >>>' + accountId);
              if (accountId != null) {
                Account accountObj = SelectQueriesHelperClass.getAccountById(accountId);
                if (accountObj != null) {
                  if (EligibilityObjTag.get('stamped_bt_roi') != null)
                    accountObj.Stamped_ROI_BT_ROI__c = Double.valueOf(EligibilityObjTag.get('stamped_bt_roi'));
                  if (EligibilityObjTag.get('stamped_topup_roi') != null)
                    accountObj.Stamped_Top_UP_ROI__c = Double.valueOf(EligibilityObjTag.get('stamped_topup_roi'));
                  if (EligibilityObjTag.get('stamped_pf') != null)
                    accountObj.Stamped_PF__c = Double.valueOf(EligibilityObjTag.get('stamped_pf'));
                  if (EligibilityObjTag.get('stamped_insurance') != null)
                    accountObj.Stamped_Insurance__c = Double.valueOf(EligibilityObjTag.get('stamped_insurance'));
                  update accountobj;
                }
              }
            } catch (Exception e) {
              system.debug('Exception while retrieving account Record >>' + e);
            }
          }

          /*Added By Ankush End */

          /*  Prajyot : #10660 Pricing Logic END  */


          for (Object item: items) {
            Map < String, Object > propEligibilityTag = (Map < String, Object > ) item;

            //UWEligibleAmt = String.valueOf(propEligibilityTag.get('fullUWEligibleAmt'));

            /* if (propEligibilityTag.containsKey('propertyId') && propEligibilityTag.containsKey('standardLTV') && propEligibilityTag.get('standardLTV') != null && propEligibilityTag.containsKey('appliedFoir') && propEligibilityTag.get('appliedFoir') != null)
    stdLTV += String.valueOf(propEligibilityTag.get('propertyId')) + '-' + String.valueOf(propEligibilityTag.get('standardLTV')) + ',' + String.valueOf(propEligibilityTag.get('appliedFoir'));
             */ // temporary comeneted by rasika for bug 11154
            if (propEligibilityTag.containsKey('propertyId') && propEligibilityTag.get('propertyId') != null) // for property     
              stdLTV += String.valueOf(propEligibilityTag.get('propertyId')) + '-';
            if (propEligibilityTag.containsKey('standardLTV') && propEligibilityTag.get('standardLTV') != null)
              stdLTV += String.valueOf(propEligibilityTag.get('standardLTV')) + ',';
            if (propEligibilityTag.containsKey('appliedFoir') && propEligibilityTag.get('appliedFoir') != null)
              stdLTV += String.valueOf(propEligibilityTag.get('appliedFoir'));
            //bug 11154 end SHL requirement
            if (propEligibilityTag.containsKey('LTVIncldIncusrance') && propEligibilityTag.get('LTVIncldIncusrance') != null) {
              stdLTV += ',' + String.valueOf(propEligibilityTag.get('LTVIncldIncusrance'));
            }
            //TSR / legal logic stamping by Piya 1-17-17 Start
            if (propEligibilityTag.containsKey('legalStatus') && propEligibilityTag.get('legalStatus') != null) {
              stdLTV += ',' + String.valueOf(propEligibilityTag.get('legalStatus'));
            }
            if (propEligibilityTag.containsKey('EC_TSR_Status') && propEligibilityTag.get('EC_TSR_Status') != null) {
              stdLTV += ',' + String.valueOf(propEligibilityTag.get('EC_TSR_Status'));
            }
            //TSR / legal logic stamping by Piya End
            stdLTV += ';';

            //maxLoanEligibility = String.valueOf(propEligibilityTag.get('maxLoanEligible'));
            //mortgageEligibilityResult.put('standardLTV',String.valueOf(propEligibilityTag.get('propertyId'))+';'+String.valueOf(propEligibilityTag.get('standardLTV')))
          }

          //System.debug('stdLTV='+stdLTV+'=UWEligibleAmt='+UWEligibleAmt);
          /*OfferAmount = String.valueOf(MCPObjTag.get('finalOfferAmount'));           
    UWEligibleAmt = String.valueOf(MCPObjTag.get('fullUWEligibleAmt'));
    loanId = String.valueOf(MCPObjTag.get('loan_id'));*/

          System.debug('OfferAmount==' + OfferAmount + '::maxLoanEligibility::' + maxLoanEligibility + '::::' + 'UWEligibleAmt:::' + UWEligibleAmt + '-loanId-' + loanId + '=stdLTV=' + stdLTV);
          //}


          mortgageEligibilityResult.put('maxLoanEligibility', maxLoanEligibility);
          mortgageEligibilityResult.put('finalOfferAmount', OfferAmount);
          mortgageEligibilityResult.put('final_foir', finalFOIR);
          mortgageEligibilityResult.put('applicable_foir', applicableFOIR);
          mortgageEligibilityResult.put('standardLTV', stdLTV);
          mortgageEligibilityResult.put('totalEMI', totalEMI);
          mortgageEligibilityResult.put('total_monthly_income', totalInCon); // bug 11156 by rasika

          mortgageEligibilityResult.put('max_tenor', max_tenor); //SHL changes
          mortgageEligibilityResult.put('eligible_PLS_amount', eligible_PLS_amount); //SHL changes
          mortgageEligibilityResult.put('revised_offer_amount_final', revised_offer_amount_final); //SHL changes
          mortgageEligibilityResult.put('max_loan_as_per_FOIR', max_loan_as_per_FOIR); //SHL changes

          mortgageEligibilityResult.put('loanId', loanId);
          mortgageEligibilityResult.put('Status', 'Success');

          //For SHOL
          mortgageEligibilityResult.put('eligible_loan_amount_12', String.valueOf(EligibilityObjTag.get('eligible_loan_amount_12')));
          mortgageEligibilityResult.put('eligible_loan_amount_24', String.valueOf(EligibilityObjTag.get('eligible_loan_amount_24')));
          mortgageEligibilityResult.put('eligible_loan_amount_36', String.valueOf(EligibilityObjTag.get('eligible_loan_amount_36')));
          mortgageEligibilityResult.put('eligible_loan_amount_48', String.valueOf(EligibilityObjTag.get('eligible_loan_amount_48')));
          mortgageEligibilityResult.put('eligible_loan_amount_60', String.valueOf(EligibilityObjTag.get('eligible_loan_amount_60')));
          mortgageEligibilityResult.put('applicable_foir', String.valueOf(EligibilityObjTag.get('applicable_foir')));

        } else {
          mortgageEligibilityResult.put('Status', 'Failed');
          System.debug('<-----CONNECTION ERROR----->');
        }

      }

    } catch (Exception e) {
      System.debug(e.getMessage() + ' Line number====>' + e.getLineNumber());
    }
    return mortgageEligibilityResult;



  }

  //Dynamic Collateral Mgmt Start
  public Map < String, Object > callDynamicColl(Map < String, Object > reqMap) {
    Map < String, Object > mortgageDCMResult = new Map < String, Object > ();
    try {

      Map < string, string > DCMMortgageValueMap = reqMap.containsKey('generic_map') ? (Map < String, String > ) reqMap.get('generic_map') : new Map < String, String > ();

      List < Property_Details__c > PropertyList = reqMap.containsKey('prop_lst') ? (List < Property_Details__c > ) reqMap.get('prop_lst') : new List < Property_Details__c > ();

      List < String > propertyIdentOPList = new List < String > ();
      Map < String, String > propertyTriggersDetailsMap = new Map < String, String > ();

      JSONGenerator gen = JSON.createGenerator(true);
      gen.writeStartObject();
      gen.writeFieldName('Loan_Parameter');
      gen.writeStartObject();

      //gen.writeStringField('loan_id', DCMMortgageValueMap.get('loan_id') != null ? DCMMortgageValueMap.get('loan_id') : '');
      if (DCMMortgageValueMap.containsKey('product'))
        gen.writeObjectField('product', DCMMortgageValueMap.get('product'));
      if (DCMMortgageValueMap.containsKey('invisibleMonitoringProduct'))
        gen.writeObjectField('invisibleMonitoringProduct', DCMMortgageValueMap.get('invisibleMonitoringProduct'));
      if (DCMMortgageValueMap.containsKey('monitoringFor'))
        gen.writeObjectField('monitoringFor', DCMMortgageValueMap.get('monitoringFor'));
      if (DCMMortgageValueMap.containsKey('approved_loan_amount'))
        gen.writeNumberField('approved_loan_amount', decimal.valueOf(DCMMortgageValueMap.get('approved_loan_amount')));
      gen.writeEndObject();
      gen.writeFieldName('Demographic');
      gen.writeStartArray();
      gen.writeStartObject();
      if (DCMMortgageValueMap.containsKey('applicant_type'))
        gen.writeObjectField('applicant_type', DCMMortgageValueMap.get('applicant_type'));
      if (DCMMortgageValueMap.containsKey('date_of_birth'))
        gen.writeObjectField('date_of_birth', DCMMortgageValueMap.get('date_of_birth'));
      gen.writeEndObject();
      gen.writeEndArray();

      gen.writeFieldName('propertyDetails');
      gen.writeStartArray();
      if (PropertyList != null && PropertyList.size() > 0) {
        for (Property_Details__c property: PropertyList) {
          gen.writeStartObject();
          gen.writeObjectField('property_id', property.id);
          if (property.Property_Age__c != null)
            gen.writeObjectField('property_age', double.valueof(property.Property_Age__c));
          else
            gen.writeObjectField('property_age', 0.0);

          /* Bug-18163 Shubham Start */
          if (property.Extra_Amenities_Val1__c != null)
            gen.writeObjectField('extra_amenities_Val1', property.Extra_Amenities_Val1__c);
          else
            gen.writeObjectField('extra_amenities_Val1', 0);
          if (property.Property_Land_Rate_Val1__c != null)
            gen.writeObjectField('property_rate_Val1', Double.valueOf(property.Property_Land_Rate_Val1__c));
          else
            gen.writeObjectField('property_rate_Val1', 0);
          if (property.Basic_Rate__c != null)
            gen.writeObjectField('basic_rate_as_per_PE', property.Basic_Rate__c);
          else
            gen.writeObjectField('basic_rate_as_per_PE', 0);
          /* Bug-18163 Shubham End */

          // already passing in Total_valuation_As_per_PE_PPIV2__c ==  peValuation (total_valuation)
          //  == PPI_variance  Avg_Property_price__c is price not varience
          // already passing in c == (construction_area == Construction_Area_SBU__c> 
          //landAreainSqft == Property_Land_Area_In_Sq_Ft__c

          // Changes done for DCM on 7 Oct start
          if (property.Construction_Area_SBU__c != null)
            gen.writeObjectField('constructionAreaSBU', double.valueof(property.Construction_Area_SBU__c));
          else
            gen.writeObjectField('constructionAreaSBU', 0.0);

          if (property.Total_valuation_As_per_PE_PPIV2__c != null)
            gen.writeObjectField('peValuation', double.valueof(property.Total_valuation_As_per_PE_PPIV2__c));
          else
            gen.writeObjectField('peValuation', 0.0);


          if (property.Property_Land_Area_In_Sq_Ft__c != null)
            gen.writeObjectField('landAreainSqft', double.valueof(property.Property_Land_Area_In_Sq_Ft__c));
          else
            gen.writeObjectField('landAreainSqft', 0.0);

          if (property.Avg_Property_price__c != null)
            gen.writeObjectField('PPI_variance', double.valueof(property.Avg_Property_price__c));
          else
            gen.writeObjectField('PPI_variance', 0.0);
          // Changes done for DCM on 7 Oct End
          gen.writeObjectField('difficult_to_locate_property', '');

          if (property.Nature_of_property__c != null)
            gen.writeObjectField('property_type', property.Nature_of_property__c);
          else
            gen.writeObjectField('property_type', '');

          if (property.Property_Type__c != null)
            gen.writeObjectField('property_usage', property.Property_Type__c);
          else
            gen.writeObjectField('property_usage', '');

          if (property.Construction_Area_SBU__c != null)
            gen.writeObjectField('construction_area', double.valueof(property.Construction_Area_SBU__c));
          else
            gen.writeObjectField('construction_area', 0.0);
          if (property.Stage_of_Construction__c != null)
            gen.writeObjectField('construction_completion', property.Stage_of_Construction__c);
          else
            gen.writeObjectField('construction_completion', 0);


          if (property.Developer_Name__c != null) {
            if (property.Developer_Name__r.Builder_Segmentation__c != null) {
              gen.writeObjectField('builder_category', property.Developer_Name__r.Builder_Segmentation__c);
            } else
              gen.writeObjectField('builder_category', '');
          } else
            gen.writeObjectField('builder_category', '');


          if (property.Developer_Name__r.Builder_Segmentation__c != null)
            gen.writeObjectField('builder_category', property.Developer_Name__r.Builder_Segmentation__c);
          else
            gen.writeObjectField('builder_category', '');


          if (property.Property_City__c != null)
            gen.writeObjectField('property_city', property.Property_City__c);
          else
            gen.writeObjectField('property_city', '');

          if (property.Top_Up_Percentage__c != null) // bug 16051 s
            gen.writeObjectField('top_up_percentage', property.Top_Up_Percentage__c);
          else
            gen.writeObjectField('top_up_percentage', 0);
          //gen.writeObjectField('top_up_percentage', 51); // bug 16051 e

          if (property.Total_Valuation__c != null)
            gen.writeObjectField('total_valuation', double.valueof(property.Total_Valuation__c)); // bug 16051:removed  total_valuation_as_perr_PPIV2 binding
          else
            gen.writeObjectField('total_valuation', 0.0);

          if (property.Approach_Road_Mortgage__c != null) {
            if (property.Approach_Road_Mortgage__c == '<5ft') {
              gen.writeObjectField('approach_road', 5);
            } else if (property.Approach_Road_Mortgage__c == '<5ft - 10ft') {
              gen.writeObjectField('approach_road', 7);
            } else if (property.Approach_Road_Mortgage__c == '10ft - 15ft') {
              gen.writeObjectField('approach_road', 12);
            } else if (property.Approach_Road_Mortgage__c == '>15ft') {
              gen.writeObjectField('approach_road', 15);
            }
          } else {
            gen.writeObjectField('approach_road', 0);
          }

          if (property.Top_floor_property__c != null) {
            if (property.Top_floor_property__c == 'Yes') {
              gen.writeObjectField('top_floor_property', 'Y');
            } else {
              gen.writeObjectField('top_floor_property', 'N');
            }
          } else {
            gen.writeObjectField('top_floor_property', '');
          }
          if (property.Seperate_access_to_the_property__c != null) // bug 16051 
            gen.writeObjectField('separate_access', property.Seperate_access_to_the_property__c); // bug 16051
          else
            gen.writeObjectField('separate_access', '');
          if (property.Property_Status__c != null)
            gen.writeObjectField('property_status', property.Property_Status__c);
          else
            gen.writeObjectField('property_status', '');

          if (property.No_of_tenants_Relative__c != null)
            gen.writeObjectField('number_of_tenants', double.valueof(property.No_of_tenants_Relative__c));
          else
            gen.writeObjectField('number_of_tenants', 0);



          if (property.Net_LTV1__c != null)
            gen.writeObjectField('net_LTV1', double.valueof(property.Net_LTV1__c));
          else
            gen.writeObjectField('net_LTV1', 0.0);

          gen.writeObjectField('FSI', 0);

          if (property.Distance_Outside_Municipal_limits__c != null)
            gen.writeObjectField('distance_from_city_centre', double.valueof(property.Distance_Outside_Municipal_limits__c));
          else
            gen.writeObjectField('distance_from_city_centre', 0);



          if (property.Construction_Area_Val1__c != null) // bug 16051 s
            gen.writeObjectField('construction_Area_Val1', property.Construction_Area_Val1__c);
          else
            gen.writeObjectField('construction_Area_Val1', 0); // bug 16051 e
          if (property.Construction_Rate_Val1__c != null)
            gen.writeObjectField('construction_rate', double.valueof(property.Construction_Rate_Val1__c)); //Bug 16051 - Binding changed from Construction_rate__c to Construction_Rate_Val1__c
          else
            gen.writeObjectField('construction_rate', 0.0);
          if (property.Construction_Rate_Val1__c != null)
            gen.writeObjectField('construction_Rate_Val1', double.valueof(property.Construction_Rate_Val1__c)); // bug 16051:removed Construction_rate__c binding
          else
            gen.writeObjectField('construction_Rate_Val1', 0.0);

          if (property.Property_Usage__c != null)
            gen.writeObjectField('property_type_used', String.valueof(property.Property_Usage__c));
          else
            gen.writeObjectField('property_type_used', '');
          /* Bug-18163 Shubham Start */
          if (DCMMortgageValueMap.containsKey('purpose_of_loan'))
            gen.writeObjectField('purpose_of_loan', DCMMortgageValueMap.get('purpose_of_loan'));
          /* Bug-18163 Shubham End */

          gen.writeEndObject();
        }
      }

      gen.writeEndArray();

      gen.writeEndObject();
      String jsonString = gen.getAsString();

      System.debug('********JSON string to be passed for IM********' + jsonString);

      Mid_office_BRE_flow__c BRE_ver = Mid_office_BRE_flow__c.getValues('Dynamic Coll Mgmt');

      if (BRE_ver != null) {
        endpointURL = BRE_ver.EndpointURL__c;
      }

      username = 'DEFAULT\\Admin';
      password = 'Admin';
      //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/Verifications/versions/0.0.1-SNAPSHOT/rules/Verifications/verificationMain/executions';
      //endpointURL = 'http://104.43.10.139:8087/executionserver/rest/1/ruleServices/Verifications/versions/0.0.1-SNAPSHOT/rules/Verifications/verificationMain/executions';
      System.debug('********Endpoint for IM********' + endpointURL);
      System.debug('********Username for IM********' + username);
      System.debug('********Passowrd for IM********' + password);

      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      System.debug('RM authorizationHeader ---' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      Http http = new Http();
      HTTPResponse res;
      if (!Test.isRunningTest()) {
        res = http.send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          // Proper Response
          System.debug('Response -----> ' + res);
          System.debug('Request -----> ' + req);
          String result = res.getBody();
          System.debug('Result ----->' + result);
          //mortgageDCMResult = parseResponseForIM(result);
          //System.debug('Map of result -----> ' + mortgageDCMResult);
          if (result != null) {
            Map < String, Object > DynamicCollResponse = new Map < String, Object > ();

            DynamicCollResponse = (Map < String, Object > ) JSON.deserializeUntyped(result);
            system.debug('---DynamicCollResponse===>' + DynamicCollResponse);
            system.debug('---DynamicCollResponse.get(output)===>' + DynamicCollResponse.get('output'));
            Map < String, Object > DynamicCollOutPutRes = (Map < String, Object > ) DynamicCollResponse.get('output');
            system.debug('---DynamicCollOutPutRes===>' + DynamicCollOutPutRes);

            system.debug('---DynamicCollOutPutRes.get(messageDC)===>' + DynamicCollOutPutRes.get('messageDC'));



            List < Object > DynamicCollMessageDC = (List < Object > ) DynamicCollOutPutRes.get('messageDC');
            system.debug('---DynamicCollMessageDC===>' + DynamicCollMessageDC);

            for (Object item: DynamicCollMessageDC) {
              Map < String, Object > propMessageDCTag = (Map < String, Object > ) item;

              if (propMessageDCTag.containsKey('key') && propMessageDCTag.get('key') != null && propMessageDCTag.containsKey('value') && propMessageDCTag.get('value') != null && propMessageDCTag.get('value') == 'IDENTIFIED FOR DYNAMIC COLLATERALING')
                propertyIdentOPList.add(String.valueOf(propMessageDCTag.get('key')));

            }
            /*
    system.debug('---DynamicCollMessageDC.get(e)===>'+DynamicCollMessageDC.get('e'));

    List<Object> DynamicColleDC = (List<Object>)DynamicCollMessageDC.get('e');
    system.debug('---DynamicColleDC===>'+DynamicColleDC);
    system.debug('---DynamicColleDC.get(key)===>'+DynamicColleDC.get('key'));
    system.debug('---DynamicColleDC.get(value)===>'+DynamicColleDC.get('value'));
             */

            List < Object > DynamicCollTriggersDetails = (List < Object > ) DynamicCollOutPutRes.get('passTriggersDetails');
            for (Object item: DynamicCollTriggersDetails) {
              Map < String, Object > propTriggersDetailsTag = (Map < String, Object > ) item;

              if (propTriggersDetailsTag.containsKey('key') && propTriggersDetailsTag.get('key') != null && propTriggersDetailsTag.containsKey('value') && propTriggersDetailsTag.get('value') != null)
                propertyTriggersDetailsMap.put(String.valueOf(propTriggersDetailsTag.get('key')), String.valueOf(propTriggersDetailsTag.get('value')));

            }

            System.debug('propertyIdentOPList=' + propertyIdentOPList + '=propertyTriggersDetailsMap=' + propertyTriggersDetailsMap);

            mortgageDCMResult.put('prop_IdentifiedList', propertyIdentOPList);
            mortgageDCMResult.put('prop_TriggersDetails', propertyTriggersDetailsMap);

            system.debug('---DynamicCollOutPutRes.get(passTriggersDetails)===>' + DynamicCollOutPutRes.get('passTriggersDetails'));
            system.debug('---DynamicCollOutPutRes.get(totalCount)===>' + DynamicCollOutPutRes.get('totalCount'));
            system.debug('---DynamicCollOutPutRes.get(triggersCount)===>' + DynamicCollOutPutRes.get('triggersCount'));
          }
        } else {
          // Error in getting response
          system.debug('<-----CONNECTION ERROR----->');
        }
      }

    } catch (Exception e) {
      system.debug('---Exception Message ---' + e.getMessage());
      system.debug('---Exception line number ---' + e.getLineNumber());
    }
    return mortgageDCMResult;

  }
  //Dynamic Collateral Mgmt End

  //Mortgage Re-Engg End

  //Red flagging Start ---- by harsit garg
  public String callBRERedFlagging(Map < String, Object > inputMap) {

    Map < String, Object > inputCIBILTempMap = new Map < String, Object > ();
    Map < String, Object > inputCIBILMap = new Map < String, Object > ();
    Map < String, Object > inputCIBILExtensionMap = new Map < String, Object > ();
    Map < String, Object > inputCIBILExtension1Map = new Map < String, Object > ();

    if (inputMap != null) {

      if (inputMap.containsKey('cibilTemp') && inputMap.get('cibilTemp') != null)
        inputCIBILTempMap = (Map < String, Object > ) JSON.deserializeUntyped(JSON.serialize(inputMap.get('cibilTemp')));

      //System.debug('inputCIBILTempMap:'+inputCIBILTempMap.get('Loan_Application__r').get('Loan_Application_Number__c'));

      if (inputMap.containsKey('cibil') && inputMap.get('cibil') != null)
        inputCIBILMap = (Map < String, Object > ) JSON.deserializeUntyped(JSON.serialize(inputMap.get('cibil')));

      if (inputMap.containsKey('cibileExtension') && inputMap.get('cibileExtension') != null)
        inputCIBILExtensionMap = (Map < String, Object > ) JSON.deserializeUntyped(JSON.serialize(inputMap.get('cibileExtension')));

      if (inputMap.containsKey('cibileExtension1') && inputMap.get('cibileExtension1') != null)
        inputCIBILExtension1Map = (Map < String, Object > ) JSON.deserializeUntyped(JSON.serialize(inputMap.get('cibileExtension1')));


      Map < String, Object > loanMap = new Map < String, Object > ();
      if (inputCIBILTempMap.containsKey('Loan_Application__r') && inputCIBILTempMap.get('Loan_Application__r') != null)
        loanMap = (Map < String, Object > ) inputCIBILTempMap.get('Loan_Application__r');

      //System.debug('loanMap:'+loanMap.get('Loan_Application_Number__c'));


      //Main Map
      Map < String, Object > requestParam = new Map < String, Object > ();

      //Cibil Map start

      Map < String, Object > cibilMap = new Map < String, Object > ();
      cibilMap.put('loan_id', (loanMap.containsKey('Loan_Application_Number__c') && loanMap.get('Loan_Application_Number__c') != null) ? loanMap.get('Loan_Application_Number__c') : ''); //From Cibil Temp----- Loan Application
      cibilMap.put('autoLoan', (inputCIBILExtension1Map.containsKey('Max_Auto_Loan__c') && inputCIBILExtension1Map.get('Max_Auto_Loan__c') != null) ? inputCIBILExtension1Map.get('Max_Auto_Loan__c') : 0); //From CIBIL_Extension1
      cibilMap.put('autoLoanMob', (inputCIBILExtension1Map.containsKey('Max_Auto_loan_MOB__c') && inputCIBILExtension1Map.get('Max_Auto_loan_MOB__c') != null) ? inputCIBILExtension1Map.get('Max_Auto_loan_MOB__c') : 0); //From CIBIL_Extension1
      cibilMap.put('equifaxScore', 0);
      cibilMap.put('securedMob', (inputCIBILExtension1Map.containsKey('Max_Secured_MOB__c') && inputCIBILExtension1Map.get('Max_Secured_MOB__c') != null) ? inputCIBILExtension1Map.get('Max_Secured_MOB__c') : 0); //From CIBIL_Extension1
      cibilMap.put('unsecuredMob', (inputCIBILExtension1Map.containsKey('Max_Unsecured_MOB__c') && inputCIBILExtension1Map.get('Max_Unsecured_MOB__c') != null) ? inputCIBILExtension1Map.get('Max_Unsecured_MOB__c') : 0); //From CIBIL_Extension1
      cibilMap.put('securedLoanAmount', (inputCIBILExtension1Map.containsKey('Max_Secured_Loan_Amount__c') && inputCIBILExtension1Map.get('Max_Secured_Loan_Amount__c') != null) ? inputCIBILExtension1Map.get('Max_Secured_Loan_Amount__c') : 0); //From CIBIL_Extension1
      cibilMap.put('unSecuredLoanAmount', (inputCIBILExtension1Map.containsKey('Max_unSecured_Loan_Amount__c') && inputCIBILExtension1Map.get('Max_unSecured_Loan_Amount__c') != null) ? inputCIBILExtension1Map.get('Max_unSecured_Loan_Amount__c') : 0); //From CIBIL_Extension1
      cibilMap.put('applicant_id', (inputCIBILTempMap.containsKey('Applicant__c') && inputCIBILTempMap.get('Applicant__c') != null) ? inputCIBILTempMap.get('Applicant__c') : ''); //From Cibil Temp
      cibilMap.put('applicant_Type', (inputCIBILTempMap.containsKey('ApplicantType__c') && inputCIBILTempMap.get('ApplicantType__c') != null) ? inputCIBILTempMap.get('ApplicantType__c') : ''); //From Cibil Temp
      cibilMap.put('amout_Overdue_Limit', (inputCIBILMap.containsKey('Amout_Overdue_Limit__c') && inputCIBILMap.get('Amout_Overdue_Limit__c') != null) ? inputCIBILMap.get('Amout_Overdue_Limit__c') : 0); //From CIBIL
      cibilMap.put('CIBIL_Fired_time', (inputCIBILMap.containsKey('CIBIL_Fired_time__c') && inputCIBILMap.get('CIBIL_Fired_time__c') != null) ? String.valueOf(Date.valueOf(((String.valueOf(inputCIBILMap.get('CIBIL_Fired_time__c'))).split('T'))[0])) : ''); //From CIBIL
      cibilMap.put('CIBIL_updated_time', (inputCIBILMap.containsKey('CIBIL_updated_time__c') && inputCIBILMap.get('CIBIL_updated_time__c') != null) ? String.valueOf(Date.valueOf(((String.valueOf(inputCIBILMap.get('CIBIL_updated_time__c'))).split('T'))[0])) : '');
      cibilMap.put('date_Processed', (inputCIBILMap.containsKey('Date_Processed__c') && inputCIBILMap.get('Date_Processed__c') != null) ? inputCIBILMap.get('Date_Processed__c') : ''); //From CIBIL
      cibilMap.put('EM_Date_of_Entry_for_Cibil_Remarks_Code', (inputCIBILExtensionMap.containsKey('EM_Date_of_Entry_for_Cibil_Remarks_Code__c') && inputCIBILExtensionMap.get('EM_Date_of_Entry_for_Cibil_Remarks_Code__c') != null) ? inputCIBILExtensionMap.get('EM_Date_of_Entry_for_Cibil_Remarks_Code__c') : ''); //From CIBIL_Extension
      cibilMap.put('EM_Date_of_Entry_for_Error_Code', (inputCIBILExtensionMap.containsKey('EM_Date_of_Entry_for_Error_Code__c') && inputCIBILExtensionMap.get('EM_Date_of_Entry_for_Error_Code__c') != null) ? inputCIBILExtensionMap.get('EM_Date_of_Entry_for_Error_Code__c') : ''); //From CIBIL_Extension
      cibilMap.put('EM_Date_of_Entry_for_Error_Dispute_Re', (inputCIBILExtensionMap.containsKey('EM_Date_of_Entry_for_Error_Dispute_Re__c') && inputCIBILExtensionMap.get('EM_Date_of_Entry_for_Error_Dispute_Re__c') != null) ? inputCIBILExtensionMap.get('EM_Date_of_Entry_for_Error_Dispute_Re__c') : ''); //From CIBIL_Extension
      cibilMap.put('bad_Track_Record', (inputCIBILExtension1Map.containsKey('Bad_Track_Record__c') && inputCIBILExtension1Map.get('Bad_Track_Record__c') != null) ? inputCIBILExtension1Map.get('Bad_Track_Record__c') : ''); //From CIBIL_Extension1
      cibilMap.put('CIBIL_Match_check', (inputCIBILMap.containsKey('CIBIL_Match_check__c') && inputCIBILMap.get('CIBIL_Match_check__c') != null) ? inputCIBILMap.get('CIBIL_Match_check__c') : ''); //FROM CIBIL
      cibilMap.put('CIBIL_Rules_Fail', (inputCIBILExtension1Map.containsKey('CIBIL_Rules_Fail__c') && inputCIBILExtension1Map.get('CIBIL_Rules_Fail__c') != null) ? inputCIBILExtension1Map.get('CIBIL_Rules_Fail__c') : ''); //From CIBIL_Extension1

      // Start of production issue fix by Niraj
      String cibilScore;
      if (inputCIBILMap.containsKey('CIBIL_Score__c') && inputCIBILMap.get('CIBIL_Score__c') != null && inputCIBILMap.get('CIBIL_Score__c') == '000-1') {
        cibilScore = '-1';
      } else {
        if (inputCIBILMap.containsKey('CIBIL_Score__c') && inputCIBILMap.get('CIBIL_Score__c') != null) {
          cibilScore = String.valueOf(inputCIBILMap.get('CIBIL_Score__c'));
        }
      }
      cibilMap.put('CIBIL_Score', (cibilScore != null) ? Integer.valueOf(cibilScore) : 0); //FROM CIBIL
      // End of production issue fix by Niraj
      cibilMap.put('PL_Score', (inputCIBILExtensionMap.containsKey('PL_Score__c') && inputCIBILExtensionMap.get('PL_Score__c') != null) ? inputCIBILExtensionMap.get('PL_Score__c') : ''); //From CIBIL_Extension
      cibilMap.put('TU_Score', (inputCIBILExtensionMap.containsKey('TU_Score__c') && inputCIBILExtensionMap.get('TU_Score__c') != null) ? inputCIBILExtensionMap.get('TU_Score__c') : ''); //From CIBIL_Extension
      cibilMap.put('write_Off', (inputCIBILExtension1Map.containsKey('Write_Off__c') && inputCIBILExtension1Map.get('Write_Off__c') != null) ? inputCIBILExtension1Map.get('Write_Off__c') : ''); //From CIBIL_Extension1
      cibilMap.put('cibilPos', 0);
      cibilMap.put('securedUnsecuredLoanAmount', (inputCIBILExtension1Map.containsKey('Secured_Unsecured_Loan_Amount__c') && inputCIBILExtension1Map.get('Secured_Unsecured_Loan_Amount__c') != null) ? inputCIBILExtension1Map.get('Secured_Unsecured_Loan_Amount__c') : 0); //From CIBIL_Extension1
      cibilMap.put('mob', (inputCIBILExtension1Map.containsKey('max_mob__c') && inputCIBILExtension1Map.get('max_mob__c') != null) ? inputCIBILExtension1Map.get('max_mob__c') : 0); //From CIBIL_Extension1

      //Cibil map End

      //Account Information List Start

      List < Map < String, Object >> accountInfoList = new List < Map < String, Object >> ();

      Map < String, Object > accntInfoMap = null;

      String memberId, accntTypeId, ownershipId, accntinfoId, dpdId, dateOpenedId, dateLastPaymentId, dateClosedId, sanctionAmtId, currentBalanceId, dateReportedId, amountOverdueId, suitFiledStatusid, startEndDateId, paymenthistoryStartId, paymenthistoryEndId;

      for (Integer i = 0; i < 30; i++) {

        if (i < 20)
          accntInfoMap = prepareAccountInfo(inputCIBILMap, i);
        else
          accntInfoMap = prepareAccountInfo(inputCIBILExtensionMap, i);

        if (accntInfoMap != null)
          accountInfoList.add(accntInfoMap);

      }

      //Account Information List End

      //Loan-param Information START

      Map < String, Object > loanInfoMAP = new Map < String, Object > ();
      loanInfoMAP.put('loan_id', (loanMap.containsKey('Loan_Application_Number__c') && loanMap.get('Loan_Application_Number__c') != null) ? loanMap.get('Loan_Application_Number__c') : ''); //From Cibil Temp --- Loan Application
      loanInfoMAP.put('product', (loanMap.containsKey('Product__c') && loanMap.get('Product__c') != null) ? loanMap.get('Product__c') : ''); //From Cibil Temp ---- Loan Application

      //Loan-param Information END

      requestParam.put('cibil', cibilMap);
      requestParam.put('account_information', accountInfoList);
      requestParam.put('loan_parameter', loanInfoMAP);

      String jsonString = JSON.serialize(requestParam);
      System.debug('::jsonString::' + jsonString);

      Mid_office_BRE_flow__c breRedFlag = Mid_office_BRE_flow__c.getValues('BRE Red Flag');
      if (breRedFlag != null) {
        username = breRedFlag.Username__c;
        password = breRedFlag.Password__c;
        //endpointURL = '';
        endpointURL = breRedFlag.EndpointURL__c;
      }

      System.debug('********Endpoint********' + endpointURL);
      System.debug('********Username********' + username);
      System.debug('********Passowrd********' + password);
      if (!Test.isRunningTest()) {
        HTTPRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setbody(jsonString);
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = EncodingUtil.base64Encode(headerValue);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        System.debug('Request -----> ' + req);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('<-----CONNECTION---->' + res.getStatusCode());
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          // Proper Response
          System.debug('Request -----> ' + req);
          String result = res.getBody();
          System.debug('Result ----->' + result);
          return result;

        } else {
          // Error in getting response
          System.debug('<-----CONNECTION ERROR----->' + res.getStatusCode());
          return null;
        }

      }
    }
    return null;

  }

  String memberId, accntTypeId, ownershipId, accntinfoId, dpdId, dateOpenedId, dateLastPaymentId, dateClosedId, sanctionAmtId, currentBalanceId, dateReportedId, amountOverdueId, suitFiledStatusid, startEndDateId, paymenthistoryStartId, paymenthistoryEndId;
  Map < String, Object > accountInfoMap;

  private Map < String, Object > prepareAccountInfo(Map < String, Object > inputMap, Integer i) {

    accountInfoMap = new Map < String, Object > ();

    memberId = 'Member' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    accntTypeId = 'Account_Type' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    ownershipId = 'Ownership' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    accntinfoId = 'Account_Info' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    dpdId = 'Days_Past_Due' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    dateOpenedId = 'Date_Opened' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    dateLastPaymentId = 'Date_Last_Payment' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    dateClosedId = 'Date_Closed' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    sanctionAmtId = 'Sanction_Amount' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    currentBalanceId = 'Current_Balance' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    dateReportedId = 'Date_Reported' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    amountOverdueId = 'Amount_Overdue' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    suitFiledStatusid = 'Suit_Filed_Status' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    if (i < 20)
      startEndDateId = 'Start_End_Dates' + ((i == 0) ? '' : String.valueOf(i)) + '__c';
    else {
      paymenthistoryStartId = 'Payment_History_Start_Date' + (i + 1) + '__c';
      paymenthistoryEndId = 'Payment_History_End_Date' + (i + 1) + '__c';
    }

    if (inputMap.containsKey(memberId) && inputMap.get(memberId) != null && inputMap.get(memberId) != '' && inputMap.containsKey(accntTypeId) && inputMap.get(accntTypeId) != null && !((String.valueOf(inputMap.get(accntTypeId))).equalsIgnoreCase('no data'))) {

      accountInfoMap.put('member', inputMap.get(memberId));
      accountInfoMap.put('accountType', inputMap.get(accntTypeId));
      accountInfoMap.put('ownership', (inputMap.containsKey(ownershipId) && inputMap.get(ownershipId) != null) ? inputMap.get(ownershipId) : '');
      accountInfoMap.put('accountInfo', (inputMap.containsKey(accntinfoId) && inputMap.get(accntinfoId) != null) ? inputMap.get(accntinfoId) : '');
      accountInfoMap.put('dpd', (inputMap.containsKey(dpdId) && inputMap.get(dpdId) != null) ? inputMap.get(dpdId) : '');
      accountInfoMap.put('dateOpened', (inputMap.containsKey(dateOpenedId) && inputMap.get(dateOpenedId) != null) ? inputMap.get(dateOpenedId) : '');
      accountInfoMap.put('dateLastPayment', (inputMap.containsKey(dateLastPaymentId) && inputMap.get(dateLastPaymentId) != null) ? inputMap.get(dateLastPaymentId) : '');
      accountInfoMap.put('dateClosed', (inputMap.containsKey(dateClosedId) && inputMap.get(dateClosedId) != null) ? inputMap.get(dateClosedId) : '');
      accountInfoMap.put('sanctionAmt', (inputMap.containsKey(sanctionAmtId) && inputMap.get(sanctionAmtId) != null) ? inputMap.get(sanctionAmtId) : 0);
      accountInfoMap.put('currentBalance', (inputMap.containsKey(currentBalanceId) && inputMap.get(currentBalanceId) != null) ? inputMap.get(currentBalanceId) : 0);
      accountInfoMap.put('dateReported', (inputMap.containsKey(dateReportedId) && inputMap.get(dateReportedId) != null) ? inputMap.get(dateReportedId) : '');
      accountInfoMap.put('amountOverdue', (inputMap.containsKey(amountOverdueId) && inputMap.get(amountOverdueId) != null) ? Double.valueOf(inputMap.get(amountOverdueId)) : 0);
      accountInfoMap.put('suitFiledStatus', (inputMap.containsKey(suitFiledStatusid) && inputMap.get(suitFiledStatusid) != null) ? inputMap.get(suitFiledStatusid) : '');
      if (i < 20)
        accountInfoMap.put('startEndDate', (inputMap.containsKey(startEndDateId) && inputMap.get(startEndDateId) != null) ? inputMap.get(startEndDateId) : '');
      else
        accountInfoMap.put('startEndDate', ((inputMap.containsKey(paymenthistoryStartId) && inputMap.get(paymenthistoryStartId) != null) ? inputMap.get(paymenthistoryStartId) : '') + ' ' + ((inputMap.containsKey(paymenthistoryEndId) && inputMap.get(paymenthistoryEndId) != null) ? inputMap.get(paymenthistoryEndId) : ''));

      return accountInfoMap;
    }

    return null;
  }
  //Red Flagging End  

  //Mobility changes S
  public static string docPOMobilityDocumentListFetch(String inputJSON) {
    string responceJSON;
    string endpointURL;
    string username;
    string password;
    // inputJSON = '{\r\n\"Demographic\": [{\r\n                                \"customerSegment\": \"SUPER WOW\",\r\n                                \"professionType\": \"NOT EQUAL TO CA\",\r\n                                \"applicant_type\": \"Primary\"\r\n                }],\r\n                \"Loan_Parameter\": {\r\n                                \"product\": \"PRO\",\r\n                                \"loan_id\" : \"4234234\",\r\n                                \"processType\": \"PRE APPROVED\",\r\n                                \"dolVersion\": 1\r\n                }\r\n}\r\n';

    HttpRequest req = new HttpRequest();
    Mid_office_BRE_flow__c BRE_seg = Mid_office_BRE_flow__c.getValues('Doc PO Mobility Document List Fetch');

    if (BRE_seg != null) {
      endpointURL = '';
      endpointURL = BRE_seg.EndpointURL__c;
      password = BRE_seg.Password__c;
      username = BRE_seg.Username__c;
    } else
      System.debug('Mid_office_BRE_flow__c Not maintained properly');

    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(inputJSON);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    if (!Test.isRunningTest()) {
      Http http = new Http();

      HTTPResponse res = http.send(req);
      System.debug('*********bodyfinal : ' + req);
      responceJSON = res.getBody();

      /*
    DOM.Document doc = new DOM.Document();

    doc.load(result);

    DOM.XMLNode root = doc.getRootElement();
    System.debug('*************root: ' + root);
    refNo = root.getattribute('documentList', null);
    responceXML = parseResponse1(root);
    System.debug('*************mapOfMCPResult : ' + mapOfMCPResult);
       */

      System.debug('************* FINAL RESULT ' + responceJSON);

      return responceJSON;
    }
    return null;
  }
  //mobility changes E



  //********************** START Insurance Distribution

  public static String getInsuranceUnderwriterBRECall(String inputJSON) {
    String response = '';
    response = insuranceAPICallout(Label.mobileInsuranceUnderwriterCallEndpoint, inputJSON);
    return response;
  }

  public static String getEBIBRECall(String inputJSON) {
    String response = '';
    response = insuranceAPICallout(Label.InsuranceEBIEndpoint, inputJSON);
    return response;
  }
  // Motor API
  public static String calculatePremiumBRECall(String inputJSON, String src) {
    String response = '';
    //PREMUM CALLOUT FOR BAGIC MOTOR
    if (src == 'BAGIC_MOTOR') {
      System.debug(' ** PREMUM CALLOUT FOR BAGIC MOTOR');
      response = insuranceAPICallout(Label.InsuranceBAGICMotorPremiumEndpoint, inputJSON);
    } else if (src == 'AgeAgnostic') {
      // Age Agnostic
      System.debug(' ** PREMUM CALLOUT FOR Age Agnsotic');
      System.debug(' ** PREMUM CALLOUT FOR Age Agnsotic Input is : ' + inputJSON);
      response = insuranceAPICallout(Label.InsAgeAgnosticPremiumEndpoint, inputJSON);
    }
        // Added by Anurag for 22027 S
        else if (src == 'BFHCG')
        {
            System.debug(' ** PREMUM CALLOUT BFHCG');
            System.debug(' ** PREMUM CALLOUT FOR BFHCG Input is : '+inputJSON);
            // response = '{"errorcoderes": "0","errorlistres": [],"transactionid": 2159351,"genpremdtls": {"netpremium": "4935","finalpremium": "5823"}}';
            response = insuranceAzureAPICallout(Label.InsBFHCGPremiumEndpoint , inputJSON);
        }
        // Added by Anurag for 22027 E
    //PREMUM CALLOUT FOR OTHER <MAX/BALIC>
    else {
      System.debug(' ** PREMUM CALLOUT FOR OTHER <MAX/BALIC>');
      response = insuranceAPICallout(Label.InsurancePremiumEndpoint, inputJSON);
    }
    System.debug(' ** Response is > ' + response);
    return response;
  }
  //Motor API
  public static String appFormAPICall(String inputJSON, String productType) {
    String response = '';
    System.debug('productType:::' + productType);
    if (productType == 'MAX')
      response = insuranceAPICallout(Label.InsuranceAppFormEndpoint_MAX, inputJSON);
    else if (productType == 'BALIC')
      response = insuranceAPICallout(Label.InsuranceAppFormEndpoint_BALIC, inputJSON);
    else if (productType == 'BAGIC')
      response = insuranceAPICallout(Label.InsuranceBAGICMotorPolicyIssueEndpoint, inputJSON);
    else if (productType == 'AgeAgnostic')
      response = insuranceAPICallout(Label.InsAgeAgnosticPolicyEndpoint, inputJSON);
        // Added by Anurag for 22027
        else if(productType == 'BFHCG')
            response = insuranceAzureAPICallout(Label.InsBFHCGPolicyEndpoint, inputJSON);
    return response;
  }
    public static String billdeskBRECall(String inputJSON) {
        String response = '';
        response = insuranceAPICallout(Label.InsuranceBilldeskEndpoint, inputJSON);
        return response;
    }
  public static String insuranceAPICallout(String endPoint, String inputJSON) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endPoint);
    req.setMethod('POST');
    req.setbody(inputJSON);
    req.setTimeout(120000);
    String username = 'DEFAULT\\Admin';
    String password = 'Admin';
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Added by Anurag for 23343 S
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    // req.setHeader('Ocp-Apim-Subscription-Key', Label.InsuranceAzureKey);
    // Added by Anurag for 23343 E
  System.debug('req:::' + req);
  Http http = new Http();
  HTTPResponse res;
  try {
   if (!Test.isRunningTest())
    res = http.send(req);
   else {
    res = new HTTPResponse();
    res.setBody('');
   }
  } catch (System.CalloutException e) {
   System.debug('Callout error: ' + e);
   System.debug(res.toString());
  }
  return res.getBody();
 }
    // Added by Anurag for 20839 S
    public static String insuranceAzureAPICallout(String endPoint, String inputJSON) {
        System.debug('insuranceAzureAPICallout');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setbody(inputJSON);
        req.setTimeout(120000);
        String username = 'DEFAULT\\Admin';
        String password = 'Admin';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = EncodingUtil.base64Encode(headerValue);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Added by Anurag for 23343 S
        // req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        req.setHeader('Ocp-Apim-Subscription-Key', Label.InsuranceAzureKey);
        // Added by Anurag for 23343 E
    System.debug('req:::' + req);
    Http http = new Http();
    HTTPResponse res;
    try {
      if (!Test.isRunningTest())
        res = http.send(req);
      else {
        res = new HTTPResponse();
        res.setBody('');
      }
    } catch (System.CalloutException e) {
      System.debug('Callout error: ' + e);
      System.debug(res.toString());
    }
    return res.getBody();
  }
    // Added by Anurag for 20839 E
  /*API callout method for ECS*/
  public static String insuranceECSCallout(String endPoint, String inputJSON) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endPoint);
    req.setMethod('POST');
    req.setbody(inputJSON);
    req.setTimeout(120000);
    String resBody = '';
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Ocp-Apim-Subscription-Key', Label.ECSAPIKey);
    resBody = processAPIRequest(req);
    return resBody;
  }
  /*Method to handle API callout request*/
  public static String processAPIRequest(HttpRequest req) {
    Http http = new Http();
    HTTPResponse res = new HTTPResponse();
    try {
      if (!Test.isRunningTest())
        res = http.send(req);
      else {
        res.setBody('');
      }
      System.debug('Result:::' + res);
    } catch (System.CalloutException e) {
      System.debug('Callout error: ' + e);
    }
    return res.getBody();
  }
  public static String calculateProductBRECall(String inputJSON) {
    HttpRequest req = new HttpRequest();
    //req.setEndpoint('http://mwuat.bflapps.in:11000/BFLInstanceInsuranceWS/rest/InstanceInsurance');
    //propensityCallEndpoint
    //req.setEndpoint('http://mwprod.bflapps.in:11000/BFLInstanceInsuranceWS/rest/InstanceInsurance');
    req.setEndpoint(label.propensityCallEndpoint);
    req.setMethod('POST');
    req.setbody(inputJSON);
    req.setTimeout(120000);
    String username = 'DEFAULT\\Admin';
    String password = 'Admin';
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res;
    try {
      if (!Test.isRunningTest())
        res = http.send(req);
      else {
        // return dummy response FOR PRODUCT
        res = new HTTPResponse();
        res.setBody('{"custData":{"savingsFirstProduct":"ABC","savingsSecondProduct":"ABC","childFirstProduct":"ABC","childSecondProduct":"ABC","retirementFirstProduct":"ABC","retirementSecondProduct":"ABC","protectionFirstProduct":"ABC","protectionSecondProduct":"ABC","healthFirstProduct":"ABC","healthSecondProduct":"ABC","paFirstProduct":"ABC","paSecondProduct":"ABC","ciFirstProduct":"ABC","ciSecondProduct":"ABC"},"errorCode":"ABC","errorDescription":"ABC"}');
      }
    } catch (System.CalloutException e) {
      System.debug('Callout error: ' + e);
      System.debug(res.toString());
    }
    return res.getBody();
  }

  public static String calculateRSABRECall(String inputJSON) {
    HttpRequest req = new HttpRequest();
    //req.setEndpoint('http://104.43.10.139:8087/executionserver/rest/1/ruleServices/RSA%20Calculator/versions/0.0.1-SNAPSHOT/rules/RSA%20Calculator/computeRSA/executions'); 
    //rsaCallEndpoint
    //req.setEndpoint('http://138.91.38.234:8087/executionserver/rest/1/ruleServices/RSA%20Calculator/versions/0.0.1-SNAPSHOT/rules/RSA%20Calculator/computeRSA/executions');
    req.setEndpoint(label.rsaCallEndpoint);
    req.setMethod('POST');
    req.setbody(inputJSON);
    req.setTimeout(120000);
    String username = 'DEFAULT\\Admin';
    String password = 'Admin';
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res;
    try {
      if (!Test.isRunningTest())
        res = http.send(req);
      else {
        // return dummy response FOR RSA
        res = new HTTPResponse();
        res.setBody('{"lifeInsurance":{"protection":166700000,"savings":0,"child1":0,"child2":0,"pension":0},"healthInsurance":{"health":5000000.00,"personalAccident":200000000,"critical_Illness":15000000.00,"hospitalCash":5000000.00},"Action":true}');
      }
    } catch (System.CalloutException e) {
      System.debug('Callout error: ' + e);
      System.debug(res.toString());
    }
    return res.getBody();
  }
  //********************** END Insurance Distribution

  //BT Multiplier 10905 calculator.. YK
  public static String btMultiplierCalculator(String jsonRequestString) {
    Mid_office_BRE_flow__c btMultiplierCalculator = Mid_office_BRE_flow__c.getValues('BT Multiplier Calculator');
    HttpRequest req = new HttpRequest();
    req.setEndpoint(btMultiplierCalculator.EndpointURL__c);
    req.setMethod('POST');
    req.setbody(jsonRequestString);
    req.setTimeout(120000);
    String username = btMultiplierCalculator.Username__c;
    String password = btMultiplierCalculator.Password__c;
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    Http http = new Http();
    HTTPResponse res;

    if (!Test.isRunningTest())
      res = http.send(req);
    else {
      // return dummy response FOR RSA
      res = new HTTPResponse();
      res.setBody('{"bt_loans_output":[{"existing_loan_id": "5435345","loan_amount": 56000}],"Action": true}');
    }
    return res.getBody();
  }

  //FOS calculator Mahima start
  public MAP < String, String > callBRFOSCalculator(Map < string, string > valuesMap, boolean IsDLRMFos) {
    system.debug('valuesMap in calculate fos offer amount======>' + valuesMap);
    Map < string, string > fosResponse = new Map < string, string > ();
    system.debug('**0**');
    JSONGenerator gen = JSON.createGenerator(true);
    Mid_office_BRE_flow__c FOSEndpoint = new Mid_office_BRE_flow__c();
    system.debug('**1**');
    gen.writeStartObject();
    // gen.writeFieldName('request');
    System.debug('**2**' + valuesMap.get('monthlyObligation'));
    // System.debug('**3**');
    if (isDLRMFos) {
      gen.writeStringField('loan_id', valuesMap.get('loan_id') != null ? valuesMap.get('loan_id') : '');
      gen.writeStringField('financiar_name', valuesMap.get('financiar_name') != null ? valuesMap.get('financiar_name') : '');
      gen.writeNumberField('mortgage_loan_sanc_amt', valuesMap.get('mortgage_loan_sanc_amt') != null ? decimal.valueOf(valuesMap.get('mortgage_loan_sanc_amt')) : 0);
      gen.writeNumberField('mortgage_loan_mob', valuesMap.get('mob') != null ? Integer.valueOf(valuesMap.get('mob')) : 0);
      gen.writeStringField('type_of_degree', valuesMap.get('type_of_degree') != null ? valuesMap.get('type_of_degree') : '');
      gen.writeStringField('mortgage_loan_status', valuesMap.get('everTakenMortgageLoan') != null ? valuesMap.get('everTakenMortgageLoan') : '');
      gen.writeNumberField('unsecure_offer_amount', valuesMap.get('unsecure_offer_amount') != null ? decimal.valueOf(valuesMap.get('unsecure_offer_amount')) : 0);
      gen.writeStringField('customer_segment', valuesMap.get('segment1') != null ? valuesMap.get('segment1') : '');
      gen.writeStringField('branch_name', valuesMap.get('location') != null ? valuesMap.get('location') : '');
      gen.writeStringField('base_product', valuesMap.get('baseProduct') != null ? valuesMap.get('baseProduct') : '');
      gen.writeStringField('product_required', valuesMap.get('product_required') != null ? valuesMap.get('product_required') : '');
      gen.writeStringField('product', valuesMap.get('product') != null ? valuesMap.get('product') : '');

      //17834 Start of FOS Calculator changes for self-employed and salaried
      //gen.writeStringField('product', valuesMap.get('product') != null ? valuesMap.get('product') : '');
      gen.writeStringField('dateOfBirth', valuesMap.get('dateOfBirth') != null ? valuesMap.get('dateOfBirth') : '');
      gen.writeNumberField('annualRentalIncome', valuesMap.get('annualRentalIncome') != null ? Integer.valueOf(valuesMap.get('annualRentalIncome')) : 0);
      gen.writeNumberField('totalofLiveMortgageLoan', valuesMap.get('totalofLiveMortgageLoan') != null ? Integer.valueOf(valuesMap.get('totalofLiveMortgageLoan')) : 0);
      gen.writeStringField('incentiveFrequency', valuesMap.get('incentiveFrequency') != null ? valuesMap.get('incentiveFrequency') : '');
      //gen.writeStringField('product_required', valuesMap.get('product_required') != null ? valuesMap.get('product_required') : '');
      //gen.writeStringField('base_product', valuesMap.get('base_product') != null ? valuesMap.get('base_product') : '');
      gen.writeStringField('customer_segment', valuesMap.get('customer_segment') != null ? valuesMap.get('customer_segment') : '');
      gen.writeNumberField('maxPLAvailedBureau', valuesMap.get('maxPLAvailedBureau') != null ? Integer.valueOf(valuesMap.get('maxPLAvailedBureau')) : 0);
      gen.writeStringField('transactionType', valuesMap.get('transactionType') != null ? valuesMap.get('transactionType') : '');
      //gen.writeStringField('branch_name', valuesMap.get('branch_name') != null ? valuesMap.get('branch_name') : '');
      gen.writeNumberField('monthlyNetSalary', valuesMap.get('monthlyNetSalary') != null ? Integer.valueOf(valuesMap.get('monthlyNetSalary')) : 0);
      gen.writeNumberField('monthlyObligation', valuesMap.get('monthlyObligation') != null ? decimal.valueOf(valuesMap.get('monthlyObligation')) : 0);
      gen.writeNumberField('annualIncentiveAmount', valuesMap.get('annualIncentiveAmount') != null ? Integer.valueOf(valuesMap.get('annualIncentiveAmount')) : 0);
      gen.writeNumberField('maximumBLPLAmountL_C', valuesMap.get('maximumBLPLAmountL_C') != null ? decimal.valueOf(valuesMap.get('maximumBLPLAmountL_C')) : 0);
      gen.writeNumberField('maximumoutofClosedMortgageLoan', valuesMap.get('maximumoutofClosedMortgageLoan') != null ? decimal.valueOf(valuesMap.get('maximumoutofClosedMortgageLoan')) : 0);
      gen.writeNumberField('annualTurnoverShownonBooks', valuesMap.get('annualTurnoverShownonBooks') != null ? decimal.valueOf(valuesMap.get('annualTurnoverShownonBooks')) : 0);
      gen.writeNumberField('annualNetProfit', valuesMap.get('annualNetProfit') != null ? decimal.valueOf(valuesMap.get('annualNetProfit')) : 0);
      // 17834 End of FOS Calculator changes for self-employed and salaried
      //Bug 19469 - Changes in Salaried and self-employed FOS calculator S
      gen.writeStringField('financiar_name2', valuesMap.get('financiar_name2') != null ? valuesMap.get('financiar_name2') : '');
      System.debug('valuesMap.get(mortgage_loan_sanc_amt2)--->' + valuesMap.get('mortgage_loan_sanc_amt2'));
      gen.writeNumberField('mortgage_loan_sanc_amt2', (valuesMap.get('mortgage_loan_sanc_amt2') != null && valuesMap.get('mortgage_loan_sanc_amt2') != '') ? decimal.valueOf(valuesMap.get('mortgage_loan_sanc_amt2')) : 0.0);
      gen.writeNumberField('mortgage_loan_mob2', (valuesMap.get('mortgage_loan_mob2') != null && valuesMap.get('mortgage_loan_mob2') != '') ? Integer.valueOf(valuesMap.get('mortgage_loan_mob2')) : 0);
      gen.writeStringField('dateOfRegistration', (valuesMap.get('dateOfRegistration') != null && valuesMap.get('dateOfRegistration') != '') ? valuesMap.get('dateOfRegistration') : '');
      //Bug 19469 - Changes in Salaried and self-employed FOS calculator E
    } else
      //Added by Mahima- 13484- DLRM mortgage offer-- end--
    {
      gen.writeStringField('customerName', valuesMap.get('customerName') != null ? valuesMap.get('customerName') : '');
      gen.writeStringField('contactNo', valuesMap.get('contactNo') != null ? valuesMap.get('contactNo') : '');
      gen.writeStringField('location', valuesMap.get('location') != null ? valuesMap.get('location') : '');
      gen.writeStringField('baseProduct', valuesMap.get('baseProduct') != null ? valuesMap.get('baseProduct') : '');
      gen.writeStringField('segment', valuesMap.get('segment') != null ? valuesMap.get('segment') : '');
      gen.writeStringField('product', valuesMap.get('product') != null ? valuesMap.get('product') : '');
      gen.writeStringField('everTakenMortgageLoan', valuesMap.get('everTakenMortgageLoan') != null ? valuesMap.get('everTakenMortgageLoan') : '');
      gen.writeStringField('latestMortgageLoanFinancier', valuesMap.get('latestMortgageLoanFinancier') != null ? valuesMap.get('latestMortgageLoanFinancier') : '');
      gen.writeNumberField('mob', valuesMap.get('mob') != null ? Integer.valueOf(valuesMap.get('mob')) : 0);
      gen.writeStringField('natureOfBusiness', valuesMap.get('natureOfBusiness') != null ? valuesMap.get('natureOfBusiness') : '');
      gen.writeNumberField('totalofLiveMortgageLoan', valuesMap.get('totalofLiveMortgageLoan') != null ? decimal.valueOf(valuesMap.get('totalofLiveMortgageLoan')) : 0);
      gen.writeNumberField('maximumoutofClosedMortgageLoan', valuesMap.get('maximumoutofClosedMortgageLoan') != null ? decimal.valueOf(valuesMap.get('maximumoutofClosedMortgageLoan')) : 0);
      gen.writeNumberField('maximumBLPLAmountL_C', valuesMap.get('maximumBLPLAmountL_C') != null ? decimal.valueOf(valuesMap.get('maximumBLPLAmountL_C')) : 0);
      gen.writeNumberField('annualTurnoverShownonBooks', valuesMap.get('annualTurnoverShownonBooks') != null ? decimal.valueOf(valuesMap.get('annualTurnoverShownonBooks')) : 0);
      //gen.writeStringField('annualTurnoverShownonBooks', valuesMap.get('annualTurnoverShownonBooks') != null ? valuesMap.get('annualTurnoverShownonBooks') : '0');
      gen.writeNumberField('annualNetProfit', valuesMap.get('annualNetProfit') != null ? decimal.valueOf(valuesMap.get('annualNetProfit')) : 0);
      system.debug('valuesMap.get(monthlyObligation)===' + valuesMap.get('monthlyObligation'));
      gen.writeNumberField('monthlyObligation', valuesMap.get('monthlyObligation') != null ? decimal.valueOf(valuesMap.get('monthlyObligation')) : 0);
      gen.writeStringField('specialization', valuesMap.get('specialization') != null ? valuesMap.get('specialization') : '');
      // Bug 19469 - Changes in Salaried and self-employed FOS calculator S
      gen.writeStringField('dateOfBirth', valuesMap.get('dateOfBirth') != null ? valuesMap.get('dateOfBirth') : '');
      gen.writeStringField('financiar_name2', valuesMap.get('financiar_name2') != null ? valuesMap.get('financiar_name2') : '');
      gen.writeNumberField('mortgage_loan_sanc_amt2', valuesMap.get('mortgage_loan_sanc_amt2') != null ? decimal.valueOf(valuesMap.get('mortgage_loan_sanc_amt2')) : 0);
      gen.writeNumberField('mortgage_loan_mob2', valuesMap.get('mortgage_loan_mob2') != null ? Integer.valueOf(valuesMap.get('mortgage_loan_mob2')) : 0);
      gen.writeStringField('dateOfRegistration', valuesMap.get('dateOfRegistration') != null ? valuesMap.get('dateOfRegistration') : '');
      //Bug 19469 - Changes in Salaried and self-employed FOS calculator E 
    }
    gen.writeEndObject();
    String jsonString = gen.getAsString();
    system.debug('jsonString=======>' + jsonString);
    HttpRequest req = new HttpRequest();
    FOSEndpoint = Mid_office_BRE_flow__c.getValues('FOSCalculator');
    system.debug('FOSEndpoint ' + FOSEndpoint);
    if (FOSEndpoint != null) {
      endpointURL = '';
      if (isDLRMFos)
        endpointURL = FOSEndpoint.FASScripURL__c;
      else
        endpointURL = FOSEndpoint.EndpointURL__c;

      username = FOSEndpoint.Username__c;
      password = FOSEndpoint.Password__c;
    }
    System.Debug('endpointURL' + endpointURL);
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = EncodingUtil.base64Encode(headerValue);
    System.debug('UserName--->' + username + ' ###  Password---->' + password);
    System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
    req.setHeader('Authorization', 'Basic ' + authorizationHeader);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    FOSCalculatorRes responseFOS = new FOSCalculatorRes();
    if (!Test.isRunningTest()) {
      Http http = new Http();
      HTTPResponse res = http.send(req);


      String result = res.getBody();
      system.debug('result======>' + result);
      try {
        responseFOS = FOSCalculatorRes.parse(result);
        system.debug('responseFOS======>' + responseFOS);
        // 17834 Start of FOS Calculator changes for self-employed and salaried
        /*if (isDLRMFos) 
            {
                fosResponse.put('bt_offer_amount', responseFOS.bt_offer_amount);
                fosResponse.put('offer_type', responseFOS.offer_type);
                fosResponse.put('non_bt_offer_amount', responseFOS.non_bt_offer_amount);
            } 
            else 
            {
                fosResponse.put('offerAmount', responseFOS.offerAmount);
                fosResponse.put('offerType', responseFOS.offerType);
                fosResponse.put('campaignCode', responseFOS.campaignCode);
            }*/
        fosResponse.put('bt_offer_amount', responseFOS.bt_offer_amount);
        fosResponse.put('offer_type', responseFOS.offer_type);
        fosResponse.put('non_bt_offer_amount', responseFOS.non_bt_offer_amount);
        fosResponse.put('descriptions', responseFOS.descriptions);
        fosResponse.put('offerAmount', responseFOS.offerAmount);
        fosResponse.put('offerType', responseFOS.offerType);
        fosResponse.put('campaignCode', responseFOS.campaignCode);
        fosResponse.put('age', responseFOS.age);
        fosResponse.put('financier_category', responseFOS.financier_category);
        // 17834 End of FOS Calculator changes for self-employed and salaried
      } catch (exception ex) {
        fosResponse.put('errormsg', result);
      }
    } else {
      fosResponse.put('bt_offer_amount', '123');
      fosResponse.put('non_bt_offer_amount', '123');
      fosResponse.put('offer_type', '123');
      fosResponse.put('bt_offer_amount', '123');
    }
    return fosResponse;
  }
  //FOS calculator Mahima end

  /*
   method owner : Akshata Rajmane
   date : 14 /06/2017 
   purpose : bre call for get loan status : Loan Status Api inhancement -Bug 12987
   */
  public MAP < String, Object > LoanStatusAPIService(Map < string, string > valuesMap) {
    //system.debug('valuesMap======>' + valuesMap);
    Map < string, Object > LoanStatusAPIResponse = new Map < string, Object > ();
    List < Policy_Master__c > resultOfStatus = new List < Policy_Master__c > ();
    String endpointURL, key; //15448 Added key 
    LoanStatusRequest charges;
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('dealId', valuesMap.get('DealID'));
    gen.writeEndObject();

    String jsonString = gen.getAsString();
    system.debug('jsonString=======>' + jsonString);
    HttpRequest req = new HttpRequest();
    Mid_office_BRE_flow__c LoanStatusAPIEndpoint = Mid_office_BRE_flow__c.getValues('Loan Status Api Service');
    if (LoanStatusAPIEndpoint != null) {
      endpointURL = '';
      //15448 S
      if (LoanStatusAPIEndpoint.EndpointURL__c != null && LoanStatusAPIEndpoint.FASScripURL__c != null) {
        endpointURL = LoanStatusAPIEndpoint.EndpointURL__c;
        key = LoanStatusAPIEndpoint.FASScripURL__c; //15448
      } //15448 E
    }
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    req.setHeader('Ocp-Apim-Subscription-Key', key); //15448 ADDED KEY
    if (!Test.isRunningTest()) {
      Http http = new Http();
      HTTPResponse res = http.send(req);
      String result = res.getBody();
      system.debug('result======>' + result);
      //  result = '{"responseCode": 0,"responseMessage": "Success","tabLoanStatusApi": [{"agreementId": "123","agreementNo": "4020HL1234567","loanStatus": "WIP","appForms": "23134567788"},{"agreementId": "123","agreementNo": "4020HL1234567","loanStatus": "C","appForms": "23134567788"}]}';
      charges = LoanStatusRequest.parseResponse(result);
      system.debug('charges======>' + charges);
      LoanStatusAPIResponse.put('response', charges.responseMessage);
      LoanStatusAPIResponse.put('listOfLoanStatus', charges.tabLoanStatusApi);

    } else {
      String result = '{"responseCode": 0,"responseMessage": "Success","tabLoanStatusApi": [{"agreementId": "123","agreementNo": "4020HL1234567","loanStatus": "WIP","appForms": "23134567788"},{"agreementId": "123","agreementNo": "4020HL1234567","loanStatus": "C","appForms": "23134567788"}]}';
      charges = LoanStatusRequest.parseResponse(result);
      //system.debug('charges======>' + charges);
      LoanStatusAPIResponse.put('response', charges.responseMessage);
      LoanStatusAPIResponse.put('listOfLoanStatus', charges.tabLoanStatusApi);
    }

    system.debug('charges======>' + LoanStatusAPIResponse);
    return LoanStatusAPIResponse;
  }
  //Getting Mail Triggers on Britching loan approval 
  public Map < String, String > CallBREMailTriggerJson(MAP < String, String > mapOfParameters) {
    try {
      system.debug('Start of CallBREMailTrigger method');
      if (mapOfParameters != null && mapOfParameters.size() > 0) {
        for (string mapKey: mapOfParameters.keyset()) {
          system.debug('Key Name --> ' + mapKey + ' Key Value --> ' + mapOfParameters.get(mapKey));
        }
      }
      Map < string, string > MailTriggerResponces = new Map < string, string > ();

      JSONGenerator gen = JSON.createGenerator(true);

      //Start of main object
      gen.writeStartObject();
      //Start of profit_loss_statement
      gen.writeFieldName('profit_loss_statement');
      gen.writeStartObject();
      // bug 15633 changed integer.value to decimal.value for 4 values
      gen.writeNumberField('growth_in_sales_turnover', mapOfParameters.get('growth_in_sales_turnover') != null ? Double.valueof(mapOfParameters.get('growth_in_sales_turnover')) : 0);
      gen.writeNumberField('cy_net_profit', mapOfParameters.get('cy_net_profit') != null ? Decimal.valueof(mapOfParameters.get('cy_net_profit')) : 0);
      gen.writeNumberField('cy_depriciation', mapOfParameters.get('cy_depriciation') != null ? Decimal.valueof(mapOfParameters.get('cy_depriciation')) : 0);
      gen.writeNumberField('py_net_profit', mapOfParameters.get('py_net_profit') != null ? Decimal.valueof(mapOfParameters.get('py_net_profit')) : 0);
      gen.writeNumberField('py_depriciation', mapOfParameters.get('py_depriciation') != null ? Decimal.valueof(mapOfParameters.get('py_depriciation')) : 0);
      gen.writeNumberField('cy_audited_turnover', mapOfParameters.get('cy_audited_turnover') != null ? Integer.valueof(mapOfParameters.get('cy_audited_turnover')) : 0);
      gen.writeNumberField('debtor_turnover_days', mapOfParameters.get('debtor_turnover_days') != null ? Double.valueof(mapOfParameters.get('debtor_turnover_days')) : 0);
      gen.writeNumberField('annualised_bto', mapOfParameters.get('annualised_bto') != null ? Double.valueof(mapOfParameters.get('annualised_bto')) : 0);
      gen.writeNumberField('creditor_turnover_days', mapOfParameters.get('creditor_turnover_days') != null ? Double.valueof(mapOfParameters.get('creditor_turnover_days')) : 0);
      gen.writeNumberField('inward_return', mapOfParameters.get('inward_return') != null ? Integer.valueof(mapOfParameters.get('inward_return')) : 0);
      gen.writeNumberField('cy_capital', mapOfParameters.get('cy_capital') != null ? Integer.valueof(mapOfParameters.get('cy_capital')) : 0);
      gen.writeNumberField('py_capital', mapOfParameters.get('py_capital') != null ? Integer.valueof(mapOfParameters.get('py_capital')) : 0);
      gen.writeNumberField('cy_reserve_surplus', mapOfParameters.get('cy_reserve_surplus') != null ? Integer.valueof(mapOfParameters.get('cy_reserve_surplus')) : 0);
      gen.writeNumberField('py_reserve_surplus', mapOfParameters.get('py_reserve_surplus') != null ? Integer.valueof(mapOfParameters.get('py_reserve_surplus')) : 0);
      gen.writeNumberField('cy_Total_ouside_borrowings', mapOfParameters.get('cy_Total_ouside_borrowings') != null ? Integer.valueof(mapOfParameters.get('cy_Total_ouside_borrowings')) : 0);
      gen.writeNumberField('py_Total_ouside_borrowings', mapOfParameters.get('py_Total_ouside_borrowings') != null ? Integer.valueof(mapOfParameters.get('py_Total_ouside_borrowings')) : 0);
      gen.writeNumberField('sum_bounce_inward', mapOfParameters.get('sum_bounce_inward') != null ? Double.valueof(mapOfParameters.get('sum_bounce_inward')) : 0);
      gen.writeNumberField('sum_db_inward', mapOfParameters.get('sum_db_inward') != null ? Double.valueof(mapOfParameters.get('sum_db_inward')) : 0);
      gen.writeEndObject();
      //end of profit_loss_statement
      //Start of Loan_Parameter
      gen.writeFieldName('Loan_Parameter');
      gen.writeStartObject();
      gen.writeNumberField('approved_loan_amount', mapOfParameters.get('approved_loan_amount') != null ? Decimal.valueof(mapOfParameters.get('approved_loan_amount')) : 0);
      gen.writeStringField('scheme_name', mapOfParameters.get('scheme_name'));
      gen.writeEndObject();
      //end of Loan_Parameter
      //Start of Generic 
      gen.writeFieldName('Generic');
      gen.writeStartObject();
      gen.writeStringField('branch_name', mapOfParameters.get('branch_name'));
      gen.writeEndObject();
      //End of Generic
      //Creating Bank Summary Related Values.
      gen.writeFieldName('Bank_summary');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeStringField('loan_id', mapOfParameters.get('loan_id'));
      //Start: Changes Made by Rohan on 30-06-17 for Enhancement ID: 12500 and Bug ID: 13511 
      //gen.writeNumberField('avg_od_cc_utilisation', mapOfParameters.get('avg_od_cc_utilisation') != null ? Integer.valueof(mapOfParameters.get('avg_od_cc_utilisation')) : 0);
      gen.writeNumberField('avg_od_cc_utilisation', mapOfParameters.get('avg_od_cc_utilisation') != null ? Double.valueof(mapOfParameters.get('avg_od_cc_utilisation')) : 0.0);
      //End: Changes Made by Rohan on 30-06-17 for Enhancement ID: 12500 and Bug ID: 13511 
      //Start: Changes Made by Rohan on 30-06-17 for Enhancement ID: 12500 and Bug ID: 13511 
      //gen.writeNumberField('avg_od_cc_limit', mapOfParameters.get('avg_od_cc_limit') != null ? Integer.valueof(mapOfParameters.get('avg_od_cc_limit')) : 0);
      gen.writeNumberField('avg_od_cc_limit', mapOfParameters.get('avg_od_cc_limit') != null ? Double.valueof(mapOfParameters.get('avg_od_cc_limit')) : 0.0);
      ////End: Changes Made by Rohan on 30-06-17 for Enhancement ID: 12500 and Bug ID: 13511 
      gen.writeStringField('applicant_type', mapOfParameters.get('applicant_type'));
      //gen.writeStringField('applicant_id', mapOfParameters.get('applicant_id'));
      gen.writeNumberField('BL_od_cc_utilisation', mapOfParameters.get('BL_od_cc_utilisation') != null ? Double.valueof(mapOfParameters.get('BL_od_cc_utilisation')) : 0);
      gen.writeEndObject();
      gen.writeEndArray();
      //End of Bank Summarry 
      //Creating Demographic Related Values.
      gen.writeFieldName('Demographic');
      gen.writeStartArray();
      gen.writeStartObject();
      //Start: Changes Made by Rohan on 12-07-17 for Enhancement ID: 12500 and Bug ID: 13437
      //gen.writeStringField('customer_segment', mapOfParameters.get('customer_segment'));
      gen.writeStringField('customer_segment', mapOfParameters.get('Credit_Customer_Segment__c'));
      //End: Changes Made by Rohan on 30-06-17 for Enhancement ID: 12500 and Bug ID: 13437 
      //Start: Changes Made by Rohan on 30-06-17 for Enhancement ID: 12500 and Bug ID: 13437
      //gen.writeNumberField('total_employment_vintage', mapOfParameters.get('total_employment_vintage__c') != null ? Integer.valueof(mapOfParameters.get('total_employment_vintage__c')) : 0);
      gen.writeNumberField('total_employment_vintage', mapOfParameters.get('Vintage_with_BAL__c') != null ? Integer.valueof(mapOfParameters.get('Vintage_with_BAL__c')) : 0);
      //End: Changes Made by Rohan on 30-06-17 for Enhancement ID: 12500 and Bug ID: 13437 
      gen.writeStringField('pan', mapOfParameters.get('pan'));
      gen.writeStringField('nature_of_business', mapOfParameters.get('nature_of_business'));
      gen.writeStringField('industry', mapOfParameters.get('Main_Industry__c'));
      gen.writeStringField('sub_industry', mapOfParameters.get('Main_Sub_Industry__c'));
      gen.writeStringField('sector', mapOfParameters.get('Main_Sector__c'));
      gen.writeStringField('applicant_type', mapOfParameters.get('applicant_type'));
      gen.writeEndObject();
      gen.writeEndArray();
      //End of Demographic
      //Creating cibil_lst Related Values.
      gen.writeFieldName('Cibil_lst');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeNumberField('CIBIL_Score', mapOfParameters.get('CIBIL_Score') != null ? Integer.valueof(mapOfParameters.get('CIBIL_Score')) : 0);
      //gen.writeStringField('loan_id', mapOfParameters.get('loan_id')); 
      gen.writeNumberField('cibil_enquiry', mapOfParameters.get('cibil_enquiry') != null ? Integer.valueof(mapOfParameters.get('cibil_enquiry')) : 0);
      gen.writeStringField('applicant_Type', mapOfParameters.get('applicant_type'));
      gen.writeEndObject();
      gen.writeEndArray();
      //End of Demographic 
      //Creating existing_loan Related Values.
      gen.writeFieldName('existing_loan');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeNumberField('monthly_loan_obligations', mapOfParameters.get('monthly_loan_obligations') != null ? Decimal.valueof(mapOfParameters.get('monthly_loan_obligations')) : 0);
      gen.writeStringField('applicant_type', mapOfParameters.get('applicant_type'));
      gen.writeEndObject();
      gen.writeEndArray();
      //End of existing_loan
      gen.writeEndObject();
      //End of Main Object  

      String jsonString = gen.getAsString();
      System.debug('jsonString=======>' + JSON.serialize(jsonString));
      //System.Debug('Json string length' + jsonString.length());
      HttpRequest req = new HttpRequest();
      Mid_office_BRE_flow__c emailTrigger = Mid_office_BRE_flow__c.getValues('Email_Triggers');
      username = emailTrigger.Username__c;
      password = emailTrigger.Password__C;
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      //system.debug('authorizationHeader --->' + authorizationHeader);
      if (emailTrigger != null) {
        endpointURL = '';
        endpointURL = emailTrigger.EndpointURL__c;
      }
      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      if (!Test.isRunningTest()) {
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.Debug('Request ' + req);
        if (res != null) {
          String result = res.getBody();
          system.debug('result======>' + result);
          MailTriggerResponse emailTriggerResponse = MailTriggerResponse.parse(result);
          if (emailTriggerResponse != null) {
            //system.debug('Email Triggers ======>' + emailTriggerResponse);
            Email_Trigger_Configuration__mdt[] lst_EmailTriggersMdt = [select TriggerName__c, Rule_A__c, Rule_A_Condition__c, Rule_B__c, Rule_B_Condition__c,
                                                                       Rule_C__c, Rule_C_Condition__c, Rule_D__c, Rule_D_Condition__c
                                                                       From Email_Trigger_Configuration__mdt
                                                                       ];
            if (mapOfParameters.get('Applicant_ID') != null) {
              Applicant__c objApplicant = [Select ID, Name from Applicant__c where ID =: mapOfParameters.get('Applicant_ID')];
              if (objApplicant != null) {
                objApplicant.Controllership_BRE_Responce__c = result;
                //system.debug('Calling ComposeAndSendControllershipEmail');                
                ComposeAndSendControllershipEmail(emailTriggerResponse, lst_EmailTriggersMdt, mapOfParameters);
                update objApplicant;
              }
            }

          }
          MailTriggerResponces.put('result', 'test');
        }
      }
    } catch (Exception ex) {
      system.debug('Exception occured in CallBREMailTriggerJson and details are Line Number ' + ex.getLineNumber() + 'Details are ' + ex);
    }
    //return MailTriggerResponces;
    return null;
  }
  public void ComposeAndSendControllershipEmail(MailTriggerResponse emailTriggerResponse, Email_Trigger_Configuration__mdt[] lst_EmailTriggersMdt, MAP < string, string > mapOfParameters) {
    //system.debug('ComposeAndSendControllershipEmail is called ');
    transient string loanID;
    Opportunity LoanDetails;
    boolean isActiveFlag = false;
    string templateName = 'Controllership BRE Trigger Email';
    string[] toAddresses = new List < String > ();
    String mailBody;
    string Subject;
    String[] CC;
    string[] bcc;
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //select NCM__c,RCM__c,ACM__c,CEO__c,Area_SM__c,Zonal_SM__c,National_SM__c,Regional_SM__c,RISK__c from Opportunity where ID =
    if (mapOfParameters != null && mapOfParameters.get('loan_id') != null) {
      loanID = mapOfParameters.get('loan_id');
      LoanDetails = [select NCM__c, NCM__r.email, NCM__r.IsActive, RCM__c, RCM__r.email, RCM__r.IsActive, ACM__c, ACM__r.email, ACM__r.IsActive, CEO__c, CEO__r.email, CEO__r.IsActive, Area_SM__c, Area_SM__r.email, Area_SM__r.IsActive, Zonal_SM__c, Zonal_SM__r.email, Zonal_SM__r.IsActive, National_SM__c, National_SM__r.email, National_SM__r.IsActive, Regional_SM__c, Regional_SM__r.email, Regional_SM__r.IsActive, RISK__c, RISK__r.email, RISK__r.IsActive
                     from Opportunity where ID =: loanID
                     ];
    }
    EmailTemplate tempID = [SELECT Id, HTMLValue, Name, Body FROM EmailTemplate WHERE name =: templateName];
    if (tempID != null) {
      if (tempID.HTMLValue != null && tempID.HTMLValue != '') {
        List < SMS_Sent__c > smslist = new List < SMS_Sent__c > ();
        //Adding Trigger Condition to send mail for every trigger seperatly 
        for (MailTriggerResponse.cls_Triggers_Output objTrigger: emailTriggerResponse.Triggers_Output) {
          if (objTrigger != null && objTrigger.trigger_name != null && objTrigger.trigger_name != '') {
            string DyamicBody = CreateDynamicTableForControllershipEmail(objTrigger, lst_EmailTriggersMdt, mapOfParameters);

            if (DyamicBody != null && DyamicBody != '') {
              ////system.debug('Return string is ' + DyamicBody);  
              ////system.debug('HTML Content is ' + tempID.HTMLValue);
              mailBody = tempID.HTMLValue;
              //system.debug('Before Replace email body is ' + mailBody);
              mailBody = mailBody.replace('##Opportunity_Name##', mapOfParameters.get('Opportunity_Name') != null ? String.valueof(mapOfParameters.get('Opportunity_Name')) : '');
              mailBody = mailBody.replace('##Loan_Application_Number##', mapOfParameters.get('Loan_Application_Number') != null ? String.valueof(mapOfParameters.get('Loan_Application_Number')) : '');
              mailBody = mailBody.replace('##Applicant_Name##', mapOfParameters.get('Applicant_Name') != null ? String.valueof(mapOfParameters.get('Applicant_Name')) : '');
              mailBody = mailBody.replace('##PAN_Number##', mapOfParameters.get('pan') != null ? String.valueof(mapOfParameters.get('pan')) : '');
              mailBody = mailBody.replace('##Branch##', mapOfParameters.get('branch_name') != null ? String.valueof(mapOfParameters.get('branch_name')) : '');
              mailBody = mailBody.replace('##Product##', mapOfParameters.get('Loan_Product') != null ? String.valueof(mapOfParameters.get('Loan_Product')) : '');
              mailBody = mailBody.replace('##Dynamic_Content##', DyamicBody);
              //mailBody = mailBody.replace('##Dynamic_Content##',DyamicBody.replace('"','\"'));   
              mailBody = mailBody.replace('"', '\"');
              //system.debug('Controllership eMail Body ' + mailBody);
              Subject = ' Controller-ship trigger email for Loan Application Number :-' + (mapOfParameters.get('Loan_Application_Number') != null ? String.valueof(mapOfParameters.get('Loan_Application_Number')) : '');
              //system.debug('Subject for email is ' + Subject);
              ////system.debug('Value is ' + emailRecepient);
              if (objTrigger.mail_alert != null) {
                string[] mailRecepient = objTrigger.mail_alert.split(',');
                if (mailRecepient != null && mailRecepient.size() > 0 && LoanDetails != null) {
                  for (string strRecepient: mailRecepient) {
                    if (toAddresses == null)
                      toAddresses = new List < String > ();
                      if (strRecepient == 'NCM' && LoanDetails.NCM__c != null && LoanDetails.NCM__r.IsActive == true && (LoanDetails.NCM__r.email != null && !LoanDetails.NCM__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.NCM__r.email);
                        //break;
                      } else
                        isActiveFlag = true;

                      if (strRecepient == 'RCM' && LoanDetails.RCM__c != null && LoanDetails.RCM__r.IsActive == true && (LoanDetails.RCM__r.email != null && !LoanDetails.RCM__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.RCM__r.email);
                      } else
                        isActiveFlag = true;
                      if (strRecepient == 'ACM' && LoanDetails.ACM__c != null && LoanDetails.ACM__r.IsActive == true && (LoanDetails.ACM__r.email != null && !LoanDetails.ACM__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.ACM__r.email);
                      } else
                        isActiveFlag = true;
                      if (strRecepient == 'ZCM' && LoanDetails.CEO__c != null && LoanDetails.CEO__r.IsActive == true && (LoanDetails.CEO__r.email != null && !LoanDetails.CEO__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.CEO__r.email);
                      } else
                        isActiveFlag = true;
                      if (strRecepient == 'ASM' && LoanDetails.Area_SM__c != null && LoanDetails.Area_SM__r.IsActive == true && (LoanDetails.Area_SM__r.email != null && !LoanDetails.Area_SM__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.Area_SM__r.email);
                      } else
                        isActiveFlag = true;
                      if (strRecepient == 'ZSM' && LoanDetails.Zonal_SM__c != null && LoanDetails.Zonal_SM__r.IsActive == true && (LoanDetails.Zonal_SM__r.email != null && !LoanDetails.Zonal_SM__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.Zonal_SM__r.email);
                      } else
                        isActiveFlag = true;
                      if (strRecepient == 'NSM' && LoanDetails.National_SM__c != null && LoanDetails.National_SM__r.IsActive == true && (LoanDetails.National_SM__r.email != null && !LoanDetails.National_SM__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.National_SM__r.email);
                      } else
                        isActiveFlag = true;
                      if (strRecepient == 'RSM' && LoanDetails.Regional_SM__c != null && LoanDetails.Regional_SM__r.IsActive == true && (LoanDetails.Regional_SM__r.email != null && !LoanDetails.Regional_SM__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.Regional_SM__r.email);
                      } else
                        isActiveFlag = true;
                      if (strRecepient == 'NRM' && LoanDetails.RISK__c != null && LoanDetails.RISK__r.IsActive == true && (LoanDetails.RISK__r.email != null && !LoanDetails.RISK__r.email.contains('='))) {
                        toAddresses.add(LoanDetails.RISK__r.email);
                      } else
                        isActiveFlag = true;

                      if (strRecepient == 'HO') {
                        string hoEmailIDs = Label.Controllership_Ho_Email_IDs;
                        if (hoEmailIDs != null && hoEmailIDs != '') {
                          for (string strhoEmail: hoEmailIDs.Split(',')) {
                            toAddresses.Add(strhoEmail);
                          }
                        }
                      } else
                        isActiveFlag = true;

                  }
                }
              }
              //isActiveFlag = true;
              if (isActiveFlag == true) {
                string defaultEmailRecepient = Label.Controllership_default_email_receiver;
                if (defaultEmailRecepient != null && defaultEmailRecepient != '') {
                  for (string tempEmail: defaultEmailRecepient.split(';')) {
                    toAddresses.Add(tempEmail);
                  }
                  //toAddresses = defaultEmailRecepient.split(';');
                  //toAddresses.Add(defaultEmailRecepient.split(';'));
                }
              }
              //system.debug('Recepient of controllership email are ' + toAddresses);
              if (!Test.isRunningTest()) {
                //system.debug('Test is not running now sending the email');
                string emailAddressses = '';
                if (toAddresses != null)
                  emailAddressses = string.join(toAddresses, ',');

                //system.debug('Email addresses are ' + emailAddressses );
                try {
                  //system.debug('Before GeneralUtilities.SendEmailWithBodyUsingBAFLLogix');
                  System.Debug('Trigger_name --> ' + objTrigger.trigger_name + ' and recepient details are toAddresses ' + toAddresses + ' CC ' + CC + ' BCC ' + bcc);
                  BAFL_EmailServicesLogix.EmailServicesPort stub = new BAFL_EmailServicesLogix.EmailServicesPort();
                  stub.timeout_x = 120000;
                  BAFL_EmailServicesLogix.SendEmailResponse er = stub.SendEmail('noreply@bajajfinserv.in',
                      'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com',
                      toAddresses,
                      CC,
                      bcc,
                      'Normal',
                      new BAFL_EmailServicesLogix.Attachment[] {},
                      Subject,
                      mailBody,
                      'bajaj');
                  //GeneralUtilities.SendEmailWithBodyUsingBAFLLogix(toAddresses,CC,bcc,Subject,mailBody);
                  //system.debug('after GeneralUtilities.SendEmailWithBodyUsingBAFLLogix');
                  SMS_Sent__c objSMS = new SMS_Sent__c();
                  objSMS.LoanApplication__c = loanID;
                  objSMS.Name = Subject;
                  objSMS.Email_sent__c = true;
                  objSMS.Email_sent_time__c = system.now();
                  objSMS.Controllership_Email_SentAt__c = emailAddressses;
                  //objSMS.SMS_Text_Sent__c = mailBody;
                  objSMS.Status__c = 'Sent';
                  smslist.add(objSMS);
                  //system.debug('SMS List object is ' + smsList);
                  toAddresses = null;
                  CC = null;
                  bcc = null;
                } catch (Exception ex) {
                  //system.debug('Exception occured in ComposeAndSendControllershipEmail details are ' + ex);
                  SMS_Sent__c objSMS = new SMS_Sent__c();
                  objSMS.LoanApplication__c = loanID;
                  objSMS.Name = Subject;
                  objSMS.Email_sent__c = false;
                  objSMS.Email_sent_time__c = system.now();
                  objSMS.Controllership_Email_SentAt__c = emailAddressses;
                  //objSMS.SMS_Text_Sent__c = mailBody;
                  objSMS.Status__c = 'Pending';
                  smslist.add(objSMS);
                  //system.debug('SMS List object is ' + smsList);
                  //system.debug('Exception occured in ComposeAndSendControllershipEmail details are ' + ex);
                }
              } else
                //system.debug('Else condition for if running test is hitted');
                toAddresses.clear();
            }
          }
        }
        if (smslist != null && smslist.size() > 0)
          insert smslist;
      }
    }
  }

  public string CreateDynamicTableForControllershipEmail(MailTriggerResponse.cls_Triggers_Output objTrigger, Email_Trigger_Configuration__mdt[] lst_EmailTriggersMdt, MAP < string, string > mapParameters) {
    string emailBodyHead = '<table><tr><td><b>' + 'Trigger Name' + '</b></td><td><b>' + 'Rule Name' + '</b></td><td><b>' + 'Parameter Value' + '</b></td></tr>';
    string emailBody = '';
    List < string > lst_MailBodies = new List < string > ();

    //for(MailTriggerResponse.cls_Triggers_Output objTrigger : emailTriggerResponse.Triggers_Output)
    //{
    if (objTrigger != null && lst_EmailTriggersMdt != null) {
      //system.debug('Trigger Name' + objTrigger.trigger_name);    
      for (Email_Trigger_Configuration__mdt objMetadata: lst_EmailTriggersMdt) {
        string strMetaDataTgr = objMetadata.TriggerName__c.replaceAll('\\s+', '');
        string strTgr = objTrigger.trigger_name.replaceAll('\\s+', '');
        string strTemp = '';
        if (strMetaDataTgr.equalsIgnoreCase(strTgr)) {
          //system.debug('Matched Trigger Name' + objTrigger.trigger_name);
          if (objTrigger.rule != null && objTrigger.rule != '') {
            string[] ruleArray = objTrigger.rule.split(',');
            if (ruleArray != null) {
              for (string rule: ruleArray) {
                if (rule != null && rule != '') {
                  if (rule.equalsIgnoreCase('A') && objMetadata.Rule_A__c != null) {
                    strTemp = '';
                    strTemp = objTrigger.trigger_name.replace('<', '&lt;').replace('>', '&gt;');
                    emailBody += '<tr><td>' + strTemp + '</td>';
                    strTemp = '';
                    strTemp = objMetadata.Rule_A__c.replace('<', '&lt;').replace('>', '&gt;');
                    emailBody += '<td>' + strTemp + '</td>';
                    string strnestedValueTable = CreateRuleValueTable(mapParameters, objMetadata.Rule_A_Condition__c);
                    if (strnestedValueTable != '')
                      emailBody += '<td>' + strnestedValueTable + '</td>';
                    emailBody += '</tr>';
                  } else if (rule.equalsIgnoreCase('B') && objMetadata.Rule_B__c != null) {
                    strTemp = '';
                    strTemp = objTrigger.trigger_name.replace('<', '&lt;').replace('>', '&gt;');
                    emailBody += '<tr><td>' + strTemp + '</td>';
                    strTemp = '';
                    strTemp = objMetadata.Rule_B__c.replace('<', '&lt;').replace('>', '&gt;');
                    emailBody += '<td>' + strTemp + '</td>';
                    string strnestedValueTable = CreateRuleValueTable(mapParameters, objMetadata.Rule_B_Condition__c);
                    if (strnestedValueTable != '')
                      emailBody += '<td>' + strnestedValueTable + '</td>';
                    emailBody += '</tr>';
                  } else if (rule.equalsIgnoreCase('C') && objMetadata.Rule_C__c != null) {
                    strTemp = '';
                    strTemp = objTrigger.trigger_name.replace('<', '&lt;').replace('>', '&gt;');
                    emailBody += '<tr><td>' + strTemp + '</td>';
                    strTemp = '';
                    strTemp = objMetadata.Rule_C__c.replace('<', '&lt;').replace('>', '&gt;');
                    emailBody += '<td>' + strTemp + '</td>';
                    string strnestedValueTable = CreateRuleValueTable(mapParameters, objMetadata.Rule_C_Condition__c);
                    if (strnestedValueTable != '')
                      emailBody += '<td>' + strnestedValueTable + '</td>';
                    emailBody += '</tr>';
                  } else if (rule.equalsIgnoreCase('D') && objMetadata.Rule_D__c != null) {
                    strTemp = '';
                    strTemp = objTrigger.trigger_name.replace('<', '&lt;').replace('>', '&gt;');
                    emailBody += '<tr><td>' + strTemp + '</td>';
                    strTemp = '';
                    strTemp = objMetadata.Rule_D__c.replace('<', '&lt;').replace('>', '&gt;');
                    emailBody += '<td>' + strTemp + '</td>';
                    string strnestedValueTable = CreateRuleValueTable(mapParameters, objMetadata.Rule_D_Condition__c);
                    if (strnestedValueTable != '')
                      emailBody += '<td>' + strnestedValueTable + '</td>';
                    emailBody += '</tr>';
                  }
                }
              }
              //emailBody += '</table>';
              //emailBody = emailBodyHead + emailBody;.replace('>','&gt;')

            } else
              emailBody = '';
          }
          break;
        }
      }
    }
    //if(emailBody != '')
    //lst_MailBodies.Add( emailBodyHead + emailBody + '</table>');
    //}
    ////system.debug('Email Body before contactination ' + emailBody);
    if (emailBody != '')
      emailBody = emailBodyHead + emailBody + '</table>';
    return emailBody;
  }
  public string CreateRuleValueTable(MAP < string, string > mapValues, string strRuleCondn) {
    string[] arrRuleCondition = null;
    string[] arrRuleParameters = null;
    string strTableString = '<table>';
    integer count = 0;
    if (strRuleCondn != null && strRuleCondn != '') {
      //system.debug('Rule Condition is '+ strRuleCondn);
      arrRuleCondition = strRuleCondn.split(',');
      if (arrRuleCondition != null) {
        for (string rule: arrRuleCondition) {
          if (rule != null && rule != '') {
            string[] arrParam = rule.split(':');
            if (arrParam != null && arrParam.size() == 2) {
              strTableString += '<tr><td>' + arrParam[0] + '</td><td>';
              for (string fieldName: mapValues.KeySet()) {
                if (arrParam[1] != null && arrParam[1] != '' && arrParam[1].touppercase().contains(fieldName.touppercase())) {
                  ////system.debug('Fetching value of fieldName ' + fieldName);
                  strTableString += mapvalues.get(fieldName) + '</td></tr>';
                  break;
                }
              }
            }
          }
        }
      }
    }
    strTableString += '</table>';
    ////system.debug('strTableString is ' + strTableString);
    return strTableString;
  }
  /*SAL PL to SAL LAP start - Krish*/
  public String callBRELAPOfferGeneration(Map < String, Object > inputReq) {
    String result = '';
    try {
      String endpoint = '';
      String username = '';
      String password = '';
      if (Mid_office_BRE_flow__c.getValues('SAL PL to SAL LAP') != null && Mid_office_BRE_flow__c.getValues('SAL PL to SAL LAP').EndpointURL__c != null) {
        endpoint = Mid_office_BRE_flow__c.getValues('SAL PL to SAL LAP').EndpointURL__c;
        password = Mid_office_BRE_flow__c.getValues('SAL PL to SAL LAP').Password__c;
        username = Mid_office_BRE_flow__c.getValues('SAL PL to SAL LAP').Username__c;
      }
      JSONGenerator gen = JSON.createGenerator(true);
      List < Existing_Loan_details__c > extList = (List < Existing_Loan_details__c > ) inputreq.get('existing_loans');
      system.debug('extList' + extList);
      gen.writeStartObject();
      gen.writeFieldName('existingLoan');
      gen.writeStartArray();
      for (Existing_Loan_Details__c eld: extList) {
        gen.writeStartObject();
        gen.writeNumberField('securedLoanAmount', Decimal.valueof(inputReq.get('securedLoanAmount') + ''));
        gen.writeNumberField('unsecuredLoanAmount', Decimal.valueof(inputReq.get('unSecuredLoanAmount') + ''));
        gen.writeNumberField('mortgageLoanAmount', Decimal.valueof(inputReq.get('mortgageLoanAmount') + ''));
        gen.writeStringField('loan_id', String.valueof(inputReq.get('loan_id')));
        gen.writeStringField('applicant_type', 'Primary');
        gen.writeNumberField('number_of_hl_loans', Decimal.valueof(inputReq.get('number_of_hl_loans') + ''));
        gen.writeNumberField('monthly_loan_obligations', Decimal.valueof(inputReq.get('monthly_loan_obligations') + ''));
        gen.writeNumberField('existingLoanAmount', (eld.Loan_Amount__c != null) ? eld.Loan_Amount__c : 0);
        gen.writeStringField('existingLoanProduct', (eld.Loan_Type__c != null) ? eld.Loan_Type__c : '');
        gen.writeStringField('bankName', (eld.financers__c != null) ? eld.financers__c : '');
        gen.writeNumberField('loanMob', (eld.MOB__c != null) ? eld.MOB__c : 0);
        gen.writeNumberField('pos', (eld.POS__c != null) ? eld.POS__c : 0);
        gen.writeNumberField('loanEmi', (eld.Derived_EMI__c != null) ? eld.Derived_EMI__c : 0);
        gen.writeStringField('offerProductId', (eld.Name != null) ? eld.Name : '');
        gen.writeNumberField('existingLoanTenor', (eld.Tenor__c != null) ? eld.Tenor__c : 0);
        gen.writeStringField('loanStatus', (eld.Status__c != null) ? eld.Status__c : '');
        gen.writeNumberField('currentBalance', (eld.POS__c != null) ? eld.POS__c : 0);
        gen.writeStringField('loanSanctionDate', (eld.Start_On__c != null) ? String.valueof(eld.Start_On__c) : '');
        gen.writeStringField('stillOwnProperty', (eld.Still_own_the_property__c != null) ? eld.Still_own_the_property__c : '');
        gen.writeStringField('mortgageFreeProperty', (eld.Mortgage_free_property__c != null) ? eld.Mortgage_free_property__c : '');
        gen.writeNumberField('dpdMoreThan30', Decimal.valueof(inputReq.get('dpdMoreThan30') + ''));
        //gen.writeNumberField('last3MonthBounceCount', 0);
        //gen.writeNumberField('last6MonthBounceCount', 0);

        gen.writeEndObject();
      }


      gen.writeEndArray();
      system.debug('after');
      gen.writeFieldName('loanParameter');
      gen.writeStartObject();
      gen.writeStringField('loan_id', String.valueof(inputReq.get('loan_id')));
      gen.writeNumberField('approved_loan_amount', Decimal.valueof(inputReq.get('approved_loan_amount') + ''));
      gen.writeNumberField('requested_loan_amount', Decimal.valueof(inputReq.get('requested_loan_amount') + ''));
      gen.writeNumberField('requested_tenor', Decimal.valueof(inputReq.get('requested_tenor') + ''));
      gen.writeNumberField('reqested_roi', Decimal.valueof(inputReq.get('reqested_roi') + ''));
      gen.writeNumberField('loan_application_number', Decimal.valueof(inputReq.get('loan_application_number') + ''));
      gen.writeStringField('product', String.valueof(inputReq.get('product')));
      gen.writeStringField('scheme_name', String.valueof(inputReq.get('scheme_name')));
      gen.writeStringField('type_of_loan', String.valueof(inputReq.get('type_of_loan')));
      gen.writeStringField('process_type', String.valueof(inputReq.get('process_type')));
      gen.writeStringField('stage', String.valueof(inputReq.get('stage')));
      gen.writeStringField('sourcing_channel_type', String.valueof(inputReq.get('sourcing_channel_type')));
      gen.writeStringField('sub_stage', String.valueof(inputReq.get('sub_stage')));
      gen.writeNumberField('offer_amount', Decimal.valueof(inputReq.get('offer_amount') + ''));
      gen.writeStringField('program_type', String.valueof(inputReq.get('program_type')));
      gen.writeEndObject();
      system.debug('after00');
      gen.writeFieldName('demographic');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeStringField('loan_id', String.valueof(inputReq.get('loan_id')));
      gen.writeStringField('type_of_constitution', String.valueof(inputReq.get('type_of_constitution')));
      gen.writeStringField('educational_qualification', String.valueof(inputReq.get('educational_qualification')));
      gen.writeStringField('current_employment_vintage', String.valueof(inputReq.get('current_employment_vintage')));
      gen.writeNumberField('total_employment_vintage', Decimal.valueof(inputReq.get('total_employment_vintage') + ''));
      gen.writeStringField('date_of_birth', String.valueof(inputReq.get('date_of_birth')));
      gen.writeStringField('costomer_type', String.valueof(inputReq.get('costomer_type')));
      gen.writeStringField('customer_segment', String.valueof(inputReq.get('customer_segment')));
      gen.writeNumberField('years_in_business_job', Decimal.valueof(inputReq.get('years_in_business_job') + ''));
      gen.writeStringField('first_name', String.valueof(inputReq.get('first_name')));
      gen.writeStringField('last_name', String.valueof(inputReq.get('last_name')));
      gen.writeStringField('residence_type', String.valueof(inputReq.get('residence_type')));
      gen.writeStringField('applicant_type', String.valueof(inputReq.get('applicant_type')));
      gen.writeStringField('marital_status', String.valueof(inputReq.get('marital_status')));
      gen.writeStringField('company_category', String.valueof(inputReq.get('company_category')));
      gen.writeStringField('company_type', String.valueof(inputReq.get('company_type')));
      gen.writeStringField('office_email_id', String.valueof(inputReq.get('office_email_id')));
      gen.writeStringField('name_of_employer', String.valueof(inputReq.get('name_of_employer')));
      gen.writeStringField('gender', String.valueof(inputReq.get('gender')));
      gen.writeStringField('pan', String.valueof(inputReq.get('pan')));
      gen.writeStringField('residence_city', String.valueof(inputReq.get('residence_city')));
      gen.writeStringField('office_city', String.valueof(inputReq.get('office_city')));
      gen.writeNumberField('residence_pin_code', Decimal.valueof(inputReq.get('residence_pin_code') + ''));
      gen.writeNumberField('office_pin_code', Decimal.valueof(inputReq.get('office_pin_code') + ''));
      gen.writeNumberField('staying__since_year', Decimal.valueof(inputReq.get('staying__since_year') + ''));
      gen.writeStringField('nature_of_business', String.valueof(inputReq.get('nature_of_business')));
      gen.writeStringField('customer_type', String.valueof(inputReq.get('customer_type')));
      gen.writeEndObject();
      gen.writeEndArray();
      system.debug('after0');
      gen.writeFieldName('bankSummary');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeStringField('loan_id', String.valueof(inputReq.get('loan_id')));
      gen.writeStringField('applicant_type', String.valueof(inputReq.get('applicant_type')));
      gen.writeNumberField('avg_od_cc_utilisation', Decimal.valueof(inputReq.get('avg_od_cc_utilisation') + ''));
      gen.writeEndObject();
      gen.writeEndArray();
      system.debug('afte1');
      gen.writeFieldName('generic');
      gen.writeStartObject();
      gen.writeStringField('loan_id', String.valueof(inputReq.get('loan_id')));
      gen.writeStringField('branch_type', String.valueof(inputReq.get('branch_type')));
      gen.writeStringField('branch_name', String.valueof(inputReq.get('branch_name')));
      gen.writeStringField('branch_code', String.valueof(inputReq.get('branch_code')));
      gen.writeEndObject();
      system.debug('after2');
      gen.writeFieldName('cibilList');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeStringField('loan_id', String.valueof(inputReq.get('loan_id')));
      system.debug('securedLoanAmount' + inputReq.get('securedLoanAmount'));
      gen.writeNumberField('securedLoanAmount', Decimal.valueof(inputReq.get('securedLoanAmount') + ''));
      gen.writeNumberField('unSecuredLoanAmount', Decimal.valueof(inputReq.get('unSecuredLoanAmount') + ''));
      gen.writeNumberField('CIBIL_Score', Decimal.valueof(inputReq.get('CIBIL_Score') + ''));
      gen.writeStringField('applicant_Type', String.valueof(inputReq.get('applicant_type')));
      gen.writeEndObject();
      gen.writeEndArray();
      system.debug('afte3');
      gen.writeFieldName('cams');
      gen.writeStartArray();
      gen.writeStartObject();
      gen.writeStringField('loan_id', String.valueof(inputReq.get('loan_id')));
      gen.writeNumberField('average_net_salary', Decimal.valueof(inputReq.get('average_Net_Salary') + ''));
      gen.writeNumberField('gross_Salary_Month1', Decimal.valueof(inputReq.get('gross_Salary_Month1') + ''));
      gen.writeNumberField('gross_Salary_Month2', Decimal.valueof(inputReq.get('gross_Salary_Month2') + ''));
      gen.writeNumberField('gross_Salary_Month3', Decimal.valueof(inputReq.get('gross_Salary_Month3') + ''));
      gen.writeNumberField('net_Salary_for_Month1', Decimal.valueof(inputReq.get('net_Salary_for_Month1') + ''));
      gen.writeNumberField('proposed_Loan_Amt', Decimal.valueof(inputReq.get('proposed_Loan_Amt') + ''));
      gen.writeNumberField('rental_Income', Decimal.valueof(inputReq.get('rental_Income') + ''));
      gen.writeEndObject();
      gen.writeEndArray();
      system.debug('afte4');
      gen.writeEndObject();
      String jsonString = gen.getAsString();
      system.debug('gen' + gen);
      system.debug('jsonString' + jsonString);

      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpoint);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      //String username = 'DEFAULT\\Admin';
      //String password = 'Admin';
      system.debug('username password is:' + username + password);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      if (!Test.isRunningTest()) {
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('Status Code' + res.getStatusCode());
        result = res.getBody();
        system.debug('result======>' + result);
        //offerGenResponse.put();
      } else {
        result = '{"output":{"loanId":"51383967163","offerAmountList":[{"existingProduct":"LAP","offerAmount":3905029.729195266,"multiplier":11,"documents":"APPLICATION FORM;KYC","offerAIdentifier":"NORMAL","offerProductId":"L_12698997","legalFlag":"Y","technicalFlag":"","physicalPDFlag":""}],"calculatedOffer":"SAL-LAP-BTTP","noOfferReason":"MOB norms not met","calculatedOfferRevisedFor":null,"segment":null},"Action":true}';
      }

    } catch (Exception e) {
      System.debug('Exception' + e.getMessage() + e.getLineNumber());
    }
    return result;
  }
  /*SAL PL to SAL LAP end - Krish*/
  //Bug Id: 13488, Changes done by PG for Magicbricks Phase 2 on 13th July 2017.Start 
  //Method Name:callPeMbMatrixValuation
  //Discription:callPeMbMatrixValuation 1.creates BRE  request Json.
  //            2.Calls httpRestCallout method ,which is a generalized method for making HTTP reuests .
  //            3.Parses Request Json to extract relevant information. 

  public Map < String, Integer > callPeMbMatrixValuation(List < Map < String, String >> breParamList) {

    system.debug('breParamList ' + breParamList);
    Map < String, String > iteratorMap = new Map < String, String > ();
    Map < String, String > peMbMapRslt = new Map < String, String > ();
    Map < String, Integer > propIdPropValMap;

    //Get BRE request details from  Mid_office_BRE_flow__c.PE_Magicbricks_Matrix_BRE dataset.
    Mid_office_BRE_flow__c brePeMbMatrix = Mid_office_BRE_flow__c.getValues('PE_Magicbricks_Matrix_BRE');

    if (brePeMbMatrix != NULL) {

      //User-name for BRE request.
      username = brePeMbMatrix.Username__c;

      //Password for BRE request.
      password = brePeMbMatrix.Password__c;

      //Endpoint URL for BRE request.
      endpointURL = brePeMbMatrix.EndpointURL__c;
    }


    // Create a JSONGenerator object.Pass true to the constructor for pretty print formatting.
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartArray();

    // Get size of breParamList.breParamList is a List of Map of Property Details.
    Integer listSize = breParamList.size();

    while (listSize >= 1) {

      gen.writeStartObject();

      for (String keyVal: breParamList.get(listSize - 1).keyset()) {

        iteratorMap = breParamList.get(listSize - 1);

        if (keyVal == 'total_valuation_as_per_pe' || keyVal == 'total_valuation_as_per_mb') {

          gen.writeNumberField(keyVal, Integer.valueOf(iteratorMap.get(keyVal)));

        } else {

          gen.writeStringField(keyVal, iteratorMap.get(keyVal));

        }
      }
      listSize--;
      gen.writeEndObject();

    }
    gen.writeEndArray();

    //getAsString method returns the generated JSON content.
    String jsonString = gen.getAsString();

    //Create a map of request param.
    Map < String, String > httpReqMap = new MAP < String, String > ();

    httpReqMap.put('method', 'POST');
    httpReqMap.put('body', jsonString);
    httpReqMap.put('timeout', '120000');
    httpReqMap.put('contentType', 'application/json;charset=UTF-8');
    httpReqMap.put('username', username);
    httpReqMap.put('password', password);
    httpReqMap.put('endpointURL', endpointURL);
    httpReqMap.put('authorizationType', 'Basic Auth');
    httpReqMap.put('callName', 'PE_MB_MatrixBreCall');

    System.debug('jsonString=======>' + jsonString);

    //BRE callout for get Property valuation (PE-MB Matrix Valuation) by considering both Prop Equity and Magicbricks Valuation. 
    HTTPResponse res = httpRestCallout(httpReqMap);

    //BRE callout successful.
    if (res.getStatusCode() == 201) {

      //Deserialize BRE response body.
      Map < String, Object > resJsonMap = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
      system.debug('resJsonMap :' + resJsonMap);

      //Process Json response to retrieve relevant information. 
      List < object > outputList = (List < object > ) resJsonMap.get('output');
      Integer size = outputList.size();
      propIdPropValMap = new Map < string, Integer > ();

      //Populate propIdPropValMap (key :Property Id,Value: PE-MB Matrix Valuation).
      while (size > 0) {

        Map < String, Object > outputObj = (Map < String, Object > ) outputList[size - 1];
        propIdPropValMap.put((String) outputObj.get('property_id'), (Integer) outputObj.get('final_amount_as_per_grid'));
        size--;
      }
      system.debug('propIdPropValMap ' + propIdPropValMap);

    } else {

      //BRE call-out unsuccessful. 
      System.debug('Request unsucessful');
    }
    return propIdPropValMap;
  } //callPeMbMatrixValuation method ends here.


  //Method Name:httpRestCallout
  //Discription:httpRestCallout method 1.Retrives http request specific information from httpReqMap attribute .
  //            2.Creates HTTP request  and makes the request.
  //            3.Return HTTP response. 
  public HTTPResponse httpRestCallout(Map < String, String > httpReqMap) {

    system.debug('httpReqMap' + httpReqMap);

    // Instantiate HttpRequest
    HttpRequest req = new HttpRequest();

    //Set Endpoint for request.
    req.setEndpoint(httpReqMap.get('endpointURL'));

    //Set Method for request.
    req.setMethod(httpReqMap.get('method'));

    //Set request body.
    req.setbody(httpReqMap.get('body'));

    //Set timeout for request.
    req.setTimeout(Integer.valueOf(httpReqMap.get('timeout')));

    String authorizationHeader;

    //Create authorization header by base 64 encoding the concatinated string of Username and Password.
    if (httpReqMap.get('authorizationType') == 'Basic Auth') {

      System.debug('UserName--->' + username + ' ###  Password---->' + password);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      authorizationHeader = EncodingUtil.base64Encode(headerValue);

      //Set Authorization
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);

    } else {
      //Impliment logic for other Authorization Types if required .
    }

    //Set request's Content-Type. 
    req.setHeader('Content-Type', httpReqMap.get('contentType'));

    system.debug('request ' + req);

    //Instantiate HTTP.
    Http http = new Http();

    System.debug(httpReqMap.get('callName') + 'Call Start :' + system.now());

    //Make request.
    HTTPResponse res = http.send(req);

    System.debug(httpReqMap.get('callName') + 'Call End :' + system.now());
    System.debug('Response ' + res);
    System.debug(httpReqMap.get('callName') + 'Response Body : ' + res.getBody());
    System.debug(httpReqMap.get('callName') + 'Response Status : ' + res.getStatus());

    //Return response.
    return res;

  } //callPeMbMatrixValuation method ends here.

  //Bug Id: 13488, Changes done by PG for Magicbricks Phase 2 on 13th July 2017.End. 
  /* Customer Level Collateral Tracking added by priya start  */
  public static String generateAccessToken(Map < String, Object > inputMap) {
    String accessToken;
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
    Map < string, object > result = new Map < string, object > ();
    req.setEndpoint(String.valueof(inputMap.get('Endpoint1')));
    req.setMethod('POST');
    req.setTimeout(120000);
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    req.setBody('grant_type=' + inputMap.get('grant_type') + '&client_id=' + inputMap.get('client_id') + '&client_secret=' + EncodingUtil.URLENCODE((String) inputMap.get('client_secret'), 'UTF-8') + '&resource=' + inputMap.get('resource'));
    system.debug('Body is' + req.getBody());
    try {
      if (!Test.isRunningTest())
        res = http.send(req);
      result = (Map < String, Object > ) JSON.deserializeuntyped(res.getBody());
      system.debug('Result is' + result);
      accessToken = (String) result.get('access_token');
    } catch (Exception e) {
      system.debug('Exception occured' + e.getMessage() + e.getLineNumber());
    }

    return accessToken;
  }
  public static Map < string, Object > fetchCollateralData(String body) {
    Map < String, Object > valueCollateral = new Map < String, Object > ();
    StaticResource staticRsrc = new StaticResource();
    staticRsrc = [SELECT body from StaticResource where name = 'SalariedCustomSettings'];
    String jsnBody = staticRsrc.Body.tostring();
    Map < String, Object > allMap = (Map < String, Object > ) JSON.deserializeUntyped(jsnBody);
    valueCollateral = (Map < String, Object > ) allMap.get('customer_collateral');
    String accessToken = generateAccessToken(valueCollateral);
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
    Map < string, Object > parsedResponseMap = new Map < string, string > ();
    req.setEndpoint(String.valueof(valueCollateral.get('Endpoint2')));
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('Authorization', 'Bearer ' + accessToken);
    req.setHeader('Ocp-Apim-Subscription-Key', (string) valueCollateral.get('Ocp-Apim-Subscription-Key'));
    req.setMethod('POST');
    req.setBody(body);
    try {
      system.debug('Body is' + req.getBody() + req);
      if (!Test.isRunningTest()) {
        res = http.send(req);
      }
      String result = res.getBody();
      System.debug('Response:--' + res);
      System.debug('result---' + result);
      parsedResponseMap = (Map < String, Object > ) JSON.deserializeUntyped(result);
      System.debug('parsedResponseMap---' + parsedResponseMap);
    } catch (Exception e) {
      System.debug('Exception: ' + e);
      return null;
    }
    return parsedResponseMap;
  }
  /* Customer Level Collateral Tracking added by priya end  */
  /*IMPS Account Validation :13907 S*/
  public static Map < String, String > CallIMPSWebService(Map < String, Object > inputMap) {
    String endpointURL, key;
    Map < String, string > responseMap = new Map < String, String > ();
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('requestId', inputMap.get('requestId') != null ? String.valueof(inputMap.get('requestId')) : '');
    gen.writeStringField('beneIFSCCode', inputMap.get('beneIFSCCode') != null ? String.valueof(inputMap.get('beneIFSCCode')) : '');
    gen.writeStringField('beneAccNumber', inputMap.get('beneAccNumber') != null ? String.valueof(inputMap.get('beneAccNumber')) : '');
    gen.writeStringField('source', inputMap.get('source') != null ? String.valueof(inputMap.get('source')) : '');
    gen.writeNumberField('amount', (inputMap.get('amount') != null && inputMap.get('amount') != '') ? Integer.valueof(inputMap.get('amount')) : 0);
    gen.writeStringField('remitterName', inputMap.get('remitterName') != null ? String.valueof(inputMap.get('remitterName')) : '');
    gen.writeStringField('remitterMobile', inputMap.get('remitterMobile') != null ? String.valueof(inputMap.get('remitterMobile')) : '');
    gen.writeEndObject();
    String jsonString = gen.getAsString();
    Mid_office_BRE_flow__c IMPSEndpoint = Mid_office_BRE_flow__c.getValues('IMPSEndPoint');
    if (IMPSEndpoint != null) {
      endpointURL = IMPSEndpoint.EndpointURL__c;
      key = IMPSEndpoint.FASScripURL__c;
    }
    system.debug('jsonString=======>' + jsonString);
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    String accessToken = getAccessToken();
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    System.debug('access token : ' + accessToken);
    req.setHeader('Authorization', 'Bearer ' + accessToken);
    req.setHeader('Ocp-Apim-Subscription-Key', key); //15448 ADDED KEY
    if (!Test.isRunningTest()) {
      Http http = new Http();
      HTTPResponse res = http.send(req);
      String result = res.getBody();
      system.debug('result======>' + result);
      Map < String, Object > resMap = (Map < String, Object > ) JSON.deserializeUntyped(result);
      for (String s: resMap.keyset()) {
        responseMap.put(s, resMap.get(s) != null ? String.valueOf(resMap.get(s)) : '');
      }

      system.debug('responseMap======>' + responseMap);

    } else {
      system.debug('inside dummy response');
      responseMap.put('bankRefNum', '23434332');
      responseMap.put('beneName', 'dgfgfsdffds');
      responseMap.put('dateTime', '04012018151258');
      responseMap.put('respCode', '4545');
      responseMap.put('respDesc', 'Successful Transcation');
      responseMap.put('traceNumber', '20180104151645151647');
    }
    return responseMap;
  }
  public static Map < String, String > CallIMPSRecheckWebService(Map < String, Object > inputmap) {
    String endpointURL, key;
    Map < String, string > responseRecheckMap = new Map < String, String > ();
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('requestId', inputMap.get('requestId') != null ? String.valueof(inputMap.get('requestId')) : '');
    gen.writeStringField('traceNumber', inputMap.get('traceNumber') != null ? String.valueof(inputMap.get('traceNumber')) : '');
    gen.writeEndObject();
    String jsonString = gen.getAsString();
    Mid_office_BRE_flow__c IMPSEndpoint = Mid_office_BRE_flow__c.getValues('IMPSRecheckEndPoint');
    if (IMPSEndpoint != null) {
      endpointURL = IMPSEndpoint.EndpointURL__c;
      key = IMPSEndpoint.FASScripURL__c;
    }
    system.debug('jsonString=======>' + jsonString);
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setTimeout(120000);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    String accessToken = getAccessToken();
    System.debug('access token : ' + accessToken);
    req.setHeader('Authorization', 'Bearer ' + accessToken);
    req.setHeader('Ocp-Apim-Subscription-Key', key); //15448 ADDED KEY
    if (!Test.isRunningTest()) {
      Http http = new Http();
      HTTPResponse res = http.send(req);
      String result = res.getBody();
      Map < String, Object > resMap = (Map < String, Object > ) JSON.deserializeUntyped(result);
      for (String s: resMap.keyset()) {
        responseRecheckMap.put(s, resMap.get(s) != null ? String.valueOf(resMap.get(s)) : '');
      }
      system.debug('responseMap======>' + responseRecheckMap);

    } else {
      responseRecheckMap.put('bankRefNum', '23434332');
      responseRecheckMap.put('beneName', 'dgfgfsdffds');
      responseRecheckMap.put('dateTime', '04012018151258');
      responseRecheckMap.put('respCode', '4545');
      responseRecheckMap.put('respDesc', 'Successful Transcation');
      responseRecheckMap.put('traceNumber', '20180104151645151647');
    }
    return responseRecheckMap;
  }
  public static string getAccessToken() {
    List < StaticResource > staticRsrc = new List < StaticResource > ();
    staticRsrc = [SELECT body from StaticResource where name = 'SalariedCustomSettings'];
    String accessToken = null;
    if (staticRsrc != NULL && staticRsrc.size() > 0) {
      String jsnBody = staticRsrc[0].Body.tostring();
      Map < String, Object > allMap = (Map < String, Object > ) JSON.deserializeUntyped(jsnBody);
      Map < String, Object > valueCollateral = new Map < String, Object > ();
      valueCollateral = (Map < String, Object > ) allMap.get('IMPS_Account_Validation');
      accessToken = GeneralUtilities.generateAccessToken(valueCollateral);
    }
    return accessToken;

  }
  /*IMPS Account Validation :13907 E*/
  // 17664 Rajesh
  //16621-POS_PO
  public Map < String, Object > callBREDocumentsv2(MAP < String, String > mapOfPolicyParameters) {
    Map < String, Object > mapOfResults = new Map < String, Object > ();

    try {
      if (mapOfPolicyParameters != null) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();

        gen.writeFieldName('Loan_Parameter');
        gen.writeStartObject();
        if (mapOfPolicyParameters.containsKey('product'))
          gen.writeStringField('product', mapOfPolicyParameters.get('product'));

        if (mapOfPolicyParameters.containsKey('stage'))
          gen.writeStringField('stage', mapOfPolicyParameters.get('stage'));

        if (mapOfPolicyParameters.containsKey('processType'))
          gen.writeStringField('processType', mapOfPolicyParameters.get('processType'));
        gen.writeEndObject();


        gen.writeFieldName('Demographic');
        gen.writeStartArray();
        gen.writeStartObject();



        if (mapOfPolicyParameters.containsKey('type_of_constitution'))
          gen.writeStringField('type_of_constitution', mapOfPolicyParameters.get('type_of_constitution'));

        if (mapOfPolicyParameters.containsKey('vip'))
          gen.writeStringField('vip', mapOfPolicyParameters.get('vip'));

        if (mapOfPolicyParameters.containsKey('educational_qualification'))
          gen.writeStringField('educational_qualification', mapOfPolicyParameters.get('educational_qualification'));

        if (mapOfPolicyParameters.containsKey('loan_application_employment_type'))
          gen.writeStringField('loan_application_employment_type', mapOfPolicyParameters.get('loan_application_employment_type'));

        if (mapOfPolicyParameters.containsKey('date_of_birth'))
          gen.writeStringField('date_of_birth', mapOfPolicyParameters.get('date_of_birth'));

        if (mapOfPolicyParameters.containsKey('date_of_incorporation'))
          gen.writeStringField('date_of_incorporation', mapOfPolicyParameters.get('date_of_incorporation'));

        if (mapOfPolicyParameters.containsKey('dummy_member1'))
          gen.writeStringField('dummy_member1', mapOfPolicyParameters.get('dummy_member1'));

        if (mapOfPolicyParameters.containsKey('dummy_member2'))
          gen.writeStringField('dummy_member2', mapOfPolicyParameters.get('dummy_member2'));

        if (mapOfPolicyParameters.containsKey('dummy_member3'))
          gen.writeStringField('dummy_member3', mapOfPolicyParameters.get('dummy_member3'));

        if (mapOfPolicyParameters.containsKey('dummy_member4'))
          gen.writeStringField('dummy_member4', mapOfPolicyParameters.get('dummy_member4'));

        if (mapOfPolicyParameters.containsKey('dummy_member5'))
          gen.writeStringField('dummy_member5', mapOfPolicyParameters.get('dummy_member5'));

        if (mapOfPolicyParameters.containsKey('dummy_member6'))
          gen.writeStringField('dummy_member6', mapOfPolicyParameters.get('dummy_member6'));

        if (mapOfPolicyParameters.containsKey('dummy_member7'))
          gen.writeStringField('dummy_member7', mapOfPolicyParameters.get('dummy_member7'));

        if (mapOfPolicyParameters.containsKey('dummy_member8'))
          gen.writeStringField('dummy_member8', mapOfPolicyParameters.get('dummy_member8'));
        if (mapOfPolicyParameters.containsKey('dummy_member9'))
          gen.writeStringField('dummy_member9', mapOfPolicyParameters.get('dummy_member9'));
        if (mapOfPolicyParameters.containsKey('dummy_member10'))
          gen.writeStringField('dummy_member10', mapOfPolicyParameters.get('dummy_member10'));

        if (mapOfPolicyParameters.containsKey('constitution'))
          gen.writeStringField('constitution', mapOfPolicyParameters.get('constitution'));

        if (mapOfPolicyParameters.containsKey('costomer_type'))
          gen.writeStringField('costomer_type', mapOfPolicyParameters.get('costomer_type'));

        if (mapOfPolicyParameters.containsKey('residence_ownership'))
          gen.writeStringField('residence_ownership', mapOfPolicyParameters.get('residence_ownership'));

        if (mapOfPolicyParameters.containsKey('permanent_house_ownership'))
          gen.writeStringField('permanent_house_ownership', (mapOfPolicyParameters.get('permanent_house_ownership')));

        if (mapOfPolicyParameters.containsKey('factory_plant_ownership'))
          gen.writeStringField('factory_plant_ownership', mapOfPolicyParameters.get('factory_plant_ownership'));

        if (mapOfPolicyParameters.containsKey('customer_segment'))
          gen.writeStringField('customer_segment', mapOfPolicyParameters.get('customer_segment'));

        if (mapOfPolicyParameters.containsKey('clinic_hospital_type'))
          gen.writeStringField('clinic_hospital_type', mapOfPolicyParameters.get('clinic_hospital_type'));

        if (mapOfPolicyParameters.containsKey('outside_geo_limit'))
          gen.writeStringField('outside_geo_limit', mapOfPolicyParameters.get('outside_geo_limit'));

        if (mapOfPolicyParameters.containsKey('first_name'))
          gen.writeStringField('first_name', mapOfPolicyParameters.get('first_name'));

        if (mapOfPolicyParameters.containsKey('last_name'))
          gen.writeStringField('last_name', mapOfPolicyParameters.get('last_name'));
        if (mapOfPolicyParameters.containsKey('residence_type'))
          gen.writeStringField('residence_type', mapOfPolicyParameters.get('residence_type'));
        if (mapOfPolicyParameters.containsKey('existing_customer_flag'))
          gen.writeStringField('existing_customer_flag', mapOfPolicyParameters.get('existing_customer_flag'));
        if (mapOfPolicyParameters.containsKey('applicant_type'))
          gen.writeStringField('applicant_type', mapOfPolicyParameters.get('applicant_type'));
        if (mapOfPolicyParameters.containsKey('marital_status'))
          gen.writeStringField('marital_status', mapOfPolicyParameters.get('marital_status'));
        if (mapOfPolicyParameters.containsKey('gender'))
          gen.writeStringField('gender', mapOfPolicyParameters.get('gender'));
        if (mapOfPolicyParameters.containsKey('pan'))
          gen.writeStringField('pan', mapOfPolicyParameters.get('pan'));
        if (mapOfPolicyParameters.containsKey('residence_city'))
          gen.writeStringField('residence_city', mapOfPolicyParameters.get('residence_city'));
        if (mapOfPolicyParameters.containsKey('office_city'))
          gen.writeStringField('office_city', mapOfPolicyParameters.get('office_city'));

        gen.writeEndObject();
        gen.writeEndArray();

        gen.writeFieldName('profitLossStatement');
        gen.writeStartObject();

        if (mapOfPolicyParameters.containsKey('loan_id'))
          gen.writeNullField('loan_id');
        if (mapOfPolicyParameters.containsKey('cy_sales_turnover'))
          gen.writeNullField('cy_sales_turnover');
        if (mapOfPolicyParameters.containsKey('cy_interest_to_pvt_parties'))
          gen.writeNullField('cy_interest_to_pvt_parties');
        if (mapOfPolicyParameters.containsKey('py_sales_turnover'))
          gen.writeNullField('py_sales_turnover');
        if (mapOfPolicyParameters.containsKey('py_profit_before_tax'))
          gen.writeNullField('py_profit_before_tax');
        if (mapOfPolicyParameters.containsKey('py_profit_after_tax'))
          gen.writeNullField('py_profit_after_tax');
        if (mapOfPolicyParameters.containsKey('py_income_as_per_itr'))
          gen.writeNullField('py_income_as_per_itr');
        if (mapOfPolicyParameters.containsKey('cy_profit_before_tax'))
          gen.writeNullField('cy_profit_before_tax');
        if (mapOfPolicyParameters.containsKey('cy_profit_after_tax'))
          gen.writeNullField('cy_profit_after_tax');
        if (mapOfPolicyParameters.containsKey('cy_income_as_per_itr'))
          gen.writeNullField('cy_income_as_per_itr');
        if (mapOfPolicyParameters.containsKey('py_depriciation'))
          gen.writeNullField('py_depriciation');
        if (mapOfPolicyParameters.containsKey('cy_depriciation'))
          gen.writeNullField('cy_depriciation');
        if (mapOfPolicyParameters.containsKey('py_salary_to_partner'))
          gen.writeNullField('py_salary_to_partner');
        if (mapOfPolicyParameters.containsKey('cy_salary_to_partner'))
          gen.writeNullField('cy_salary_to_partner');
        if (mapOfPolicyParameters.containsKey('py_interest_to_partner'))
          gen.writeNullField('py_interest_to_partner');
        if (mapOfPolicyParameters.containsKey('cy_interest_to_partner'))
          gen.writeNullField('cy_interest_to_partner');
        if (mapOfPolicyParameters.containsKey('py_ebitda'))
          gen.writeNullField('py_ebitda');
        if (mapOfPolicyParameters.containsKey('cy_ebitda'))
          gen.writeNullField('cy_ebitda');
        if (mapOfPolicyParameters.containsKey('py_total_interest_paid'))
          gen.writeNullField('py_total_interest_paid');
        if (mapOfPolicyParameters.containsKey('cy_total_interest_paid'))
          gen.writeNullField('cy_total_interest_paid');
        if (mapOfPolicyParameters.containsKey('py_cash_profit'))
          gen.writeNullField('py_cash_profit');
        if (mapOfPolicyParameters.containsKey('cy_cash_profit'))
          gen.writeNullField('cy_cash_profit');
        if (mapOfPolicyParameters.containsKey('py_total_networth'))
          gen.writeNullField('py_total_networth');
        if (mapOfPolicyParameters.containsKey('cy_total_networth'))
          gen.writeNullField('cy_total_networth');
        if (mapOfPolicyParameters.containsKey('py_debtors'))
          gen.writeNullField('py_debtors');
        if (mapOfPolicyParameters.containsKey('cy_debtors'))
          gen.writeNullField('cy_debtors');
        if (mapOfPolicyParameters.containsKey('py_creditors'))
          gen.writeNullField('py_creditors');
        if (mapOfPolicyParameters.containsKey('cy_creditors'))
          gen.writeNullField('cy_creditors');
        if (mapOfPolicyParameters.containsKey('py_adjusted_networth'))
          gen.writeNullField('py_adjusted_networth');
        if (mapOfPolicyParameters.containsKey('cy_adjusted_networth'))
          gen.writeNullField('cy_adjusted_networth');
        if (mapOfPolicyParameters.containsKey('cy_annual_receipt'))
          gen.writeNullField('cy_annual_receipt');
        if (mapOfPolicyParameters.containsKey('cy_income_from_business'))
          gen.writeNullField('cy_income_from_business');
        if (mapOfPolicyParameters.containsKey('cy_net_profit'))
          gen.writeNullField('cy_net_profit');
        if (mapOfPolicyParameters.containsKey('py_net_profit'))
          gen.writeNullField('py_net_profit');
        if (mapOfPolicyParameters.containsKey('gross_receipts'))
          gen.writeNullField('gross_receipts');
        if (mapOfPolicyParameters.containsKey('cy_Interest_to_FI'))
          gen.writeNullField('cy_Interest_to_FI');
        if (mapOfPolicyParameters.containsKey('py_Interest_to_FI'))
          gen.writeNullField('py_Interest_to_FI');
        if (mapOfPolicyParameters.containsKey('py_interest_to_pvt_parties'))
          gen.writeNullField('py_interest_to_pvt_parties');
        if (mapOfPolicyParameters.containsKey('cy_inBigDecimal_to_pvt_parties'))
          gen.writeNullField('cy_inBigDecimal_to_pvt_parties');
        if (mapOfPolicyParameters.containsKey('py_Total_ouside_borrowings'))
          gen.writeNullField('py_Total_ouside_borrowings');
        if (mapOfPolicyParameters.containsKey('cy_Total_ouside_borrowings'))
          gen.writeNullField('cy_Total_ouside_borrowings');
        if (mapOfPolicyParameters.containsKey('days_gap_in_itr'))
          gen.writeNullField('days_gap_in_itr');
        if (mapOfPolicyParameters.containsKey('dummy_member9'))
          gen.writeStringField('dummy_member9', mapOfPolicyParameters.get('dummy_member9'));
        if (mapOfPolicyParameters.containsKey('dummy_member10'))
          gen.writeStringField('dummy_member10', mapOfPolicyParameters.get('dummy_member10'));
        if (mapOfPolicyParameters.containsKey('cy_inventory'))
          gen.writeNullField('cy_inventory');
        if (mapOfPolicyParameters.containsKey('py_inventory'))
          gen.writeNullField('py_inventory');
        if (mapOfPolicyParameters.containsKey('cy_total_assets'))
          gen.writeNullField('cy_total_assets');
        if (mapOfPolicyParameters.containsKey('py_total_assets'))
          gen.writeNullField('py_total_assets');
        if (mapOfPolicyParameters.containsKey('cy_current_assets'))
          gen.writeNullField('cy_current_assets');
        if (mapOfPolicyParameters.containsKey('py_current_assets'))
          gen.writeNullField('py_current_assets');
        if (mapOfPolicyParameters.containsKey('cy_current_liabilities'))
          gen.writeNullField('cy_current_liabilities');
        if (mapOfPolicyParameters.containsKey('py_current_liabilities'))
          gen.writeNullField('py_current_liabilities');
        if (mapOfPolicyParameters.containsKey('applicant_id'))
          gen.writeNullField('applicant_id');

        gen.writeEndObject();


        gen.writeFieldName('CAMS');
        gen.writeStartArray();

        gen.writeStartObject();
        gen.writeEndObject();
        gen.writeEndArray();

        gen.writeEndObject();

        String endpointURL = '';
        String username = '';
        STring password = '';

        Mid_office_BRE_flow__c POS_Document_endPoint = Mid_office_BRE_flow__c.getValues('POS_DocumentEndPoint');
        username = (String) POS_Document_endPoint.Username__c;
        password = (String) POS_Document_endPoint.Password__C;
        if (POS_Document_endPoint != null) {
          endpointURL = POS_Document_endPoint.EndpointURL__c;
        }

        //    username = 'DEFAULT\\Admin';
        //    password='Admin';
        //    endpointURL = 'http://52.172.206.229:8087/executionserver/rest/1/ruleServices/Document/versions/0.0.1-SNAPSHOT/rules/Document/documentMain/executions';

        system.debug('username' + userName + password);
        String jsonString = gen.getAsString();
        system.debug('jsonString' + jsonString);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        req.setbody(jsonString);
        req.setTimeout(120000);
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = EncodingUtil.base64Encode(headerValue);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        Http http = new Http();

        HTTPResponse res = new HTTPResponse();
        if (!Test.isRunningTest()) {
          res = http.send(req);
          if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            // Proper Response
            System.debug('Request document -----> ' + req.getBody());
            String result = res.getBody();
            System.debug('Result document----->' + result);
            mapOfResults = (Map < String, Object > ) JSON.deserializeUntyped(result);

          } else {
            // Error in getting response
            System.debug('<-----CONNECTION ERROR----->');
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception>>>' + e.getLineNumber() + e.getStackTraceString() + 'cause:' + e);
    }
    return mapOfResults;
  }
  /*Sales 2.0 17138 s*/
  public Map < String, Object > callBREMCPMobilityV2(MAP < String, String > mapOfPolicyParameters) {

    Map < String, Object > mapOfResults = new Map < String, Object > ();

    if (mapOfPolicyParameters != null) {
      JSONGenerator gen = JSON.createGenerator(true);
      gen.writeStartObject();
      gen.writeStringField('call_type', 'MCP');
      gen.writeFieldName('mcp_inputs');
      gen.writeStartObject();

      if (mapOfPolicyParameters.get('loan_id') == '' || mapOfPolicyParameters.get('loan_id') == null)
        gen.writeNullField('loan_id');
      else
        gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id'));

      if (mapOfPolicyParameters.get('branch_name') == '' || mapOfPolicyParameters.get('branch_name') == null)
        gen.writeNullField('branch_name');
      else
        gen.writeStringField('branch_name', mapOfPolicyParameters.get('branch_name'));

      /*if(mapOfPolicyParameters.get('branchType') == '')
             gen.writeNullField('branchType');      
         else
             gen.writeStringField('branchType',mapOfPolicyParameters.get('branchType')); */

      if (mapOfPolicyParameters.get('application_source') == '')
        gen.writeNullField('application_source');
      else
        gen.writeStringField('application_source', mapOfPolicyParameters.get('application_source'));


      if (mapOfPolicyParameters.get('date_of_birth') == '')
        gen.writeNullField('date_of_birth');
      else
        gen.writeStringField('date_of_birth', mapOfPolicyParameters.get('date_of_birth'));



      if (mapOfPolicyParameters.get('company_type') == '')
        gen.writeNullField('company_type');
      else
        gen.writeStringField('company_type', mapOfPolicyParameters.get('company_type'));

      if (mapOfPolicyParameters.get('total_employment_vintage') == '0')
        gen.writeNullField('total_employment_vintage');
      else
        gen.writeNumberField('total_employment_vintage', Decimal.valueOf(mapOfPolicyParameters.get('total_employment_vintage')));



      if (mapOfPolicyParameters.get('current_employment_vintage') == '0')
        gen.writeNullField('current_employment_vintage');
      else
        gen.writeNumberField('current_employment_vintage', Decimal.valueOf(mapOfPolicyParameters.get('current_employment_vintage')));


      if (mapOfPolicyParameters.get('specialProfile') == '')
        gen.writeBooleanField('specialProfile', false);
      else
        gen.writeBooleanField('specialProfile', Boolean.valueOf(mapOfPolicyParameters.get('specialProfile')));


      if (mapOfPolicyParameters.get('net_salary') == '')
        gen.writeNullField('net_salary');
      else
        gen.writeNumberField('net_salary', Decimal.valueOf(mapOfPolicyParameters.get('net_salary')));

      if (mapOfPolicyParameters.get('industry') == '')
        gen.writeNullField('industry');
      else
        gen.writeStringField('industry', mapOfPolicyParameters.get('industry'));

      if (mapOfPolicyParameters.get('product') == '')
        gen.writeNullField('product');
      else
        gen.writeStringField('product', mapOfPolicyParameters.get('product'));
      gen.writeStringField('enhanced_offer', mapOfPolicyParameters.get('enhanced_offer'));

      gen.writeEndObject();
      gen.writeEndObject();

      String endpointURL = '';
      String username = '';
      STring password = '';

      if (!CommonUtility.isEmpty(staticresc)) {
        string jsnBody = staticresc.Body.toString();
        Map < String, Object > ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
        Map < String, Object > breMap = (Map < String, Object > ) ALLMap.get('BREEndpoint');
        //Map < String, Object > credsMap = (Map < String, Object > ) breMap.get('MCP_Details');
        Map < String, Object > credsMap = (Map < String, Object > ) breMap.get(mapOfPolicyParameters.get('product')+' Endpoint');  //22018 RSL Mobility Hrushikesh  
        if (credsMap != null) {
          endpointURL = (String) credsMap.get('Endpoint'); //22018
          username = (String) credsMap.get('userName');
          password = (String) credsMap.get('password');
          System.debug('rohit333 ' + endpointURL);
        }
      }

      String jsonString = gen.getAsString();
      System.debug('robin ' + jsonString);
      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      Http http = new Http();
      HTTPResponse res;
      if (!Test.isRunningTest()) {
        res = http.send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          // Proper Response
          System.debug('Request -----> ' + req.getBody());
          String result = res.getBody();
          System.debug('Result ----->' + result);
          mapOfResults = processResponseforMCP(result);
          System.debug('Map of result -----> ' + mapOfResults);
        } else {
          // Error in getting response
          System.debug('<-----CONNECTION ERROR----->');
        }
      }
    }
    return mapOfResults;
  }
  public class mcpList {

    public String mcpOutput;
    public String mcpDesc;
    public String loanId;

  }

  public class JSONParserForMCP {

    public LIst < mcpList > mcpParams;
    public String mcp_policy;
    public Boolean Action;

    public JSONParserForMCP parse(String json) {

      return (JSONParserForMCP) System.JSON.deserialize(json, JSONParserForMCP.class);
    }
  }
  public Map < String, Object > processResponseforMCP(String mcpResult) {
    Map < String, Object > mapOfResult = new Map < String, Object > ();
    BRECallout.JSONParserForMCP jsonParser = new BRECallout.JSONParserForMCP();
    BRECallout.JSONParserForMCP parseMCP = jsonParser.parse(mcpResult);
    SYstem.debug('mcp parse ' + parseMCP);
    if (parseMCP.mcpParams != null) mapOfResult.put('mcp_List', parseMCP.mcpParams);
    else {
      mapOfResult.put('mcp_List', null);
    }

    mapOfResult.put('mcp_policy', parseMCP.mcp_policy);
    mapOfResult.put('Action', parseMCP.Action);

    return mapOfResult;
  }

  public Map < String, String > callBREVerificationsv2(MAP < String, String > mapOfPolicyParameters) {

    Map < String, String > mapOfResults = new Map < String, String > ();

    if (mapOfPolicyParameters != null) {
      JSONGenerator gen = JSON.createGenerator(true);
      gen.writeStartObject();
      gen.writeStringField('call_type', 'VERIFICATIONS');
      gen.writeFieldName('Verifications_Inputs');
      gen.writeStartObject();
      /*  gen.writeStringField('EPFO_api_response',mapOfPolicyParameters.get('EPFO_api_response'));
gen.writeStringField('EPFO_test_result',mapOfPolicyParameters.get('EPFO_test_result'));
gen.writeStringField('email_triggered',mapOfPolicyParameters.get('email_triggered'));
gen.writeStringField('email_verified',mapOfPolicyParameters.get('email_verified'));
gen.writeStringField('domain_check',mapOfPolicyParameters.get('domain_check'));*/
      gen.writeStringField('processType', mapOfPolicyParameters.get('processType'));
      gen.writeStringField('residence_vintage', mapOfPolicyParameters.get('residence_vintage'));
      gen.writeStringField('offer_type', mapOfPolicyParameters.get('offer_type'));
      gen.writeStringField('riskSegmentClassification', mapOfPolicyParameters.get('riskSegmentClassification'));
      gen.writeNumberField('approved_loan_amount', Decimal.valueOf(mapOfPolicyParameters.get('approved_loan_amount')));
      gen.writeStringField('EPFO_api_response', mapOfPolicyParameters.get('EPFO_api_response'));
      gen.writeStringField('EPFO_test_result', mapOfPolicyParameters.get('EPFO_test_result'));
      gen.writeStringField('email_triggered', mapOfPolicyParameters.get('email_triggered'));
      // gen.writeStringField('email_verified',mapOfPolicyParameters.get('email_verified'));
      gen.writeStringField('sourcing_channel_risk',mapOfPolicyParameters.get('sourcing_channel_risk'));//22018 added extra parameter for RSL
      if (!commonutility.isEmpty(mapOfPolicyParameters.get('email_verified'))) {
        if (mapOfPolicyParameters.get('email_verified') == 'true') {
          gen.writeStringField('email_verified', 'YES');
        } else {
          gen.writeStringField('email_verified', 'NO');
        }
      } else {
        gen.writeStringField('email_verified', 'NO');
      }
      system.debug('domaincheck >' + mapOfPolicyParameters.get('domain_check'));
      gen.writeStringField('domain_check', mapOfPolicyParameters.get('domain_check'));
      /*if (!commonutility.isEmpty(mapOfPolicyParameters.get('domain_check'))) {
             if (mapOfPolicyParameters.get('domain_check') == 'OK' || mapOfPolicyParameters.get('domain_check') == 'Pass') {
                 gen.writeStringField('domain_check','SUCCESSFUL');
             } else if (mapOfPolicyParameters.get('domain_check') == 'NOT OK' || mapOfPolicyParameters.get('domain_check') == 'false' ){
                 gen.writeStringField('domain_check','NOT CONFIRMED');
             }
         } 
         else
             gen.writeStringField('domain_check','');
       */
      gen.writeStringField('product', mapOfPolicyParameters.get('product'));
      gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id'));
      if (!commonutility.isEmpty(mapOfPolicyParameters.get('perfios_trigger_flag'))) {
        gen.writeBooleanField('perfios_trigger_flag', Boolean.valueOf(mapOfPolicyParameters.get('perfios_trigger_flag')));
      } else {
        gen.writeBooleanField('perfios_trigger_flag', false);
      }
      if (!commonutility.isEmpty(mapOfPolicyParameters.get('perfios_response_flag'))) {
        gen.writeBooleanField('perfios_response_flag', Boolean.valueOf(mapOfPolicyParameters.get('perfios_response_flag')));
      } else
        gen.writeBooleanField('perfios_response_flag', false);
      gen.writeNumberField('net_salary', Decimal.valueOf(mapOfPolicyParameters.get('net_salary')));
      gen.writeStringField('source_of_data', mapOfPolicyParameters.get('source_of_data'));
      if (!commonutility.isEmpty(mapOfPolicyParameters.get('authenticity_score_flag'))) {
        gen.writeBooleanField('authenticity_score_flag', Boolean.valueOf(mapOfPolicyParameters.get('authenticity_score_flag')));
      } else
        gen.writeBooleanField('authenticity_score_flag', false);
      gen.writeStringField('residential_type', mapOfPolicyParameters.get('residential_type'));
      // gen.writeStringField('residential_type','RENTED - STAYING ALONE');
      gen.writeStringField('date_of_birth', mapOfPolicyParameters.get('date_of_birth'));
      gen.writeStringField('branch_name', mapOfPolicyParameters.get('branch_name'));
      gen.writeNumberField('no_of_home_loans', Integer.valueOf(mapOfPolicyParameters.get('no_of_home_loans')));
      /*CR 24122 s*/
  
      gen.writeStringField('perfios_Statement_Status_1',mapOfPolicyParameters.get('perfios_Perfios_Statement_Status_1'));
      gen.writeStringField('perfios_Statement_Status_2',mapOfPolicyParameters.get('perfios_Perfios_Statement_Status_2'));
      gen.writeStringField('perfios_Statement_Status_3',mapOfPolicyParameters.get('perfios_Perfios_Statement_Status_3'));
      
      /*CR 24122 e*/
      //gen.writeNumberField('no_of_home_loans',Integer.valueOf('1'));
      //Rohit banking details start
      gen.writeFieldName('banking_dashboard');
      gen.writeStartObject();
      if (!commonutility.isEmpty(mapOfPolicyParameters.get('perfios_response_flag'))) {
        gen.writeBooleanField('perfios_response_flag', Boolean.valueOf(mapOfPolicyParameters.get('perfios_response_flag')));
      } else
        gen.writeBooleanField('perfios_response_flag', false);

      gen.writeStringField('salary_selected', mapOfPolicyParameters.get('salary_selected'));
      gen.writeStringField('source_of_data', mapOfPolicyParameters.get('source_of_data'));
      gen.writeNumberField('inward_cheque_bounce', Integer.valueOf(mapOfPolicyParameters.get('inward_cheque_bounce')));
      gen.writeNumberField('inward_ecs_bounce', Integer.valueOf(mapOfPolicyParameters.get('inward_ecs_bounce')));
      gen.writeStringField('salary_credit_date_variation', mapOfPolicyParameters.get('salary_credit_date_variation'));
      gen.writeStringField('salary_amount_difference', mapOfPolicyParameters.get('salary_amount_difference'));
      gen.writeNumberField('salary1', Decimal.valueOf(mapOfPolicyParameters.get('salary1')));
      gen.writeNumberField('salary2', Decimal.valueOf(mapOfPolicyParameters.get('salary2')));
      gen.writeNumberField('salary3', Decimal.valueOf(mapOfPolicyParameters.get('salary3')));
      if (mapOfPolicyParameters.get('salary_date1') == '')
        gen.writeNullField('salary_date1');
      else
        gen.writeDateField('salary_date1', Date.valueOf(mapOfPolicyParameters.get('salary_date1')));

      if (mapOfPolicyParameters.get('salary_date2') == '')
        gen.writeNullField('salary_date2');
      else
        gen.writeDateField('salary_date2', Date.valueOf(mapOfPolicyParameters.get('salary_date2')));

      if (mapOfPolicyParameters.get('salary_date3') == '')
        gen.writeNullField('salary_date3');
      else
        gen.writeDateField('salary_date3', Date.valueOf(mapOfPolicyParameters.get('salary_date3')));

      gen.writeStringField('bank_name', mapOfPolicyParameters.get('bank_name'));
      gen.writeNumberField('authenticity_score', Decimal.valueOf(mapOfPolicyParameters.get('authenticity_score')));
      // gen.writeNumberField('authenticity_score',3);
      gen.writeEndObject();
      //Rohit banking details stop
      gen.writeNumberField('loanAmount', Decimal.valueOf(mapOfPolicyParameters.get('loanAmount')));
      //gen.writeNumberField('loanAmount',589900);
      // gen.writeStringField('address_matching_eKYC',mapOfPolicyParameters.get('address_matching_eKYC'));
      // gen.writeStringField('address_matching_perfios',mapOfPolicyParameters.get('address_matching_perfios'));
      //  gen.writeStringField('address_matching_eKYC','YES');
      //  gen.writeStringField('address_matching_perfios','YES');

      gen.writeStringField('company_type', mapOfPolicyParameters.get('company_type'));
      gen.writeStringField('address_matching_eKYC', mapOfPolicyParameters.get('address_matching_eKYC'));
      gen.writeStringField('address_matching_perfios', mapOfPolicyParameters.get('address_matching_perfios'));

      gen.writeEndObject();
      gen.writeEndObject();

      HttpRequest req = new HttpRequest();
      Blob headerValue = Blob.valueOf('DEFAULT\\Admin' + ':' + 'Admin');
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      String endpointURL = '';
      if (!CommonUtility.isEmpty(staticresc)) {
        string jsnBody = staticresc.Body.toString();
        Map < String, Object > ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
        Map < String, Object > breMap = (Map < String, Object > ) ALLMap.get('BREEndpoint');
        //Map < String, Object > credsMap = (Map < String, Object > ) breMap.get('Common Endpoint');
        Map < String, Object > credsMap = (Map < String, Object > ) breMap.get(mapOfPolicyParameters.get('product')+' Endpoint');  //22018 RSL Mobility Hrushikesh   
        if (credsMap != null) {
          endpointURL = (String) credsMap.get('Endpoint');
          req.setEndpoint(endpointURL);
          System.debug('rohit333 ' + endpointURL);
        }
      }

      //  String username = '';
      //  STring password = '';
      String jsonString = gen.getAsString();
      System.debug('robin ' + jsonString);

      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      // Blob headerValue = Blob.valueOf(username + ':' + password);
      //    String authorizationHeader = EncodingUtil.base64Encode(headerValue);     
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      // req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      Http http = new Http();
      HTTPResponse res = new HTTPResponse();
      if (!Test.isRunningTest()) {
        res = http.send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          // Proper Response
          System.debug('Request -----> ' + req.getBody());
          String result = res.getBody();
          System.debug('Result ----->' + result);
          mapOfResults = parseResponseForVerification(result);

        } else {
          // Error in getting response
          System.debug('<-----CONNECTION ERROR----->');
        }
      }
    }
    return mapOfResults;
  }
  public Map < String, String > parseResponseForVerification(String responseMap) {
    Map < String, String > mapOfResults = new Map < String, String > ();

    // JSONResponse reponse = JSONResponse.parse(responseMap);
    // System.debug('*****Response*****' + reponse);
    Map < String, Object > inputJSON = (Map < String, Object > ) JSON.deserializeUntyped(responseMap);

    if (inputJSON.get('Verifications_Output') != null) {
      Map < String, Object > inputbody = (Map < String, Object > )(inputJSON.get('Verifications_Output'));
      if (inputbody.get('verificationsList') != null) {
        List < object > verObj = (List < object > ) inputbody.get('verificationsList');
        system.debug('verObj>>' + verObj);
        string code = '';
        for (Object obj: verObj) {
          system.debug('obj>>>' + obj);
          Map < String, Object > mapobj = (Map < String, Object > ) obj;
          if (code != '')
            code = code + ',' + String.valueof(mapobj.get('verification_code'));
          else
            code = String.valueof(mapobj.get('verification_code'));
        }
        system.debug('code>>>' + code);
        mapOfResults.put('BREVerificationCodes', code);
        Map < String, Object > mapOfOut = new Map < String, Object > ();
        for (String key: inputbody.keySet()) {
          if (key != 'verificationsList') {
            mapOfOut.put(key, inputbody.get(key));
          }
        }
        mapOfResults.put('Employment_Check', (String) inputbody.get('employment_check'));
        mapOfResults.put('banking_output', (String) inputbody.get('banking_output'));
        mapOfResults.put('output_map', mapOfOut != null ? JSON.serialize(mapOfOut) : '');
        system.debug('code>>>' + inputbody.get('employment_check') + inputbody.get('banking_output'));
      }
    }
    system.debug('map ------->' + mapOfResults);

    return mapOfResults;
  }
  public Map < String, Object > callBREDeviationsv2(MAP < String, String > mapOfPolicyParameters) {
    Map < String, Object > mapOfResults = new Map < String, Object > ();
    if (mapOfPolicyParameters != null) {
      JSONGenerator gen = JSON.createGenerator(true);
      gen.writeStartObject();
      gen.writeStringField('call_type', 'DEVIATIONS');
      gen.writeFieldName('Deviation_Inputs');
      gen.writeStartObject();
      gen.writeStringField('processType', mapOfPolicyParameters.get('processType'));
      gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id'));
      gen.writeStringField('product', mapOfPolicyParameters.get('product'));
      gen.writeStringField('branch_name', mapOfPolicyParameters.get('branch_name'));
      gen.writeStringField('ews_segment', mapOfPolicyParameters.get('ews_segment'));
      gen.writeStringField('date_of_birth', mapOfPolicyParameters.get('date_of_birth'));
      //gen.writeStringField('offer_type',mapOfPolicyParameters.get('offer_type'));
      gen.writeStringField('risk_segment', mapOfPolicyParameters.get('risk_segment'));
      gen.writeNumberField('overdue_amount', Decimal.valueof(mapOfPolicyParameters.get('overdue_amount')));
      gen.writeStringField('dpd30_in_last_6months', mapOfPolicyParameters.get('dpd30_in_last_6months'));
      gen.writeStringField('dpd90_in_last_6months', mapOfPolicyParameters.get('dpd90_in_last_6months'));
      gen.writeStringField('asset_classification_view', mapOfPolicyParameters.get('asset_classification_view'));
      gen.writeStringField('cc_dpd', mapOfPolicyParameters.get('cc_dpd'));
      gen.writeStringField('cc_30dpd', mapOfPolicyParameters.get('cc_30dpd'));
      gen.writeStringField('residence_stability', mapOfPolicyParameters.get('residence_stability'));
      gen.writeStringField('gold_loan_dpd', mapOfPolicyParameters.get('gold_loan_dpd'));
      gen.writeStringField('dpd_cluster_segment', mapOfPolicyParameters.get('dpd_cluster_segment'));
      gen.writeNumberField('cibil_score', Integer.valueOf(mapOfPolicyParameters.get('cibil_score')));
      gen.writeStringField('bad_match', mapOfPolicyParameters.get('bad_match'));
      gen.writeStringField('application_source', mapOfPolicyParameters.get('application_source'));
      gen.writeBooleanField('specialProfile', Boolean.valueOf(mapOfPolicyParameters.get('specialProfile')));
      gen.writeStringField('company_type', mapOfPolicyParameters.get('company_type'));
      gen.writeNumberField('total_employment_vintage', Decimal.valueOf(mapOfPolicyParameters.get('total_employment_vintage')));
      gen.writeNumberField('current_employment_vintage', Decimal.valueOf(mapOfPolicyParameters.get('current_employment_vintage')));
      gen.writeNumberField('net_salary', Decimal.valueOf(mapOfPolicyParameters.get('net_salary')));
      if (!commonutility.isEmpty(mapOfPolicyParameters.get('domain_check'))) {
        if (mapOfPolicyParameters.get('domain_check') == 'OK' || mapOfPolicyParameters.get('domain_check') == 'Pass') {
          gen.writeStringField('domain_check', 'SUCCESSFUL');
        } else if (mapOfPolicyParameters.get('domain_check') == 'NOT OK' || mapOfPolicyParameters.get('domain_check') == 'false') {
          gen.writeStringField('domain_check', 'NOT CONFIRMED');
        }
      }

      gen.writeNumberField('approved_loan_amount', Decimal.valueOf(mapOfPolicyParameters.get('approved_loan_amount')));
      gen.writeNumberField('requested_loan_amount', Decimal.valueOf(mapOfPolicyParameters.get('requested_loan_amount')));
      //gen.writeNumberField('max_loan_as_per_foir', Decimal.valueOf(mapOfPolicyParameters.get('max_loan_as_per_foir')));
      gen.writeNumberField('max_loan_as_per_multiplier', Decimal.valueOf(mapOfPolicyParameters.get('max_loan_as_per_multiplier')));
      gen.writeStringField('loan_type', mapOfPolicyParameters.get('loan_type'));
      gen.writeNumberField('inward_ecs', Decimal.valueof(mapOfPolicyParameters.get('inward_ecs')));
      gen.writeNumberField('cheque_bounce', Decimal.valueof(mapOfPolicyParameters.get('cheque_bounce')));
      gen.writeStringField('credit_status', mapOfPolicyParameters.get('credit_status'));
      system.debug('before emi_bounce_last_3months');
      gen.writeStringField('emi_bounce_last_3months', mapOfPolicyParameters.get('emi_bounce_last_3months'));

      gen.writeStringField('fraud_match', mapOfPolicyParameters.get('fraud_match'));
      gen.writeStringField('industry', mapOfPolicyParameters.get('industry') != '' ? mapOfPolicyParameters.get('industry') : ' ');
      gen.writeBooleanField('email_confirmation', Boolean.valueof(mapOfPolicyParameters.get('email_confirmation')));
      system.debug('after emi_bounce_last_3months');
      gen.writeStringField('salary_date1', mapOfPolicyParameters.get('salary_date1'));
      gen.writeStringField('salary_date2', mapOfPolicyParameters.get('salary_date2'));
      gen.writeStringField('salary_date3', mapOfPolicyParameters.get('salary_date3'));

      gen.writeStringField('enhanced_offer', mapOfPolicyParameters.get('enhanced_offer'));
      //gen.writeBooleanField('email_confirmation',true);
      gen.writeStringField('EPFO_check', mapOfPolicyParameters.get('EPFO_check'));
      gen.writeNumberField('maxLoanAmountAsPerFoir', Decimal.valueOf(mapOfPolicyParameters.get('maxLoanAmountAsPerFoir')));
      gen.writeNumberField('final_loan_amount', Decimal.valueOf(mapOfPolicyParameters.get('final_loan_amount')));
      gen.writeEndObject();
      gen.writeEndObject();
      String endpointURL = '';
      String username = '';
      STring password = '';
      system.debug('pk1');
      if (!CommonUtility.isEmpty(staticresc)) {
        string jsnBody = staticresc.Body.toString();
        Map < String, Object > ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
        Map < String, Object > breMap = (Map < String, Object > ) ALLMap.get('BREEndpoint');
        //Map < String, Object > credsMap = (Map < String, Object > ) breMap.get('Common Endpoint');
        Map < String, Object > credsMap = (Map < String, Object > ) breMap.get(mapOfPolicyParameters.get('product')+' Endpoint');  //22018 RSL Mobility Hrushikesh
        system.debug('pk2' + credsMap);
        if (credsMap != null) {
          endpointURL = (String) credsMap.get('Endpoint');
          username = (String) credsMap.get('userName');
          password = (String) credsMap.get('password');
          System.debug('rohit333 ' + endpointURL);
          system.debug('pk3');
        }
      }
      system.debug('username' + userName + password);
      String jsonString = gen.getAsString();
      system.debug('jsonString' + jsonString);
      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      req.setHeader('Content-Type', 'application/json');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      Http http = new Http();
      HTTPResponse res;
      system.debug('request is' + req);
      if (!Test.isRunningTest()) {
        res = http.send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          // Proper Response
          System.debug('Request -----> ' + req.getBody());
          String result = res.getBody();
          System.debug('Result ----->' + result);
          mapOfResults = (Map < String, Object > ) JSON.deserializeUntyped(result);
          System.debug('Map of result -----> ' + mapOfResults);
        } else {
          // Error in getting response
          System.debug('<-----CONNECTION ERROR----->');
        }
      }
    }
    return mapOfResults;
  }
  public Map < String, Object > callBREDocumentsv2Sal(MAP < String, String > mapOfPolicyParameters) {
    Map < String, Object > mapOfResults = new Map < String, Object > ();
    try {
      if (mapOfPolicyParameters != null) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('call_type', 'DOCUMENTS');
        gen.writeFieldName('Document_Inputs');
        gen.writeStartObject();
        gen.writeStringField('branch_name', mapOfPolicyParameters.get('branch_Name'));
        gen.writeStringField('date_of_birth', mapOfPolicyParameters.get('date_of_birth'));
        gen.writeStringField('loan_id', mapOfPolicyParameters.get('loan_id'));
        gen.writeStringField('product', mapOfPolicyParameters.get('product'));
        gen.writeStringField('offer_type', mapOfPolicyParameters.get('offer_type'));
        gen.writeStringField('risk_segment', mapOfPolicyParameters.get('risk_segment'));
        gen.writeStringField('perfios_response', mapOfPolicyParameters.get('perfios_response_flag'));
        gen.writeStringField('residence_current_verification', mapOfPolicyParameters.get('residence_current_verification'));
        gen.writeStringField('office_verification', mapOfPolicyParameters.get('office_verification'));
        gen.writeStringField('ekyc_response', mapOfPolicyParameters.get('ekyc_response'));
        gen.writeStringField('address_match_with_ekyc_address', mapOfPolicyParameters.get('address_match_with_ekyc_address'));
        gen.writeNumberField('overdue_amount', Decimal.valueof(mapOfPolicyParameters.get('overdue_amount')));
        gen.writeStringField('dpd30_in_last_6months', mapOfPolicyParameters.get('dpd30_in_last_6months'));
        gen.writeStringField('residence_type', mapOfPolicyParameters.get('residence_type'));
        gen.writeStringField('email_verification', mapOfPolicyParameters.get('email_verification'));
        gen.writeStringField('umrn', mapOfPolicyParameters.get('umrn'));
        gen.writeStringField('dpd90_in_last_6months', mapOfPolicyParameters.get('dpd90_in_last_6months'));
        gen.writeStringField('asset_classification_view', mapOfPolicyParameters.get('asset_classification_view'));
        gen.writeStringField('suit_filed', mapOfPolicyParameters.get('suit_filed'));
        gen.writeNumberField('no_of_live_PL', Integer.valueOf(mapOfPolicyParameters.get('no_of_live_PL')));
        gen.writeStringField('cc_dpd', mapOfPolicyParameters.get('cc_dpd'));
        gen.writeStringField('cc_30dpd', mapOfPolicyParameters.get('cc_30dpd'));
        gen.writeNumberField('total_current_outstanding', Integer.valueOf(mapOfPolicyParameters.get('total_current_outstanding')));
        gen.writeStringField('gold_loan_dpd', mapOfPolicyParameters.get('gold_loan_dpd'));
        gen.writeStringField('consent_on_app_form', mapOfPolicyParameters.get('consent_on_app_form'));
        gen.writeStringField('consent_on_agreement_form', mapOfPolicyParameters.get('consent_on_agreement_form'));
        gen.writeNumberField('no_of_insurances', Integer.valueOf(mapOfPolicyParameters.get('no_of_insurances')));
        gen.writeStringField('application_source',mapOfPolicyParameters.get('application_source'));//Bug 22624
        gen.writeStringField('company_category', mapOfPolicyParameters.get('company_category')); //24997


        gen.writeEndObject();
        gen.writeEndObject();
        String endpointURL = '';
        String username = '';
        STring password = '';

        if (!CommonUtility.isEmpty(staticresc)) {
          string jsnBody = staticresc.Body.toString();
          Map < String, Object > ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
          Map < String, Object > breMap = (Map < String, Object > ) ALLMap.get('BREEndpoint');
          //Map < String, Object > credsMap = (Map < String, Object > ) breMap.get('Common Endpoint');
          Map < String, Object > credsMap = (Map < String, Object > ) breMap.get(mapOfPolicyParameters.get('product')+' Endpoint');  //22018 RSL Mobility Hrushikesh

          if (credsMap != null) {
            endpointURL = (String) credsMap.get('Endpoint');
            username = (String) credsMap.get('userName');
            password = (String) credsMap.get('password');
            System.debug('rohit333 ' + endpointURL);
          }
        }
        system.debug('username' + userName + password);
        String jsonString = gen.getAsString();
        system.debug('jsonString' + jsonString);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        req.setbody(jsonString);
        req.setTimeout(120000);
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = EncodingUtil.base64Encode(headerValue);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        Http http = new Http();

        HTTPResponse res = new HTTPResponse();
        if (!Test.isRunningTest()) {
          res = http.send(req);
          if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            // Proper Response
            System.debug('Request document -----> ' + req.getBody());
            String result = res.getBody();
            System.debug('Result document----->' + result);
            mapOfResults = (Map < String, Object > ) JSON.deserializeUntyped(result);

          } else {
            // Error in getting response
            System.debug('<-----CONNECTION ERROR----->');
          }
        }
      }
    } catch (Exception e) {
      System.debug('Exception>>>' + e.getLineNumber() + e.getStackTraceString() + 'cause:' + e);
    }
    return mapOfResults;
  }
  public Map < String, String > parseResponseForDocument(String responseMap) {
    Map < String, String > mapOfResults = new Map < String, String > ();

    // JSONResponse reponse = JSONResponse.parse(responseMap);
    // System.debug('*****Response*****' + reponse);
    Map < String, Object > inputJSON = (Map < String, Object > ) JSON.deserializeUntyped(responseMap);

    if (inputJSON.get('Verifications_Output') != null) {
      Map < String, Object > inputbody = (Map < String, Object > )(inputJSON.get('Verifications_Output'));
      if (inputbody.get('verificationsList') != null) {
        List < object > verObj = (List < object > ) inputbody.get('verificationsList');
        system.debug('verObj>>' + verObj);
        string code = '';
        for (Object obj: verObj) {
          system.debug('obj>>>' + obj);
          Map < String, Object > mapobj = (Map < String, Object > ) obj;
          if (code != '')
            code = code + ',' + String.valueof(mapobj.get('verification_code'));
          else
            code = String.valueof(mapobj.get('verification_code'));
        }
        system.debug('code>>>' + code);
        mapOfResults.put('BREVerificationCodes', code);
      }
    }
    system.debug('map ------->' + mapOfResults);

    return mapOfResults;
  }

  public Map < String, Object > parseResponseForPANBRE(String responseMap) {
    Map < String, Object > mapOfResults = new Map < String, Object > ();
    Map < String, Object > inputJSON = (Map < String, Object > ) JSON.deserializeUntyped(responseMap);
    try {
      if (inputJSON.get('Pan_Series_Output') != null) {
        Map < String, Object > inputbody = (Map < String, Object > )(inputJSON.get('Pan_Series_Output'));
        for (String str: inputbody.keySet()) {
          /*System.debug('00'+inputbody.get(str));
           System.debug((inputbody.get(str)) instanceof Map<String,String>);*/
          mapOfResults.put(str, inputbody.get(str));
        }

      }
    } catch (Exception e) {
      System.debug('Exception in ' + e.getLineNumber() + e.getMessage());
    }

    system.debug('map ------->' + mapOfResults);

    return mapOfResults;
  }
  public Map < String, Object > callPANBRE(MAP < String, String > inputMap, List < De_Dupe__c > dedupeList) {
    Map < String, Object > mapOfResults = new Map < String, String > ();
    // List<De_Dupe__c>  dedupeLst = new List<De_Dupe__c>();
    if (inputMap != null) {
      JSONGenerator gen = JSON.createGenerator(true);
      gen.writeStartObject();
      gen.writeStringField('call_type', 'PAN AND CODIFIED');
      gen.writeFieldName('Pan_Series_Input');
      gen.writeStartObject();
      System.debug('branch Name n bre  -->' + inputMap.get('branch_Name'));
      gen.writeStringField('branch_name', inputMap.get('branch_Name'));
      gen.writeStringField('loan_id', inputMap.get('loan_id'));
      gen.writeStringField('product', inputMap.get('product'));
      gen.writeStringField('date_of_birth', inputMap.get('date_of_birth'));
      gen.writeStringField('pan', inputMap.get('pan'));
      gen.writeStringField('pan_status', inputMap.get('pan_status'));
      gen.writeStringField('dual_pan_records_found', inputMap.get('dual_pan_records_found'));
      if (!commonutility.isEmpty(inputMap.get('email_verified'))) {
        if (inputMap.get('email_verified') == 'true') {
          gen.writeStringField('email_verified', 'YES');
        } else {
          gen.writeStringField('email_verified', 'NO');
        }
      } else {
        gen.writeStringField('email_verified', 'NO');
      }
      system.debug('domaincheck >' + inputMap.get('domain_check'));
      gen.writeStringField('domain_check', inputMap.get('domain_check'));
      gen.writeStringField('EPFO_api_response', inputMap.get('EPFO_api_response'));
      gen.writeStringField('EPFO_test_result', inputMap.get('EPFO_test_result'));
      gen.writeStringField('email_triggered', inputMap.get('email_triggered'));
      gen.writeStringField('product_Identifier', inputMap.get('product_Identifier') != null ?inputMap.get('product_Identifier'):'NO' );//US 1636
      gen.writeFieldName('codified_dedupe_inputs');
      gen.writeStartArray();
      System.debug('dedupeLst ' + dedupeList.size());

      for (integer i = 0; i < dedupeList.size(); i++) {
        System.debug('inputMap.get(emi_bounce_last_3months))' + inputMap.get('emi_bounce_last_3months'));
        System.debug('dedupeLst[i]' + dedupeList[i]);
        gen.writeStartObject();
        //US 1636 start
        gen.writeNumberField('mob', Decimal.valueOf(inputMap.get('mob')));
        gen.writeNumberField('emi_bounce_last_3months', Integer.valueOf(inputMap.get('emi_bounce_last_3months')));
        gen.writeNumberField('emi_bounce_last_6months', Integer.valueOf(inputMap.get('emi_bounce_last_6months')));
        gen.writeStringField('dedupe_source',dedupeList[i].Dedupe_Source__c  != null ? dedupeList[i].Dedupe_Source__c:'');
        gen.writeStringField('customer_status',dedupeList[i].Customer_Status__c != null ? dedupeList[i].Customer_Status__c :'');
        //gen.writeNumberField('no_of_live_PL',Integer.valueOf(inputMap.get('no_of_live_PL')));
        if(dedupeList[i].MOB_of_LAN__c != null)
            gen.writeNumberField('mob__c',dedupeList[i].MOB_of_LAN__c);
        else
            gen.writeNullField('mob__c');
                   
        if(dedupeList[i].Non_Tech_Bounce_Last_3_Months__c != null) 
            gen.writeNumberField('non_Tech_Bounce_Last_3_Months__c',dedupeList[i].Non_Tech_Bounce_Last_3_Months__c);
        else
            gen.writeNullField('non_Tech_Bounce_Last_3_Months__c');
                    
        if(dedupeList[i].Non_Tech_Bounce_Last_6_Months__c != null)    
            gen.writeNumberField('non_Tech_Bounce_Last_6_Months__c',dedupeList[i].Non_Tech_Bounce_Last_6_Months__c);
        else
            gen.writeNullField('non_Tech_Bounce_Last_6_Months__c');
                    
        gen.writeStringField('product__c',dedupeList[i].Product__c != null ? dedupeList[i].Product__c:'');
        //US 1636 stop
        gen.writeEndObject();
      }
      gen.writeEndArray();
      gen.writeFieldName('cod_cibil');
      gen.writeStartObject();
      gen.writeNumberField('overdue_amount', Decimal.valueOf(inputMap.get('overdue_amount')));
      gen.writeStringField('dpd30_in_last_6months', inputMap.get('dpd30_in_last_6months'));
      gen.writeStringField('dpd90_in_last_6months', inputMap.get('dpd90_in_last_6months'));
      gen.writeNumberField('no_of_live_PL', Integer.valueOf(inputMap.get('no_of_live_PL')));
      gen.writeStringField('cc_dpd', inputMap.get('cc_dpd'));
      gen.writeStringField('gold_loan_dpd', inputMap.get('gold_loan_dpd'));
      gen.writeStringField('cc_30dpd', inputMap.get('cc_30dpd'));
      gen.writeNumberField('total_current_outstanding', Integer.valueOf(inputMap.get('total_current_outstanding')));
      gen.writeStringField('asset_classification_view', inputMap.get('asset_classification_view'));
      gen.writeStringField('suit_filed', inputMap.get('suit_filed'));
      gen.writeNumberField('CIBIL_Score', Integer.valueOf(inputMap.get('CIBIL_Score')));
      gen.writeNumberField('net_Salary_for_Month1', Decimal.valueOf(inputMap.get('net_Salary_for_Month1')));
      gen.writeNumberField('number_of_HL_Loans', Integer.valueOf(inputMap.get('number_of_HL_Loans')));
      gen.writeNumberField('noOfPLEnquiriesIn12M', Decimal.valueOf(inputMap.get('noOfPLEnquiriesIn12M')));
      gen.writeStringField('settlement', inputMap.get('settlement'));
      gen.writeStringField('written_off_settled_status', inputMap.get('written_off_settled_status'));
      gen.writeNumberField('noOfPLEnquiriesIn6M', Decimal.valueOf(inputMap.get('noOfPLEnquiriesIn6M')));
      gen.writeStringField('company_Category', inputMap.get('company_Category'));
      gen.writeNumberField('unsecuredLoanRatio', Decimal.valueOf(inputMap.get('unsecuredLoanRatio')));
      gen.writeStringField('dpd_cluster_segment', inputMap.get('dpd_cluster_segment'));
      gen.writeEndObject();
      gen.writeEndObject();
      gen.writeEndObject();
      HttpRequest req = new HttpRequest();
      Blob headerValue = Blob.valueOf('DEFAULT\\Admin' + ':' + 'Admin');
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      String endpointURL = '';
      if (!CommonUtility.isEmpty(staticresc)) {
        string jsnBody = staticresc.Body.toString();
        Map < String, Object > ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
        Map < String, Object > breMap = (Map < String, Object > ) ALLMap.get('BREEndpoint');
        //Map < String, Object > credsMap = (Map < String, Object > ) breMap.get('Common Endpoint');
        Map < String, Object > credsMap = (Map < String, Object > ) breMap.get(inputMap.get('product')+' Endpoint');  //22018 RSL Mobility Hrushikesh
        if (credsMap != null) {
          endpointURL = (String) credsMap.get('Endpoint');
          req.setEndpoint(endpointURL);
          System.debug('Endpoint ' + endpointURL);
        }
      }
      String jsonString = gen.getAsString();
      System.debug('robin ' + jsonString);

      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      Http http = new Http();
      HTTPResponse res = new HTTPResponse();
      if (!Test.isRunningTest()) {
        res = http.send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          // Proper Response
          System.debug('Request -----> ' + req.getBody());
          String result = res.getBody();
          System.debug('Result HV ----->' + result);
          mapOfResults = parseResponseForPANBRE(result);
          System.debug('Result ----->' + result);

        } else {
          System.debug('<-----CONNECTION ERROR----->');
        }
      }
    }
    return mapOfResults;
  }

  public Map < String, Object > callBREDynamicOffer(MAP < String, String > mapOfPolicyParameters) {

        Map < String, Object > mapOfResults = new Map < String, Object > ();

        if (mapOfPolicyParameters != null) {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            //gen.writeStringField('call_type', mapOfPolicyParameters.get('call_type'));

            gen.writeFieldName('Eligibility_Inputs');
            gen.writeStartObject();
            //24318 start
            gen.writeStringField('loan_id',mapOfPolicyParameters.get('loan_id')); 
            gen.writeStringField('product',mapOfPolicyParameters.get('product'));
            gen.writeStringField('branch_name',mapOfPolicyParameters.get('branch_name'));
            gen.writeStringField('sub_industry',mapOfPolicyParameters.get('sub_industry'));
            gen.writeStringField('system_designation',mapOfPolicyParameters.get('system_designation'));
            gen.writeNumberField('total_employment_vintage',Decimal.valueOf(mapOfPolicyParameters.get('total_employment_vintage')));
            gen.writeStringField('qualification',mapOfPolicyParameters.get('qualification'));
            gen.writeStringField('institute_name',mapOfPolicyParameters.get('institute_name'));
            gen.writeStringField('company_name',mapOfPolicyParameters.get('company_name'));
            gen.writeNumberField('final_foir',Decimal.valueOf(mapOfPolicyParameters.get('final_foir')));
            gen.writeNumberField('unsecured_foir',Decimal.valueOf(mapOfPolicyParameters.get('unsecured_foir')));
            gen.writeNumberField('monthly_loan_obligations',Decimal.valueOf(mapOfPolicyParameters.get('monthly_loan_obligations')));
            gen.writeNumberField('bajaj_loan_obligations',Decimal.valueOf(mapOfPolicyParameters.get('bajaj_loan_obligations')));
             if (mapOfPolicyParameters.get('CIBIL_Score') == '00000')
                gen.writeNumberField('CIBIL_Score', 0);
            else if (mapOfPolicyParameters.get('CIBIL_Score') == '000-1')
                gen.writeNumberField('CIBIL_Score', -1);
            else
                gen.writeNumberField('CIBIL_Score', mapOfPolicyParameters.get('CIBIL_Score') != null ? Decimal.valueof(mapOfPolicyParameters.get('CIBIL_Score')) : 0);
            gen.writeNumberField('number_of_HL_Loans', Decimal.valueof(mapOfPolicyParameters.get('number_of_HL_Loans')));
            gen.writeNumberField('noOfPLEnquiriesIn6M', Decimal.valueof(mapOfPolicyParameters.get('noOfPLEnquiriesIn6M')));
            gen.writeNumberField('noOfPLEnquiriesIn12M', Decimal.valueof(mapOfPolicyParameters.get('noOfPLEnquiriesIn12M')));
            gen.writeStringField('codified_cibil',mapOfPolicyParameters.get('codified_cibil'));//codified cibil CR     
            gen.writeFieldName('offer_roi_inputs');
            gen.writeStartObject();
            gen.writeStringField('cibil_type',mapOfPolicyParameters.get('cibil_type'));
            gen.writeStringField('company_category',mapOfPolicyParameters.get('company_category'));
            gen.writeNumberField('securedUnsecuredRatio',Decimal.valueOf(mapOfPolicyParameters.get('securedUnsecuredRatio')));
            gen.writeNumberField('cibil_pl_enq_3months',Integer.valueOf(mapOfPolicyParameters.get('cibil_pl_enq_3months')));
            gen.writeNumberField('cibil_pl_enq_6months',Integer.valueOf(mapOfPolicyParameters.get('cibil_pl_enq_6months')));
            gen.writeStringField('affluence',mapOfPolicyParameters.get('affluence'));
            gen.writeNumberField('loan_amount',Decimal.valueOf(mapOfPolicyParameters.get('loan_amount')));
            gen.writeStringField('dob',mapOfPolicyParameters.get('dob'));          
            gen.writeEndObject();
            gen.writeStringField('dob',mapOfPolicyParameters.get('dob'));
            gen.writeNumberField('monthly_loan_obligations_unsec', Decimal.valueof(mapOfPolicyParameters.get('monthly_loan_obligations_unsec')));
            gen.writeNumberField('applicable_foir', Decimal.valueof(mapOfPolicyParameters.get('applicable_foir')));
            gen.writeNumberField('monthly_salary',Decimal.valueOf(mapOfPolicyParameters.get('monthly_salary')));
            gen.writeNumberField('existing_loan_EMI',Decimal.valueOf(mapOfPolicyParameters.get('existing_loan_EMI')));
            gen.writeNumberField('assumed_loan_amt',Decimal.valueOf(mapOfPolicyParameters.get('assumed_loan_amt')));
            gen.writeNumberField('unsecured_existing_loan_EMI',Decimal.valueOf(mapOfPolicyParameters.get('unsecured_existing_loan_EMI')));
            gen.writeStringField('account_type_flag',mapOfPolicyParameters.get('account_type_flag')); 
            gen.writeStringField('application_source',mapOfPolicyParameters.get('application_source')); //22624 Sprint 5C
            gen.writeStringField('customer_segment',mapOfPolicyParameters.get('customer_segment')); 
            gen.writeStringField('account_type',mapOfPolicyParameters.get('account_type')); 
            gen.writeNumberField('sanctioned_loan_amount',Decimal.valueOf(mapOfPolicyParameters.get('sanctioned_loan_amount')));
            gen.writeStringField('company_category',mapOfPolicyParameters.get('company_category'));
            gen.writeEndObject();
            gen.writeFieldName('account_Details');
            //gen.writeObject(accountdata);
            
            List<Map<String,String>> accountdata = (List<Map<String,String>>)JSON.deserialize(mapOfPolicyParameters.get('account_Details'),List<Map<String,String>>.class);
            //gen.writeObject(accountdata);
            gen.writeStartArray();
            if(!CommonUtility.isEmpty(accountData)){
            for(Map<String,String> accMap : accountdata){
                gen.writeStartObject();
                gen.writeStringField('account_type',accMap.get('account_type') != null ? accMap.get('account_type') : '');
                gen.writeStringField('loan_start_date',accMap.get('loan_start_date') != null ? accMap.get('loan_start_date') : '');
                
                gen.writeStringField('ownership_type',accMap.get('ownership_type') != null ? accMap.get('ownership_type') : '');
                if(accMap.get('loan_amount') != null & accMap.get('loan_amount') != '')
                    gen.writeNumberField('loan_amount',Decimal.valueOf(accMap.get('loan_amount')));
                else
                    gen.writeNullField('loan_amount');
                gen.writeStringField('secured_OR_unsecured',accMap.get('secured_OR_unsecured') != null ? accMap.get('secured_OR_unsecured'):'' );
            gen.writeEndObject();
            }
            }
            gen.writeEndArray();
            gen.writeEndObject(); 
               //24318 stop    
            String endpointURL = '';
            String username = '';
            STring password = '';

            if (!CommonUtility.isEmpty(staticresc)) {
                string jsnBody = staticresc.Body.toString();
                Map < String, Object > ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
                Map < String, Object > breMap = (Map < String, Object > ) ALLMap.get('BREEndpoint');
                Map < String, Object > credsMap = (Map < String, Object > ) breMap.get('Dynamic offer');//24318 changed tag name

                if (credsMap != null) {
                    endpointURL = (String) credsMap.get('Endpoint');
                    username = (String) credsMap.get('userName');
                    password = (String) credsMap.get('password');
                    System.debug('rohit333 ' + endpointURL);
                }
            }
            //system.debug('username' + userName + password);
            String jsonString = gen.getAsString();
            system.debug('jsonString' + jsonString);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpointURL);
            req.setMethod('POST');
            req.setbody(jsonString);
            req.setTimeout(120000);
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = EncodingUtil.base64Encode(headerValue);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Basic ' + authorizationHeader);
            Http http = new Http();
            HTTPResponse res;
            system.debug('request is' + req);
            if (!Test.isRunningTest()) {
                res = http.send(req);
                if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
                    // Proper Response
                    System.debug('Request -----> ' + req.getBody());
                    String result = res.getBody();
                    System.debug('Result ----->' + result);
                    mapOfResults = (Map < String, Object > ) JSON.deserializeUntyped(result);
                    System.debug('Map of result -----> ' + mapOfResults);
                } else {
                    // Error in getting response
                    System.debug('<-----CONNECTION ERROR----->');
                }
            }
        }
        return mapOfResults;
    }
  //Calling Eligibility for CA & Doctors BUG ID 18592
  public DoctorCAEligibilityResponse EligibilityCallForCADoctors(MAP < String, String > mapOfParameters) {
    DoctorCAEligibilityResponse objResponse;
    try {
      system.debug('Start of EligibilityCallForCADoctors method');
      /*if(mapOfParameters != null && mapOfParameters.size() >0)
   {
       for(string mapKey : mapOfParameters.keyset())
       {
           system.debug('Key Name --> ' + mapKey + ' Key Value --> ' + mapOfParameters.get(mapKey));
       }
   } Uncomment if loop to cross check key & values*/
      Map < string, string > MailTriggerResponces = new Map < string, string > ();

      JSONGenerator gen = JSON.createGenerator(true);

      //Start of main object
      gen.writeStartObject();
      //gen.writeFieldName('Doctors_Inputs'); 
      //gen.writeStartObject(); 
      gen.writeStringField('product', mapOfParameters.get('product') != null ? mapOfParameters.get('product') : '');
      gen.writeStringField('loan_id', mapOfParameters.get('loan_id') != null ? mapOfParameters.get('loan_id') : '');
      gen.writeStringField('profession', mapOfParameters.get('profession') != null ? mapOfParameters.get('profession') : '');
      gen.writeStringField('type_of_degree', mapOfParameters.get('type_of_degree') != null ? mapOfParameters.get('type_of_degree') : '');
      gen.writeNumberField('total_employment_vintage', mapOfParameters.get('total_employment_vintage') != null ? Decimal.valueof(mapOfParameters.get('total_employment_vintage')) : 0);
      System.Debug('Value of total_live_sanctioned_amt ' + mapOfParameters.get('total_live_sanctioned_amt'));
      gen.writeNumberField('total_live_sanctioned_amt', mapOfParameters.get('total_live_sanctioned_amt') != null ? Decimal.valueof(mapOfParameters.get('total_live_sanctioned_amt')) : 0);
      gen.writeNumberField('total_pos', mapOfParameters.get('total_pos') != null && mapOfParameters.get('total_pos') != '' ? Double.valueof(mapOfParameters.get('total_pos')) : 0);
      gen.writeNumberField('max_closed_loan', mapOfParameters.get('max_closed_loan') != null && mapOfParameters.get('max_closed_loan') != '' ? Double.valueof(mapOfParameters.get('max_closed_loan')) : 0);
      gen.writeStringField('customer_segment', mapOfParameters.get('customer_segment') != null ? mapOfParameters.get('customer_segment') : '');
      gen.writeStringField('branch_name', mapOfParameters.get('branch_name') != null && mapOfParameters.get('branch_name') != '' ? mapOfParameters.get('branch_name') : '');
      //gen.writeNumberField('unSecuredLoanAmount', mapOfParameters.get('unSecuredLoanAmount') != null && mapOfParameters.get('unSecuredLoanAmount') != '' ? Double.valueof(mapOfParameters.get('unSecuredLoanAmount')) : 0);
      //gen.writeNumberField('securedLoanAmount', mapOfParameters.get('securedLoanAmount') != null && mapOfParameters.get('securedLoanAmount') != '' ? Double.valueof(mapOfParameters.get('securedLoanAmount')) : 0);
      // Bug Id : 22425
      gen.writeNumberField('unSecuredLoanAmount', mapOfParameters.get('unSecuredLoanAmount') != null && mapOfParameters.get('unSecuredLoanAmount') != '' ? Decimal.valueof(mapOfParameters.get('unSecuredLoanAmount')) : 0);
      gen.writeNumberField('securedLoanAmount', mapOfParameters.get('securedLoanAmount') != null && mapOfParameters.get('securedLoanAmount') != '' ? Decimal.valueof(mapOfParameters.get('securedLoanAmount')) : 0);
      //System.debug('double --> ' + Decimal.valueOf(mapOfParameters.get('unSecuredLoanAmount')));
      // System.debug('double --> ' + Decimal.valueof(mapOfParameters.get('securedLoanAmount')));
      IF(mapOfParameters.get('cibil_score') != null) {
        if (mapOfParameters.get('cibil_score') == '00000')
          gen.writeNumberField('cibil_score', 0);
        else
          if (mapOfParameters.get('cibil_score') == '000-1')
            gen.writeNumberField('cibil_score', 0);
          else
            gen.writeNumberField('cibil_score', mapOfParameters.get('cibil_score') != '' ? Double.valueof(mapOfParameters.get('cibil_score')) : 0);
      }
      else
        gen.writeNumberField('cibil_score', 0);
      gen.writeStringField('date_of_birth', mapOfParameters.get('date_of_birth') != null && mapOfParameters.get('date_of_birth') != '' ? mapOfParameters.get('date_of_birth') : '');
      gen.writeStringField('date_of_registration', mapOfParameters.get('date_of_registration') != null && mapOfParameters.get('date_of_registration') != '' ? mapOfParameters.get('date_of_registration') : '');
      gen.writeEndObject();

      String jsonString = gen.getAsString();
      System.Debug('jsonString --> ' + jsonString);
      //System.debug('jsonString=======>' + JSON.serialize(jsonString));
      //System.Debug('Json string length' + jsonString.length());
      HttpRequest req = new HttpRequest();
      Mid_office_BRE_flow__c emailTrigger = Mid_office_BRE_flow__c.getValues('Doctor_CA_Eligibility');
      username = emailTrigger.Username__c;
      password = emailTrigger.Password__C;
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);
      //system.debug('authorizationHeader --->' + authorizationHeader);
      if (emailTrigger != null) {
        endpointURL = '';
        endpointURL = emailTrigger.EndpointURL__c;
      }
      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      req.setHeader('Content-Type', 'application/json;charset=UTF-8');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      if (!Test.isRunningTest()) {
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.Debug('Request ' + req);
        if (res != null) {
          String result = res.getBody();
          system.debug('result======>' + result);
          if (result != null && result != '') {
            objResponse = DoctorCAEligibilityResponse.parse(result);
            System.Debug('Values of objResponse ' + objResponse);
          }
        } else
          System.Debug('Result returned as null ');
      }
    } catch (Exception ex) {
      system.debug('Exception occured in EligibilityCallForCADoctors and details are Line Number ' + ex.getLineNumber() + 'Details are ' + ex);
    }
    if (objResponse != null)
      return objResponse;
    else
      return null;
  }
  /* Digital Sampling - s */
  //Added For LoanGuard Access Token Digital Sampling
  public static string getLgAccessToken(String calltype)
  {
    List<StaticResource> staticRsrc = new List<StaticResource>();
    staticRsrc = [SELECT body from StaticResource where name = 'SalariedCustomSettings'];
    String accessToken = null;
    if(staticRsrc != NULL && staticRsrc.size() > 0)
    {
      String jsnBody= staticRsrc[0].Body.tostring();
      System.debug('jsnBody --> ' + jsnBody);
      Map<String,Object> allMap= (Map<String,Object>) JSON.deserializeUntyped(jsnBody);
      Map<String,Object> valueCollateral = new Map<String,Object>();
      valueCollateral = (Map<String,Object>)allMap.get(calltype);
      System.debug('valueCollateral --> ' + valueCollateral);
      accessToken = GeneralUtilities.genAccessToken(valueCollateral); 
      System.debug('accessToken --> ' + accessToken);
    }
    return accessToken;

  }
  //save button logic for digital sampling
  public MAP < String, object > callLoanguardAPI(Map < String, String > loanAppMap , List<Applicant__c> appLst , String testRes){
    String endpointURL;
    System.debug('Inside BRE LoanGuard');
    System.debug('Product BRE --> ' + String.valueOf(loanAppMap.get('ProductName')));
    Map< String , Object > loanGuardResponse = new Map< String , Object >();
    Mid_office_BRE_flow__c LGEndpoint = Mid_office_BRE_flow__c.getValues('LGCreateApplication');
    if (!Test.isRunningTest()){
      endpointURL = LGEndpoint.EndpointURL__c;
    }
    else{
      endpointURL = '';
    }
    JSONGenerator gen = JSON.createGenerator(true);
    try{
      gen.writeStartObject();
      gen.writeStringField('ApplicationNo' , loanAppMap.get('ApplicationNo') != null ? String.valueOf(loanAppMap.get('ApplicationNo')) : '');
      gen.writeStringField('ApplicationDate', loanAppMap.get('ApplicationDate') != null ? String.valueOf(loanAppMap.get('ApplicationDate')) : '');
      gen.writeNumberField('LoanTenure', loanAppMap.get('LoanTenure') != null ? Integer.valueOf(loanAppMap.get('LoanTenure')) : 0);
      gen.writeNumberField('LoanAmount', loanAppMap.get('LoanAmount') != null ? Integer.valueOf(loanAppMap.get('LoanAmount')) : 0);
      gen.writeStringField('ProductName', loanAppMap.get('ProductName') != null? String.valueOf(loanAppMap.get('ProductName')) : '');

      gen.writeFieldName('Applicants');
      gen.writeStartArray();
      String appType;
      for(Applicant__c app : appLst){
        if(app.Applicant_Type__c == 'Primary'){
          appType = 'Applicant';
        }
        else if(app.Applicant_Type__c == 'Guarantor'){
          appType = 'Guarantor';
        }
        else{
          appType = 'Co-Applicant';
        }
        gen.writeStartObject();
        gen.writeStringField('ApplicantTypeCode' , appType != null ? appType : '');
        gen.writeStringField('LoanguardId' , '');
        gen.writeStringField('ApplicantFirstName' , app.Contact_Name__r.FirstName != null ? String.valueOf(app.Contact_Name__r.FirstName) : '');
        gen.writeStringField('ApplicantMiddleName' , app.Contact_Name__r.Middle_Name__c != null ? String.valueOf(app.Contact_Name__r.Middle_Name__c) : '');
        gen.writeStringField('ApplicantLastName' , app.Contact_Name__r.LastName != null ? String.valueOf(app.Contact_Name__r.LastName) : '');
        gen.writeStringField('ApplicantDateOfBirth' , app.Contact_Name__r.Date_of_Birth__c != null ? String.valueOf(app.Contact_Name__r.Date_of_Birth__c.day() + '/' + app.Contact_Name__r.Date_of_Birth__c.month() + '/' + app.Contact_Name__r.Date_of_Birth__c.year()) : '' );
        gen.writeStringField('ApplicantGender' , app.Contact_Name__r.Gender__c != null ? String.valueOf(app.Contact_Name__r.Gender__c) : '');
        gen.writeStringField('APresentAddress' , app.Contact_Name__r.Address_1__c + ' ' + app.Contact_Name__r.Address_2__c + ' ' + app.Contact_Name__r.Address_3__c);
        gen.writeStringField('APermanentAddress' , app.Contact_Name__r.Permanant_Address_Line_1__c + ' ' + app.Contact_Name__r.Permanant_Address_Line_2__c + ' ' + app.Contact_Name__r.Permanant_Address_Line_3__c);
        gen.writeStringField('ACompanyAddress' , app.Contact_Name__r.Address_Line_One__c + ' ' + app.Contact_Name__r.Address_2nd_Line__c + ' ' + app.Contact_Name__r.Address_3rd_Line__c);
        gen.writeStringField('ApplicantVoterIdNo' , app.Contact_Name__r.VoterID_Number__c != null ? String.valueOf(app.Contact_Name__r.VoterID_Number__c):'');
        gen.writeStringField('ApplicantPanNo' , app.Contact_Name__r.PAN_Number__c != null ? String.valueOf(app.Contact_Name__r.PAN_Number__c) : '');
        gen.writeStringField('ApplicantAadharNo' , app.Contact_Name__r.Aadhar_Number__c != null ? String.valueOf(app.Contact_Name__r.Aadhar_Number__c) : '');
        gen.writeStringField('PassportNo' , app.Contact_Name__r.PassPort_Number__c != null ? String.valueOf(app.Contact_Name__r.PassPort_Number__c) : '');
        gen.writeStringField('ApplicantNationality' , 'Indian');
        gen.writeStringField('ApplicantDesignation' , app.Contact_Name__r.Designation__c != null ? String.valueOf(app.Contact_Name__r.Designation__c) : '');
        gen.writeStringField('ApplicantCompanyName' , app.Contact_Name__r.Employer_Name__c != null ? String.valueOf(app.Contact_Name__r.Employer_Name__c) : '');
        gen.writeStringField('ApplicantBankAcNo' , app.Contact_Name__r.Bank_Account_No__c != null ? String.valueOf(app.Contact_Name__r.Bank_Account_No__c) : '');
        gen.writeEndObject();

      }
      gen.writeEndArray();
      gen.writeEndObject();
    }
    catch(exception e){
      system.debug('error message --> ' + e.getMessage() + ' ' + e.getLineNumber());

    }
    System.debug('gen --> ' + gen);
    String jsonString = gen.getAsString();
    System.debug('jsonString --> ' + jsonString);
    HttpRequest req = new HttpRequest();
    System.debug('endpointURL --> ' + endpointURL);
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setbody(jsonString);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    String accessToken = getLgAccessToken('LoanGuardAPI');
    System.debug('accessToken'+accessToken);
    req.setHeader('Authorization','Bearer '+accessToken);
    Http http = new Http();
    HTTPResponse res;
    if (!Test.isRunningTest()) 
    {
      System.debug('Inside Callout');

      res = http.send(req);


    }
    else{
      res = new HTTPResponse();
      if(testRes == 'Success'){
        res.setBody('{"Status":"Success","Message":["Application saved successfully."],"Data":{"ApplicationNo":"5320670834076","Applicants":[{"LoanguardId":"L18325","ApplicantCustomerId":"","ApplicantFirstName":"conFirtsName","ApplicantMiddleName":"","ApplicantLastName":"Hanchate"}]}}');
      }
      else{
        res.setBody('{"Status":"Failed","Message":["Application saved successfully."],"Data":{"ApplicationNo":"5320670834076","Applicants":[{"LoanguardId":"L18325","ApplicantCustomerId":"","ApplicantFirstName":"conFirtsName","ApplicantMiddleName":"","ApplicantLastName":"Hanchate"}]}}');
      }

    }
    String result = res.getBody();
    System.debug('result -->'+result);
    loanGuardResponse = (Map<String, Object>)JSON.deserializeUntyped(result);
    system.debug('loanGuardResponse-->' + loanGuardResponse);

    return loanGuardResponse;
  }

  //submit button logic for sending the document digital sampling
  public static Map<String,object> CallBREForDocSubmit(List<Id> CVIDs,String ApplicationNo,String LGId)
  {
    Map<String,Object> responseMap = new Map<String,Object>();
    JSONGenerator gen = JSON.createGenerator(true);
    //System.debug('in method'+cvLst.size());
    String documents = '';

    gen.writeStartArray();
    System.debug('req size3 '+Limits.getHeapSize());
    for(ContentVersion cv : [select id,ContentDocumentId,Title,versionData from ContentVersion where ContentDocumentId IN: CVIDs]){
      gen.writeStartObject();
      gen.writeStringField('DocumentName' , cv.Title != null ? String.valueOf(cv.Title) : '');
      gen.writeStringField('DocumentData' , String.valueOf(EncodingUtil.base64Encode(cv.VersionData)) != null ?  String.valueOf(EncodingUtil.base64Encode(cv.VersionData)): '');
      gen.writeEndObject();
    }

    gen.writeEndArray();
    String DocjsonString = gen.getAsString();
    System.debug('req size4 '+Limits.getHeapSize());
    System.debug('DocjsonString --> ' + DocjsonString);
    HttpRequest req = new HttpRequest();
    List<String> lst = new List<String>();
    lst.add(ApplicationNo);
    lst.add(LGId);
    String endpointURL;
    Mid_office_BRE_flow__c LGSubmitEndpoint = Mid_office_BRE_flow__c.getValues('LGSubmitDocument');
    if (!Test.isRunningTest()){
      endpointURL = String.format(LGSubmitEndpoint.EndpointURL__c , lst);
    }
    else{
      endpointURL = ''; 
    }
    System.debug('endpointURL --> ' + endpointURL);
    req.setEndpoint(endpointURL);
    req.setMethod('POST');
    req.setBody(String.valueOf(DocjsonString));

    String accessToken = getLgAccessToken('LoanGuardAPI');
    System.debug('accessToken'+accessToken);
    req.setHeader('Authorization','Bearer '+accessToken);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');

    //System.debug('req size '+req.getBodyAsBlob().size());
    HTTPResponse res;
    Http http = new Http();
    if (!Test.isRunningTest()) 
    {
      res = http.send(req);

    }
    else{
      res = new HTTPResponse();
      res.setBody('{"Status":"Success","Message":[""],"Data":[{"DocumentTypeId":39,"LGDocumentName":"LG00987_Form GST REG_2.pdf","DocumentName":"FORM GST REG 26-02-2019 05:17:54 .pdf","DocumentIndex":2,"LGDocId":59468,"Status":"Success","Message":"Document uploaded successfully."}]}');
    }
    String result = res.getBody();
    System.debug('result -->'+res);
    System.debug('result body --> ' + result);
    if(result != null && result != '')
      responseMap = (Map<String, Object>)JSON.deserializeUntyped(result);

    System.debug('Submit responseMap --> ' + responseMap);
    return responseMap;
  }

  public static Map<String,object> CallMarkComplete(String loanApplicationNumber){
    Map<String,object> responseMap = new Map<String,object>();
    Mid_office_BRE_flow__c LGMarkCompleteEndpoint = Mid_office_BRE_flow__c.getValues('LGMarkComplete');
    String endpointURL;
    String endpoint;
    if (!Test.isRunningTest()){
      endpointURL = LGMarkCompleteEndpoint.EndpointURL__c;
      endpoint = endpointURL.replace('{{appno}}' , loanApplicationNumber);  
    }
    else{
      endpoint = '';
    }
    System.debug('Mark Complete endpoint --> ' + endpoint);
    String accessToken = getLgAccessToken('LoanGuardAPI');
    System.debug('accessToken'+accessToken);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpoint);
    req.setBody('');
    req.setMethod('POST');
    req.setHeader('Authorization','Bearer '+accessToken);
    req.setHeader('Content-Type', 'application/text;charset=UTF-8');
    //req.setHeader('Content-Length', '4096');
    Http http = new Http();
    HTTPResponse res;
    if (!Test.isRunningTest()) 
    {
      res = http.send(req);
    }
    else{
      res = new HTTPResponse();
      res.setBody('{"Status":"Success","Message":["Application 5320670834078 marked complete."]}');
    }
    String result = res.getBody();
    System.debug('result -->'+res);
    System.debug('result --> ' + result);
    System.debug('res code --> ' + res.getStatusCode());
    if(result != null && result != ''){
      responseMap = (Map<String, object>)JSON.deserializeUntyped(result);
}


    return responseMap;
  }
  //added for bug id 22019 shilpa start
   
   public Map < String, Object > callPANBreCheckPO(MAP < String, String > mapOfPolicyParameters) {
        System.debug('*************mapOfPolicyCheckParameters: ' + mapOfPolicyParameters);
    Map<String,Object> mapOfResults = new Map<String,String>();
        if(mapOfPolicyParameters != null){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('change_flag',mapOfPolicyParameters.get('change_flag'));
            gen.writeStringField('EPFO_api_response',mapOfPolicyParameters.get('EPFO_api_response'));
            gen.writeStringField('domain_check',mapOfPolicyParameters.get('domain_check'));
            gen.writeStringField('email_verified',mapOfPolicyParameters.get('email_verified'));
            if(mapOfPolicyParameters.get('CIBIL_score') != '000-1')
            gen.writeNumberField('CIBIL_Score',Decimal.valueOf(mapOfPolicyParameters.get('CIBIL_score')));
            else
            gen.writeNumberField('CIBIL_Score',0);
            gen.writeStringField('DPD_Cluster_seg',!CommonUtility.isEmpty(mapOfPolicyParameters.get('DPD_Cluster_seg'))?mapOfPolicyParameters.get('DPD_Cluster_seg'):'');
            gen.writeStringField('riskSegmentClassification',!CommonUtility.isEmpty(mapOfPolicyParameters.get('riskSegmentClassification'))?mapOfPolicyParameters.get('riskSegmentClassification'):'');
            gen.writeEndObject();
      
            String endpointURL = '';
            String username = '';
            STring password = '';
            
            if(!CommonUtility.isEmpty(staticresc)){
                string jsnBody = staticresc.Body.toString();
                Map<String,Object> ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);           
                Map<String,Object> breMap =(Map<String,Object>)ALLMap.get('BREEndpoint');
                Map<String,Object> credsMap =(Map<String,Object>)breMap.get('PANBREPO');
                
                if(credsMap != null){
                    endpointURL = (String)credsMap.get('Endpoint');
                    username = (String)credsMap.get('userName');
                    password = (String)credsMap.get('password');
                    System.debug('pkURL '+endpointURL);
                }
            }
            system.debug('username'+userName+password);
            String jsonString = gen.getAsString();   
            system.debug('jsonString'+jsonString);   
            Result=BREOpt(username,password,endpointURL,jsonString,'JSON');
                    System.debug('Result ----->' + result);
            if(result!=null && result != ''){
                    mapOfResults = (Map<String,Object>)JSON.deserializeUntyped(result);
                    System.debug('Map of result -----> ' + mapOfResults);
                } else {
                    System.debug('<-----CONNECTION ERROR----->');
                }         
            
        } 
        return mapOfResults;
    }
    //BREOpt Method added for Optimization of BRECallout
    public String BREOpt(String username, String password, String endpointURL, String body,String type) {
        String result='';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        req.setbody(body);
        req.setTimeout(120000);
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = EncodingUtil.base64Encode(headerValue);
        System.debug('authorizationHeader --->' + authorizationHeader + ' OR   REVGQVVMVFxBZG1pbjpBZG1pbg==');
        if(type=='XML')
        {
        req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
        }
        else
        {
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        }
        req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        
        Http http = new Http();
        System.debug('*****BRE call start:-' + system.now());
        if (!Test.isRunningTest()) {
            HTTPResponse res = http.send(req);
            
            System.debug('*****status:-' + res.getStatusCode());
            if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            System.debug('*****BRE call end:-' + system.now());
            System.debug('*****req:-' + req.getBody());
            System.debug(res.getBody());
            result = res.getBody();
            }
        }
        return result;
}   

   //added for bug id 22019 stop
  /* Digital Sampling - e */

  /* 20939 sprint 5 , added by hrushikesh */
  public Map<String,Object> callIM(MAP < String, String > mapOfPolicyParameters){
    try{
      Map < String, Object > mapOfResults = new Map < String, Object >();
      Map < String, Object > mapOfInner = new Map < String, Object >();
      System.debug('0');

      if(mapOfPolicyParameters != null){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        //gen.writeFieldName('Monitoring_Inputs');
        //  gen.writeStartObject();    


        System.debug('1');

        gen.writeStringField('pan_number',mapOfPolicyParameters.get('pan_number'));
        System.debug('2');
        if(mapOfPolicyParameters.get('cibil_score') == '00000')
          gen.writeNumberField('cibil_score',0);
        else if(mapOfPolicyParameters.get('cibil_score') == '000-1')
          gen.writeNumberField('cibil_score',-1);
        else
          gen.writeNumberField('cibil_score',decimal.valueOf(mapOfPolicyParameters.get('cibil_score')));

        System.debug('2');

        gen.writeStringField('date_of_first_loan',mapOfPolicyParameters.get('date_of_first_loan'));
        System.debug('2');

        gen.writeStringField('loan_type',mapOfPolicyParameters.get('loan_type'));
        System.debug('2');

        gen.writeNumberField('sanctioned_amount',Integer.valueOf(mapOfPolicyParameters.get('sanctioned_amount')));
        gen.writeNumberField('total_work_exp',double.valueOf(mapOfPolicyParameters.get('total_work_exp')));
        gen.writeStringField('sourcing_channel_risk',mapOfPolicyParameters.get('sourcing_channel_risk'));
        gen.writeStringField('company_category',mapOfPolicyParameters.get('company_category'));
        gen.writeStringField('designation',mapOfPolicyParameters.get('designation'));
        gen.writeStringField('salary_identified_through_perfios',mapOfPolicyParameters.get('salary_identified_through_perfios'));
        gen.writeStringField('qualification',mapOfPolicyParameters.get('qualification'));
        gen.writeStringField('edu_institute',mapOfPolicyParameters.get('edu_institute'));
        gen.writeStringField('offer_type',mapOfPolicyParameters.get('offer_type'));

        gen.writeObjectField('mobile',Boolean.valueOf(mapOfPolicyParameters.get('mobile')));
        gen.writeObjectField('bank_account',Boolean.valueOf(mapOfPolicyParameters.get('bank_account')));
        gen.writeObjectField('pan',Boolean.valueOf(mapOfPolicyParameters.get('pan')));
        gen.writeObjectField('dob',Boolean.valueOf(mapOfPolicyParameters.get('dob')));
        gen.writeObjectField('resi_addr',Boolean.valueOf(mapOfPolicyParameters.get('resi_addr')));
        gen.writeObjectField('perfios_response_flag',Boolean.valueOf(mapOfPolicyParameters.get('perfios_response_flag')));
        gen.writeStringField('bank_name',mapOfPolicyParameters.get('bank_name'));
        gen.writeStringField('source_of_data',mapOfPolicyParameters.get('source_of_data'));
        gen.writeNumberField('authenticity_score',double.valueOf(mapOfPolicyParameters.get('authenticity_score')));
        gen.writeStringField('branch_name',mapOfPolicyParameters.get('branch_name'));
        System.debug('3');

        gen.writeStringField('date_of_birth',mapOfPolicyParameters.get('date_of_birth'));
        gen.writeNumberField('salary',double.valueOf(mapOfPolicyParameters.get('salary')));
        gen.writeStringField('email_triggered',mapOfPolicyParameters.get('email_triggered'));
        gen.writeStringField('domain_check',mapOfPolicyParameters.get('domain_check'));
        gen.writeStringField('EPFO_api_response',mapOfPolicyParameters.get('EPFO_api_response'));
        gen.writeStringField('residential_type',mapOfPolicyParameters.get('residential_type'));
        gen.writeStringField('address_change_flag',mapOfPolicyParameters.get('address_change_flag'));
        gen.writeStringField('geo_tagging_location',mapOfPolicyParameters.get('geo_tagging_location'));
        gen.writeStringField('HL_PL',mapOfPolicyParameters.get('HL_PL'));
        gen.writeStringField('unsecured_loan',mapOfPolicyParameters.get('unsecured_loan'));
        gen.writeStringField('business_loan',mapOfPolicyParameters.get('business_loan'));
        gen.writeNumberField('HL_PL_amount',double.valueOf(mapOfPolicyParameters.get('HL_PL_amount')));
        gen.writeNumberField('unsecured_loan_amount',double.valueOf(mapOfPolicyParameters.get('unsecured_loan_amount')));
        gen.writeObjectField('geo_tagging_flag',Boolean.valueOf(mapOfPolicyParameters.get('geo_tagging_flag')));
        System.debug('4');

        gen.writeEndObject();
        //gen.writeEndObject();

        HttpRequest req = new HttpRequest();
        //Blob headerValue = Blob.valueOf('DEFAULT\\Admin' + ':' + 'Admin');
        //String authorizationHeader = EncodingUtil.base64Encode(headerValue);     
        //req.setHeader('Content-Type', 'application/json');
        //req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        String endpointURL = '';
        String username = '';
        STring password = '';
        if(!CommonUtility.isEmpty(staticresc)){
          string jsnBody = staticresc.Body.toString();
          Map<String,Object> ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);
          Map<String,Object> breMap =(Map<String,Object>)ALLMap.get('BREEndpoint');
          Map<String,Object> credsMap =(Map<String,Object>)breMap.get('Invisible_Monitoring');
          if(credsMap!= null){
            endpointURL = (String)credsMap.get('Endpoint');
            username =(String)credsMap.get('userName');
            password =(String)credsMap.get('password');

            //req.setEndpoint(endpointURL);
            System.debug('Hrushikesh -Endpoint is '+endpointURL);
          }
        }

        Blob headerValue = Blob.valueOf(username + ':' + password);
        system.debug('headerValue'+headerValue);
        String authorizationHeader = EncodingUtil.base64Encode(headerValue); 
        req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        String jsonString = gen.getAsString();
        System.debug('Json String '+authorizationHeader+jsonString);        

        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        req.setbody(jsonString);
        req.setTimeout(120000);

        req.setHeader('Content-Type', 'application/json');
        // req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        Http http = new Http();
        HTTPResponse res = new HTTPResponse() ;
        System.debug('Request -----> ' + req);
        if (!Test.isRunningTest()) {
          res = http.send(req);
          System.debug('Result ----->' + res);
          if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            // Proper Response

            String result = res.getBody();
            System.debug('Result ----->' + result);               
            mapOfResults = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
            mapOfInner = (Map < String, Object > )mapOfResults.get('Monitoring_Output');                   
          } else {
            // Error in getting response

            String result = res.getBody();
            System.debug('Result ----->' + result);
            System.debug('<-----CONNECTION ERROR----->');
          }         
        }
      } 
      return mapOfInner;
    }catch(Exception e)
    {System.debug('Exception e '+e.getMessage()+e.getLineNumber());}
    return null;
  }
  /* 20939 sprint 5 end , added by hrushikesh */
  /* 22017 sprint 5B start*/
  public Map < String, Object> callBRERisksSgmentation(MAP < String, String > mapOfPolicyParameters){

    Map < String, Object > mapOfResults =new Map < String, Object >();

    if(mapOfPolicyParameters != null){
      JSONGenerator gen = JSON.createGenerator(true);
      gen.writeStartObject();
      // gen.writeStringField('call_type','CUSTOMER SEGMENTATION');
      // gen.writeFieldName('Segment_Input');
      // gen.writeStartObject();
      gen.writeNumberField('number_of_HL_Loans',Decimal.valueof(mapOfPolicyParameters.get('number_of_HL_Loans')));
      gen.writeNumberField('noOfPLEnquiriesIn6M',Integer.valueof(mapOfPolicyParameters.get('noOfPLEnquiriesIn6M')));
      gen.writeNumberField('noOfPLEnquiriesIn12M',Integer.valueof(mapOfPolicyParameters.get('noOfPLEnquiriesIn12M')));
      if(mapOfPolicyParameters.get('cibil_Score') == '00000')
        gen.writeNumberField('cibil_Score',0);
      else if(mapOfPolicyParameters.get('cibil_Score') == '000-1')
        gen.writeNumberField('cibil_Score',-1);
      else
        gen.writeNumberField('cibil_Score',mapOfPolicyParameters.get('cibil_Score') != null ? Integer.valueof(mapOfPolicyParameters.get('cibil_Score')) : 0);

      // gen.writeEndObject();
      gen.writeEndObject();
      String endpointURL = '';
      String username = '';
      STring password = '';

      if(!CommonUtility.isEmpty(staticresc)){
        string jsnBody = staticresc.Body.toString();
        Map<String,Object> ALLMap = (Map<String,Object>)JSON.deserializeUnTyped(jsnBody);           
        Map<String,Object> breMap =(Map<String,Object>)ALLMap.get('BREEndpoint');
        Map<String,Object> credsMap =(Map<String,Object>)breMap.get('RiskSegmentation Endpoint');

        if(credsMap != null){
          endpointURL = (String)credsMap.get('Endpoint');
          username = (String)credsMap.get('userName');
          password = (String)credsMap.get('password');
          System.debug('pkURL '+endpointURL);
        }
      }
      system.debug('username'+userName+password);
      String jsonString = gen.getAsString();   
      system.debug('jsonString'+jsonString);   
      HttpRequest req = new HttpRequest();
      req.setEndpoint(endpointURL);
      req.setMethod('POST');
      req.setbody(jsonString);
      req.setTimeout(120000);
      Blob headerValue = Blob.valueOf(username + ':' + password);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);     
      req.setHeader('Content-Type', 'application/json');
      req.setHeader('Authorization', 'Basic ' + authorizationHeader);
      Http http = new Http();
      HTTPResponse res;
      system.debug('request is'+req);
      if (!Test.isRunningTest()) {
        res = http.send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
          System.debug('Request -----> ' + req.getBody());
          String result = res.getBody();
          System.debug('Result ----->' + result);               
          mapOfResults = (Map<String,Object>)JSON.deserializeUntyped(result);
          System.debug('Map of result -----> ' + mapOfResults);
        } else {
          System.debug('<-----CONNECTION ERROR----->');
        }         
      }
    } 
    return mapOfResults;
  }

  /* 22017 sprint 5B end*/
// Bug_23971 - Professional Loans Segmentation V2
public  Map < String, String > calculateNewSegmentationTwo( String jsonString ){


Map<String, String> mapOfSegmentationTwoResults = new Map<String, String>();

   /*  String userName    = Label.SegmentTwouserName;
     String Password    = Label.SegmentTwopassword;
     String endPointURL = Label.SegmentTwo_URL; */
   
   Mid_office_BRE_flow__c BRE_Flow = Mid_office_BRE_flow__c.getValues('SegmentationVTwo Flow');
        if (BRE_Flow != null) {
            username = BRE_Flow.Username__c;
            password = BRE_Flow.Password__c;
            endpointURL = BRE_Flow.EndpointURL__c;
        }
      
        System.debug('********Username used for new SegmentationV2********' + username);
        System.debug('********password used  for new SegmentationV2********' + password );
        System.debug('********endPointURL used for new SegmentationV2********' + endpointURL );
         
   System.debug('********JSON string to be passed for new SegmentationV2********' + jsonString);

  
         try {
               
                    HttpRequest req = new HttpRequest();   
                       
                    //   req.setEndpoint('http://10.156.128.9:8087/executionserver/rest/1/ruleServices/Eligibility_One/versions/0.0.1-SNAPSHOT/rules/Eligibility_One/Eligibility_One_Main/executions');
                       
                         req.setEndpoint(endpointURL);
                           
                         req.setMethod('POST'); 
                   
                         req.setbody(jsonString);
                         
                         req.setTimeout(120000); 
                      //   Blob headerValue = Blob.valueOf('DEFAULT\\Admin' + ':' + 'Admin');
                         Blob headerValue = Blob.valueOf(username + ':' + password);
                            
                  String authorizationHeader = EncodingUtil.base64Encode(headerValue);
                  
                   system.debug('authorizationHeader :: ' + authorizationHeader);
                  
                  req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                  req.setHeader('Authorization', 'Basic ' + authorizationHeader); 
                              Http http = new Http();
                         HTTPResponse res;
                           if(!Test.isRunningTest())
                              res = http.send(req);
                           else
                               {
                               res=new HTTPResponse();
                               res.setBody('{"Eligibility_One_Output":{"eligible_loan_amount":700000,"offer_roi":13.5,"offer_pf":1.75,"offer_insurance":1.75,"offer_tenor":96,"flat_offer_roi":14.0,"flat_offer_pf":1.5,"flat_offer_insurance":1.5,"credit_card_offer_amount":300000,"segmentation_one":"SEGMENT 1","customer_segment":"NORMAL","asset_score":10},"Action":true}');
                               }
                              
                              system.debug('res.getBody :: ' + res.getBody());
                          
                      
                   //   segmentTwoResponseclass responsecls  = (segmentTwoResponseclass)System.JSON.deserialize(res.getBody(), segmentTwoResponseclass.class);
                          
                          segmentTwoResponseclass responsecls  =  segmentTwoResponseclass.parse(res.getBody()); 
                             
                              system.debug('Printing response fron BRE, in formated class form -- ' + responsecls);
                              
                mapOfSegmentationTwoResults.put('eligible_loan_amount',String.valueOf(responsecls.Eligibility_One_Output.eligible_loan_amount));
            mapOfSegmentationTwoResults.put('offer_roi', String.valueOf(responsecls.Eligibility_One_Output.offer_roi));
            mapOfSegmentationTwoResults.put('offer_pf',String.valueOf(responsecls.Eligibility_One_Output.offer_pf));
            mapOfSegmentationTwoResults.put('offer_insurance',String.valueOf(responsecls.Eligibility_One_Output.offer_insurance));
            mapOfSegmentationTwoResults.put('offer_tenor',String.valueOf(responsecls.Eligibility_One_Output.offer_tenor));
            mapOfSegmentationTwoResults.put('flat_offer_roi',String.valueOf(responsecls.Eligibility_One_Output.flat_offer_roi));
            mapOfSegmentationTwoResults.put('flat_offer_pf',String.valueOf(responsecls.Eligibility_One_Output.flat_offer_pf));
            
            mapOfSegmentationTwoResults.put('flat_offer_insurance',String.valueOf(responsecls.Eligibility_One_Output.flat_offer_insurance));
            mapOfSegmentationTwoResults.put('credit_card_offer_amount', String.valueOf(responsecls.Eligibility_One_Output.credit_card_offer_amount));
            mapOfSegmentationTwoResults.put('segmentation_one',String.valueOf(responsecls.Eligibility_One_Output.segmentation_one));
            mapOfSegmentationTwoResults.put('customer_segment',String.valueOf(responsecls.Eligibility_One_Output.customer_segment));
            
            mapOfSegmentationTwoResults.put('asset_score',String.valueOf(responsecls.Eligibility_One_Output.asset_score));

              system.debug('{');
             for (String fieldName : mapOfSegmentationTwoResults.keySet())
              System.debug(fieldName + ': ' + mapOfSegmentationTwoResults.get(fieldName));
            system.debug('}');            
                                    
              } catch (Exception e) {
              String message = e.getMessage() + '  ' + e.getLineNumber() + '  ' + e.getCause() + '  ' + e.getTypeName();
              system.debug('Error msg  is  :: ' + message );
               }
        return mapOfSegmentationTwoResults;
}
 // Bug_23971 - Professional Loans Segmentation V2

 //US 5374 start
    
    public Map < String, Object > callExperiaAPI(Map<String,String> request){
        
         Map < String, Object > mapOfResults = new Map < String, Object > ();
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('SourceUID', request.get('SourceUID'));
        gen.writeStringField('SourceName', request.get('SourceName'));
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        System.debug('jsonString=======>' + jsonString);
        String endpointURL = '';
            String username = '';
            STring password = '';

            if (!CommonUtility.isEmpty(staticresc)) {
                string jsnBody = staticresc.Body.toString();
                Map < String, Object > ALLMap = (Map < String, Object > ) JSON.deserializeUnTyped(jsnBody);
                Map < String, Object > breMap = (Map < String, Object > ) ALLMap.get('BREEndpoint');
                Map < String, Object > credsMap = (Map < String, Object > ) breMap.get('Experia API');

                if (credsMap != null) {
                    endpointURL = (String) credsMap.get('Endpoint');
                    username = (String) credsMap.get('userName');
                    password = (String) credsMap.get('password');
                    System.debug('rohit333 ' + endpointURL);
                }
            }
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        req.setMethod('POST');
        req.setbody(jsonString);
            req.setTimeout(120000);
            Blob headerValue = Blob.valueOf(username + ':' + password);
            //String authorizationHeader = EncodingUtil.base64Encode(headerValue);
            req.setHeader('Content-Type', 'application/json');
            //req.setHeader('Authorization', 'Basic ' + authorizationHeader);
        Http http = new Http();
        HTTPResponse res;
        system.debug('request is' + req);
         if (!Test.isRunningTest()) {
            res = http.send(req);
                if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
                    // Proper Response
                    System.debug('Request -----> ' + req.getBody());
                    String result = res.getBody();
                    System.debug('Result ----->' + result);
                    mapOfResults = (Map < String, Object > ) JSON.deserializeUntyped(result);
                    System.debug('Map of result -----> ' + mapOfResults);
                } else {
                    // Error in getting response
                    System.debug('<-----CONNECTION ERROR----->');
                }
         }
        return mapOfResults;
    }
    //US 5374 stop

}