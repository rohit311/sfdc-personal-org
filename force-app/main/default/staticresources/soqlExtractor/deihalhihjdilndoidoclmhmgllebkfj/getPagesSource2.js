// @author Rob W <http://stackoverflow.com/users/938089/rob-w>
// Demo: var serialized_html = DOMtoString(document);

function DOMtoString(document_root) {
   var pageHTML = '',
        node = document_root.firstChild;
		
    while (node) {
     
	  pageHTML+= node.outerHTML;
	  
	   node = node.nextSibling;
    }
	
	
var index1 = pageHTML.indexOf("<pre class=\"codeBlock\">");
var index2 = pageHTML.indexOf("</pre>");
var codeBlock = pageHTML.substring(index1,index2);
	
	var outputStr = '';
	var queryCountMap = new Map();
	var objectCountMap = new Map();
var logLinesArr = codeBlock.replace( /\n/g, "sfanalyzer" ).split("sfanalyzer");
	var soqlQueryStrArr;
	var soqlQueryStr;
	var queryCountInt;
	var objectCountInt;
	var objectRegEx;
	
	for(var i=1;i<logLinesArr.length-1;i++)
	{
		if(aContainsB(logLinesArr[i],"SOQL_EXECUTE_BEGIN"))
		{
			 soqlQueryStrArr = logLinesArr[i].split("|");
			 soqlQueryStr = soqlQueryStrArr[4] + "\n";
			 // get the count from the hashmap for the current query
			 if(queryCountMap.get(soqlQueryStrArr[4])!=null)
			 {
			 // increment the count and save it back in the mao
			 queryCountInt = queryCountMap.get(soqlQueryStrArr[4]);
			// console.log('query exists in map.');
			// console.log('count is ' + queryCountInt + ' for query ' + soqlQueryStrArr[4]);
			 queryCountMap.put(soqlQueryStrArr[4], queryCountInt + 1);
			 }
			 
			 else
			 {
					// else the query does not exist in the map
						// insert the query in the map and initialize the count to One
						queryCountMap.put(soqlQueryStrArr[4], 1);
						//console.log('adding ' + soqlQueryStrArr[4] + ' to hashmap for the first time');
						//outputStr=outputStr+soqlQueryStr;
			 }
			 
			 objectRegEx = soqlQueryStrArr[4].match("from (.*?) ");
			 
			 if(objectRegEx==null || objectRegEx.length==0)
			 {
			  objectRegEx = soqlQueryStrArr[4].match("FROM (.*?) ");
			  
			  }
			  
			  if(objectRegEx!=null && objectRegEx.length > 0)
			  {
			 if(objectCountMap.get(objectRegEx[1])!=null)
			 {
				 objectCountInt = objectCountMap.get(objectRegEx[1]);
				objectCountMap.put(objectRegEx[1],objectCountInt+1);			
			}
			else
			{
				objectCountMap.put(objectRegEx[1], 1);
			}
			
			}
		}
	}
	
	
	
	
	
	

	
	var queryCountMapEntry = queryCountMap.entrys();
	var objectCountMapEntry = objectCountMap.entrys();
	var outputHTML = "<h3 align=\"center\" style\"color:#039;\"> SOQL Extractor And Analyzer for SalesForce </h3> <center><font size=1> Developed By <a href=\"mailto:rajivashokbhatt+SOQLExtractor@gmail.com\" target=\"_blank\">Rajiv Bhatt</a> Like it? Rate It!! </font></center> <table id=\"hor-minimalist-a\"> <thead><th>SOQL Queries and their Execution Counts</th></thead><tbody><tr><td> <table id=\"box-table-a\" summary=\"SOQL Query Execution Counts\">  <thead> <tr> <th>SOQL Query</th> <th> Execution Count </th> </tr>  </thead> <tbody>";
	for(var i=0;i < queryCountMapEntry.length ; i++)
	{
		outputHTML = outputHTML + "<tr><td width=\"70%\">" + queryCountMapEntry[i].key + "</td> <td width=\"30%\" style=\"text-align: center;\">" +  queryCountMap.get(queryCountMapEntry[i].key) + "</td></tr>";
	}
	outputHTML+="</tbody></table> </td> </tr></tbody></table> <table id=\"hor-minimalist-a\"> <thead><th>Related Objects, on which these SOQLs were executed, with their Execution Counts</th></thead><tbody><tr><td> <table id=\"box-table-a\" summary=\"Objects on which SOQLs where Executed with their Execution Counts\">  <thead> <tr> <th>Related Object Name</th> <th> Execution Count </th> </tr>  </thead> <tbody>";
	for(var j=0;j < objectCountMapEntry.length ; j++)
	{
		outputHTML = outputHTML + "<tr><td>" + objectCountMapEntry[j].key + "</td> <td>" +  objectCountMap.get(objectCountMapEntry[j].key) + "</td></tr>";
	}
	outputHTML+="</tbody></table> </td></tbody></table>";
	if(queryCountMapEntry.length == 0)
	 {
		outputHTML = "<table id=\"hor-minimalist-a\"> <thead><th><h4 style=\"color:#1797c0;\"> No SOQL Queries found on this page. Make sure you use this extension after opening up a debug log on salesforce.com</h4></th><thead></table>"
	 }

    return outputHTML;
	
    
}

chrome.extension.sendMessage({
    action: "getSource",
    source: DOMtoString(document)
});




function aContainsB (a, b) {
    return a.indexOf(b) >= 0;
}

function Map() {
this.keys = new Array();
this.data = new Object();

this.put = function(key, value) {
    if(this.data[key] == null){
        this.keys.push(key);
    }
    this.data[key] = value;
};

this.get = function(key) {
    return this.data[key];
};

this.remove = function(key) {
    this.keys.remove(key);
    this.data[key] = null;
};

this.each = function(fn){
    if(typeof fn != 'function'){
        return;
    }
    var len = this.keys.length;
    for(var i=0;i<len;i++){
        var k = this.keys[i];
        fn(k,this.data[k],i);
    }
};

this.entrys = function() {
    var len = this.keys.length;
    var entrys = new Array(len);
    for (var i = 0; i < len; i++) {
        entrys[i] = {
            key : this.keys[i],
            value : this.data[i]
        };
    }
    return entrys;
};

this.isEmpty = function() {
    return this.keys.length == 0;
};

this.size = function(){
    return this.keys.length;
};
}


/**************************************************************/
/* Prepares the cv to be dynamically expandable/collapsible   */
/**************************************************************/
function prepareList() {
    $('#expList').find('li:has(ul)')
    .click( function(event) {
        if (this == event.target) {
            $(this).toggleClass('expanded');
            $(this).children('ul').toggle('medium');
        }
        return false;
    })
    .addClass('collapsed')
    .children('ul').hide();

    //Create the button funtionality
    $('#expandList')
    .unbind('click')
    .click( function() {
        $('.collapsed').addClass('expanded');
        $('.collapsed').children().show('medium');
    })
    $('#collapseList')
    .unbind('click')
    .click( function() {
        $('.collapsed').removeClass('expanded');
        $('.collapsed').children().hide('medium');
    })
    
};


/**************************************************************/
/* Functions to execute on loading the document               */
/**************************************************************/
$(document).ready( function() {
    prepareList()
});