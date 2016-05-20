/*
Next:
Filter assets by zone (show all commands, but collapsed?)
Filter messages by faction and zone
Draw icons for assets and commands.
Move breadcrumbs?
Get map pins properly working
Different message types and message queue
Get PHP working.
Get actions working:
- Send message
- Reassign asset
- Transfer asset
- Support fire
- Update unit status
*/
var game = (function () {
    //these appear as properties of game.
//    var privateCounter = 1;
    var isLocal
    //these are lower case to indicate there is a direct equivalent in XML
    var selected_section;
    var selected_main_section;
    var user_faction_id;
    var user_command_id;

    var module = {} //this is returned at end module.faction_id=game.faction_id=faction_id (for example), but only game.faction_id is visible outside function.
    var settings = {}
    var data = {}

    module.init = function () {
        copyAllChildren(xmlStatic, xmlMain);
        copyAllChildren(xmlGame, xmlMain);
        module.user_faction_id = xmlMain.firstChild.selectSingleNode("update").getAttribute("user_faction_id");
        module.user_command_id = xmlMain.firstChild.selectSingleNode("update").getAttribute("user_command_id");
        module.settings = xmlMain.firstChild;
        module.data = xmlMain.firstChild;
        module.settings.setAttribute("user_faction_id", module.user_faction_id);
        module.settings.setAttribute("user_command_id", module.user_command_id);
        module.settings.setAttribute("selected_faction_id", module.user_faction_id);
//        module.settings.setAttribute("selected_command_id", module.user_command_id);
        module.commands.select(module.user_command_id);

        module.isLocal = true;

        module.recurseData(xmlMain, xslRecurse);

        module.sections.select('T1');
        //module.additional = game.additional; //make sub-module part of main and accessible as module. not just game. //seems to be unnecessary
        //module.additional.test('newtest');
    }

    module.recurseData = function (xmlSource, xslRecurseTemplate) {
        //takes data, recurses specific nodes and copies them back into original
        var xmlRecursed = XSLtransform(xmlSource, xslRecurseTemplate);
        copyAllChildren(xmlRecursed, xmlSource);
    }

    module.selectItem = function (strType, strID, strSection) {
 //               alert('selected_' + strType + '_id set to ' + strID );
        //this does a basic select
        module.settings.setAttribute('selected_' + strType + '_id', strID);
        module.settings.setAttribute('selected_class', strType); //used to work out last context.

        if (strType == 'zone') {
            //change of context will mean any previously rendered divs are invalid
            module.sections.clearRendering();
        }

        if (strType == 'command') {
            module.commands.select(strID);
        }

        if (strSection) {
            //as well as selecting an item, alter the displayed section
            module.sections.select(strSection, true);
        } else {
            //otherwise just update current section
            module.sections.refresh();
//            alert('refresh');
        }
    }

    module.showMapPin = function (message_id) {
        var nodeMessage = xmlMain.firstChild.selectSingleNode("/data/messages/message[@message_id='" + message_id + "']");
        module.selectItem('message', message_id);
        module.selectItem('zone', nodeMessage.getAttribute("zone_id"), "T1");
    }

    module.selectSection = function (ID, forceRender) {
        alert('obsolete');
    }

    function privateModuleFunction() {
        alert('privateModuleFunction');
    }
    /*
    module.sections = {};
    module.sections.select = function(ID, forceRender){
        alert('select ' + ID);
    }
    */


    return module; //needs to go at end
})()


//Sections sub-module
game.sections = (function (ID) {
    var selectedSectionID
    var sectionsmodule = {};
    var module = game; //set to public parent object so can refer consistently

    sectionsmodule.select = function (ID, forceRender) {
        //alert('sectionsmodule.select: ' + ID);
        if (!ID) { alert('sectionsmodule.select needs an ID') }

        module.selected_section = ID;
 //       alert('module_selected_section:' + module.selected_section);
        module.selected_main_section = module.selected_section.substring(0, 2);
        module.settings.setAttribute("curr_section", ID);
        showSection(forceRender);
    }

    sectionsmodule.refresh = function () {
        renderSection();
    }

    sectionsmodule.clearRendering = function () {
        //marks that any previously rendered tabs will need a redraw
        var a = game.settings.selectNodes("sections/section");
        for (var i = 0; i < a.length; i++) {
            a[i].setAttribute("rendered", null);
        }
    }

    function showSection(forceRender) {
        for (var i = 1; i <= 7; i++) {
            var ele = document.all("mainbutton" + i)
            if (ele) {
                if ('T' + i == game.selected_main_section) {
                    ele.className = "mainbutton selected";
                } else {
                    ele.className = "mainbutton";
                }
            }
            var ele = document.all("divMainT" + i)
            if (ele) {
                if ('T' + i == game.selected_main_section) {
                    ele.style.display = '';
                    //not already rendered, or force, or debug
                    if (ele.children.length == 0 || forceRender || game.selected_main_section == 'T7') {
                        renderSection()
                    } else {
                        //if already rendered but not in section then re-render
                        if (!checkSectionRendered()) {
                            renderSection();
                        }
                    };
                } else {
                    ele.style.display = 'none';
                }
            }
        }
    }

    function renderSection() {
        // alert('render ' + game.selected_main_section);
        switch (game.selected_main_section) {
            case 'T1':
                displayResult(xmlMain, xslMap, "divMain" + game.selected_main_section);
                break;
            default:
                displayResult(xmlMain, xslMain, "divMain" + game.selected_main_section);
                break;
        }
        recordSectionRendered();
    }

    function checkSectionRendered() {
        //alert('check ' + game.selected_main_section);
        var nodeSection = game.settings.selectSingleNode("sections/section[@id='" + game.selected_main_section + "' and @rendered=1]");
        if (nodeSection) {
            return true;
        } else {
            return false;
        }
    }

    function recordSectionRendered() {
        var nodeSections = game.settings.selectSingleNode("sections");
        if (!nodeSections) {
            // alert('could not find sections');
            nodeSections = game.settings.addChild("sections");
        }

        var nodeSection = nodeSections.selectSingleNode("section[@id='" + game.selected_main_section + "']");
        if (!nodeSection) {
            // alert('could not find ' + game.selected_main_section);
            nodeSection = nodeSections.addChild("section");
            nodeSection.setAttribute("id", game.selected_main_section);
        }
        nodeSection.setAttribute("rendered", 1);
    }

    return sectionsmodule;
})();

