@isTest
public with sharing class ContactTriggerHandlerTest {
    @isTest
    public  static void afterUpdateHandlerTest1() {
        List<Account> testAccs = new List<Account>();
        testAccs.add(new Account(Name = 'Test 1', Email__c ='test1@gmail.com'));
        testAccs.add(new Account(Name = 'Test 2',Email__c ='test2@gmail.com'));

        insert testAccs;

        List<Contact> testCons = new List<Contact> ();
        testCons.add(new Contact(LastName = 'Test con 1', AccountId = testAccs[0].id));
        testCons.add(new Contact(LastName = 'Test con 2', AccountId = testAccs[0].id));
        testCons.add(new Contact(LastName = 'Test con 3', AccountId = testAccs[1].id));

        insert testCons;

        List<Account> accs = [SELECT Id, Active_Contacts__c FROM Account];
        System.assertEquals(2, accs.size());
        System.assertEquals(0, accs[0].Active_Contacts__c);
        System.assertEquals(0, accs[1].Active_Contacts__c);

        List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(3,cons.size());
        
    }
    @isTest
    public  static void afterUpdateHandlerTest2() {
        List<Account> testAccs = new List<Account>();
        testAccs.add(new Account(Name = 'Test 1',Email__c ='test1@gmail.com'));
        testAccs.add(new Account(Name = 'Test 2',Email__c ='test2@gmail.com'));

        insert testAccs;

        List<Contact> testCons = new List<Contact> ();
        testCons.add(new Contact(LastName = 'Test con 1', AccountId = testAccs[0].id, Active__c = true));
        testCons.add(new Contact(LastName = 'Test con 2', AccountId = testAccs[0].id));
        testCons.add(new Contact(LastName = 'Test con 3', AccountId = testAccs[1].id));

        insert testCons;

        List<Account> accs = [SELECT Id,Name, Active_Contacts__c FROM Account];
        System.assertEquals(2, accs.size());
        for(Account acc : accs){
            if(acc.Name == 'Test 1'){
                System.assertEquals(1, acc.Active_Contacts__c);
            }
            if(acc.Name == 'Test 2'){
                System.assertEquals(0, acc.Active_Contacts__c);
            }
        }
            List<Contact> cons = [SELECT Id FROM Contact];
            System.assertEquals(3,cons.size());
        
    }

    @isTest
    public static void afterUpdateHandlerTestBulk(){
        List<Account> testAccs = new List<Account>();
        testAccs.add(new Account(Name = 'Test 1',Email__c ='test1@gmail.com'));
        testAccs.add(new Account(Name = 'Test 2',Email__c ='test2@gmail.com'));

        insert testAccs;

        List<Contact> testCons = new List<Contact>();
        for(Integer i = 0; i < 1000; i ++ ){
            testCons.add(new Contact(LastName = 'Test Contact' + i, AccountId = testAccs[0].id, Active__c = true));
        }
        testCons.add(new Contact(LastName = 'Test con Inactive 1', AccountId = testAccs[0].id));
        testCons.add(new Contact(LastName = 'Test con Inactive 2', AccountId = testAccs[0].id));
        testCons.add(new Contact(LastName = 'Test con Inactive 3', AccountId = testAccs[1].id));

        insert testCons;

        List<Account> accs = [SELECT Id,Name,Active_Contacts__c FROM Account];
        System.assertEquals(2,accs.size());
        for(Account acc : accs){
            if(acc.Name == 'Test 1'){
                System.assertEquals(1000, acc.Active_Contacts__c);
            }
            if(acc.Name == 'Test 2'){
                System.assertEquals(0, acc.Active_Contacts__c);
            }
        }
        List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(1003,cons.size());

    }
}

