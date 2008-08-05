    //Default browsercheck, added to all scripts!
    function checkBrowser(){
        this.ver=navigator.appVersion
        this.dom=document.getElementById?1:0
        this.ie5=(this.ver.indexOf("MSIE 5")>-1 && this.dom)?1:0;
        this.ie4=(document.all && !this.dom)?1:0;
        this.ns5=(this.dom && parseInt(this.ver) >= 5) ?1:0;
        this.ns4=(document.layers && !this.dom)?1:0;
        this.bw=(this.ie5 || this.ie4 || this.ns4 || this.ns5)
        return this
    }

    bw=new checkBrowser()

    //With nested layers for netscape, this function hides the layer if it's visible and visa versa
    function showHide(div,nest){
        obj=bw.dom?document.getElementById(div).style:bw.ie4?document.all[div].style:bw.ns4?nest?document[nest].document[div]:document[div]:0; 
        if(obj.visibility=='visible' || obj.visibility=='show') obj.visibility='hidden'
        else obj.visibility='visible'
    }

    //Shows the div
    function show(div,nest){
        obj=bw.dom?document.getElementById(div).style:bw.ie4?document.all[div].style:bw.ns4?nest?document[nest].document[div]:document[div]:0; 
        obj.visibility='visible'
    }

    //Hides the div
    function hide(div,nest){
        obj=bw.dom?document.getElementById(div).style:bw.ie4?document.all[div].style:bw.ns4?nest?document[nest].document[div]:document[div]:0; 
        obj.visibility='hidden'
    }

    //Shows the div
    function large(div,nest){
        obj=bw.dom?document.getElementById(div).style:bw.ie4?document.all[div].style:bw.ns4?nest?document[nest].document[div]:document[div]:0; 
        obj.color='red'
    }

    //Hides the div
    function small(div,nest){
        obj=bw.dom?document.getElementById(div).style:bw.ie4?document.all[div].style:bw.ns4?nest?document[nest].document[div]:document[div]:0; 
        obj.color='black'
    }

