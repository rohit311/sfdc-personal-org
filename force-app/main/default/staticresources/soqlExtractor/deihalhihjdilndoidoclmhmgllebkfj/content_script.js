// @author Rajiv Bhatt rajiv.ashok.bhatt@gmail.com
// Date March 4, 2014
// version 0.0.1
var CollapsibleLists=new function(){
this.apply=function(_1){
var _2=document.getElementsByTagName("ul");
for(var _3=0;_3<_2.length;_3++){
if(_2[_3].className.match(/(^| )collapsibleList( |$)/)){
this.applyTo(_2[_3],true);
if(!_1){
var _4=_2[_3].getElementsByTagName("ul");
for(var _5=0;_5<_4.length;_5++){
_4[_5].className+=" collapsibleList";
}
}
}
}
};
this.applyTo=function(_6,_7){
var _8=_6.getElementsByTagName("li");
for(var _9=0;_9<_8.length;_9++){
if(!_7||_6==_8[_9].parentNode){
if(_8[_9].addEventListener){
_8[_9].addEventListener("mousedown",function(e){
e.preventDefault();
},false);
}else{
_8[_9].attachEvent("onselectstart",function(){
event.returnValue=false;
});
}
if(_8[_9].addEventListener){
_8[_9].addEventListener("click",_a(_8[_9]),false);
}else{
_8[_9].attachEvent("onclick",_a(_8[_9]));
}
_b(_8[_9]);
}
}
};
function _a(_c){
return function(e){
if(!e){
e=window.event;
}
var _d=(e.target?e.target:e.srcElement);
while(_d.nodeName!="LI"){
_d=_d.parentNode;
}
if(_d==_c){
_b(_c);
}
};
};
function _b(_e){
var _f=_e.className.match(/(^| )collapsibleListClosed( |$)/);
var uls=_e.getElementsByTagName("ul");
for(var _10=0;_10<uls.length;_10++){
var li=uls[_10];
while(li.nodeName!="LI"){
li=li.parentNode;
}
if(li==_e){
uls[_10].style.display=(_f?"block":"none");
}
}
_e.className=_e.className.replace(/(^| )collapsibleList(Open|Closed)( |$)/,"");
if(uls.length>0){
_e.className+=" collapsibleList"+(_f?"Open":"Closed");
}
};
}();


insertOptions();

