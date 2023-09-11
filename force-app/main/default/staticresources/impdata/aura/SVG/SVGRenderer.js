({
	/*
    *   @description	: 	Method is called when the component is rendered. 
    * 						This method sets the path to SVG icon using xlinkHref.
    *   @version		: 	1.0
    */
    render : function(component, helper) {
		// Grab attributes from the component markup
		var classname = component.get("v.class");
		var xlinkhref = component.get("v.xlinkHref");
		var ariaHidden = component.get("v.aria-hidden");
 
		// Return an svg element with the attributes
		var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
		svg.setAttribute("class", classname);
		svg.setAttribute("aria-hidden", ariaHidden);
		svg.innerHTML = '<use xlink:href="' + xlinkhref + '"></use>';
		return svg;
	}
})