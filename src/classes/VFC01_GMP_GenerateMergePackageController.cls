/*
*                                                                                                 *
*                            Version 1.00                                                         *
*                                                                                                 *
* Creation Date: 1.Aug.2014                    Karan Khanna                                       *
* Last Modified: 1.Aug.2014                    Karan Khanna                                       *
*                                                                                                 *
*                             © 2008 - Accenture - All Rights Reserved                            *


*/


public class VFC01_GMP_GenerateMergePackageController {
    
// ============================================================================
// = V.A.R.I.A.B.E.L.S
// ============================================================================
    public static MetadataService.DescribeMetadataObject result = new MetadataService.DescribeMetadataObject();
    public List<SelectOption> MetaDataTypes {get; set;} //list to display metadata types available
    public String MetaDataType {get; set;} //variable to store selected metadatatype by user      
    public map<integer,List<componentsWrapper>> RetrievedComponentMap{get;set;} //Map to store all components related to selected metadata    
    public list<componentsWrapper> listToDisplauOnUI{get;set;} //list to display components on UI        
    public  Set<String> InFolderMetadataList{get;set;} //[Report, Dashboard, Document, EmailTemplate]
    public String selectedFolder{get;set;} // //variable to store selected folder
    public List<SelectOption> folderList {get; set;} //variable to store available folders in system    
    public list<componentsWrapper> selectedComponentlist{get;set;} //list to contain selected components for package.xml    
    private List<String> versionlist=new List<String>{'28.0','29.0','30.0','31.0'}; //list to store package version details    
    public String strSelectedVersion{get;set;}  //variable to store selected version from User
    public Folder packageFolder{get;set;} //variable to store folder details
    @TestVisible private String strFoldername='XML_Package_Documents';        
    public string strMergedPackageFilename{get;set;}
    public String MergedPackageFileid{get;set;}
    public string UserDefinedFilename{get;set;}        
    private Map<String, String> sobjectmap=new Map<String, String>();
    public static final Integer NUM_ATTACHMENTS_TO_ADD=5;    
    public List<documentWrapper> doclist{get;set;}    
    public List<documentwrapper> doclistUI{get;set;}
    public List<Document> newDocList{get;set;}
    public boolean IsFolderDisplayed{get;set;}
    public String strPackageXml{get;set;}    
    public boolean isPackageXmlDisplayed{get;set;}
    public boolean showAllFiles{get;set;}
    public String strSearchtext{get;set;}
    public boolean IsCustomObjectsDisplayed{get;set;}
    public String selectedObject{get;set;}
    public List<SelectOption> ObjectList {get; set;}
    private Map<String,String> CustomFieldIdmap=new map<String,String>();
    public Date fromDate {get; set;}
    public Date toDate {get; set;}
    public boolean filterLM {get;set;} 
    public boolean showMP{get;set;}    
    
// ============================================================================
// = G.E.T.T.E.R.S
// ============================================================================
    public list<selectoption> getVersionList(){
        list<selectoption> options=new List<selectoption>();
        for(String ss:versionlist){
            options.add(new selectoption(ss,ss));
        }
        return options;
    }
// ============================================================================
// = C.O.N.S.T.R.U.C.T.O.R
// ============================================================================
   
    public VFC01_GMP_GenerateMergePackageController(){
        
        folderList=new List<SelectOption> ();
        InFolderMetadataList=new Set<String>();
        listToDisplauOnUI=new list<componentsWrapper> ();
        selectedComponentlist=new list<componentsWrapper> ();
        pageNumber=1;
        pageSize=50;
        MetadataType='CustomApplication'; 
        strSelectedVersion='30.0';
                
        FindFolder();        
        doclist=new List<documentWrapper> ();
        doclistUI=new List<documentWrapper> ();
        newDocList=new list<Document>();
        showAllFiles=false;
        //Reset attachment option to 5 files
        addMoreFiles();
        showMP = false;
        filterLM = false;
    }    
        
    //method to add components for generating package.xml
    public PageReference  AddComponents(){
        if(listToDisplauOnUI.size()>0){
            for(componentsWrapper cw:listToDisplauOnUI){
                if(cw.isSelected==true){
                    if(!isAlreadyPresentinSelectedComp(cw)){
                        cw.isSelected=false;
                        selectedComponentlist.add(cw);
                    }
                }
            }
        }
        return null;
    }
    
    //method to check if selected component is already present in list of selected components
    public boolean isAlreadyPresentinSelectedComp(componentsWrapper cw){
        if(selectedComponentlist.size()>0){
            Set<String> selectedComponentset=new Set<String>();
            for(componentsWrapper cc:selectedComponentlist){
                selectedComponentset.add(cc.strComponentName);
            }
            if(selectedComponentset.contains(cw.strComponentName)){
                return true;
            }
        }
        return false;
    }
    
