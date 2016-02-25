/*  @Author - Accenture     
    @name - ProjectBuilderLoginController      
    @Description - This class is used to handle login controles in project builder package and redirection to sandbox and 
                    production from that..    
    @Version - 1.0
*/ 
public class ProjectBuilderLoginController {
    public String strDomain{get;set;}
    public String strCurrentUrl{get;set;}
    public String strPageName{get;set;}
    public boolean isErrorFound{get;set;}
    public boolean isProduction{get;set;}
    public String strUserType{get;set;}//Only for test coverage
   
    /*This method is used to handeling login and redirection to sandbox or production environment
    */ 
    public ProjectBuilderLoginController(){
        try{
        strCurrentUrl='https://'+ApexPages.currentPage().getHeaders().get('Host');
        strPageName='/ProjectBuilderLoginValidater';
        isProduction=true;
        isErrorFound=false;
        
        String strCode=ApexPages.currentPage().getParameters().get('code');
        if(strCode!=null && strCode!=''){
             if(strDomain==null || String.isBlank(strDomain)){
              strDomain=ApexPages.currentPage().getParameters().get('state');
             
             }
            
            isProduction=strDomain=='login'?true:false;
            TokenFormatter objToken=getAccessToken(strCode);
            if(objToken.id!=null && objToken.id!=''){
                ProjectXMLUtil.setAccessToken(objToken.access_token, objToken.instance_url, objToken.id,isProduction);
            }else{
                isErrorFound=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.INFO,objToken.strErrorMessage));
            }
        }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.INFO,ex.getMessage()+': Line Number:'+ex.getLineNumber()+'==='+ApexPages.currentPage().getParameters().get('code')));
        }
        
    }
    
    /*This method is used to get domain details
    */
    public List<SelectOption> getDomainDetail(){ 
        return new List<SelectOption>{new SelectOption('','--None--'),new SelectOption('login','Producation'),new SelectOption('test','Sandbox')};
    
    }
    
    /*This method is used for redirection of pages
    */
    public pagereference redirectToPage(){
        pagereference objPageReference=null;
        if(!isErrorFound){
        String strToken= ProjectXMLUtil.getAccessToken(isProduction);
        String strInstanceUrl= ProjectXMLUtil.getInstanceURL(isProduction);
        if(strToken!='' && strInstanceUrl!=''&&validateToken(strToken,strInstanceUrl)){
             objPageReference=Page.VF_MetadataComponent;
            objPageReference.setRedirect(true);
            
        }
      } 
      
      return objPageReference;
    }
    
    /*This method is used to validate login details
    */
    public pagereference validateLoginDetail(){
        
        isProduction=strDomain=='login'?true:false;
        
        pagereference objPageReference =null;
        if(!UserInfo.getUserType().equalsIgnoreCase('guest') && (strUserType==null || strUserType!='guest')){
            objPageReference=Page.VF_MetadataComponent;
            objPageReference.setRedirect(true);
        }else{
            String strToken= ProjectXMLUtil.getAccessToken(isProduction);
            String strInstanceUrl= ProjectXMLUtil.getInstanceURL(isProduction);
            
            if(strToken!=null && !String.isBlank(strToken) && strInstanceUrl!=null && !String.isBlank(strInstanceUrl)){
                if(validateToken(strToken,strInstanceUrl)){
                    objPageReference=Page.VF_MetadataComponent;
                    objPageReference.setRedirect(true);
                }else{
                     objPageReference=getURLToRedirect();
                }
            }else{
                 objPageReference=getURLToRedirect();
                
            }
        }
        
      return objPageReference;  
    }
    
    /*This method is used to get URL to redirect according to the selection
    */
    public pagereference getURLToRedirect(){
        pagereference objPageReference=new pagereference(getAuthorizationURL());
        objPageReference.setRedirect(true);
        return objPageReference;
    }
    
    /*This method is used to get Authorization URL
    */
    public String getAuthorizationURL(){
        Authorization_URL__c obj=getAuthorization_URL();
        
        String strUrl='https://'+strDomain+'.salesforce.com/services/oauth2/authorize?client_id='+obj.Consumer_Key__c+'&redirect_uri='+EncodingUtil.urlEncode(strCurrentUrl+strPageName, 'UTF-8')+'&scope='+
                       '&state='+strDomain+'&response_type=code';
        
        
     return strUrl; 
    }
    
    /*This method is used to get access token URL
    */
    public String getAccessTokenURL(String strCode){
        String strUrl = '';
        if(!Test.isRunningTest()){
            Authorization_URL__c obj=getAuthorization_URL();
            strUrl='https://'+strDomain+'.salesforce.com/services/oauth2/token?client_id='+obj.Consumer_Key__c+'&redirect_uri='+EncodingUtil.urlEncode(strCurrentUrl+strPageName, 'UTF-8')+'&scope='+
                           '&state='+strDomain+'&grant_type=authorization_code&client_secret='+obj.Client_Secret__c+'&code='+strCode;
        }
        return strUrl;
    }
    
    /*This method is used to get access token
    */
    public TokenFormatter getAccessToken(String strCode){
        TokenFormatter objToken=new TokenFormatter();
         HttpRequest req = new HttpRequest();
         req.setEndpoint(getAccessTokenURL(strCode));
         req.setMethod('POST');
        //req.setBody();          
        Http http = new Http();
        if(!Test.isRunningTest()){ 
            HTTPResponse res = http.send(req);
            
            if(res.getStatuscode()==200){
                 objToken=TokenFormatter.parse(res.getBody());
            }else{
                objToken.strErrorMessage=res.getBody();
            }
        }
        return objToken;
    }

    /*This method is used to get Authorization URL
    */
    public Authorization_URL__c getAuthorization_URL(){
            Map<String,Authorization_URL__c> mapConnectionDetail = Authorization_URL__c.getAll();
            if(mapConnectionDetail!=null && mapConnectionDetail.values()!=null && mapConnectionDetail.values().size()>0){
                return mapConnectionDetail.values().get(0); 
            }
            
          return new Authorization_URL__c();
    }
    
    /*This method is used to validate token
    */
    public boolean validateToken(String strToken,String strInstanceUrl){
        
             HttpRequest req = new HttpRequest();
             req.setEndpoint(strInstanceUrl+'/services/data/v26.0/sobjects/User');
             req.setMethod('GET');
             req.setHeader('Authorization','Bearer '+strToken); 
            Http http = new Http();
         if(!Test.isRunningTest()){ 
            HTTPResponse res = http.send(req);
            
            if(res.getStatusCode()==200){
                return true;
            }
        }
      return false; 
    }
}