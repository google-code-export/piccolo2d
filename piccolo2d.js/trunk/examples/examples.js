/*
Copyright (c) 2008-2009, Piccolo2D project, http://piccolo2d.org
Copyright (c) 1998-2008, University of Maryland
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided
that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions
and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions
and the following disclaimer in the documentation and/or other materials provided with the
distribution.

None of the name of the University of Maryland, the name of the Piccolo2D project, or the names of its
contributors may be used to endorse or promote products derived from this software without specific
prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

//This file is used by the examples for common tasks like counting total number of nodes in a scene, etc.
        
// To deal with the case where firebug's console is not available'
if (typeof console === "undefined") {
    console = {log: function() {}};
}

function randomCSSColor() {
  var r = Math.round(Math.random()*255);
  var g = Math.round(Math.random()*255);
  var b = Math.round(Math.random()*255);
  
  return "rgb(" + r + "," + g + "," + b + ")";
}

$(function() {
    function countNodes(node) {
       var result = 1;
       
       for (var i=0; i<node.children.length; i++) {
         result += countNodes(node.children[i]);
       }
       
       return result;
    }
    
    var nodeCount = countNodes(pCanvas.camera.layers[0]);
    
    $("#totalNodeCount").text(nodeCount);
    $("<h2>Example's Source Code</h2>").appendTo($("#container"));
    $("<pre name='code' class='javascript'>&nbsp;</pre>").html($("#example").html().replace("<", "&lt;").replace(">", "&gt;")).appendTo($("#container"));
    $('<link href="sh/css/SyntaxHighlighter.css" rel="stylesheet" type="text/css">').appendTo($("head"));
    $('<script type="text/javascript" src="sh/js/shCore.js"></script><script type="text/javascript" src="sh/js/shBrushJScript.js"></script>').appendTo($("body"));    
    dp.SyntaxHighlighter.ClipboardSwf = '/flash/clipboard.swf';
    dp.SyntaxHighlighter.HighlightAll('code');

});