    //method to remove components from list of selected components
    public Pagereference RemoveComponent(){
        system.debug('********selectedComponentlist.size'+selectedComponentlist.size());
        if(selectedComponentlist.size()>0){
            List<componentsWrapper> temp=new List<componentsWrapper>();
            List<componentsWrapper> listOfRemovedComp=new List<componentsWrapper>();
            for(componentsWrapper ccw:selectedComponentlist){
                if(ccw.isSelected==false){
                    temp.add(ccw); 
                }else{
                    ccw.isSelected=false;
                }
            }
            if(temp.size()>=0){
                selectedComponentlist=new List<componentsWrapper>();
                selectedComponentlist=temp;
            }
            
        }
        return null;
    }
    
    //variables for pagination------------
    public Integer pageSize {get;set;} //number of records to display in page.
    public Integer recordIndex {get;set;}//starting index of record which will be displayed on page
    public String currentPageInfo{get;set;}//message displayed on page
    // for disabling pagination links
    public Boolean showPrevious {get;set;}
    public Boolean showNext {get;set;}
    
    private Integer totalRecords; //total number of records which needs to be paginated
    private Integer pageNumber; //current page displayed to user
    //-------------------variables for pagination end-------------------------    
    
    //----------------Pagination code starts----------------------------------    
    
    //this method will be called on page will load first time
    public void activatePaginationCurrent(){
       
        if(RetrievedComponentMap.size()!=0 && pageSize!=null ){
            pageNumber = 1;
            showPrevious = false;
            if(RetrievedComponentMap.size() > pageNumber)
                showNext = true;
            else
                showNext = false;
            currentPageInfo = 'Showing Page ' + pageNumber +  ' of ' + RetrievedComponentMap.size() + ' pages ' ;    
           
        }
    }
    
    public void showPrevious(){ 
        pageNumber--;
        if(RetrievedComponentMap.get(pageNumber)!=null){
            if(RetrievedComponentMap.get(pageNumber).size()>0){
                listToDisplauOnUI=RetrievedComponentMap.get(pageNumber);
            }
        }
        enableDisablePaginationLinks();       
    }
    
    public void showNext(){
        pageNumber++;
        if(RetrievedComponentMap.get(pageNumber)!=null){
            if(RetrievedComponentMap.get(pageNumber).size()>0){
                listToDisplauOnUI=RetrievedComponentMap.get(pageNumber);
            }
        }
        enableDisablePaginationLinks();
    }
    
    public void showFirst(){
        recordIndex = 0;
        pageNumber = 1;
        if(RetrievedComponentMap.get(pageNumber)!=null){
            if(RetrievedComponentMap.get(pageNumber).size()>0){
                listToDisplauOnUI=RetrievedComponentMap.get(pageNumber);
            }
        }
        enableDisablePaginationLinks();
    }
    
    public void showLast(){
        pageNumber=RetrievedComponentMap.size();
        if(RetrievedComponentMap.get(pageNumber)!=null){
            if(RetrievedComponentMap.get(pageNumber).size()>0){
                listToDisplauOnUI=RetrievedComponentMap.get(pageNumber);
            }
        }
        
        enableDisablePaginationLinks();
    }
    
    //below method will be called whenever First,Previous,Next and Last button is clicked.
    private void enableDisablePaginationLinks(){
        integer totalPages=RetrievedComponentMap.size();
        if(totalPages!=0 && pageSize!=null){
            if(pageNumber == 0)
                showPrevious = false;
            else
                showPrevious = true;

             if((totalPages - pageNumber) <= 0)
                showNext = false;
             else
                showNext = true;
            currentPageInfo = 'Showing Page ' + pageNumber +  ' of ' + RetrievedComponentMap.size() + ' pages ' ;        
        }
    }
    //----------------Pagination code ends------------------------------------------------------------
    
    //method to do call out to fetch all available metadata types present in  org
    public PageReference init()    {
        
            // List available Metadata Types via the 'describeMetadata' API call
            MetadataService.MetadataPort service = createService(); 
                
            MetadataService.DescribeMetadataResult describeResult =  new MetadataService.DescribeMetadataResult ();
            if(!Test.isRunningTest())
            describeResult =  service.describeMetadata(30);
            
            List<String> metadataTypeNames = new List<String>();
            
            if(!Test.isRunningTest())
            for(MetadataService.DescribeMetadataObject metadataObject : describeResult.metadataObjects)
            {
                metadataTypeNames.add(metadataObject.xmlName);
                if(metadataObject.inFolder==true){
                    InFolderMetadataList.add(metadataObject.xmlName);
                }
                // Include child Metadata Types (such as CustomField, ValidationRule etc..)
                if(metadataObject.childXmlNames!=null)
                    for(String childXmlName : metadataObject.childXmlNames)
                        if(childXmlName!=null){                            
                                metadataTypeNames.add(childXmlName);
                        }
            }   

            // Sort Metadata Types
            metadataTypeNames.sort();
            MetaDataTypes = new List<SelectOption>();               
            for(String metadataTypeName : metadataTypeNames)
                MetaDataTypes.add(new SelectOption(metadataTypeName, metadataTypeName));
            
            FindAllComponents(); 
            
        return null;    
    }
    
