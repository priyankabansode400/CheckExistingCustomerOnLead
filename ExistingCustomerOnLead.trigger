/*
 ===============================================================================================================
    Version        Date          Author          Comment
 ===============================================================================================================
     v1         9 MAY 2016      Priyanka       Before insert 'ExistingCustomerOnLead' Trigger on Lead 
                                               Call 'insertLead' method of 'ExistingCustomerOnLeadHandler' Class.

     v2         11 May 2016     Priyanka       Before update 'ExistingCustomerOnLead' Trigger on Lead 
                                               Call 'updateLead' method of 'ExistingCustomerOnLeadHandler' Class.
*/

trigger ExistingCustomerOnLead on Lead (before insert, before update) {
    
    if(trigger.isBefore && trigger.isInsert){
        ExistingCustomerOnLeadHandler  oLead = new ExistingCustomerOnLeadHandler();
        oLead.insertLead(Trigger.new);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        ExistingCustomerOnLeadHandler  oLead = new ExistingCustomerOnLeadHandler();
        oLead.updateLead(Trigger.new,Trigger.old);
    }
}