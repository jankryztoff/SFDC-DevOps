/*
*                                                                                                 *
*                            Version 1.00                                                         *
*                                                                                                 *
* Creation Date: 1.Aug.2014                    Karan Khanna                                      *
* Last Modified: 1.Aug.2014                    Karan Khanna                                      *
*                                                                                                 *
*                             © 2008 - Accenture - All Rights Reserved  *

*/

@isTest
public class VFC01_GMP_GenMergePackageController_Test {    
   
     public static testmethod void VFC01_GMP_GenMergePackageController_Test() {
     
        // Call Mock Class to execute webservices
        Test.setMock(WebServiceMock.class, new GMP_WebServiceMockMetadata_Test());
        
        //controller class object
        VFC01_GMP_GenerateMergePackageController VFC = new VFC01_GMP_GenerateMergePackageController(); 
    
        VFC.init();
       
        //Variables for AddComponents()
        //-----------------------------
        VFC01_GMP_GenerateMergePackageController.componentsWrapper cw1 = new VFC01_GMP_GenerateMergePackageController.componentsWrapper();
        VFC01_GMP_GenerateMergePackageController.componentsWrapper cw2 = new VFC01_GMP_GenerateMergePackageController.componentsWrapper();
        VFC01_GMP_GenerateMergePackageController.componentsWrapper cw3 = new VFC01_GMP_GenerateMergePackageController.componentsWrapper();        
        VFC01_GMP_GenerateMergePackageController.componentsWrapper cw4 = new VFC01_GMP_GenerateMergePackageController.componentsWrapper();        
        cw1.strComponentName='abc1';
        cw1.isSelected=true;
        cw2.strComponentName='abc2';
        cw2.isSelected=false;
        cw3.strComponentName='abc1';
        cw3.isSelected=true;
        cw4.strComponentName='abc3';
        cw4.isSelected=true;
        VFC.listToDisplauOnUI.add(cw1);
        VFC.listToDisplauOnUI.add(cw2);
        VFC.listToDisplauOnUI.add(cw3);
        VFC.listToDisplauOnUI.add(cw4);
        
        VFC.AddComponents();
        //-----------------------------
        
        VFC.getVersionList();
        
        //set value of MetaDataType 
        VFC.MetaDataType='CustomField';
        VFC.FindAllComponents(); 
        
        //set value of MetaDataType which InFolderMetadataList contains 
        VFC.InFolderMetadataList.add('testfield');
        VFC.MetaDataType='testfield';
        VFC.FindAllComponents(); 
        
        //set value of MetaDataType which InFolderMetadataList do not contain
        VFC.MetaDataType='testfield1';
        VFC.FindAllComponents(); 
        
        //initailizing package folder as folder cannot be inserted
        VFC.packagefolder.DeveloperName='XML_Package_Documents';
        VFC.packagefolder.name = 'test';
        
        VFC.RetrievedComponentMap.put(1,VFC.selectedComponentlist);
        
        VFC.showPrevious();
        VFC.showNext();
        VFC.showFirst();
        VFC.showLast();
        
        //satisfying all conditions of SearchComponents()
        //-----------------------------
        VFC.strSearchtext='abc1';
        VFC.SearchComponents();
        
        VFC.strSearchtext='';
        VFC.SearchComponents();
        
        VFC.selectedFolder='testfolder';
        VFC.SearchComponents();

        VFC.selectedFolder='';
        VFC.selectedObject='testobject';
        VFC.SearchComponents();
        //-----------------------------
        
        VFC.strPackageXml='testXML';
        VFC.UploadPackagexml();
        
        VFC.GeneratepackageXml();
        
        //initializing fromDate and ToDate for LMFilter()
        VFC.fromDate=date.today();
        VFC.toDate=date.today();
        VFC.LMFilter();
        
        //satisfying all condition of VFC.upload();
        //-----------------------------
        Document doc1 = new Document();
        doc1.name = 'testdoc';
        VFC.upload();
        
        doc1.body = blob.valueof('testbody');
        VFC.upload();
        
        doc1.body = blob.valueof('<note><to><Members>Members</Members></to><from><name>Jani</name></from><heading>Reminder</heading><body>test body!</body></note>');
        doc1.type = 'xml';
        VFC.newDocList.add(doc1);
        VFC.upload();
        //-----------------------------
        
        VFC.ResetAttachmentList();
        
        VFC01_GMP_GenerateMergePackageController.documentWrapper dw1 = new VFC01_GMP_GenerateMergePackageController.documentWrapper();
        dw1.doc.name = 'testdoc';
        dw1.selected = true;
        VFC.doclistUI.add(dw1);
        
        Set<string> teststring = new Set<String>();
        testString.add('test1');
        VFC.tempMap.put('test1',testString);
        
        VFC.MergeFiles();
        
        VFC.FinalPackageXmlGenerator(VFC.tempMap);
        
        VFC.doclistUI.clear();
        dw1.selected = false;
        VFC.doclistUI.add(dw1);
        VFC.DeleteSelectedFiles();
        //VFC.FinalPackageXmlGenerator(Map<String, Set<String>> tempMap);
        
        VFC.showAllDocs();
        List<document> doclist = new List<Document>();
        DocList.add(doc1);
        VFC.Parsexmlfile(DocList);
        
        //VFC.createService();
        
        VFC.sortrecords(VFC.selectedComponentlist);
        
        VFC.UploadPackagexml();
        //VFC.PackageUploaderInDocument('test1');
        
        VFC01_GMP_GenerateMergePackageController.ValidComponentMapFromMetaData();
        
        VFC.selectedcomponentList[0].isSelected = false;
        VFC.selectedcomponentList[1].isSelected = true;
        VFC.RemoveComponent();
        
    }
}