    public boolean IsFolderRequiredForMetadata(String strmetaData){
        boolean IsFolderRequired=false;
        if(strmetaData!=null && strmetaData!=''){
            if(InFolderMetadataList.contains(MetaDataType)){
                String FolderType='';
                IsFolderRequired=true;
                if(MetaDataType.equalsignorecase('EmailTemplate')){
                    FolderType='Email';
                }else{
                    FolderType=MetaDataType;
                }
                FindAvailableFolders(FolderType);
            }
            
        }
        return IsFolderRequired;
    }
    public void FindAvailableFolders(String metadataType){
        
        folderList=new List<SelectOption> ();
        folderList.add(new selectoption('','--Select--'));
        for(Folder fold:[select id,name,developername from Folder where type=:metadataType order by developername]){
            if(fold.developername!=null && fold.name!=null){
                folderList.add(new selectoption(fold.developername,fold.name));
            }
        }
    }    
    
    public PageReference FindAllComponents(){
        selectedFolder='';
        selectedObject='';
        IsFolderDisplayed=false;
        IsCustomObjectsDisplayed=false;
        intializeVariables();
        if(MetaDataType!=null && MetaDataType!=''){
            if(MetaDataType.equalsignorecase('CustomField')){
                intializeVariables();
                FindAllObjects();
                IsCustomObjectsDisplayed=true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select Object Before selecting fields.'));
            }else{
                if(IsFolderRequiredForMetadata(MetaDataType)){
                    RetrievedComponentMap=new map<integer,List<componentsWrapper>>();
                    listToDisplauOnUI=new list<componentsWrapper> ();
                    strSearchtext='';
                    IsFolderDisplayed=true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select folder.'));
                }else{
                    listMetadataItems();
                }
            }
        }
        return null;
    }
    
    public Void intializeVariables(){
        RetrievedComponentMap=new map<integer,List<componentsWrapper>>();
        listToDisplauOnUI=new list<componentsWrapper> ();
        strSearchtext='';
        fromDate = null;
        toDate = null;
    }
    
