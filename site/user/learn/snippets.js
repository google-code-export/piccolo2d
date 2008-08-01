
// This method is used to swap two types of content (like tabs in a tabbed pane)
// by hiding all sections with the hideName, showing all sections with the showName,
// unselecting links with the unselLinkName and selecting links with the selLinkName.
function swapSections(hideName, showName, unselLinkName, selLinkName) {
	_setVisibilityAll(hideName, "hidden");
	_setVisibilityAll(showName, "visible");
	_setLinksSelectedAll(unselLinkName, false);
	_setLinksSelectedAll(selLinkName, true);
}

function _setVisibilityAll(objectBaseName, visibility) {
	for(var i = 0;;i++) {
		var obj = findObjectById(objectBaseName + i);
		if((typeof obj) != "object")
			break;
		obj.visibility = visibility;
		/*
		if(visibility == "visible") {
			var parent = getStyleObject("snippet" + i);
			parent.height = obj.height;
		}
		*/
	}
}

function _setLinksSelectedAll(objectBaseName, selected) {
	for(var i = 0;;i++) {
		var obj = findObjectById(objectBaseName + i);
		if((typeof obj) != "object")
			break;
		if(selected) {
			obj.color = "#000000";
			obj.textDecoration = "none";
		} else {
			obj.color = "#0000FF";
			obj.textDecoration = "underline";
		}
	}
}
/*
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

function resizeDiv(objectBaseName) {
	for(var i = 0;;i++) {
		var obj = findObjectById(objectBaseName + i);
		if((typeof obj) != "object")
			break;
		obj.pixelHeight = obj.pixelHeight - 20;
	}
}*/

///////////////////////////////////////////////////////////
// javascript basics (object lookup) //////////////////////
///////////////////////////////////////////////////////////

// convert all characters to lowercase to simplify testing
var agt=navigator.userAgent.toLowerCase();
is_ie = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1))

ns4 = (document.layers)? true:false
ie4 = (document.all)? true:false
ns7 = (document.getElementById)? true:false

// Helper to find the object for a given id
function findObjectById(name) {
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

