function rotateElement(degrees){ 
    return function(info, tab){
        chrome.tabs.sendMessage(tab.id, "getClickedEl", function(clickedEl){
            chrome.tabs.sendMessage(tab.id, 'transformElement' + degrees)
        });
    }
}

function setUpContextMenus() {
    // add your context menu entry here
    chrome.contextMenus.create({
        id: "rotateRight",
        contexts: ['all'],
        title: 'Rotate 90 degrees clockwise',
        onclick: rotateElement(degrees=90)
    });

    chrome.contextMenus.create({
        id: "rotateLeft",
        contexts: ['all'],
        title: 'Rotate 90 degrees anti-clockwise',
        onclick: rotateElement(degrees=270)
    });
    
    chrome.contextMenus.create({
        id: "rotate180",
        contexts: ['all'],
        title: 'Rotate 180 degrees',
        onclick: rotateElement(degrees=180)
    });

    chrome.contextMenus.create({
        id: "rotate0",
        contexts: ['all'],
        title: 'Original rotation',
        onclick: rotateElement(degrees=0)
    });
}

setUpContextMenus();

