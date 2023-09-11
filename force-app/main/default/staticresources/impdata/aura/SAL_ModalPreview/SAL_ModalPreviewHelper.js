({
	showModal : function(component) {
        
        var resultId = component.get("v.docId");
        var cmpTarget = component.find('pop');
        console.log('resultId'+resultId);
		$A.util.addClass(cmpTarget, 'slds-show');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        var allDocs = component.get("v.allDocs");
        var cvRec;
        for(var i=0;i<allDocs.length;i++){
            if(allDocs[i].cvData.Id == resultId){
            	cvRec = allDocs[i];   
            }
        }
        console.log('check cv'+cvRec.cvData.FileType);
        if(cvRec.cvData.FileType == 'PNG' || cvRec.cvData.FileType == 'JPEG' || cvRec.cvData.FileType == 'JPG'){
            var modal = document.createElement('div');
            
            modal.setAttribute("class" , "parentDiv");
            component.find("iframeHolder").getElement().appendChild(modal);
            
            var theFrame = document.createElement('img');
            theFrame.style.height = "500px";
            theFrame.style.width = "500px";
            theFrame.setAttribute("src",component.get("v.prefixURL")+cvRec.cvData.Id);
            
            modal.appendChild(theFrame);
            
            
        }
        else if(cvRec.cvData.FileType == 'PDF'){
            var modal = document.createElement('div');
            console.log('iframe'+component.find("iframeHolder").getElement());
            modal.setAttribute("class" , "parentDiv");
            component.find("iframeHolder").getElement().appendChild(modal);
            
            var theFrame = document.createElement('iframe');
            theFrame.style.height = "500px";
            theFrame.style.width = "500px";
            var fileURL = '';
            console.log('result[i].baseContent'+cvRec.baseContent);
            var url = 'data:application/pdf;base64,' + cvRec.baseContent;
            var index = i+1;
            var filename = 'preview'+index+'.pdf';
            console.log('filename is'+filename);
            fetch(url)
            .then(res => res.blob())
            .then($A.getCallback(blob => theFrame.setAttribute("src",  URL.createObjectURL(new File([blob], filename, { type: 'application/pdf' }))))); 
            
            modal.appendChild(theFrame);
        }	
	}
})