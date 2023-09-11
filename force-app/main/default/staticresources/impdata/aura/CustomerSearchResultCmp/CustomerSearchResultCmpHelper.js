({
	toggleDiv : function(divId) {
        var valdiv = document.getElementById(divId);
		if (valdiv.style.display === "none") {
    		valdiv.style.display = "block";
  		} else {
    		valdiv.style.display = "none";
  		}
	}
})