//Commands sub-module
game.commands = (function (ID) {
    var selectedCommandID
    var commandsModule = {};
    var module = game; //set to public parent object so can refer consistently

    commandsModule.select = function (ID) {
        selectedCommandID = ID;
        if (ID) {
            module.settings.setAttribute("selected_command_id", ID);
            var zoneID = getCommandNode(ID).getAttribute("zone_id");
            if (zoneID) {
                //module.settings.setAttribute('selected_zone_id', zoneID);
                module.zones.select(zoneID);
            }
        } else {
            module.settings.setAttribute("selected_command_id", null);
        }
//        module.sections.refresh();
    }

    function getCommandNode(ID) {
        var nodeTemp = module.data.selectSingleNode("/data/commands/command[@command_id='" + ID + "']");
        return nodeTemp;
    }

    return commandsModule;
})();

//Messages sub-module
game.messages = (function (ID) {
    var messagesModule = {};
    var module = game; //set to public parent object so can refer consistently

    messagesModule.send = function () {
        alert('send message');
    }

    return messagesModule;
})();

//Zones sub-module
game.zones = (function (ID) {
    var zonesModule = {};
    var module = game; //set to public parent object so can refer consistently

    zonesModule.select = function (ID) {
        module.settings.setAttribute('selected_zone_id', ID);
        //change of context will mean any previously rendered divs are invalid
        module.sections.clearRendering();
    }

    return zonesModule;
})();

/*
//this works with limitation that can't access private bits of parent
game.additional = (function () {
    var submodule = {};
    var parentmodule = game.module; //still doesn't make private elements of parent visible
    submodule.test = function (ID) {
        alert('rendering ' + ID);
    }
   // game.renderSection();
    return submodule;
})();


var GameObject = function () {
    //var self = this;
    var user_faction_id;
    var user_command_id;
    var selected_section;
    var selected_main_section;
    var selected_second;
    var isLocal;
    var settings;
    var test

    return {
        init: function () {
            game.user_command_id = 9;
            alert(game.user_command_id);
            initialisePage();
        }

    }

    function initialisePage() {

        copyAllChildren(xmlStatic, xmlMain);
        copyAllChildren(xmlGame, xmlMain);
        game.user_faction_id = xmlMain.firstChild.selectSingleNode("update").getAttribute("user_faction_id");
        game.user_command_id = xmlMain.firstChild.selectSingleNode("update").getAttribute("user_command_id");

        game.isLocal = true;
        game.settings = xmlMain.firstChild;

        game.settings.setAttribute("user_faction_id", game.user_faction_id);
        game.settings.setAttribute("user_command_id", game.user_command_id);
        game.settings.setAttribute("selected_faction_id", game.user_faction_id);
        game.settings.setAttribute("selected_command_id", game.user_command_id);
        //xmlMain.firstChild.appendChild(xmlRules.firstChild);
        //xmlMain.firstChild.appendChild(xmlGame.firstChild);
        selectSection('T1');
    }





    function renderDetail() {
        var selectedDetail = xmlMain.firstChild.getAttribute("detail");

        if (selectedDetail == 'map') {
            document.all("divDetail").style.display = 'none';
            displayResult(xmlMain, xslMain, "divMain");
        } else {
            if (selectedDetail == 'zone' || selectedDetail == 'asset' || selectedDetail == 'assettype') {
                displayResult(xmlMain, xslDetail, "divDetail2");
                document.all("divDetail2").style.display = '';
            } else {
                displayResult(xmlMain, xslDetail, "divDetail");
                document.all("divDetail").style.display = '';
            }
        }
    }

    function selectDetail(strCode, strID, strZoneID) {

        game.settings.setAttribute("detail", strCode);
        //alert(xmlMain.firstChild.getAttribute("detail"));

        if (!strID) {
            if (strCode != 'zones' && strCode != 'map') {
                game.settings.removeAttribute("detail_id");
            }
        } else {
            game.settings.setAttribute("detail_id", strID);
        }

        renderDetail();
        cancelBubble();
    }









    function toggleVisibility(strType) {
        var currVis = xmlMain.firstChild.getAttribute("hide_" + strType);
        if (currVis == 1) {
            xmlMain.firstChild.setAttribute("hide_" + strType, 0);
        } else {
            xmlMain.firstChild.setAttribute("hide_" + strType, 1);
        }
        renderPage();
    }

    function closeDetail() {
        var e = document.all("divDetail2");
        if (e.style.display == '') {
            e.style.display = 'none';
        } else {
            var e = document.all("divDetail");
            if (e.style.display == '') {
                e.style.display = 'none';
            }
        }
    }

    function opSetup(zone_id, op_type_id) {
        alert('Setting up op in zone:' + zone_id + ' op_type:' + op_type_id);
        //   displayResult(xmlMain, xslSetup, "divSetup");
        document.all("divPopup").style.display = '';
        //    alert('Finished');
    }


    function sendMessage() {
        var strMessage = txtMessage.value;
        alert('Send: ' + strMessage);
    }
}
*/


