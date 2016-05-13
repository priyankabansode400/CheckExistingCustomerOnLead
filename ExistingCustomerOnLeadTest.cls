/*
 ==============================================================================================================================================================
    Version             Date             Author          Comment
 ==============================================================================================================================================================
    v1               10 MAY 2016       Priyanka         Test Class to test 'ExistingCustomerOnLead' trigger and 'ExistingCustomerOnLeadHandler' Class coverage.
                                                        insertSearchContactTest() : Method to test search for Contact with Email match with Lead Email
                                                        insertSearchAccountTest() : Method to test search for Account with Phone match with Lead Phone
                                                        insertNoMatchFoundTest()  : Method to test search for Account,Contact with Email, Phone, Company
                                                                                    not match with Lead Email, Phone, Company
                                                        insertRecordInBulkTest()  : Method to test for inserting record in bulk

    v2               11 MAY 2016       Priyanka         Created test method 
                                                        updateLeadMatchTest()     : Method to test update on matching Company, Phone, other field in lead
                                                        updateLeadNoMatchTest()   : Method to test update lead when company, email, phone does't match with account/ contact
*/

@isTest
private class ExistingCustomerOnLeadTest {
    
    // Method to test search for Contact with Email match with Lead Email
    static testMethod void insertSearchContactTest(){
        List<Account> lstAccount = new List<Account>();
        List<Contact> lstContact = new List<Contact>();
        
        // create Account record
        Account oAccount = new Account();
        oAccount.Name = 'account1';
        oAccount.Email_Id__c = 'account@gmail.com';
        oAccount.Company__c = 'INFI';
        oAccount.Phone = '111 111 111';
        lstAccount.add(oAccount);
        //insert lstAccount;
        
        // create Contact record
        Contact oContact = new Contact();
        oContact.LastName = 'contact1';
        oContact.Phone = '121 1234 5678';
        oContact.Company__c = 'CON';
        oContact.Email = 'contact1@gmail.com';
        lstContact.add(oContact);
        //insert lstContact;
        
        // create Lead record
        Lead oLead = new Lead();
        oLead.LastName = 'dasjchbsdlead';
        oLead.Phone = '121 1234 5678';
        oLead.Email = 'contact1@gmail.com';
        oLead.Company = 'IBM';
        
        Test.startTest();
            // insert Account list, Contact list, Lead
            insert lstAccount;
            insert lstContact;
            insert oLead;
        Test.stopTest();
        
        // Assertion to check ExistingCustomer set to true and account , contact list size
        system.assert(true,oLead.Existing_Customer__c);
        system.assertEquals(1,lstAccount.size());
        system.assertEquals(1,lstContact.size());
    }
    
    // Method to test search for Account with Phone match with Lead Phone
    static testMethod void insertSearchAccountTest(){
        List<Account> lstAccount = new List<Account>();
        List<Contact> lstContact = new List<Contact>();
        
        // create Account record and add to List
        Account oAccount1 = new Account();
        oAccount1.Name = 'account1';
        oAccount1.Email_Id__c = 'account1@gmail.com';
        oAccount1.Company__c = 'IBM';
        oAccount1.Phone = '101 101 101';
        lstAccount.add(oAccount1);
        
        Account oAccount2 = new Account();
        oAccount2.Name = 'account2';
        oAccount2.Email_Id__c = 'account2@gmail.com';
        oAccount2.Company__c = 'INFI';
        oAccount2.Phone = '102 102 102';
        lstAccount.add(oAccount2);
        //insert lstAccount;
        
        // create Contact record and add to List
        Contact oContact1 = new Contact();
        oContact1.LastName = 'contact1';
        oContact1.Phone = '121 1234 5678';
        oContact1.Company__c = 'CON1';
        oContact1.Email = 'contact1@gmail.com';
        lstContact.add(oContact1);
        
        Contact oContact2 = new Contact();
        oContact2.LastName = 'contact2';
        oContact2.Phone = '101 1234 5678';
        oContact2.Company__c = 'CON2';
        oContact2.Email = 'contact2@gmail.com';
        lstContact.add(oContact2);
        //insert lstContact;
        
        // create Lead record
        Lead oLead = new Lead();
        oLead.LastName = 'dasjchbsdlead';
        oLead.Phone = '101 101 101';
        oLead.Email = 'lead@gmail.com';
        oLead.Company = 'IBM';
        
        Test.startTest();
            // insert Account list, Contact list, Lead
            insert lstAccount;
            insert lstContact;
            insert oLead;
        Test.stopTest();
        
        // Assertion to check ExistingCustomer set to true and account , contact list size
        system.assert(true,oLead.Existing_Customer__c);
        system.assertEquals(2,lstAccount.size());
        system.assertEquals(2,lstContact.size());
    }
    
