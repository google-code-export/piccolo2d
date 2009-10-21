// convert all characters to lowercase to simplify testing
var agt=navigator.userAgent.toLowerCase();

// *** BROWSER VERSION ***
// Note: On IE5, these return 4, so use is_ie5up to detect IE5.
var is_major = parseInt(navigator.appVersion);

var is_mac    = (agt.indexOf("mac")!=-1);
var is_ie     = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));
var is_ie3    = (is_ie && (is_major < 4));
var is_ie4    = (is_ie && (is_major == 4) && (agt.indexOf("msie 4")!=-1) );
var is_ie4up  = (is_ie && (is_major >= 4));
var is_ie5    = (is_ie && (is_major == 4) && (agt.indexOf("msie 5.0")!=-1) );
var is_ie5_5  = (is_ie && (is_major == 4) && (agt.indexOf("msie 5.5") !=-1));
var is_ie5up  = (is_ie && !is_ie3 && !is_ie4);
var is_ie5_5up =(is_ie && !is_ie3 && !is_ie4 && !is_ie5);
var is_ie6    = (is_ie && (is_major == 4) && (agt.indexOf("msie 6.")!=-1) );
var is_ie6up  = (is_ie && !is_ie3 && !is_ie4 && !is_ie5 && !is_ie5_5);
    
var is_DOTNET = false
var version = ""

var layers = (document.layers)? true:false
var all = (document.all)? true:false

if ((navigator.userAgent.indexOf(".NET CLR")>-1)) {
	is_DOTNET = true
	
	agentString = navigator.userAgent
	while ((index = agentString.indexOf(".NET CLR ")) != -1) {
		agentString = agentString.substring(index+9)
		version = agentString.substring(0,3)
		if (version == "1.1") break
	}
}

function getStyleObject(name) {
    var o;
    if (all) {
       if (typeof eval("document.all." + name) == "object") {
	      o = eval("document.all." + name + ".style");
	   }	  
    } else {
       if (layers) {
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

function showWarnings() {
	var warning = false;
	if (!is_ie5_5up) {
		var obj = getStyleObject('IE_Warning');
		obj.display = "inline";
		warning = true;
	}
	else if (!is_DOTNET) {
		var obj = getStyleObject('NET_Warning');
		obj.display = "inline";
		warning = true;
	} else if (version != "1.1") {
		var obj = getStyleObject('NET_Vsn_Warning');
		obj.display = "inline";
		
		warning = true;
	}
	
	if (warning) {
		var obj = getStyleObject('Applet');
		obj.display = "none";
	}
}