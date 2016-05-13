/*
 ==================================================================================================================================================================================
    Version         Date             Author          Comment
 ==================================================================================================================================================================================
     v1          9 MAY 2016        Priyanka       Created 'insertLead' method in 'ExistingCustomerOnLeadHandler' Class which perform functionality: 
                                                  Search Accounts or Contacts for a match on the Company name OR Email OR Phone from the Lead. If a match 
                                                  on any of those values is found, check the Existing Customer checkbox on the Lead.

     v1.1       10 MAY 2016        Priyanka       Modified 'insertLead' method in 'ExistingCustomerOnLeadHandler' Class to perform seperate retrival of searched
                                                  account and contact

     v2         11 MAY 2016        Priyanka       Created 'updateLead' method in 'ExistingCustomerOnLeadHandler' Class which perform functionality: 
                                                  Search Accounts or Contacts for a match on the Company name OR Email OR Phone from the Lead when lead is updated.
                                                  If a match on any of those values is found, check the Existing Customer checkbox on the Lead.

     v3         12 MAY 2016        Priyanka       Created 'checkExistingCustomer', 'unCheckExistingCustomer' methods which perform  below functionality:
                                                  checkExistingCustomer : Method to check ExistingCustomer on Lead if match found
                                                  unCheckExistingCustomer :Method to uncheck ExistingCustomer on Lead if no match found

     v4         13 MAY 2016        Priyanka       Created  'getEmail', 'getCompany', 'getPhone', 'getSearchedContact', 'getSearchedAccount' methods which perform below functionality:
                                                  getEmail : Method to get lead email
                                                  getCompany : Method to get lead company
                                                  getPhone : Method to get lead phone
                                                  getSearchedContact : Method to retrive contact match with Email or Phone or Company of lead
                                                  getSearchedAccount : Method to retrive account match with Email or Phone or Company of lead
*/