    /* Method to test search for Account,Contact with Email, Phone, Company not match with Lead
    Email, Phone, Company */
    static testMethod void insertNoMatchFoundTest(){
        List<Account> lstAccount = new List<Account>();
        List<Contact> lstContact = new List<Contact>();
        
        // create Account record and add to List
        Account oAccount1 = new Account();
        oAccount1.Name = 'account1';
        oAccount1.Company__c = 'INFI';
        oAccount1.Phone = '101 101 101';
        lstAccount.add(oAccount1);
        
        Account oAccount2 = new Account();
        oAccount2.Name = 'account2';
        oAccount2.Company__c = 'HERO';
        oAccount2.Phone = '102 102 102';
        lstAccount.add(oAccount2);
        //insert lstAccount;
        
        // create Contact record and add to List
        Contact oContact1 = new Contact();
        oContact1.LastName = 'contact1';
        oContact1.Phone = '121 1234 5678';
        oContact1.Email = 'contact1@gmail.com';
        lstContact.add(oContact1);
        
        Contact oContact2 = new Contact();
        oContact2.LastName = 'contact2';
        oContact2.Phone = '101 1234 5678';
        oContact2.Email = 'contact2@gmail.com';
        lstContact.add(oContact2);
        //insert lstContact;
        
        Lead oLead = new Lead();
        oLead.LastName = 'dasjchbsdlead';
        oLead.Phone = '101 102 103';
        oLead.Email = 'lead@gmail.com';
        oLead.Company = 'IBM';
        
        Test.startTest();
            // insert Account list, Contact list, Lead
            insert lstAccount;
            insert lstContact;
            insert oLead;
        Test.stopTest();
        
        // Assertion to check ExistingCustomer set to false and account , contact list size
        system.assertEquals(false,oLead.Existing_Customer__c);
        system.assertEquals(2,lstAccount.size());
        system.assertEquals(2,lstContact.size());
    }
    
    // Method to test for inserting record in bulk
    static testMethod void insertRecordInBulkTest(){
        List<Account> lstAccount = new List<Account>();
        List<Contact> lstContact = new List<Contact>();
        List<Lead> lstLead = new List<Lead>();
        
        // create Account record and add to List
        Account oAccount1 = new Account();
        oAccount1.Name = 'account1';
        oAccount1.Company__c = 'INFI';
        oAccount1.Phone = '101 101 101';
        lstAccount.add(oAccount1);
        
        Account oAccount2 = new Account();
        oAccount2.Name = 'account2';
        oAccount2.Company__c = 'HERO';
        oAccount2.Phone = '102 102 102';
        lstAccount.add(oAccount2);
        //insert lstAccount;
        
        // create Contact record and add to List
        Contact oContact1 = new Contact();
        oContact1.LastName = 'contact1';
        oContact1.Phone = '121 1234 5678';
        oContact1.Email = 'contact1@gmail.com';
        lstContact.add(oContact1);
        
        Contact oContact2 = new Contact();
        oContact2.LastName = 'contact2';
        oContact2.Phone = '101 1234 5678';
        oContact2.Email = 'contact2@gmail.com';
        lstContact.add(oContact2);
        //insert lstContact;
        
        for(integer i = 0; i < 50 ; i++){
            Lead oLead = new Lead(
            LastName = 'dasjchbsdlead',
            Phone = '101 102 103',
            Email = 'lead@gmail.com',
            Company = 'IBM '+ i);
            lstLead.add(oLead);
        }
        
        system.debug(' ==================== lead lst ' + lstLead);
        Test.startTest();
            // insert Account list, Contact list, Lead
            insert lstAccount;
            insert lstContact;
            insert lstLead;
        Test.stopTest();
        
        // Assertion to check ExistingCustomer set to false and account, contact, lead list size
        system.assertEquals(false,lstLead[0].Existing_Customer__c);
        system.assertEquals(2,lstAccount.size());
        system.assertEquals(2,lstContact.size());
        system.assertEquals(50,lstLead.size());
    }
    