    public PageReference SearchCustomFields(){
        intializeVariables();       
        if(selectedObject!=null && selectedObject!=''){
            List<CustomFieldWrapper> temp=new List<CustomFieldWrapper>();
            temp=SearchAllFieldsOfObject(selectedObject);
            List<String> DescribeCustomFieldList=FindCustomFieldsUsingDescribe(selectedObject);
            Map<String,String> CustomFieldIdmap=new map<String,String>();
            for(CustomFieldWrapper ss:temp){
                CustomFieldIdmap.put(ss.developername,ss.Id);
            }
            DescribeCustomFieldList.sort();
            map<String,componentsWrapper> AllComponentsMap=new map<String,componentsWrapper>();
            for(String ss:DescribeCustomFieldList){
                String strToCompare='';
                if(ss.endswith('__c')){
                    strToCompare=ss.substring(0,ss.length()-3);
                }
                //tooling api doesn't return Managed pakaged fields where describe returns all fields
                if(CustomFieldIdmap.containskey(strToCompare)){
                    componentsWrapper cuswrp=new componentsWrapper();
                    cuswrp.strComponentName=ss;
                    if(CustomFieldIdmap.get(strToCompare)!=null){
                        cuswrp.strComponentNameId=CustomFieldIdmap.get(strToCompare);
                    }
                    cuswrp.strMetaDataType=MetaDataType;
                    AllComponentsMap.put(cuswrp.strComponentName,cuswrp);
                }
                
            }
            
            if(AllComponentsMap.size()>0){
                listAllComponentsForPagination(AllComponentsMap);
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select object before clicking on search button.'));
        }
        return null;
    }
    
    public list<String> FindCustomFieldsUsingDescribe(String Sobjname){
        list<String> FieldList=new list<String>();
        try{            
            if(Sobjname!=null && Sobjname!=''){
                Schema.SObjectType objToken = Schema.getGlobalDescribe().get(sobjname);
                Schema.DescribeSObjectResult objDescribe=objToken.getdescribe();
                Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
                for(String ss:Fieldmap.keyset()){
                    Schema.DescribeFieldResult fd=fieldMap.get(ss).getDescribe();
                    if(fd.isCustom()){                        
                        FieldList.add(fd.getName());
                    }
                }
                FieldList.sort();                
            }
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Problem with fetching Custom fields using describe.'+e.getmessage()));
        }
        return FieldList;
    }
     
    public Pagereference SearchFolderComponents(){
        if(selectedFolder!=null && selectedFolder!=''){
            listMetadataItems();
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select folder before clicking on search button'));
        }
        return null;
    }
    
    public Pagereference LMFilter(){
        System.debug('**** LMFilter fromDate toDate'+fromDate + toDate);
        if(fromDate!=null && toDate!=null){
            filterLM = true;
            listMetadataItems();
            filterLM=false;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select date in both \'Modified after\' and \'Modified before\''));
        }
        return null;
    }    
    
    //method to find out all components related to selected metadata type
    public void listMetadataItems() {
        
        if(!Test.isRunningTest()) {
            RetrievedComponentMap=new map<integer,List<componentsWrapper>>();
            listToDisplauOnUI=new list<componentsWrapper> ();
            strSearchtext='';
            activatePaginationCurrent();
            MetadataService.MetadataPort service = createService();             
            List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
            MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
            if(selectedFolder!=null && selectedFolder!=''){
                queryLayout.folder = selectedFolder;
            }
            system.debug('*****MetaDataType:'+MetaDataType);
           
            queryLayout.type_x = MetaDataType;
            queries.add(queryLayout);       
            MetadataService.FileProperties[] fileProperties;  
            try{     
             fileProperties= service.listMetadata(queries, 30);
             system.debug('*****fileProperties:'+fileProperties);
            }catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No of retrieved components is too large to handle.'+e.getMessage()));
            }      
            
            List<String> fullNames = new List<String>();
            map<String,componentsWrapper> AllComponentsMap=new map<String,componentsWrapper>();
            
            try{
                if(fileProperties!=null){
                    for(MetadataService.FileProperties fileProperty : fileProperties){
                        if(fileProperty.id!=null && fileProperty.id!=''){
                            fullNames.add(fileProperty.fullName);
                            system.debug('***fileProperty:'+fileProperty);
                            componentsWrapper cw=new componentsWrapper();
                            cw.strComponentName=fileProperty.fullname;
                            cw.strMetaDataType=MetaDataType;
                            cw.strComponentNameId=fileProperty.id;
                            System.debug('**** filterLM'+filterLM);
                            if(filterLM == true) {
                                System.debug('**** LMFilter fromDate toDate'+fromDate + toDate);
                                System.debug('**** fileProperty.lastModifiedDate.Date()'+fileProperty.lastModifiedDate.Date());
                                
                                if(fileProperty.lastModifiedDate.Date() >= fromDate && fileProperty.lastModifiedDate.Date() <= toDate)
                                    AllComponentsMap.put(fileProperty.fullName,cw);                     
                            } else {
                                AllComponentsMap.put(fileProperty.fullName,cw);
                            }
                        }
                    }
                }
                if(AllComponentsMap.size()>0){
                    listAllComponentsForPagination(AllComponentsMap);
                }
                
            }catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage())); 
            }
        }
    }
    
    
    public void listAllComponentsForPagination(map<String,componentsWrapper> CompWrapperMmap){
        list<String> componentNamelist=new list<String>();
        map<String,componentsWrapper>componentWrappermap=CompWrapperMmap;
        componentNamelist.addAll(componentWrappermap.keyset());
        componentNamelist.sort();
        if(componentNamelist.size()>0){
                
            map<integer,List<componentsWrapper>> AfterPaginationComponentMap=new map<integer,List<componentsWrapper>>();
            list<componentsWrapper> temp=new list<componentsWrapper>();
            AfterPaginationComponentMap.put(AfterPaginationComponentMap.size()+1,new List<componentsWrapper>());
            for(String ss:componentNamelist){
                componentsWrapper cw=componentWrappermap.get(ss);
                componentsWrapper lastComponent=componentWrappermap.get(componentNamelist[componentNamelist.size()-1]);
                temp.add(cw);
                if((math.mod(temp.size(),pageSize))==0){
                    AfterPaginationComponentMap.get(AfterPaginationComponentMap.size()).add(cw);
                    if(lastComponent.strComponentNameId!=cw.strComponentNameId){
                        AfterPaginationComponentMap.put(AfterPaginationComponentMap.size()+1,new List<componentsWrapper>());
                        temp=new List<componentsWrapper>();
                    }
                        
                }else{
                        AfterPaginationComponentMap.get(AfterPaginationComponentMap.size()).add(cw);
                }
            }
            if(AfterPaginationComponentMap.size()>0){
                RetrievedComponentMap=new map<integer,List<componentsWrapper>>();
                RetrievedComponentMap=AfterPaginationComponentMap; 
                listToDisplauOnUI=RetrievedComponentMap.get(1);
                activatePaginationCurrent();
            }
                
        }
    }
    
    private static MetadataService.MetadataPort createService()
    { 
        if(!Test.isRunningTest()) {
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            return service; 
        }
        else
            return null;
    }
    
    
    public List<componentsWrapper> sortrecords(List<componentsWrapper> cwlist){
        List<componentsWrapper> temp=new List<componentsWrapper>();
        if(cwlist.size()>0){
            List<String> strkeylist=new List<String>();
            Map<String,componentsWrapper> componentmap=new map<String,componentsWrapper>();
            for(componentsWrapper cw:cwlist){
                componentmap.put(cw.strComponentName,cw);
                strkeylist.add(cw.strComponentName);
            }
            strkeylist.sort();
            for(String ss:strkeylist){
                temp.add(componentmap.get(ss));
            }   
        }
        return temp;
    }    
    
    public PageReference GeneratepackageXml(){
        isPackageXmlDisplayed=true;
        String temp='';
        if(selectedComponentlist.size()>0){
            String startStr='<?xml version="1.0" encoding="UTF-8"?>\n<Package xmlns="http://soap.sforce.com/2006/04/metadata">\n';
            String endStr='<version>'+strSelectedVersion+'</version>\n</Package>';
            Map<String,List<String>> mapOfComponents=new Map<String,List<String>>();
            for(componentsWrapper cw:selectedComponentlist){
                if(!mapOfComponents.containskey(cw.strMetadataType)){
                    mapOfComponents.put(cw.strmetadatatype,new List<String>());
                }
                mapOfComponents.get(cw.strmetadatatype).add(cw.strComponentName);
            }
            if(mapOfComponents.size()>0){
                
                for(String ss:mapOfComponents.keyset()){
                    string s1='<types>\n';
                    String s2='';
                    for(String sv:mapOfComponents.get(ss)){
                        s2+='<members>'+sv+'</members>\n';
                    }
                    temp+=s1+s2+'<name>'+ss+'</name>\n</types>\n';
                }
                
            }
            strPackageXml=startStr+temp+endStr;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select the components before generating xml'));
        }
        
        return null;
    }
    
    public class componentsWrapper{
        
        public String strComponentName{get;set;}
        public boolean isSelected{get;set;}
        public String strMetaDataType{get;set;}
        public String strComponentNameId{get;set;}
        public componentsWrapper(){
            this.isSelected=false;
        }
    }
    
    //search functionality    
    public PageReference ResetAllComponents(){
        if(selectedFolder!='' && selectedFolder!=''){
            SearchFolderComponents();
        }else if(selectedObject!=null && selectedObject!=''){
            SearchCustomFields();
        }else{
            listMetadataItems();
        }
       return null;
    }
        
    public PageReference SearchComponents(){  
     
        if(strSearchtext!=null && strSearchtext!=''){                        
            list<String>matchCompNameList=new list<String>();
            map<String,componentsWrapper> componentWrappermap=new map<String,componentsWrapper>();
            if(RetrievedComponentMap.size()>0){
                integer totalpages=RetrievedComponentMap.size();
                for(integer i=1;i<=totalpages;i++){
                    for(componentsWrapper cw:RetrievedComponentMap.get(i)){
                        String ss=cw.strComponentName.toUppercase();
                        if(ss.contains((strSearchtext).toUppercase())){
                            system.debug('**********match found:'+cw.strComponentName); 
                                matchCompNameList.add(cw.strComponentName);
                                componentWrappermap.put(cw.strComponentName,cw);
                        }
                    }   
                }
                
            }
            if(componentWrappermap.size()>0){
                listAllComponentsForPagination(componentWrappermap);
            }
            
        }else{
           return ResetAllComponents();
        }   
        return null;
    }
    
    //method to upload final package xml file to document by using generated string from FinalPackageXmlGenerator method
    public void PackageUploaderInDocument(String strGeneratedXML){
        if(strGeneratedXML!=null && strGeneratedXML!=''){
            FindFolder();
            try{
                Blob myBlob = Blob.valueof(strGeneratedXML);
                // Generating the record into Document object namely Package.xml
                Document finaldoc = new Document();
               
                datetime currentDateTime = datetime.now();
                
                finaldoc.AuthorId = UserInfo.getUserId();
                
                finaldoc.FolderId = packageFolder.id; 
                finaldoc.Body = myBlob;
                if(UserDefinedFilename!=null && UserDefinedFilename!=''){
                    finaldoc.Name=UserDefinedFilename+'-'+currentDateTime+'.xml' ;
                }else{
                    finaldoc.Name = Userinfo.getName()+'-'+currentDateTime+'.xml' ;
                }
                insert finaldoc;
                strMergedPackageFilename=finaldoc.Name;
                MergedPackageFileid=finaldoc.id;
            }catch(exception e){
                Apexpages.addmessage(new apexPages.message(ApexPages.Severity.Error,'Problem With uploading final xml Package to Document folder.Please contact your system Admin'+e.getmessage()));
                            
            }
        }        
    }
    
    public void FindFolder(){
        try{
            packageFolder=new Folder();
            if(!Test.isrunningtest())
            packageFolder=[select id from Folder where DeveloperName=:strFoldername Limit 1]; 
        }catch(exception e){
            packageFolder=[select id from Folder where id=:UserInfo.getUserId()];
        }   
    }
    
    
    public PageReference UploadPackagexml(){
        if(strPackageXml!=null && strPackageXml!=''){
            PackageUploaderInDocument(strPackageXml);
        }else{
            Apexpages.addmessage(new apexPages.message(ApexPages.Severity.Error,'Please first generate  package.xml file'));
        }
        return null;
    }
    
    public void FindAllObjects(){
        
            String strMetaDataType='CustomObject';
            ObjectList = new List<SelectOption>();       
            MetadataService.MetadataPort service = createService();             
            List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
            MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();        
            queryLayout.type_x = strMetaDataType;
            queries.add(queryLayout);       
            MetadataService.FileProperties[] fileProperties;  
            try{     
             fileProperties= service.listMetadata(queries, 30);        
            }catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No of retrieved components is too large to handle.'+e.getMessage()));
            }
            //list variable which will store all custom fields and then will be used to sort custom fields
            List<String> componentsList=new List<String>();
            CustomFieldIdmap=new map<String,String>();
            try{
                if(fileProperties!=null){
                    for(MetadataService.FileProperties fileProperty : fileProperties){
                        system.debug('***fileProperty:'+fileProperty);
                        if(fileProperty.fullName.endswith('__c')){
                            CustomFieldIdmap.put(fileProperty.fullName,fileProperty.id);
                        }else{
                            CustomFieldIdmap.put(fileProperty.fullName,fileProperty.fullName);  
                        }
                        componentsList.add(fileProperty.fullName);
                    }
                    componentsList.sort();
                }               
                if(componentsList.size()>0){
                    ObjectList.add(new selectoption('','--Select--'));
                    for(String ss:componentsList){
                        ObjectList.add(new selectoption(ss,ss));
                    }
                }            
            }catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage())); 
            }
        
    }
    
    
    public List<CustomFieldWrapper> SearchAllFieldsOfObject(String objectName){
        List<CustomFieldWrapper>fieldWrapperList=new list<CustomFieldWrapper>();
        try{
            if(selectedObject!=null && selectedObject!=''){
                String strTableEnumOrId=CustomFieldIdmap.get(selectedObject);
                HttpRequest req = new HttpRequest();
                req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
                req.setHeader('Content-Type', 'application/json');
                String domainUrl=URL.getSalesforceBaseUrl().toExternalForm();
                String endpointUrl=domainUrl+'/services/data/v28.0/tooling/query/?q=Select+id,DeveloperName,+TableEnumOrId+from+CustomField+where+TableEnumOrId=\''+strTableEnumOrId+'\'';
                system.debug('********domainUrl:'+domainUrl);
                req.setEndpoint(endpointUrl);
                req.setMethod('GET');
                
                HTTPResponse res = new HTTPResponse();
                
                if(Test.isRunningTest())
                    res.setBody('testHTTP');
                
                else
                    res=sendRequest(req); 
                               
                String ss=res.getBody();
                fieldWrapperList=CustomFieldJsonParser(ss);
                
            }else{
                Apexpages.addmessage(new Apexpages.message(ApexPages.Severity.Error,'Please select custom object and then click on search button'));
            }
        }catch(exception e){
            Apexpages.addmessage(new Apexpages.message(ApexPages.Severity.Error,'problem With retrieving Custom fields.'+e.getmessage()));
        }
        return fieldWrapperList;
    }
    
    public HTTPResponse sendRequest(HTTPRequest req){
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }    
    
    //method to parse JSON returned by tooling api
    public List<CustomFieldWrapper> CustomFieldJsonParser(String newjsondata){
        List<CustomFieldWrapper> temp1=new list<CustomFieldWrapper>();
        JSONParser parser = JSON.createParser(newjsondata );
        while (parser.nextToken() != null) {
            // Start at the array of invoices.
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire  approval process object
                        CustomFieldWrapper cus= (CustomFieldWrapper)parser.readValueAs(CustomFieldWrapper.class);                        
                        temp1.add(cus);
                        parser.skipChildren();
                    }
                }
            }
        }        
        return temp1;
    }
    
    public class CustomFieldWrapper{
        public String Id{get;set;}
        public String DeveloperName{get;set;}
    }
    
    // Add 5 more attachments option for user for upload
    public void addMoreFiles(){
        // append NUM_ATTACHMENTS_TO_ADD to the new attachments list
        for (Integer idx=0; idx<NUM_ATTACHMENTS_TO_ADD; idx++){
            newDocList.add(new Document());
        }
        showMP = true;
    }
    
    //resetting number of available attachments to 5 for upload
    public void ResetAttachmentList(){
        newDocList=new list<Document>();
        addMoreFiles();
        showMP = true;
    }
    
    //method execute after click on upload button
    public PageReference upload(){
        try{
            showAllFiles=false;
            list<Document> doctoInsertlist=new List<Document>();
            if(newDocList.size()>0){
                for (Document newAtt : newDocList){
                    system.debug('*******8:'+newAtt);
                    if (newAtt.Body!=null) {
                        doctoInsertlist.add(newAtt);
                    }
                }                
                if(doctoInsertlist.size()>0){
                    list<Document> docToInsert=new List<Document>();
                    for(Document dw:doctoInsertlist){
                        dw.FolderId=packageFolder.id;
                        docToInsert.add(dw);
                    }
                    insert docToInsert;
                    doclistUI=new List<documentWrapper>();
                    for(Document dd:docToInsert){
                        documentWrapper dww=new documentWrapper();
                        dd.body=null;
                        dww.doc=dd;
                        doclistUI.add(dww);
                    }
                    showAllFiles=true;
                    //reset attachment options
                    newDocList=new list<Document>();
                    addMoreFiles();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
                    
                }else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please upload file'));
                }
                
            }
        }catch(exception e){
            ApexPages.addmessage(new Apexpages.Message(Apexpages.severity.error, 'problem with document upload. Please try latter.'+e.getmessage()));
        }
        showMP = true;
        return null;
    }
    
    public PageReference DeleteSelectedFiles() { 
        //We create a new list of documents that we be populated only with document if they are selected
        List<Document> selectedDocs = new List<Document>(); 
        list<documentWrapper> temp=new list<documentWrapper>();
        docList = new List<documentWrapper>();     
        for(documentWrapper d: doclistUI) {
            if(d.selected == true) {
                selectedDocs.add(d.doc);
            }else{
                temp.add(d);
            }
        }
        if(selectedDocs.size() > 0){
            delete selectedDocs;
            doclistUI=new List<DocumentWrapper>();
        }else if(selectedDocs.size()==0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select document to delete.'));
        }
        if(temp.size()>0){
            doclistUI=new List<DocumentWrapper>();
            doclistUI.addAll(temp);
            
        }
        else{
            strMergedPackageFilename = null;
            showAllFiles=false;
        }
        showMP = true;
        return null;
    }
    
    //method to display all docs from Documents
    public PageReference showAllDocs() {   
        docListUI = new List<documentWrapper>();
        showAllFiles=false;
        for(Document d: [select id, name from Document where FolderId =: packageFolder.id order by createdDate DESC Limit 1000]) {
            documentWrapper dw=new documentWrapper();
            dw.doc=d;
            docListUI.add(dw);
        }
        if(docListUI.size()>0)
            showAllFiles = true;
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No records to display.'));
            docListUI = null;   
        }
       showMP = true;
       return null;
    }
    
    public PageReference MergeFiles(){
        List<Document> selectedDocs = new List<Document>();      
        for(documentWrapper d: doclistUI) {
            if(d.selected == true) {
                selectedDocs.add(d.doc);
            }
        }
        if(selectedDocs.size() > 0){
            List<Document> selectedDoctoMerge = [select id, name,body from Document where id=:selectedDocs];
            String strErrorMessage=Parsexmlfile(selectedDoctoMerge);            
            if(strErrorMessage!=null && strErrorMessage!=''){
                ApexPages.addmessage(new Apexpages.Message(Apexpages.severity.error,strErrorMessage));
            } else{
                if(tempMap.size()>0){
                    String strGeneratedXML=FinalPackageXmlGenerator(tempMap);
                    PackageUploaderInDocument(strGeneratedXML);
                }
            } 
         }
        showMP = true;
        return null;
    }
    
    //method to generate final xml and returning String after casting xml into string 
    public String FinalPackageXmlGenerator(Map<String, Set<String>> tempMap){
        list<String> ComponentSet=new list<String>();
        ComponentSet.addAll(tempMap.keyset());
        ComponentSet.sort();
        String strGeneratedXML='';        
        if(tempMap.size()>0){
            String startStr='<?xml version="1.0" encoding="UTF-8"?>\n<Package xmlns="http://soap.sforce.com/2006/04/metadata">\n';
            String endStr='<version>'+strSelectedVersion+'</version>\n</Package>';
            String temp='';
            for(String componentName:ComponentSet){
                string s1='<types>\n';
                String s2='';
                for(String sv:tempMap.get(componentName)){
                    s2+='<members>'+sv+'</members>\n';
                }
                temp+=s1+s2+'<name>'+componentName+'</name>\n</types>\n';
            }
            strGeneratedXML=startStr+temp+endStr;
        }
       return strGeneratedXML;
    }
    
   //variable to stored invalid componenttypes specified in xml files
   public Map<String,List<String>> InValidCompMap=new Map<String,list<String>>(); 
   //tempmap variable will store name with their members element for final package generation
   public Map<String, set<String>> tempMap = new Map<String, set<String>>(); 
   
   //This method is for parsing xml file what you selected and it will return all error messages while parsing xml
    public String Parsexmlfile(List<Document> listDocs){
        String strErrorMessage='';
        InValidCompMap=new Map<String,list<String>>(); 
        
        if(!Test.isRunningTest())
        tempMap = new Map<String, set<String>>();
        if(listDocs.size()>0){
            for(Document docu:listDocs){
                Blob bodyBlob = docu.Body;
                String bodyStr = bodyBlob.toString();
                if(CheckForValidXml(bodyStr)){
                    DOM.Document doc = new DOM.Document();
                    system.debug('***'+bodyStr);
                    doc.load(bodyStr);
                    
                    DOM.XMLNode rootElement = doc.getRootElement();
                    String rootElementname=String.valueof(doc.getRootElement().getName());
                    system.debug('****rootElementname'+rootElementname); //Pakage tag
                    for(Dom.XMLNode child1 : rootElement.getChildElements()){
                        system.debug('****First Child'+child1.getName()); //type tag
                        Set<String> tempSet2 = new Set<string>();
                        integer childCount=0;
                        String strComponentType='';
                        for(Dom.XMLNode child2 : child1.getChildElements()) {
                            system.debug('****second Child'+child2.getName()); //members tag or name tag
                            if(child2.getName().equalsignoreCase('Members'))
                                tempSet2.add(child2.getText()) ;// it gives you text node and add into Set
                            if(child2.getName().equalsignorecase('Name')) {
                                if(ValidComponentMap.containsKey(child2.getText().trim().touppercase())){
                                    strComponentType=ValidComponentMap.get(child2.getText().trim().touppercase());
                                    System.debug('strComponentType--'+strComponentType);
                                    // to check child is present in Map as an MapId 
                                    if(!tempMap.containsKey(strComponentType)) {
                                        tempMap.put(strComponentType,new set<String>());
                                    }
                                    //tempMap.get(strComponentType).addAll(tempSet2);
                                }else{
                                    System.debug('non member--'+child2.getText());
                                    if(!InValidCompMap.containskey(docu.name)){
                                        InValidCompMap.put(docu.name,new list<String>());
                                    }
                                    InValidCompMap.get(docu.name).add(child2.getText());
                                }
                            }
                            childCount+=1;
                            if(childCount==child1.getChildElements().size() && strComponentType!=''){
                                if(tempMap.containskey(strComponentType)){
                                    tempMap.get(strComponentType).addAll(tempSet2);
                                }
                            }
                        }
                      
                    }   
                }else{
                    strErrorMessage+=docu.Name+' does not contain valid xml. Please check and upload it again. ';
                }                
            }            
            if(InValidCompMap.size()>0){
                strErrorMessage+='following component types are invalid: \n';
                for(String ss:InValidCompMap.keyset()){
                    for(String names:InValidCompMap.get(ss)){
                        strErrorMessage+=names+',';
                    }
                    if(strErrorMessage.endsWith(',')){
                        strErrorMessage=strErrorMessage.substring(0,strErrorMessage.length()-1);
                        strErrorMessage+=' in '+ss+ ' file.\n';
                    }
                }
            }            
        }
        return strErrorMessage;    
    }
    
    public boolean CheckForValidXml(String xmlString){
        try{
            DOM.Document doc = new DOM.Document();
            system.debug('***xmlString'+xmlString);
            doc.load(xmlString);
            return true;
        }catch(exception e){
            return false;
        }
    }
    
    //wrapper class
    public class documentWrapper {
        public Document doc {get; set;}
        public Boolean selected {get; set;}
       
        public documentWrapper() {
            doc=new Document();
           selected = false;
        }
    }
   
    public static Map<String,String> ValidComponentMap=ValidComponentMapFromMetaData();     
    public static Map<String,String> ValidComponentMapFromMetaData(){
        
        Map<String,String> temp=new Map<String,String>();         
            
        // List available Metadata Types via the 'describeMetadata' API call
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
                       
        MetadataService.DescribeMetadataResult describeResult ;
        if(!Test.isRunningTest()) 
        describeResult= service.describeMetadata(30);
        System.debug('###########################describe result'+describeResult);
        List<String> metadataTypeNames = new List<String>();
        if(!Test.isRunningTest())
        for(MetadataService.DescribeMetadataObject metadataObject : describeResult.metadataObjects){
            metadataTypeNames.add(metadataObject.xmlName);
            // Include child Metadata Types (such as CustomField, ValidationRule etc..)
            if(metadataObject.childXmlNames!=null){
                for(String childXmlName : metadataObject.childXmlNames){
                    if(childXmlName!=null){
                        //if(!childXmlName.equalsignorecase('CustomField'))
                            metadataTypeNames.add(childXmlName);
                    }
                }   
            }
        }
        if(metadataTypeNames.size()>0){
            for(String ss:metadataTypeNames){
                temp.put(ss.touppercase(),ss);
            }
        }
    
        return temp;
    }
}