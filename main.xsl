<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    <xsl:key name="zone_by_id" match="/data/zones/zone" use="@zone_id"/>
    <xsl:key name="asset_by_id" match="/data/assets/asset" use="@asset_id"/>
    <xsl:key name="asset_type_by_id" match="/data/asset_types/asset_type" use="@asset_type_id"/>
    <xsl:key name="assets_by_zone_id" match="/data/assets/asset" use="@zone_id"/>
    <xsl:key name="assets_by_command_id" match="/data/assets/asset" use="@command_id"/>
    <xsl:key name="assets_by_parent_asset_id" match="/data/assets/asset" use="@parent_asset_id"/>
    <xsl:key name="command_by_id" match="/data/commands/command" use="@command_id"/>
    <xsl:key name="commands_by_faction_id" match="/data/commands/command" use="@faction_id"/>
    <xsl:key name="commands_by_zone_id" match="/data/commands/command" use="@zone_id"/>  
  
  <xsl:variable name="selected_zone_id">
    <xsl:choose>
      <xsl:when test="/data/@selected_zone_id">
        <xsl:value-of select="/data/@selected_zone_id"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="CURRZONE" select="/data/zones/zone[@zone_id=$selected_zone_id]" />
  <xsl:variable name="CURRMAP" select="/data/maps/map[@zone_id=$CURRZONE/@zone_id]" />
  <xsl:variable name="CURRCOMMAND" select="/data/commands/command[@command_id=/data/@selected_command_id]" />
  <xsl:variable name="selected_class" select="/data/@selected_class" />

  <xsl:template match="data">
 

    <xsl:variable name="curr_section" select="@curr_section" />
      <div style="position:absolute;top:0px;left:0px;width:100%">
        <div class="zoneBreadcrumbs">
          <xsl:call-template name="breadcrumbs">
            <xsl:with-param name="ZONE" select="$CURRZONE" />
          </xsl:call-template>
        </div>
        <div class="zoneOptions">
          <xsl:for-each select="/data/zones/zone[@parent_zone_id=1]">
            <xsl:sort select="@name"/>
            <div class="zoneOption" onclick="game.selectItem('zone', {@zone_id})">
              <xsl:attribute name="class">
                zoneOption
                <xsl:if test="@zone_id=$CURRZONE/@zone_id">selected</xsl:if>
              </xsl:attribute>
              <xsl:value-of select="@name"/>
            </div>
          </xsl:for-each>
        </div>        
      </div>
      <div class="navigationStrip">
        NAVIGATION STRIP      
      </div>
    <div class="mainArea">
      <xsl:choose>
        <xsl:when test="substring(/data/@curr_section, 1, 2)='T2'">
          <xsl:call-template name="mainMessages"/>
        </xsl:when>
        <xsl:when test="substring(/data/@curr_section, 1, 2)='T3'">
          <xsl:call-template name="mainForces">
            <xsl:with-param name="COMMAND" select="key('command_by_id', /data/@user_command_id)" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="/data[@curr_section='T7']">
          <xsl:call-template name="mainDebug" />
        </xsl:when>
        <xsl:otherwise>
          No template found for section <xsl:value-of select="/data/@curr_section" />
        </xsl:otherwise>
      </xsl:choose>
    </div>
    </xsl:template>
  
  <xsl:template name="breadcrumbs">
    <xsl:param name="ZONE" />
    <div style="width:64px;height:64px;border:1px solid gray;float:right;margin:5px;" onclick="game.selectItem('zone', {$ZONE/@zone_id});">
      <xsl:value-of select="$ZONE/@name"/>
    </div>
    
    <xsl:if test="$ZONE/@parent_zone_id &gt; 0">
      <xsl:call-template name="breadcrumbs">
        <xsl:with-param name="ZONE" select="key('zone_by_id', $ZONE/@parent_zone_id)" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="mainMessages">
    <div>
      <textarea id="txtMessage" rows="4" cols="50"></textarea>
      <img class="button" src="images/controls/go_48.png" style="cursor:pointer;" onclick="game.messages.send();"/>
    </div>
    <xsl:for-each select="/data/messages/message">
      <xsl:sort select="@message_id" order="descending"/>
      <xsl:variable name="MESSAGE" select="." />
      <div>
        <xsl:attribute name="class">message</xsl:attribute>
        <xsl:if test="@x">
          <img src="images/zones/map_pin.png" style="width:48px;height:48px;border:1px solid gray;" onclick="game.showMapPin({@message_id})" />
        </xsl:if>

        <xsl:variable name="FROMCOMMAND" select="/data/commands/command[@command_id=$MESSAGE/@from_command_id]" />
        <div>
          <div class="messagefrom">
            <xsl:value-of select="$FROMCOMMAND/@name"/>
          </div>
          <xsl:value-of select="@content"/>
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="mainForces">
    <xsl:param name="COMMAND" />
    <xsl:param name="faction_id" select="/data/@user_faction_id"/>
    <xsl:variable name="scale">
      <xsl:choose>
        <xsl:when test="$CURRZONE/@scale"><xsl:value-of select="$CURRZONE/@scale"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div style="" class="debug">
      Selected Class:<xsl:value-of select="$selected_class" />
      Faction:<xsl:value-of select="$faction_id" />
      Command:<xsl:value-of select="$COMMAND/@command_id" />
      Map:<xsl:value-of select="$CURRMAP/@map_id"/> Scale:<xsl:value-of select="$scale" />
      Zone:<xsl:value-of select="$CURRZONE/@zone_id"/>
    </div>
    
    <div class="commandList" style="float:left;width:350px;height:600px;">
      <xsl:variable name="root_command_id">
        <xsl:choose>
          <xsl:when test="$COMMAND/@parent_command_id"><xsl:value-of select="$COMMAND/@parent_command_id" /></xsl:when>
          <xsl:otherwise><xsl:value-of select="$COMMAND/@command_id" /></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:comment>
        Root:<xsl:value-of select="$root_command_id"/>  
      </xsl:comment>
      <xsl:choose>
        <xsl:when test="$selected_class='command'">
          <xsl:call-template name="commandSection">
            <xsl:with-param name="COMMAND" select="$CURRCOMMAND" />
            <xsl:with-param name="indent" select="0" />
          </xsl:call-template>          
        </xsl:when>
        <xsl:when test="$selected_class='zone'">
          Commands with assets in <xsl:value-of select="$CURRZONE/@name"/>
          <xsl:for-each select="/data/commands/command[(@command_id = key('assets_by_zone_id', $CURRZONE/@zone_id)/@command_id)]">
            <xsl:comment> or (@command_id = key('command_by_id', key('assets_by_zone_id', $CURRZONE/@zone_id)/@command_id)/@parent_command_id)</xsl:comment>
            <xsl:call-template name="commandSection">
              <xsl:with-param name="COMMAND" select="." />
              <xsl:with-param name="indent" select="0" />
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="commandSection">
            <xsl:with-param name="COMMAND" select="key('command_by_id', /data/@user_command_id)" />
            <xsl:with-param name="indent" select="0" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </div>
    
    <div class="assetList" style="float:left;width:500px;height:900px;overflow-y:scroll;">
      <xsl:choose>
        <xsl:when test="$selected_class='command'">
          Under control of <xsl:value-of select="$CURRCOMMAND/@name"/>
        </xsl:when>
        <xsl:when test="$selected_class='zone'">
          In <xsl:value-of select="$CURRZONE/@name"/>
          <xsl:for-each select="/data/commands/command[(@command_id = key('assets_by_zone_id', $CURRZONE/@zone_id)/@command_id)]">
            <xsl:variable name="command_id" select="@command_id" />
            <div class="command">
              <xsl:value-of select="@name"/>
            </div>
            <xsl:for-each select="/data/assets/asset[@zone_id=$CURRZONE/@zone_id and @command_id=$command_id]">
              <xsl:call-template name="assetListItem">
                <xsl:with-param name="ZONE" select="$CURRZONE" ></xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
      
    </div>      
  </xsl:template>
  
  <xsl:template name="commandSection">
    <xsl:param name="COMMAND" />
    <xsl:param name="faction_id" select="/data/@user_faction_id"/>
    <xsl:param name="indent" />

    <xsl:if test="$indent=0 and $selected_class='command'">
      <xsl:if test="$COMMAND/@parent_command_id">
        <xsl:call-template name="commandSingle">
          <xsl:with-param name="COMMAND" select="key('command_by_id', $COMMAND/@parent_command_id) " />
          <xsl:with-param name="indent" select="$indent" />
        </xsl:call-template>
      </xsl:if>
    </xsl:if>

    <xsl:call-template name="commandSingle">
      <xsl:with-param name="COMMAND" select="$COMMAND" />
      <xsl:with-param name="indent" select="$indent" />
    </xsl:call-template>

    <xsl:if test="$selected_class='command'">
      <xsl:for-each select="/data/commands/command[(@parent_command_id - $COMMAND/@command_id) = 0]">
        <xsl:call-template name="commandSection">
          <xsl:with-param name="COMMAND" select="." />
          <xsl:with-param name="indent" select="$indent + 16" />
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="commandSingle">
    <xsl:param name="COMMAND" />
    <xsl:param name="indent" />
    
    <xsl:variable name="ZONE" select="key('zone_by_id', $COMMAND/@zone_id)" />
    
    <div style="margin-left:{$indent}px;" onclick="game.selectItem('command', {$COMMAND/@command_id});">
      <xsl:attribute name="class">
        command <xsl:if test="($COMMAND/@command_id - /data/@selected_command_id) = 0">selected</xsl:if>
      </xsl:attribute>

      <xsl:value-of select="$COMMAND/@name"/> &#160;(<xsl:value-of select="$ZONE/@name" />)
      <xsl:if test="$COMMAND/@command_id=key('command_by_id', /data/@user_command_id)/@parent_command_id">
        <div style="font-weight:bold;">(Your Commanding Officer)</div>
      </xsl:if>
      <xsl:if test="$COMMAND/@command_id=/data/@user_command_id">
        <div style="font-weight:bold;">(Your Command)</div>
      </xsl:if>
    </div>    
  </xsl:template>

  <xsl:template name="assetsForCommandInZone">
    <xsl:param name="COMMAND" />
    <xsl:param name="ZONE" />

    <xsl:apply-templates select="key('assets_by_command_id', $COMMAND/@command_id)[($CURRZONE/@scale - @visibility) &gt;= 0]">
      <xsl:with-param name="COMMAND" select="$COMMAND" />
      <xsl:sort select="@order_seq" data-type="number"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="asset" name="assetListItem">
    <xsl:param name="COMMAND" />
    <xsl:param name="ZONE" />
    
    <xsl:variable name="scale" select="$CURRZONE/@scale"/>
    
    <xsl:variable name="ASSET" select="." />
    <xsl:variable name="ASSET_TYPE" select="key('asset_type_by_id', $ASSET/@asset_type_id)" />
    <div>
      <xsl:attribute name="class">
        asset
        <xsl:if test="$ASSET_TYPE/@css_class">
          <xsl:value-of select="$ASSET_TYPE/@css_class"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:if test="$ASSET/@name">
        <xsl:value-of select="$ASSET/@name"/> -
      </xsl:if>
      <xsl:value-of select="$ASSET_TYPE/@name"/>

    </div>
    
    <div style="padding-left:16px;">
      <xsl:comment>
        CHILD ASSETS at scale <xsl:value-of select="$scale"/>
        [(($scale - @visibility) &gt;= 0) and ((@command_id = $COMMAND/@command_id) or not(@command_id))]

      </xsl:comment>
      <xsl:apply-templates select="key('assets_by_parent_asset_id', $ASSET/@asset_id)[($scale - @visibility &gt;= 0) and (@command_id=$ASSET/@command_id or not(@command_id))]">
        <xsl:with-param name="scale" select="$scale" />
        <xsl:with-param name="COMMAND" select="$COMMAND" />
        <xsl:sort select="@order_seq" data-type="number"/>
      </xsl:apply-templates>  
    </div>
  </xsl:template>
  
  <xsl:template name="mainDebug">
    <xsl:variable name="UPDATE" select="/data/update" />
    <table>
      <tr>
        <td>Time now</td>
        <td>
          <xsl:value-of select="$UPDATE/@time_now"/>
        </td>
      </tr>
      <tr>
        <td>Last Updated</td>
        <td>
          <xsl:value-of select="$UPDATE/@last_updated"/>
        </td>
      </tr>
      <tr>
        <td>Seconds elapsed</td>
        <td>
          <xsl:value-of select="$UPDATE/@seconds_elapsed"/>
        </td>
      </tr>
      <tr>
        <td>Changed last updated</td>
        <td>
          <xsl:value-of select="$UPDATE/@changed_last_updated"/>
        </td>
      </tr>
      <tr>
        <td>Selected Faction</td>
        <td>
          <xsl:value-of select="/data/@selected_faction_id"/>
        </td>
      </tr>
      <tr>
        <td>Selected Command</td>
        <td>
          <xsl:value-of select="/data/@selected_command_id"/>
        </td>
      </tr>
      <tr>
        <td>Selected Zone</td>
        <td>
          <xsl:value-of select="/data/@selected_zone_id"/>
        </td>
      </tr>
    </table>
    <xsl:comment>
      <xsl:for-each select="/data/rzones/rzone">
        <div>
          <xsl:value-of select="@name"/>
          <xsl:for-each select="rczone">
            <i>
              <xsl:value-of select="@name"/>:
            </i>
            <xsl:for-each select="r_a">
              <xsl:value-of select="@asset_id"/>,
            </xsl:for-each>
          </xsl:for-each>
        </div>
      </xsl:for-each>
      <xsl:for-each select="/data/rec_commands/rec_command">
        <xsl:call-template name="recursedCommands" />
      </xsl:for-each>     
    </xsl:comment>
    RZONES
    <xsl:for-each select="/data/rec_zones/rec_zone">
    ZONE:
    <xsl:call-template name="recursedZones" />
    <br/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="recursedCommands">
    <div style="border:1px solid gray:padding:6px;">
    <xsl:value-of select="@name"/>(<xsl:value-of select="count(rec_command)"/>)
    <xsl:for-each select="rec_command">
      <xsl:call-template name="recursedCommands" />
    </xsl:for-each>
    </div>
  </xsl:template>
  
  <xsl:template name="recursedZones">
    <div style="border:1px solid gray:padding:6px;">
      <xsl:value-of select="@name"/>(<xsl:value-of select="count(rec_zone)"/>)
      <xsl:for-each select="rec_zone">
        <xsl:call-template name="recursedZones" />
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>