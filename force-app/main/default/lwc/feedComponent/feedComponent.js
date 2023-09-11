import { LightningElement, track } from 'lwc';
import getFeedData from '@salesforce/apex/feedComponentController.getFeedData';
import serverError from '@salesforce/label/c.Server_error';

export default class FeedComponent extends LightningElement {

    @track listOfFeeds = [];
    @track isValidResponse = false;
    labels = {
        serverError
    };


    fetchFeeds(){
        getFeedData()
                    .then((result)=>{
                        let processedResponse = this.parseXmlResponse(result);
                        this.listOfFeeds = processedResponse;
                        this.isValidResponse = true;
                    })
                    .catch((e)=>{
                       console.log('error ',e);   
                       this.isValidResponse = false;  
                    })
    }

    connectedCallback(){
        this.fetchFeeds();

        let currentContext = this;

        setInterval(function(){
            currentContext.fetchFeeds();
        },60000);
    }

    parseXmlResponse(xmlString){
        var parser = new DOMParser();
        var xmlDoc = parser.parseFromString(xmlString, "text/xml");
        console.log('xmlDoc ',xmlDoc);
        var items = xmlDoc.getElementsByTagName('item');
        var processedResponse = new Array();

        if(items && items.length > 0){
            for(let i=0;i<items.length;i++){
                processedResponse.push(
                    {'title':items[i].getElementsByTagName('title')[0].childNodes[0].nodeValue,
                    'link':items[i].getElementsByTagName('link')[0].childNodes[0].nodeValue,
                    "image":items[i].getElementsByTagName('media:content')[0].getAttribute('url'),
                    "url":items[i].getElementsByTagName('source')[0].getAttribute('url')+items[i].getElementsByTagName('guid')[0].childNodes[0].nodeValue}
                );
            }
        }

        return processedResponse;
    }
}