public with sharing class ExistingCustomerOnLeadHandler {
    
    // Method to insert lead and check ExistingCustomer if match found
    public void insertLead(list<lead> leadlst){
        system.debug(' ======================== Inside insertLead Method ');
        Set<String> emailSet = getEmail(leadlst);
        Set<String> companySet = getCompany(leadlst);
        Set<String> phoneSet = getPhone(leadlst);
        Map<String,Contact> contactMap = getSearchedContact(emailSet, companySet, phoneSet);
        Map<String,Account> accountMap = getSearchedAccount(emailSet, companySet, phoneSet);
        
        for (Lead oLead : leadlst) {
            //if((!contactMap.isEmpty()) || (!accountMap.isEmpty())){
            if(((!contactMap.isEmpty()) || (!accountMap.isEmpty())) && 
               ((contactMap.ContainsKey(oLead.Email) || contactMap.ContainsKey(oLead.Company) || contactMap.ContainsKey(oLead.Phone)) || 
               (accountMap.ContainsKey(oLead.Email) || accountMap.ContainsKey(oLead.Company) || accountMap.ContainsKey(oLead.Phone)) )){
               checkExistingCustomer(oLead);
            }
            //}
            else{
                unCheckExistingCustomer(oLead);
            }
        }
    }
    
    // Method to handle updation of lead record and check ExistingCustomer if match found
     public void updateLead(list<lead> newleadlst,list<lead> oldleadlst){
        system.debug(' ======================== Inside udateLead Method ');
        system.debug(' ============== oldleadlst '+ oldleadlst);
        system.debug(' ============== newleadlst '+ newleadlst);
        Set<String> emailSet = getEmail(newleadlst);
        Set<String> companySet = getCompany(newleadlst);
        Set<String> phoneSet = getPhone(newleadlst);
        Map<String,lead> leadMap = new Map<String,lead>();
        Map<String,Contact> contactMap = getSearchedContact(emailSet, companySet, phoneSet);
        Map<String,Account> accountMap = getSearchedAccount(emailSet, companySet, phoneSet);
        for(lead temp: oldleadlst){
            leadMap.put(temp.Id,temp);
        }
     
        for (Lead oLead : newleadlst) {
            //if(contactMap.ContainsKey(oLead.Email) || contactMap.ContainsKey(oLead.Company) || contactMap.ContainsKey(oLead.Phone) || accountMap.ContainsKey(oLead.Email) || accountMap.ContainsKey(oLead.Company) || accountMap.ContainsKey(oLead.Phone) ){
            //if((!contactMap.isEmpty()) || (!accountMap.isEmpty())){
            if(((!contactMap.isEmpty()) || (!accountMap.isEmpty())) && 
              ((leadMap.ContainsKey(oLead.Id)) || (contactMap.ContainsKey(oLead.Email) || contactMap.ContainsKey(oLead.Company) || contactMap.ContainsKey(oLead.Phone)) || (accountMap.ContainsKey(oLead.Email) || accountMap.ContainsKey(oLead.Company) || accountMap.ContainsKey(oLead.Phone)))){
                if ((oLead.Email != null || oLead.Phone != null || oLead.Company != null) && 
                    (leadMap.get(oLead.Id).Email != oLead.Email || leadMap.get(oLead.Id).Email == oLead.Email || leadMap.get(oLead.Id).Phone != oLead.Phone || leadMap.get(oLead.Id).Phone == oLead.Phone || leadMap.get(oLead.Id).Company != oLead.Company || leadMap.get(oLead.Id).Company == oLead.Company )) {
                        system.debug(' ======================== check ExistingCustomer ');
                        checkExistingCustomer(oLead);
                }
                //}
            }
            else{
                unCheckExistingCustomer(oLead);
            }
        }
     }
     
     // Method to get lead email
     public Set<String> getEmail(list<lead> leadlst){
        Set<String> searchedEmailSet = new Set<String>();
        for(Lead leadObject : leadlst) {
            searchedEmailSet.add(leadObject.Email);
        }
        system.debug(' =============== searchedEmailSet ' + searchedEmailSet);
        return searchedEmailSet;
     }
     
     // Method to get lead company
     public Set<String> getCompany(list<lead> leadlst){
        Set<String> searchedCompanySet = new Set<String>();
        for(Lead leadObject : leadlst) {
            searchedCompanySet.add(leadObject.Company);
        }
        system.debug(' =============== searchedCompanySet '+ searchedCompanySet);
        return searchedCompanySet;
     }
     
     // Method to get lead phone
     public Set<String> getPhone(list<lead> leadlst){
        Set<String> searchedPhoneSet = new Set<String>();
        for(Lead leadObject : leadlst) {
            searchedPhoneSet.add(leadObject.Phone);
        }
        system.debug(' =============== searchedPhoneSet '+ searchedPhoneSet);
        return searchedPhoneSet;
     }
     
     // Method to retrive contact match with Email or Phone or Company of lead
     public Map<String,Contact> getSearchedContact(Set<String> emailSet,Set<String> companySet,Set<String> phoneSet){
        Set<Contact> searchedContactSet = new Set<Contact>([SELECT ID,
                                                                   Email,
                                                                   Phone,
                                                                   Company__c 
                                                            FROM Contact 
                                                            WHERE Email IN:emailset 
                                                            OR Phone IN:phoneSet 
                                                            OR Company__c IN:companySet]);
        system.debug(' ======================== Searched Contact ' + searchedContactSet);
        Map<String,Contact> searchedContactMap = new Map<String,Contact>();
        
        for(Contact oContact: searchedContactSet){
            searchedContactMap.put(oContact.Id,oContact);
            searchedContactMap.put(oContact.Email,oContact);
            searchedContactMap.put(oContact.Phone,oContact);
            searchedContactMap.put(oContact.Company__c,oContact);
        }
        system.debug(' ======================== searchedContactMap ' + searchedContactMap);
        return searchedContactMap;
     }
     
     // Method to retrive account match with Email or Phone or Company of lead
     public Map<String,Account> getSearchedAccount(Set<String> emailSet,Set<String> companySet,Set<String> phoneSet){
        Set<Account> searchedAccountSet = new Set<Account>([SELECT ID, 
                                                                   Email_Id__c,
                                                                   Phone,
                                                                   Company__c 
                                                            FROM Account 
                                                            WHERE Email_Id__c IN:emailset 
                                                            OR Phone IN:phoneSet 
                                                            OR Company__c IN:companySet]);
        system.debug(' ======================== Searched Account ' + searchedAccountSet);
        Map<String,Account> searchedAccountMap = new Map<String,Account>();
        
        for(Account oAccount: searchedAccountSet){
            searchedAccountMap.put(oAccount.Id,oAccount);
            searchedAccountMap.put(oAccount.Email_Id__c,oAccount);
            //searchedAccountMap.put(oAcount.Phone,oAccount);
            searchedAccountMap.put(oAccount.Company__c,oAccount);
        }
        system.debug(' ======================== searchedAccountMap ' + searchedAccountMap);
        return searchedAccountMap;
     }
     
     // Method to check ExistingCustomer on Lead if match found
     public void checkExistingCustomer(lead olead){
        system.debug(' =================== inside Checking ExistingCustomer ');
        oLead.Existing_Customer__c = True;
        system.debug(' =============== Existing_Customer__c ' + oLead.Existing_Customer__c);
     }
     
     // Method to uncheck ExistingCustomer on Lead if no match found
     public void unCheckExistingCustomer(lead olead){
        system.debug(' =================== inside unChecking ExistingCustomer ');
        oLead.Existing_Customer__c = False;
        system.debug(' =============== Existing_Customer__c ' + oLead.Existing_Customer__c);
     }
}