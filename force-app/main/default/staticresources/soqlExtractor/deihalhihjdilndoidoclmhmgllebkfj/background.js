// @author Rajiv Bhatt rajiv.ashok.bhatt@gmail.com
// Date March 4, 2014
// version 0.0.1



// When the extension is installed or upgraded ...
chrome.runtime.onInstalled.addListener(function() {
  // Replace all rules ...
  chrome.declarativeContent.onPageChanged.removeRules(undefined, function() {
    // With a new rule ...
    chrome.declarativeContent.onPageChanged.addRules([
      {
        // That fires when a page's URL contains salesforce.com
        conditions: [
          new chrome.declarativeContent.PageStateMatcher({
            pageUrl: { urlContains: 'salesforce.com/p/setup/layout/ApexDebugLogDetailEdit/d' },
          })
        ],
        // And shows the extension's page action.
        actions: [ new chrome.declarativeContent.ShowPageAction() ]
      }
    ]);
  });
});

chrome.extension.onMessage.addListener(function(message, sender) {
    if (message && message.type === 'showPageAction') {
        var tab = sender.tab;
        chrome.pageAction.show(tab.id);
        chrome.pageAction.setTitle({
            tabId: tab.id,
            title: 'url=' + tab.url
        });
    }
});