function insertOptions() {
    
	
 var pageDescElem = document.getElementsByClassName("ptBreadcrumb");
  if (pageDescElem && pageDescElem.length > 0) {
        var pageDescNode = pageDescElem[0];
 var optionTable = document.createElement("div");
 optionTable.id = "optionTable";
 pageDescNode.appendChild(optionTable);
 var hiddenLogContent = document.createElement("input");
        hiddenLogContent.id = 'hiddenLogContent';
        hiddenLogContent.type = 'hidden';
        pageDescNode.appendChild(hiddenLogContent);
        var debugLogsElements = document.getElementsByClassName("codeBlock");
        if (debugLogsElements && debugLogsElements.length > 0) {
            var debugLogsElement = debugLogsElements[0];
            hiddenLogContent.value = debugLogsElement.innerHTML;
            
        }
 optionTable.innerHTML = "<br/><b> <input type='checkbox' id='logFilter' name='logFilter' value='logFilter' >Filter Log Type </input></b><br/> <br/><table id='logFilterOptionTable' width='50%' style='width:initial;display:none;'><tr><td width='20%'><input type='checkbox' id='USER_DEBUG' name='USER_DEBUG' value='USER_DEBUG'>USER_DEBUG</input></td> <td width='20%'><input type='checkbox' id='SOQL_EXECUTE_BEGIN' name='SOQL_EXECUTE_BEGIN' value='SOQL_EXECUTE_BEGIN'>SOQL_EXECUTE_BEGIN</input></td> <td width='20%'><input type='checkbox' id='SOQL_EXECUTE_END' name='SOQL_EXECUTE_END' value='SOQL_EXECUTE_END'>SOQL_EXECUTE_END </input></td> <td width='20%'><input type='checkbox' id='METHOD_ENTRY' name='METHOD_ENTRY' value='METHOD_ENTRY'>METHOD_ENTRY </input></td> </tr> <tr> <td width='20%'><input type='checkbox' id='METHOD_EXIT' name='METHOD_EXIT' value='METHOD_EXIT'>METHOD_EXIT</input></td> <td width='20%'> <input type='checkbox' id='SYSTEM_METHOD_ENTRY' name='SYSTEM_METHOD_ENTRY' value='SYSTEM_METHOD_ENTRY'>SYSTEM_METHOD_ENTRY </input></td> <td width='20%'> <input type='checkbox' id='SYSTEM_METHOD_EXIT' name='SYSTEM_METHOD_EXIT' value='SYSTEM_METHOD_EXIT'>SYSTEM_METHOD_EXIT</input> </td> <td width='20%'>  <input type='checkbox' id='WF_RULE_EVAL_BEGIN' name='WF_RULE_EVAL_BEGIN' value='WF_RULE_EVAL_BEGIN'>WF_RULE_EVAL_BEGIN </input> </td> </tr> <tr> <td width='20%'> <input type='checkbox' id='WF_RULE_EVAL_END' name='WF_RULE_EVAL_END' value='WF_RULE_EVAL_END'>WF_RULE_EVAL_END </input>  </td> <td width='20%'> <input type='checkbox' id='WF_FORMULA' name='WF_FORMULA' value='WF_FORMULA'>WF_FORMULA </input> </td> <td width='20%'>   <input type='checkbox' id='WF_CRITERIA_BEGIN' name='WF_CRITERIA_BEGIN' value='WF_CRITERIA_BEGIN'>WF_CRITERIA_BEGIN </input> </td> <td width='20%'>  <input type='checkbox' id='WF_CRITERIA_END' name='WF_CRITERIA_END' value='WF_CRITERIA_END'>WF_CRITERIA_END </input> </td> </tr> <tr> <td><input type='checkbox' id='WF_RULE_FILTER' name='WF_RULE_FILTER' value='WF_RULE_FILTER'>WF_RULE_FILTER </input> </td> <td width='20%'>  <input type='checkbox' id='WF_SPOOL_ACTION_BEGIN' name='WF_SPOOL_ACTION_BEGIN' value='WF_SPOOL_ACTION_BEGIN'>WF_SPOOL_ACTION_BEGIN </input>  </td> <td width='20%'>  <input type='checkbox' id='WF_SPOOL_ACTION_END' name='WF_SPOOL_ACTION_END' value='WF_SPOOL_ACTION_END'>WF_SPOOL_ACTION_END </input> </td>  <td width='20%'>  <input type='checkbox' id='DML_BEGIN' name='DML_BEGIN' value='DML_BEGIN'>DML_BEGIN </input>   </td> </tr> <tr> <td width='20%'> <input type='checkbox' id='DML_END' name='DML_END' value='DML_END'>DML_END</input> </td> <td width='20%'> <input type='checkbox' id='VF_DESERIALIZE_VIEWSTATE_BEGIN' name='VF_DESERIALIZE_VIEWSTATE_BEGIN' value='VF_DESERIALIZE_VIEWSTATE_BEGIN'>VF_DESERIALIZE_VIEWSTATE_BEGIN </input>  </td> <td width='20%'>  <input type='checkbox' id='VF_DESERIALIZE_VIEWSTATE_END' name='VF_DESERIALIZE_VIEWSTATE_END' value='VF_DESERIALIZE_VIEWSTATE_END'>VF_DESERIALIZE_VIEWSTATE_END</input> </td> </tr> </table><input type='checkbox' id='nestedMethods' name='nestedMethods' value='nestedMethods'><b>Nested Methods </b>(Beta - Collapsible method entry exits along with user debug and soqls) </input><br/><br/> ";
 }

var nestedMethodNode = document.getElementById('nestedMethods');
nestedMethodNode
.addEventListener(
                "click",
                function() {
								
								if(this.checked==true)
								{
									insertLog();
								
							   }
							   else
							   {
							    var treeNode = document.getElementsByClassName('treeView');
								treeNode[0].parentNode.removeChild(treeNode[0]);
							    
							   }
					
			},false); 

			var logFilterNode = document.getElementById('logFilter');
logFilterNode
.addEventListener(
                "click",
                function() {
								 var logFilterOptionTableNode = document.getElementById('logFilterOptionTable');
								if(this.checked==true)
								{
									//logFilterOptionTableNode.style.visibility="visible";
									updateLogView();
									logFilterOptionTableNode.style.display="block";
							   }
							   else
							   {
								
							document.getElementsByClassName("codeBlock")[0].innerHTML=document.getElementById('hiddenLogContent').value;
							 
								//logFilterOptionTableNode.style.visibility="hidden";
								logFilterOptionTableNode.style.display="none";
								
							      
							   }
					
			},false); 
			
var userDebugNode = document.getElementById('USER_DEBUG');
userDebugNode
.addEventListener(
                "click",
                function() {
								updateLogView();
					
			},false); 
var soqlBeginNode = document.getElementById('SOQL_EXECUTE_BEGIN');
soqlBeginNode
.addEventListener(
                "click",
                function() {
								updateLogView();
					
			},false); 
var soqlExitNode = document.getElementById('SOQL_EXECUTE_END');
soqlExitNode
.addEventListener(
                "click",
                function() {
								updateLogView();
					
			},false); 
	var methodEntryNode = document.getElementById('METHOD_ENTRY');
methodEntryNode
.addEventListener(
                "click",
                function() {
								updateLogView();
					
			},false); 
			
var methodExitNode = document.getElementById('METHOD_EXIT');
methodExitNode
.addEventListener(
                "click",
                function() {
								updateLogView();
					
			},false); 
	var systemMethodEntryNode = document.getElementById('SYSTEM_METHOD_ENTRY');
systemMethodEntryNode
.addEventListener(
                "click",
                function() {
								updateLogView();
					
			},false); 
			
var systemMethodExitNode = document.getElementById('SYSTEM_METHOD_EXIT');
systemMethodExitNode.addEventListener("click", function() {updateLogView();},false); 

var wfRuleEvalBeginNode = document.getElementById('WF_RULE_EVAL_BEGIN');
wfRuleEvalBeginNode.addEventListener("click", function() {updateLogView();},false); 

var wfRuleEvalEndNode = document.getElementById('WF_RULE_EVAL_END');
wfRuleEvalEndNode.addEventListener("click", function() {updateLogView();},false); 						

var wfFormulaNode = document.getElementById('WF_FORMULA');
wfFormulaNode.addEventListener("click", function() {updateLogView();},false); 

var wfCriteriaBeginNode = document.getElementById('WF_CRITERIA_BEGIN');
wfCriteriaBeginNode.addEventListener("click", function() {updateLogView();},false); 

var wfCriteriaEndNode = document.getElementById('WF_CRITERIA_END');
wfCriteriaEndNode.addEventListener("click", function() {updateLogView();},false); 	

var wfRuleFilterNode = document.getElementById('WF_RULE_FILTER');
wfRuleFilterNode.addEventListener("click", function() {updateLogView();},false); 

var wfSpoolBeginNode = document.getElementById('WF_SPOOL_ACTION_BEGIN');
wfSpoolBeginNode.addEventListener("click", function() {updateLogView();},false); 

var wfSpoolEndNode = document.getElementById('WF_SPOOL_ACTION_END');
wfSpoolEndNode.addEventListener("click", function() {updateLogView();},false); 	


var dmlBeginNode = document.getElementById('DML_BEGIN');
dmlBeginNode.addEventListener("click", function() {updateLogView();},false); 	

var dmlEndNode = document.getElementById('DML_END');
dmlEndNode.addEventListener("click", function() {updateLogView();},false); 

var vfBeginNode = document.getElementById('VF_DESERIALIZE_VIEWSTATE_BEGIN');
vfBeginNode.addEventListener("click", function() {updateLogView();},false); 

var vfEndNode = document.getElementById('VF_DESERIALIZE_VIEWSTATE_END');
vfEndNode.addEventListener("click", function() {updateLogView();},false); 	
 
}