    // Method to test update on matching Company, Phone, other field in lead
    static testMethod void updateLeadMatchTest(){
        List<Account> lstAccount = new List<Account>();
        List<Contact> lstContact = new List<Contact>();
        
        // create Account record and add to List
        Account oAccount1 = new Account();
        oAccount1.Name = 'account1';
        oAccount1.Company__c = 'IBM';
        oAccount1.Phone = '101 101 101';
        lstAccount.add(oAccount1);
        
        Account oAccount2 = new Account();
        oAccount2.Name = 'account2';
        oAccount2.Company__c = 'INFI';
        oAccount2.Phone = '102 102 102';
        lstAccount.add(oAccount2);
        //insert lstAccount;
        
        // create Contact record and add to List
        Contact oContact1 = new Contact();
        oContact1.LastName = 'contact1';
        oContact1.Phone = '121 1234 5678';
        oContact1.Email = 'contact1@gmail.com';
        lstContact.add(oContact1);
        
        Contact oContact2 = new Contact();
        oContact2.LastName = 'contact2';
        oContact2.Phone = '101 1234 5678';
        oContact2.Email = 'contact2@gmail.com';
        lstContact.add(oContact2);
        //insert lstContact;
        
        // create Lead record
        Lead oLead = new Lead();
        oLead.LastName = 'dasjchbsdlead';
        oLead.Phone = '111 111 111 ';
        oLead.Email = 'vbdvjlead@gmail.com';
        oLead.Company = 'IBM';
        
        Test.startTest();
            // insert Account list, Contact list, Lead
            insert lstAccount;
            insert lstContact;
            insert oLead;
            oLead.Description = 'dgfsdjvbdv';
           // oLead.Company = 'IBM';
            oLead.Email = 'contact1@gmail.com';
            oLead.Phone = '101 101 101';
            update oLead;
        Test.stopTest();
        
        // Assertion to check ExistingCustomer set to true and account , contact list size
        system.assert(true,oLead.Existing_Customer__c);
        system.assertEquals(2,lstAccount.size());
        system.assertEquals(2,lstContact.size());
    }
    
    // Method to test update lead when company, email, phone does't match with account/ contact
    static testMethod void updateLeadNoMatchTest(){
        List<Account> lstAccount = new List<Account>();
        List<Contact> lstContact = new List<Contact>();
        
        // create Account record and add to List
        Account oAccount1 = new Account();
        oAccount1.Name = 'account1';
        oAccount1.Company__c = 'IBM';
        oAccount1.Phone = '101 101 101';
        lstAccount.add(oAccount1);
        
        Account oAccount2 = new Account();
        oAccount2.Name = 'account2';
        oAccount2.Company__c = 'INFI';
        oAccount2.Phone = '102 102 102';
        lstAccount.add(oAccount2);
        //insert lstAccount;
        
        // create Contact record and add to List
        Contact oContact1 = new Contact();
        oContact1.LastName = 'contact1';
        oContact1.Phone = '121 1234 5678';
        oContact1.Email = 'contact1@gmail.com';
        lstContact.add(oContact1);
        
        Contact oContact2 = new Contact();
        oContact2.LastName = 'contact2';
        oContact2.Phone = '101 1234 5678';
        oContact2.Email = 'contact2@gmail.com';
        lstContact.add(oContact2);
        //insert lstContact;
        
        // create Lead record
        Lead oLead = new Lead();
        oLead.LastName = 'dasjchbsdlead';
        oLead.Phone = '111 111 111 ';
        oLead.Email = 'vbdvjlead@gmail.com';
        oLead.Company = 'IBDFDJ';
        insert oLead;
        oLead.Description = 'dgfsdjvbdv';
        oLead.Company = 'hdvfsdhjfvds';
        
        Test.startTest();
            // insert Account list, Contact list, Lead
            insert lstAccount;
            insert lstContact;
            update oLead;
        Test.stopTest();
        
        // Assertion to check ExistingCustomer set to false and account , contact list size
        system.assertEquals(false,oLead.Existing_Customer__c);
        system.assertEquals(2,lstAccount.size());
        system.assertEquals(2,lstContact.size());
    }
}