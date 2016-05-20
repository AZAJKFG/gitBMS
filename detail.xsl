<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    <xsl:key name="assets_by_type" match="/data/assets/asset" use="@asset_type_id"/>
    <xsl:key name="asset_by_id" match="/data/assets/asset" use="@asset_id"/>
    <xsl:key name="faction_by_id" match="/data/factions/faction" use="@faction_id"/>
    <xsl:key name="commands_by_faction" match="/data/commands/command" use="@faction_id"/>

    <xsl:key name="zone_by_id" match="/data/zones/zone" use="@zone_id"/>

    <xsl:variable name="SELECTEDFACTION" select="/data/factions/faction[@faction_id=/data/@selected_faction_id]" />
    
    <xsl:template match="data">
        <xsl:choose>
            <xsl:when test="/data[@curr_section='T2']">
                <xsl:call-template name="detailMessages" />
            </xsl:when>
            <xsl:when test="substring(/data/@curr_section, 1, 2)='T3'">
                <xsl:call-template name="detailFactions"/>
            </xsl:when>
            <xsl:when test="/data[@curr_section='T4']">
                <xsl:call-template name="detailZones" />
            </xsl:when>
            <xsl:when test="substring(/data/@curr_section, 1, 2)='T5'">
                <xsl:call-template name="detailAssets" />
            </xsl:when>

            <xsl:otherwise>
                No template found for section <xsl:value-of select="/data/@curr_section" />
                <xsl:call-template name="detailEvent" />
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    
    <xsl:template match="data2">
        
        <xsl:choose>
            <xsl:when test="/data[@detail='zone' or @detail='asset' or @detail='assettype']">
                <div class="popupBox div2">
                    <xsl:choose>
                        <xsl:when test="/data[@detail='zone']">
                            <xsl:call-template name="detailZone">
                                <xsl:with-param name="ZONE" select="/data/zones/zone[@zone_id=/data/@detail_id]" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="/data[@detail='asset']">
                            <xsl:call-template name="detailAsset">
                                <xsl:with-param name="ASSET" select="/data/assets/asset[@asset_id=/data/@detail_id]" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="/data[@detail='assettype']">
                            <xsl:call-template name="detailAssetType">
                                <xsl:with-param name="ASSETTYPE" select="/data/asset_types/asset_type[@asset_type_id=/data/@detail_id]" />
                                <xsl:with-param name="ZONE" select="key('zone_by_id', /data/@curr_z)" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                        Unrecognised detail section : <xsl:value-of select="/data/@detail"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>                
            </xsl:when>
            <xsl:otherwise>
                <div class="popupBackground">
                    <img src="images/controls/blank.png" class="ilg close" style="float:right;" onclick="closeDetail();"/>
                </div>
                <div class="popupBox">

                </div>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>
    
    <xsl:template name="factionButton">
        <xsl:param name="FACTION" />
        <img src="images/factions/{$FACTION/@faction_icon_id}_48.png" style="width:48px;height:48px;"/>
        <br/><xsl:value-of select="$FACTION/@abbreviation" />
    </xsl:template>

</xsl:stylesheet>