function updateLogView() {

 var debugLogsElements = document.getElementsByClassName("codeBlock");
  
                var debugLogsElement = debugLogsElements[0];
                debugLogsElement.innerHTML = ' ';
            
            var initialLogTextElement = document.getElementById('hiddenLogContent');
       var logLinesArr = initialLogTextElement.value.replace( /\n/g, "sfanalyzer" ).split("sfanalyzer");
	   var isUserDebugChecked = document.getElementById('USER_DEBUG').checked;
	   var issoqlBeginChecked = document.getElementById('SOQL_EXECUTE_BEGIN').checked;
	   var issoqlEndChecked = document.getElementById('SOQL_EXECUTE_END').checked;
	   var isMethodEntry = document.getElementById('METHOD_ENTRY').checked;
	   var isMethodExit = document.getElementById('METHOD_EXIT').checked; 
	   var isSystemMethodEntry = document.getElementById('SYSTEM_METHOD_ENTRY').checked;
	   var isSystemMethodExit = document.getElementById('SYSTEM_METHOD_EXIT').checked;
	   var isWFEvalBegin = document.getElementById('WF_RULE_EVAL_BEGIN').checked;
	   var isWFEvalEnd = document.getElementById('WF_RULE_EVAL_END').checked;
	   var isWFFormula = document.getElementById('WF_FORMULA').checked
	   var isWFCriteriaBegin = document.getElementById('WF_CRITERIA_BEGIN').checked;
	   var isWFCriteriaEnd = document.getElementById('WF_CRITERIA_END').checked;
	   var isWFRuleFilter = document.getElementById('WF_RULE_FILTER').checked
	   var isWFSpoolBegin = document.getElementById('WF_SPOOL_ACTION_BEGIN').checked;
	   var isWFSpoolEnd = document.getElementById('WF_SPOOL_ACTION_END').checked;
	   var isDMLBegin = document.getElementById('DML_BEGIN').checked;
	   var isDMLEnd = document.getElementById('DML_END').checked
	   var isVFBegin = document.getElementById('VF_DESERIALIZE_VIEWSTATE_BEGIN').checked;
	   var isVFEnd = document.getElementById('VF_DESERIALIZE_VIEWSTATE_END').checked;
	   
	   for(var i=1;i<logLinesArr.length-1;i++)
	{
	     if((isUserDebugChecked && aContainsB(logLinesArr[i],"USER_DEBUG")) || 
		    (issoqlBeginChecked && aContainsB(logLinesArr[i],"SOQL_EXECUTE_BEGIN")) || 
			(issoqlEndChecked && aContainsB(logLinesArr[i],"SOQL_EXECUTE_END")) || 
			(isMethodEntry && aContainsB(logLinesArr[i],"|METHOD_ENTRY|")) || 
		    (isMethodExit && aContainsB(logLinesArr[i],"|METHOD_EXIT|"))  || 
	        (isSystemMethodEntry && aContainsB(logLinesArr[i],"SYSTEM_METHOD_ENTRY")) || 
		    (isSystemMethodExit && aContainsB(logLinesArr[i],"SYSTEM_METHOD_EXIT"))  || 	        
			(isWFEvalBegin && aContainsB(logLinesArr[i],"WF_RULE_EVAL_BEGIN")) || 
		    (isWFEvalEnd && aContainsB(logLinesArr[i],"WF_RULE_EVAL_END")) ||  			
			(isWFFormula && aContainsB(logLinesArr[i],"WF_FORMULA")) || 
   		    (isWFCriteriaBegin && aContainsB(logLinesArr[i],"WF_CRITERIA_BEGIN")) || 
		    (isWFCriteriaEnd && aContainsB(logLinesArr[i],"WF_CRITERIA_END")) || 
			(isWFRuleFilter && aContainsB(logLinesArr[i],"WF_RULE_FILTER")) || 
   		    (isWFSpoolBegin && aContainsB(logLinesArr[i],"WF_SPOOL_ACTION_BEGIN")) || 
		    (isWFSpoolEnd && aContainsB(logLinesArr[i],"WF_SPOOL_ACTION_END")) || 
		    (isDMLBegin && aContainsB(logLinesArr[i],"DML_BEGIN")) || 
			(isDMLEnd && aContainsB(logLinesArr[i],"DML_END")) || 
   		    (isVFBegin && aContainsB(logLinesArr[i],"VF_DESERIALIZE_VIEWSTATE_BEGIN")) || 
		    (isVFEnd && aContainsB(logLinesArr[i],"VF_DESERIALIZE_VIEWSTATE_END")) 
			
			)
		 {
		   debugLogsElement.innerHTML = debugLogsElement.innerHTML + '\n' +  logLinesArr[i];
		 }
	}
           

}



