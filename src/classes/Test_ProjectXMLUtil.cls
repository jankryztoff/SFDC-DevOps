@isTest
private class Test_ProjectXMLUtil {
       
    static testMethod void myTest(){
       ProjectXMLUtil xmlUtil = new ProjectXMLUtil();
       ProjectXMLUtil.getHostName('https://login.salesforce.com');
       ProjectXMLUtil.getHostName('https://packagexmlbuilder-developer-edition.na17.force.com/');
       ProjectXMLUtil.getInstanceURL(true);
       ProjectXMLUtil.getInstanceURL(false);
       ProjectXMLUtil.geIdURL();
       ProjectXMLUtil.getEnvironment();
       ProjectXMLUtil.getAccessToken(true);
       ProjectXMLUtil.getAccessToken(false);
       ProjectXMLUtil.setAccessToken('Apex_AccessToken','instanceURL','IdUrl',true);
       ProjectXMLUtil.setAccessToken('Apex_AccessToken','instanceURL','IdUrl',false);
       ProjectXMLUtil.validateToken('Apex_AccessToken','instanceURL');
       
       Set<String> setStrings = new Set<String>{'item1','item2'};
       ComponentModel obj=new ComponentModel();
        obj.Type='Object';
        obj.ComponentName='Account';
        
        Map<String ,List<ComponentModel>> mapSelectedComponent=new Map<String,List<ComponentModel>>{'Account'=>new List<ComponentModel>{obj}};
        ProjectXMLUtil.prepareXmlDetail(mapSelectedComponent);
        xmlUtil.prepareFormattedXmlDetail(mapSelectedComponent);
        xmlUtil.getParentComponentDetail(setStrings);

       
    }
}