({
    displayMessage: function (component, toastid, messageid, message) {
        document.getElementById(toastid).style.display = "block";
		document.getElementById(messageid).innerHTML = message;
        console.log('message'+message);
		
		setTimeout(function () {
			document.getElementById(messageid).innerHTML = "";
			document.getElementById(toastid).style.display = "none";
		}, 5000);
	},
    closeToastnew: function (component) {
		document.getElementById('successmsgdis').innerHTML = "";
		document.getElementById('SuccessToastdis').style.display = "none";
	},
	closeToastError: function (component) {
		document.getElementById('errormsgdis').innerHTML = "";
		document.getElementById('ErrorToastdis').style.display = "none";
	},
})