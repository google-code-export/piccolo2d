// convert all characters to lowercase to simplify testing
var agt=navigator.userAgent.toLowerCase();
is_ie = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1))

ns4 = (document.layers)? true:false
ie4 = (document.all)? true:false
ns7 = (document.getElementById)? true:false

// This method is used to swap two types of content (like tabs in a tabbed pane)
// by hiding all sections with the hideName, showing all sections with the showName,
// unselecting links with the unselLinkName and selecting links with the selLinkName.
function swapSections(hideName, showName, unselLinkName, selLinkName) {
	hideShow(hideName, showName);
	unselectSelectLinks(unselLinkName, selLinkName);
}

function hideShow(hideName, showName) {
    hideAll(hideName);
    showAll(showName);
}

function getStyleObject(name) {
    var o;
    if (ie4) {
       if (typeof eval("document.all." + name) == "object") {
	      o = eval("document.all." + name + ".style");
	   }	  
    } else {
       if (ns4) {
           if (typeof eval("document.layers." + name) == "object") {
	          o = eval("document.layers." + name + ".style");
   	       }	  
       }
       else {
           if (document.getElementById(name) != null) {
 	          o = document.getElementById(name).style;
	       }
	   }
    }
    return o; 
}

function showAll(showName) {
    var i = 0;
    var obj = getStyleObject(showName + i);
    while ((typeof obj) == "object") {
 	   obj.visibility = "visible";
 	   
 	   // Uncomment these two lines to have code snippets change size
 	   // var parent = getStyleObject("snippet" + i);
 	   // parent.height = obj.height;
 	   
 	   i++;
	   obj = getStyleObject(showName + i);
    }
}

function hideAll(hideName) {
    var i = 0;
    var obj = getStyleObject(hideName + i);
    
    while ((typeof obj) == "object") {
	    obj.visibility = "hidden";
	    i++;
	    obj = getStyleObject(hideName + i);
    }
}

function unselectSelectLinks(unselLinkName, selLinkName) {
	unselectLinks(unselLinkName);
	selectLinks(selLinkName);
}

function selectLinks(selLinkName) {
    var i = 0;
    var obj = getStyleObject(selLinkName + i);
    while ((typeof obj) == "object") {
 	   obj.color = "#000000";
 	   obj.textDecoration = "none";
 	    	   
 	   i++;
	   obj = getStyleObject(selLinkName + i);
    }
}

function unselectLinks(unselLinkName) {
    var i = 0;
    var obj = getStyleObject(unselLinkName + i);
    while ((typeof obj) == "object") {
 	   obj.color = "#0000FF";
   	   obj.textDecoration = "underline";
   	   
 	   i++;
	   obj = getStyleObject(unselLinkName + i);
    }
}

function resizeDivs() {
   if (is_ie) {
      resizeDiv('java');
      resizeDiv('csharp');
      resizeDiv('snippet');
      
      resizeDiv('o_snippet');
      resizeDiv('o_java');
      resizeDiv('o_csharp');
   }
}

function resizeDiv(divName) {
    var i = 0;
    var obj = getStyleObject(divName + i);
    while ((typeof obj) == "object") {
       obj.pixelHeight = (obj.pixelHeight-20);
 	    	   
	   i++;
	   obj = getStyleObject(divName + i);
   }
}
