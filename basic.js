//translates IE XML handline
if (!window.ActiveXObject) {
    Element.prototype.selectNodes = function(sXPath) {
        var oEvaluator = new XPathEvaluator();
        var oResult = oEvaluator.evaluate(sXPath, this, null, XPathResult.ORDERED_NODE_ITERATOR_TYPE, null);
        var aNodes = new Array();

        if (oResult != null) {
            var oElement = oResult.iterateNext();
            while(oElement) {
            aNodes.push(oElement);
            oElement = oResult.iterateNext();
            }
        }
        return aNodes;
    }

    Element.prototype.selectSingleNode = function(sXPath) {
        var oEvaluator = new XPathEvaluator();

          // FIRST_ORDERED_NODE_TYPE returns the first match to the xpath.
        var oResult = oEvaluator.evaluate(sXPath, this, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
        if (oResult != null) {
            return oResult.singleNodeValue;
        } else {
            return null;
        }              
    }
}

Element.prototype.addChild = function (strNodeName) {
    var parentNode = this;
    var nodeNew = parentNode.ownerDocument.createElement(strNodeName);
    parentNode.appendChild(nodeNew);
    return nodeNew;
}

function loadXMLDoc(dname) {
    if (window.XMLHttpRequest)
      {
      xhttp=new XMLHttpRequest();
      }
    else
      {
      xhttp=new ActiveXObject("Microsoft.XMLHTTP");
      }
    xhttp.open("GET",dname,false);
    xhttp.send("");
    return xhttp.responseXML;
}

function XSLtransform(xml, xsl) {
    var xmlDoc;
   // debugger
    // code for IE
    if (window.ActiveXObject) {
        ex = xml.transformNode(xsl);
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = false;
        xmlDoc.loadXML(ex);
        return xmlDoc;
    }
    // code for Mozilla, Firefox, Opera, etc.
    else if (document.implementation && document.implementation.createDocument) {
        xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(xsl);
        resultDocument = xsltProcessor.transformToDocument(xml, document);
        return resultDocument;
    }
}
/*
function parseXML(strXML) {
    var xmlDoc
//    alert(strXML);
    if (window.DOMParser) {
        alert('parse1');
        parser = new DOMParser();
        xmlDoc = parser.parseFromString(strXML, "text/xml");
    }
    else // Internet Explorer
    {
        alert('parse2');
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = false;
        xmlDoc.loadXML(strXML);
    }
    //document.getElementById("txtDebug").text=xmlDoc
    return xmlDoc;
}
*/
function displayResult(xml, xsl, strElementName) {
//            xml=loadXMLDoc(strXMLfileName);
//            xsl=loadXMLDoc(strXSLfileName);
    // code for IE
    if (window.ActiveXObject)
      {
      ex=xml.transformNode(xsl);
      document.getElementById(strElementName).innerHTML=ex;
      }
    // code for Mozilla, Firefox, Opera, etc.
    else if (document.implementation && document.implementation.createDocument)
      {
      xsltProcessor=new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl);
      resultDocument = xsltProcessor.transformToFragment(xml,document);
      document.getElementById(strElementName).innerHTML='';
     // alert(resultDocument);
      //alert(xml);
      //alert(xsl);
      document.getElementById(strElementName).appendChild(resultDocument);
      //alert('insertBefore');document.getElementById(strElementName).insertBefore(resultDocument);

      }
}

function getQuerystring(key, default_) {
    if (default_ == null) default_ = "";
    key = key.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + key + "=([^&#]*)");
    var qs = regex.exec(window.location.href);
    if (qs == null)
        return default_;
    else
        return qs[1];
}

function rememberElementPosition(strElementName) {
    var ele = document.all(strElementName);

    if (ele) {
        var node = xmlTemp.firstChild.selectSingleNode("/data/positions/element[@ID='" + strElementName + "']");
        if (node) {
            node.setAttribute("scrollLeft", ele.scrollLeft);
            node.setAttribute("scrollTop", ele.scrollTop);
        }
    }
}

function reinstateElementPosition(strElementName) {
    var ele = document.all(strElementName);
    if (ele) {
        var node = xmlTemp.firstChild.selectSingleNode("/data/positions/element[@ID='" + strElementName + "' and @scrollLeft and @scrollTop]");
        if (node) {
            ele.scrollLeft = node.getAttribute("scrollLeft");
            ele.scrollTop = node.getAttribute("scrollTop");
        }
    }
}

function copyAllChildren(xmlSource, xmlTarget) {
    var nodeTarget = xmlTarget.firstChild;
    var nodeSource = xmlSource.firstChild;
    //if xml node, take next one
    if (nodeSource.nodeTypeString == 'processinginstruction') {
        nodeSource = xmlSource.childNodes[1];
    }
    var a = nodeSource.selectNodes("*");
    for (var i = 0; i < a.length; i++) {
        nodeTarget.appendChild(a[i]);
    }
}
function postXML(strURL, strXML) {
    $.ajax({
        url: "receiver.php",
        type: 'POST',
        data: strXML,
        dataType: "xml",
        processData: false,
        cache: false,
        error: function () { alert("No data found."); },
        success: function (xml) {
            return xml;
            //alert(xml.firstChild.getAttribute("result"));
            //  alert($(xml).find("project")[0].attr("id"));
        }
    });
}

function postXML1(strURL) {
    var str = '<?xml version="1.0" encoding="UTF-8"?><foo><bar>Hello World</bar></foo>';
    $.ajax({
        url: "receiver.php",
        type: 'POST',
        data: str,
        dataType: "xml",
        processData: false,
        cache: false,
        error: function () { alert("No data found."); },
        success: function (xml) {
            alert("it works");
          //  alert($(xml).find("project")[0].attr("id"));
        }
    });
}
function postXML2(strURL) {
    $.ajax({
        url: strURL,
        type: 'GET',
        dataType: 'xml',
        success: function (data) {
            alert(data);
        }
    });
}

function cancelBubble(e) {
    var evt = e ? e : window.event;
    if (evt.stopPropagation) evt.stopPropagation();
    if (evt.cancelBubble != null) evt.cancelBubble = true;
}
