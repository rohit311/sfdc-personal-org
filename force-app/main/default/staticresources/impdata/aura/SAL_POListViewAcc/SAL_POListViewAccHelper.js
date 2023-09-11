({
    toggleAccordion : function(component,event) {
        
        var targetId= event.target.getAttribute('id'); 
        console.log('TargetId : '+ targetId);
        if(targetId=="name0" || targetId=="icon0" || targetId=="section0"){
            this.showHideSection(component,"icon0","section0Content");
        }else if(targetId=="name1" || targetId=="icon1" || targetId=="section1"){
            this.showHideSection(component,"icon1","section1Content");
        }else if(targetId=="name2" || targetId=="icon2" || targetId=="section2"){
            this.showHideSection(component,"icon2","section2Content");
        }else if(targetId=="name3" || targetId=="icon3" || targetId=="section3"){
            this.showHideSection(component,"icon3","section3Content");
        }else if(targetId=="name4" || targetId=="icon4" || targetId=="section4"){
            this.showHideSection(component,"icon4","section4Content");
        }else if(targetId=="name3" || targetId=="icon5" || targetId=="section5"){
            this.showHideSection(component,"icon5","section5Content");
        }else if(targetId=="subname0" || targetId=="subicon0" || targetId=="subsection0"){
            this.showHideSubSection(component,"subicon0","subsection0Content")
        }else if(targetId=="subname1" || targetId=="subicon1" || targetId=="subsection1"){
            this.showHideSubSection(component,"subicon1","subsection1Content")
        }
            else if(targetId=="subname2" || targetId=="subicon2" || targetId=="subsection2"){
                this.showHideSubSection(component,"subicon2","subsection2Content")
            }
                else if(targetId=="subname3" || targetId=="subicon3" || targetId=="subsection3"){
                    this.showHideSubSection(component,"subicon3","subsection3Content")
                }
                    else if(targetId=="subname4" || targetId=="subicon4" || targetId=="subsection4"){
                        this.showHideSubSection(component,"subicon4","subsection4Content")
                    }
                        else if(targetId=="subname5" || targetId=="subicon5" || targetId=="subsection5"){
                            this.showHideSubSection(component,"subicon5","subsection5Content")
                        }
                            else if(targetId=="subname6" || targetId=="subicon6" || targetId=="subsection6"){
                                this.showHideSubSection(component,"subicon6","subsection6Content")
                            }
                                else if(targetId=="subname7" || targetId=="subicon7" || targetId=="subsection7"){
                                    this.showHideSubSection(component,"subicon7","subsection7Content")
                                }
    },
    showHideSection: function(component,iconId,sectionId){
        var i;
        //var length = 3;
        var countOfAccordian= component.get('v.countAccordian');
        
        for(i=0 ; i<countOfAccordian ; i++){ 
            var icon = 'icon'+i;
            var section = 'section'+i+'Content';
            console.log('icon : '+ iconId);
            if(icon == iconId)
            {
                var x = document.getElementById(icon).innerHTML;
                if(x =="[-]")
                    document.getElementById(icon).innerHTML = "[+]"; 
                else
                    document.getElementById(icon).innerHTML = "[-]";    	
            }else
            {
                document.getElementById(icon).innerHTML = "[+]";
            }
            console.log('section'+section+'--'+sectionId);
            if(section == sectionId){
                if(document.getElementById(section).style.display == 'none')
                    document.getElementById(section).style = "display:block"; 
                else
                    document.getElementById(section).style = "display:none"; 
            }
            else
                document.getElementById(section).style = "display:none";  
        }
    },
    showHideSubSection: function(component,iconId,sectionId){
        var i;
        var countOfAccordian= component.get('v.countAccordian');
        for(i=0 ; i<countOfAccordian ; i++){ 
            var icon = 'subicon'+i;
            var section = 'subsection'+i+'Content';
            console.log('icon : '+ icon);
            if(icon == iconId)
            {
                var x = document.getElementById(icon).innerHTML;
                if(x =="[-]")
                    document.getElementById(icon).innerHTML = "[+]"; 
                else
                    document.getElementById(icon).innerHTML = "[-]";    	
            }else
            {
                document.getElementById(icon).innerHTML = "[+]";
            }
            console.log('section'+section+'--'+sectionId);
            if(section == sectionId){
                //console.log('style is'+document.getElementById(section).style.display);
                if(document.getElementById(section).style.display == 'none')
                    document.getElementById(section).style = "display:block"; 
                else
                    document.getElementById(section).style = "display:none"; 
            }
            else
                document.getElementById(section).style = "display:none"; 
        }
    }
})