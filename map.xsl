<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt">

    <xsl:key name="assets_by_zone" match="/data/z_as/z_a" use="@zone_id"/>
    <xsl:key name="asset_by_id" match="/data/assets/asset" use="@asset_id"/>
    <xsl:key name="zone_by_id" match="/data/zones/zone" use="@zone_id"/>
    <xsl:key name="zone_type_by_id" match="/data/zone_types/zone_type" use="@zone_type_id"/>
    <xsl:key name="assets_by_type_id" match="/data/assets/asset" use="@asset_type_id"/>
    <xsl:key name="asset_type_by_id" match="/data/asset_types/asset_type" use="@asset_type_id"/>
    
    <xsl:template match="data">
        <xsl:variable name="curr_section" select="@curr_section" />
        <xsl:choose>
            <xsl:when test="@curr_section='T1'">
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
                <div style="position:absolute;top:0px;left:0px;">
                  <xsl:call-template name="breadcrumbs">
                    <xsl:with-param name="ZONE" select="$CURRZONE" />
                  </xsl:call-template>
                </div>
                <div id="divMap" isLeft="500" style="position:absolute;top:75px;left:0px;width:940px;clear:left;height:840px;overflow:scroll;border:0px solid gray;">
                    <div id="divMapActual" style="width:{$CURRMAP/@width}px;height:{$CURRMAP/@height}px;background:url('images/maps/{$CURRMAP/@background}');border:1px solid gray;">
                        <xsl:if test="not($CURRZONE)">No zone is selected</xsl:if>
                        <xsl:if test="not($CURRMAP)">No map</xsl:if>
                        <xsl:for-each select="/data/zones/zone[@map_id=$CURRMAP/@map_id]">
                          <xsl:variable name="ZONE" select="." />
                          <xsl:variable name="ZONE_TYPE" select="key('zone_type_by_id', $ZONE/@zone_type_id)" />
                          <xsl:choose>
                            <xsl:when test="$ZONE_TYPE/@name='Battlefield'">
                              <div onclick="game.selectItem('zone', {$ZONE/@zone_id});" class="mapZone" style="left:{@x}px;top:{@y}px;width:{@width}px;height:{@height}px;">
                                <xsl:value-of select="$ZONE/@name"/>
                              </div>
                            </xsl:when>
                            <xsl:otherwise>
                              <div onclick="game.selectItem('zone', {@zone_id});" class="zone" style="cursor:hand;position:absolute;left:{@x - 12}px;top:{@y - 12}px;">
                                <xsl:if test="$ZONE_TYPE/@icon">
                                  <img src="images/zones/{$ZONE_TYPE/@icon}" style="height:24px;width:24px;float:left;"/>
                                </xsl:if>
                                <div style="margin-left:24px;background: rgba(255, 255, 255, 0.6);border:1px solid gray;">
                                  <div style="opacity:1.0;white-space:nowrap;color:black;">
                                    <xsl:value-of select="@name"/>
                                  </div>
                                </div>
                              </div>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                    </div>
                  <div>
                    <xsl:if test="not(/data[@hide_assets=1])">
                      <xsl:call-template name="mapAssets">
                        <xsl:with-param name="ZONE" select="." />
                        <xsl:with-param name="MAP" select="$CURRMAP" />
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="not(/data[@hide_messages=1])">
                      <xsl:call-template name="mapMessages">
                        <xsl:with-param name="ZONE" select="." />
                        <xsl:with-param name="MAP" select="$CURRMAP" />
                      </xsl:call-template>
                    </xsl:if>
                  </div>
                </div>

                <div style="position:absolute;top:610px;left:0px;" class="debug">
                    <xsl:choose>
                        <xsl:when test="not($CURRZONE/@name)">NO CURRZONE (/data/zones/zone[@zone_id=$selected_zone_id]) $selected_zone_id=<xsl:value-of select="$selected_zone_id"/>
                    </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$CURRMAP/@name"/>CURRMAP (ID:<xsl:value-of select="$CURRZONE/@map_id" />) for <xsl:value-of select="$CURRZONE/@name"/> zone.
                            X:<xsl:value-of select="$CURRMAP/@x"/> to <xsl:value-of select="$CURRMAP/@x + $CURRMAP/@width" /> Y:<xsl:value-of select="$CURRMAP/@y" /> to <xsl:value-of select="$CURRMAP/@y + $CURRMAP/@height"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    Faction:<xsl:value-of select="/data/@user_faction_id" />
                    Command:<xsl:value-of select="/data/@user_command_id" />
                </div>
                <div id="divMapOptions" style="position:absolute;top:20px;left:20px;width:200px;height:44px;background:white;border:1px solid black;display:none;">
                    <div style="width:40px;height:40px;float:left;border:1px solid black;cursor:hand;" onclick="toggleVisibility('assets');">Assets</div>
                    <div style="width:40px;height:40px;float:left;border:1px solid black;cursor:hand;" onclick="toggleVisibility('zone_info');">Zone Info</div>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="mapAssets">
      <xsl:param name="MAP"></xsl:param>
      <xsl:for-each select="/data/asset_types/asset_type">
        <xsl:variable name="ASSET_TYPE" select="." />
        <xsl:for-each select="key('assets_by_type_id', @asset_type_id)[@x and @y and (@visibility &lt;= $MAP/@scale)]">
          
          <xsl:variable name="ASSET" select="." />
          <xsl:comment>
            <div style="position:absolute;left:{($ASSET/@x - $MAP/@left) * $MAP/@scale}px;top:{($ASSET/@y - $MAP/@top) * $MAP/@scale }px;height:16px;width:16px;border:1px solid white;">&#160;</div>
          </xsl:comment>
          <div onclick="game.selectItem('asset', {$ASSET/@asset_id});" style="cursor:pointer;float:left;position:absolute;left:{($ASSET/@x - $MAP/@x) * $MAP/@scale - 8}px;top:{($ASSET/@y - $MAP/@y) * $MAP/@scale - 8}px;">
            <img src="images/assets/{$ASSET/@asset_type_id}_16.png"/>
            <div style="margin-left:18px;margin-top:-12px;background: rgba(255, 255, 255, 0.6);border:1px solid gray;">
              <div style="opacity:1.0;white-space:nowrap;color:black;">
                <xsl:choose>
                  <xsl:when test="$ASSET/@name">
                    <xsl:value-of select="$ASSET/@name"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$ASSET_TYPE/@name"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </div>
          </div>
        </xsl:for-each>

      </xsl:for-each>
    </xsl:template>
  
  <xsl:template name="mapMessages">
    <xsl:param name="MAP"></xsl:param>
    <xsl:for-each select="/data/messages/message[@x &gt;= $MAP/@x and @x &lt;= ($MAP/@x + $MAP/@width) and @y &gt;= $MAP/@y and @y &lt;= ($MAP/@y + $MAP/@height) ]">
      <xsl:variable name="MESSAGE" select="." />
      <div class="message onmap" onclick="game.selectItem('message', {@message_id});" style="cursor:pointer;float:left;position:absolute;left:{($MESSAGE/@x - $MAP/@x) * $MAP/@scale - 8}px;top:{($MESSAGE/@y - $MAP/@y) * $MAP/@scale - 8}px;width:150px;">
        <xsl:value-of select="@content"/>
        <xsl:comment>
          <div class="debug">
            X:<xsl:value-of select="$MESSAGE/@x"/> Y:<xsl:value-of select="$MESSAGE/@y"/>
            left: <xsl:value-of select="($MESSAGE/@x - $MAP/@x) * $MAP/@scale - 8"  /> top: <xsl:value-of select="($MESSAGE/@y - $MAP/@y) * $MAP/@scale - 8"/>
          </div>
        </xsl:comment>
      </div>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="breadcrumbs">
    <xsl:param name="ZONE" />
    <div style="width:64px;height:64px;border:1px solid gray;float:right;margin:5px;" onclick="game.selectItem('zone', {$ZONE/@zone_id});"><xsl:value-of select="$ZONE/@name"/></div>
    <xsl:if test="$ZONE/@parent_zone_id &gt; 0">
      <xsl:call-template name="breadcrumbs">
        <xsl:with-param name="ZONE" select="key('zone_by_id', $ZONE/@parent_zone_id)" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
    

</xsl:stylesheet>