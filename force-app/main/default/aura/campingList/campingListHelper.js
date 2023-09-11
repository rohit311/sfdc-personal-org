({
	createItem : function(component,newCitem) {
		// var newCitem=component.get("v.newItem");
            //helper.createCampingItem(component,newCitem);
            
           
        
        //var newItem=JSON.parse(JSON.stringify(newCitem));
        
        
       
            
         //saving data to salesforce
         var action=component.get("c.saveItem");   
            action.setParams({
                "cItem":newCitem
            });
            
            action.setCallback(this,function(response){
                var state=response.getState();
                
                if(component.isValid() && state==="SUCCESS")
                {
                     var Clist=component.get("v.items");
                    Clist.push(response.getReturnValue());
                     component.set("v.items",Clist);
				}
                
            });   
            
        
	},
    
    validation: function(component){
        var validName=true;
        var validQuantity=true;
        var validPrice=true;
        
        var nameField=component.find("cName");
        var cNameVal=nameField.get("v.value");
        
        var QuantityField=component.find("cQuantity");
        var cQuantityVal=QuantityField.get("v.value");
        
        var PriceField=component.find("cCurrency");
        var cPriceVal=QuantityField.get("v.value");
        
        if($A.util.isEmpty(cNameVal)){
            validName=false;
            nameField.set("v.errors",[{message:"Name field cannot be blank."}]);
        }
        else
        {
            nameField.set("v.errors",null);
		}
        
        if($A.util.isEmpty(cQuantityVal)){
            validQuantity=false;
            QuantityField.set("v.errors",[{message:"Quantity field cannot be blank."}]);
        }
        else
        {
            QuantityField.set("v.errors",null);
		}
        
        if($A.util.isEmpty(cPriceVal)){
            validPrice=false;
            PriceField.set("v.errors",[{message:"Price field cannot be blank."}]);
        }
        else
        {
            PriceField.set("v.errors",null);
		}
        
        return validName && validQuantity && validPrice;
    }
})