<?php
    require_once ('login.php');
?>
<html>
<head>
    <link REL="stylesheet" TYPE="text/css" HREF="coins.css">
    <script language="javascript" src="basic.js"></script>
    <script language="javascript" src="coins.js"></script>
    <script language="javascript" src="serverside.js"></script>
    <script language="javascript">
        var xslMain = loadXMLDoc("main.xsl");
        var xslMap = loadXMLDoc("map.xsl");
        var xslDetail = loadXMLDoc("detail.xsl");
        var xslRecurse = loadXMLDoc("recurse.xsl");
        var xslSetup = loadXMLDoc("setup.xsl");

        var xmlMain = loadXMLDoc("data.xml")
        var xmlTemp = loadXMLDoc("temp.xml")
        var xmlGame = loadXMLDoc("data_game.php")
        var xmlStatic = loadXMLDoc("data_static.php")

      //  alert(xmlStatic.firstChild.element.xml); can't seem to output whole of xml

        var game = new gameObject();

        function init() {
            //start();
            init();
        }

        function renderPage() {
            rememberElementPosition('divMap');
            displayResult(xmlMain, xslMain, "divMain");
            reinstateElementPosition('divMap');
        }

    </script>

</head>
<body onload="init();" style="margin:0 0 0 0;">
<div class="main" id="divMainT1">1</div>
<div class="main" id="divMainT2">2</div>
<div class="main" id="divMainT3">3</div>
<div class="main" id="divMainT4">4</div>
<div class="main" id="divMainT5">5</div>
<div class="main" id="divMainT6">6</div>
<div class="main" id="divMainT7">7</div>
<div id="divDetail" style="position:absolute;top:0px;left:0px;display:none;">
</div>
<div id="divDetail2" style="position:absolute;top:0px;left:0px;display:none;">
</div>
<div id="divPopup" style="position:absolute;top:0px;left:0px;display:none;">
</div>
<div id="divTopBar" class="sectionBar">
    <div class="mainbutton selected" onclick="selectSection('T1');" id="mainbutton1" >MAP</div>
    <div class="mainbutton" onclick="selectSection('T2');" id="mainbutton2" >NEWS</div>
    <div class="mainbutton" onclick="selectSection('T3');" id="mainbutton3" >FACTION</div>
    <div class="mainbutton" onclick="selectSection('T4');" id="mainbutton4" >ZONES</div>
    <div class="mainbutton" onclick="selectSection('T5');" id="mainbutton5" >ASSETS</div>
    <div class="mainbutton" onclick="selectSection('T6');" id="mainbutton6" >OPS</div>
    <div class="mainbutton" onclick="selectSection('T7');" id="mainbutton7" >DEBUG</div>
</div>
</body>
</html>