function insertLog() {


	var outputStr = '';
	var queryCountMap = new Map();
	var objectCountMap = new Map();
            var initialLogTextElement = document.getElementById('hiddenLogContent');
       var logLinesArr = initialLogTextElement.value.replace( /\n/g, "sfanalyzer" ).split("sfanalyzer");
var collapsibleLog = '';
	var methodNameStrArr;
for(var i=1;i<logLinesArr.length-1;i++)
	{
	   if(aContainsB(logLinesArr[i],"SYSTEM_METHOD") || aContainsB(logLinesArr[i],"SYSTEM_CONSTRUCTOR") 
	     || aContainsB(logLinesArr[i],"CODE_UNIT") || aContainsB(logLinesArr[i],"SYSTEM_MODE")  || aContainsB(logLinesArr[i],"CONSTRUCTOR_ENTRY") ||  aContainsB(logLinesArr[i],"CONSTRUCTOR_EXIT") ||  aContainsB(logLinesArr[i],"ENTERING_MANAGED_PKG") )
		 {
			continue;
		 }
	   
	   methodNameStrArr = logLinesArr[i].split("|");
	   
		if(aContainsB(logLinesArr[i],"|METHOD_ENTRY|"))
		 {
		  collapsibleLog=  collapsibleLog + " <br/> &emsp;<li><b> "+ i + "&nbsp;|&nbsp; ENTER -- " + methodNameStrArr[methodNameStrArr.length-1] + "</b><ul>" ;
		 }
		 else if(aContainsB(logLinesArr[i],"|METHOD_EXIT|"))
		{
		 collapsibleLog=  collapsibleLog + " </ul></li>&emsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + i + "&nbsp;|&nbsp;<b>EXIT --" + methodNameStrArr[methodNameStrArr.length-1] + "</b><br/> <br/>";
		}
		else
		{ 
		 
		 collapsibleLog =  collapsibleLog + "&emsp;" + i + "&nbsp;|&nbsp;"+ logLinesArr[i] + '<br/>';
		 }
	}
	
	var tdElements = document.getElementsByTagName('td');

	for(var l=0;l<tdElements.length;l++)
		{
				//tdElements[l].style.color="red"; 
				if(tdElements[l].parentNode.childNodes[0].innerHTML === "Status")
				{
				tdElements[l+1].innerHTML = "     <style type='text/css'>     .treeView{      -moz-user-select:none;    position:relative; }  .treeView ul{     margin:0 0 0 -1.5em;     padding:0 0 0 1.5em;  }     .treeView ul ul{         background: url(chrome-extension://deihalhihjdilndoidoclmhmgllebkfj/img/list-item-contents.png) repeat-y left;      !important }       .treeView li.lastChild > ul{        background-image:none;       }      .treeView li{        margin:0;        padding:0;        background:url(chrome://deihalhihjdilndoidoclmhmgllebkfj/img/list-item-root.png) no-repeat top left ;        list-style-position:inside;        list-style-image:url(chrome-extension://deihalhihjdilndoidoclmhmgllebkfj/img/button.png);        cursor:auto;      !important}      .treeView li.collapsibleListOpen{        list-style-image:url(chrome-extension://deihalhihjdilndoidoclmhmgllebkfj/img/button-open.png);        cursor:pointer;      !important}      .treeView li.collapsibleListClosed{        list-style-image:url(chrome-extension://deihalhihjdilndoidoclmhmgllebkfj/img/button-closed.png);        cursor:pointer;      !important}      .treeView li li{        background-image:url(chrome-extension://deihalhihjdilndoidoclmhmgllebkfj/img/list-item.png);        padding-left:1.5em;      !important}      .treeView li.lastChild{        background-image:url(chrome-extension://deihalhihjdilndoidoclmhmgllebkfj/img/list-item-last.png);      }      .treeView li.collapsibleListOpen{        background-image:url(chrome-extension://deihalhihjdilndoidoclmhmgllebkfj/img/list-item-open.png);      }      .treeView li.collapsibleListOpen.lastChild{        background-image:url(chrome-extension://deihalhihjdilndoidoclmhmgllebkfj/img/list-item-last-open.png);      }    </style>  <ul class='treeView'><li > <div id ='expandCollapse' style='cursor:pointer;'><b>Expand All</b></div><br/><ul class='collapsibleList'> " + collapsibleLog + "</ul></li></ul>";
				break;
		}
		}
CollapsibleLists.apply();
var expandNode = document.getElementById('expandCollapse');

expandNode
            .addEventListener(
                "click",
                function() {
				
				if(aContainsB(this.innerHTML,'Collapse'))
				{ 
					while (document.getElementsByClassName(' collapsibleListOpen')!=null && document.getElementsByClassName(' collapsibleListOpen').length>0)  { 	var elem = document.getElementsByClassName(' collapsibleListOpen'); 		for(i =0;i<elem.length;i++)  			{ 			elem[i].click(); 			} }
				  this.innerHTML='<b>Expand All</b>';
				}
				else
				{

				while (document.getElementsByClassName(' collapsibleListClosed')!=null && document.getElementsByClassName(' collapsibleListClosed').length>0)  { 	var elem = document.getElementsByClassName(' collapsibleListClosed'); 		for(i =0;i<elem.length;i++)  			{ 			elem[i].click(); 			} }

				  this.innerHTML='<b>Collapse All</b>';
				}
				
		
				}, false);
}
function aContainsB (a, b) {
    return a.indexOf(b) >= 0;
}



chrome.extension.sendMessage({type:'showPageAction'});