// @author Rajiv Bhatt rajiv.ashok.bhatt@gmail.com
// Date March 4, 2014
// version 0.0.1

chrome.extension.onMessage.addListener(function(request, sender) {
  if (request.action == "getSource") {
    myDiv.innerHTML = request.source;
	//document.getElementById("myDiv").innerHTML=outputHTML;
  }
});

function onWindowLoad() {

  var message = document.querySelector('#myDiv');

  chrome.tabs.executeScript(null, {
    file: "getPagesSource2.js"
  }, function() {
    // If you try and inject into an extensions page or the webstore/NTP you'll get an error
    if (chrome.extension.lastError) {
      message.innerText = 'There was an error Parsing the log file : \n' + chrome.extension.lastError.message;
    }
  });

}

window.onload = onWindowLoad;

