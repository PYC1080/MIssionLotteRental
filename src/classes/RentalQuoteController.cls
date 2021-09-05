/*
 * ===================================================================================
 * File Name         : RentalQuoteController.cls
 * Author           : yc.park
 * Date            : 2021-09-01
 * Tester           : 
 * Target           : 
 * Description       : 
 * Modification Log
 * ===================================================================================
 * Ver      Date            Author          Modification
 * ===================================================================================
 * 1.0      2021-09-01         yg.park        Create
 * ===================================================================================
 */

public class RentalQuoteController {

    public Quote__c quote {get;set;}
    public SalesAddress__c salesAddress {get;set;}
    public CustomInfo__c customInfo {get;set;}
    public List<RentalInfo__c> listRentalInfo{get;set;}
    public Integer TotalPerMonthRentalFee{get;set;}
    public Integer TotalPerWeekRentalFee {get;set;}
    public Integer TotalRentalFeeAmount {get;set;}
    public Integer TotalQuantity {get; set;}
    public Integer TotalMonthTerm {get; set;}
    public Integer TotalWeekTerm {get; set;}
    public String QuoteNo {get; set;}
    public String QuoteDate {get; set;}
    public String QuoteSpecial {get; set;}

    public RentalQuoteController(){
        InitData();
        TotalCalculate();

        System.debug(quote);
        System.debug(QuoteSpecial);
        System.debug(salesAddress);
        System.debug(customInfo);
        System.debug(listRentalInfo);
        System.debug(TotalQuantity);
        System.debug(TotalMonthTerm);
        System.debug(TotalWeekTerm);
        System.debug(TotalPerMonthRentalFee);
        System.debug(TotalPerWeekRentalFee);
        System.debug(TotalRentalFeeAmount);

    }
    public void TotalCalculate(){
//        String test =`<div></div>`;
        QuoteSpecial = quote.Special__c.replaceAll('\n','<br/>');


        Integer QuoteDateYear = quote.QuoteDate__c.year();
        Integer QuoteDateMonth = quote.QuoteDate__c.month();
        Integer QuoteDateDay = quote.QuoteDate__c.day();

        String qdMonth;
        String qdDay;
        if(QuoteDateMonth<10){
            qdMonth = '0'+QuoteDateMonth;
        }else{
            qdMonth = String.valueOf(QuoteDateMonth);
        }
        if(QuoteDateDay<10){
            qdDay = '0'+QuoteDateDay;
        }else{
            qdDay = String.valueOf(QuoteDateDay);
        }
        QuoteDate = String.valueOf(QuoteDateYear)+'년'+qdMonth+'월'+qdDay+'일';
        String sn = (String) quote.QuoteSerialNumber__c;
        String snYear = String.valueOf(Date.today().year()) ;
        String snMonth;
        String snDay;
        if(Date.today().month()<10){
            snMonth = '0'+String.valueOf(Date.today().month());
        }else{
            snMonth = String.valueOf(Date.today().month());
        }
        if(Date.today().day()<10){
            snDay = '0'+ String.valueOf(Date.today().day());
        }else{
            snDay = String.valueOf(Date.today().day());
        }
        String strSn = snYear+snMonth+snDay;
        QuoteNo = strSn+sn.substring(sn.length()-4,sn.length());

        TotalQuantity = 0;
        TotalMonthTerm = 0;
        TotalWeekTerm = 0;
        TotalPerMonthRentalFee = 0;
        TotalPerWeekRentalFee = 0;
        TotalRentalFeeAmount = 0;
        for(RentalInfo__c objRentalInfo : listRentalInfo){
            if((Integer)objRentalInfo.Quantity__c==null){
                TotalQuantity += 0;
            }else{
                TotalQuantity+=(Integer)objRentalInfo.Quantity__c;
            }

            if((Integer)objRentalInfo.MonthContractTerm__c==null){
                TotalMonthTerm += 0;
            }else{
                TotalMonthTerm+=(Integer)objRentalInfo.MonthContractTerm__c;
            }

            if((Integer)objRentalInfo.WeekContractTerm__c==null){
                TotalWeekTerm += 0;
            }else{
                TotalWeekTerm += (Integer) objRentalInfo.WeekContractTerm__c;
            }

            if((Integer)objRentalInfo.PerMonthRentalFee__c ==null){
                TotalPerMonthRentalFee+=0;
            }else{
                TotalPerMonthRentalFee+=(Integer)objRentalInfo.PerMonthRentalFee__c;
            }
            if((Integer)objRentalInfo.PerWeekRentalFee__c==null){
                TotalPerWeekRentalFee+=0;
            }else{
                TotalPerWeekRentalFee+=(Integer)objRentalInfo.PerWeekRentalFee__c;
            }
            if((Integer)objRentalInfo.TotalRentalFee__c==null){
                TotalRentalFeeAmount+=0;
            }else{
                TotalRentalFeeAmount+=(Integer)objRentalInfo.TotalRentalFee__c;
            }
        }
    }
    public void InitData(){
        quote = [
                SELECT Id, Name, QuoteSerialNumber__c,
                        QuoteDate__c,Etc__c,Special__c,
                        CustomInfo__c, RentalInfo__c, SalesAddress__c,
                        QuoteEffectiveDate__c
                FROM Quote__c
                WHERE Name LIKE '롯데렌탈'
        ];
        salesAddress =[
                SELECT Name, SalesMobile__c, SalesPhone__c,
                        SalesEmail__c,SalesFax__c, Quote__c
                FROM SalesAddress__c
                WHERE Quote__c =: quote.Id
        ];
        customInfo = [
                SELECT Name, CustomerManager__c, CustomerMobile__c
                        , CustomerPhone__c, CustomerEmail__c, CustomerFax__c
                        , Quote__c
                FROM CustomInfo__c
                WHERE Quote__c =: quote.Id
        ];
        listRentalInfo = [
                SELECT Name, RentalItem__c, Quantity__c,
                        MonthContractTerm__c, WeekContractTerm__c,
                        PerMonthRentalFee__c, PerWeekRentalFee__c,
                        TotalRentalFee__c, ProductDetail__c,
                        Quote__c
                FROM RentalInfo__c
                WHERE Quote__c =: quote.Id
        ];
    }

}