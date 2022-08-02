//content script
var clickedEl = null;

document.addEventListener("mousedown", function(event){
    //right click
    if(event.button == 2) { 
        clickedEl = event.target;
    }
}, true);

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    if(request == "getClickedEl") {
        sendResponse(clickedEl);
    } else if (request == 'transformElement90') {
        clickedEl.setAttribute('style', '-webkit-transform: rotate(90deg)');
    } else if (request == 'transformElement180') {
        clickedEl.setAttribute('style', '-webkit-transform: rotate(180deg)');
    } else if (request == 'transformElement270') {
        clickedEl.setAttribute('style', '-webkit-transform: rotate(270deg)');
    } else if (request == 'transformElement0') {
        clickedEl.setAttribute('style', '-webkit-transform: rotate(0deg)');
    }
});
