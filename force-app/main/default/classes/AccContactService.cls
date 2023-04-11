public with sharing class AccContactService {
    
    public static void updateActiveContacts(Set<Id> accIds){
        // get aggregate results for all accounts 
        List<AggregateResult> results =[SELECT AccountId,COUNT(Id) totalContacts
        FROM Contact
        WHERE Active__c=true
        AND AccountId IN : accIds
        GROUP BY AccountId];
Map<Id,Account> accountsToUpdate = new Map<Id,Account>();
for(AggregateResult result : results){
String accId = String.valueOf(result.get('AccountId'));
Integer totalContacts = Integer.valueOf(result.get('totalContacts'));

// make sure you use id field in your account to update id
Account acc = new Account(Id=accId,Active_Contacts__c = totalContacts);
accountsToUpdate.put(accId,acc);
}
// update accounts with zero active contact
for(Id accId : accIds){
    if(! accountsToUpdate.containsKey(accId)){
        accountsToUpdate.put(accId,new Account(Id=accId,Active_Contacts__c = 0));
    }
} 
update accountsToUpdate.values();
    }
}
