<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    <xsl:key name="assets_by_zone" match="/data/assets/asset" use="@zone_id"/>
    <xsl:key name="assettype_by_id" match="/data/asset_types/asset_type" use="@asset_type_id"/>
    <xsl:key name="assets_by_type" match="/data/assets/asset" use="@asset_type_id"/>
    <xsl:key name="asset_by_id" match="/data/assets/asset" use="@asset_id"/>
    <xsl:key name="ops_by_zone" match="/data/ops/op" use="@zone_id"/>
    <xsl:key name="op_by_id" match="/data/ops/op" use="@op_id"/>
    <xsl:key name="optype_by_id" match="/data/op_types/op_type" use="@op_type_id"/>
    <xsl:key name="zone_by_id" match="/data/zones/zone" use="@zone_id"/>
    
    <xsl:template match="/data">
        <dummy>
          <xsl:apply-templates select="zones" />
          <xsl:call-template name="command1" />
          <xsl:call-template name="zone1" />
        </dummy>
    </xsl:template>

    <xsl:template name="zone1">
      <xsl:for-each select="zones">
        <rec_zones>
          <xsl:for-each select="zone[not(@parent_zone_id)]">
            <xsl:call-template name="zone2" />
          </xsl:for-each>
        </rec_zones>
      </xsl:for-each>
    </xsl:template>

  <xsl:template name="zone2">
    <xsl:variable name="ZONE" select="." />
    <rec_zone zone_id="{$ZONE/@zone_id}" name="{$ZONE/@name}">
      <xsl:for-each select="/data/zones/zone[@parent_zone_id = $ZONE/@zone_id]">
        <xsl:call-template name="zone2" />
      </xsl:for-each>
    </rec_zone>
  </xsl:template>
  
    <xsl:template name="command1" match="commands">
        <rec_commands>
          <xsl:apply-templates select="command[not(@parent_command_id)]" />
        </rec_commands>
    </xsl:template>

    <xsl:template name="command2" match="command">
      <xsl:variable name="COMMAND" select="."/>
      <rec_command command_id="{$COMMAND/@command_id}" name="{$COMMAND/@name}">
        <xsl:apply-templates select="/data/commands/command[@parent_command_id = $COMMAND/@command_id]"/>
      </rec_command>  
    </xsl:template>
    
    <xsl:template match="zones">
        <rzones>
            <xsl:for-each select="zone">
                <rzone name="{@name}" zone_id="{@zone_id}" parent_zone_id="{@parent_zone_id}">
                    <xsl:variable name="ZONE" select="." />
                    <xsl:call-template name="zoneContents">
                        <xsl:with-param name="ZONE" select="$ZONE" />
                    </xsl:call-template>
                    <xsl:if test="$ZONE/@parent_zone_id &gt; 0">
                        <xsl:call-template name="zoneParents">
                            <xsl:with-param name="ZONE" select="key('zone_by_id', $ZONE/@parent_zone_id)" />
                        </xsl:call-template>
                    </xsl:if>
                </rzone>
            </xsl:for-each>
        </rzones>
    </xsl:template>

    <xsl:template name="zoneParents">
        <xsl:param name="ZONE" />
        <rczone zone_id="{$ZONE/@zone_id}" name="{$ZONE/@name}" type="inherited">
            <xsl:for-each select="key('ops_by_zone', $ZONE/@zone_id)">
                <xsl:variable name="OP" select="key('op_by_id', @op_id)" />
                <xsl:variable name="OPTYPE" select="key('optype_by_id', $OP/@op_type_id)" />
                <r_o op_id="{$OP/@op_id}" op_type_id="{$OP/@op_type_id}" quantity="{$OP/@quantity}" faction_id="{$OP/@faction_id}" real_zone_id="{$OP/@zone_id}"/>
            </xsl:for-each>
        </rczone>
        <xsl:if test="$ZONE/@parent_zone_id &gt; 0">
            <xsl:call-template name="zoneParents">
                <xsl:with-param name="ZONE" select="key('zone_by_id', $ZONE/@parent_zone_id)" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="zoneContents">
        <xsl:param name="ZONE" />
        <rczone zone_id="{$ZONE/@zone_id}" name="{$ZONE/@name}" type="includes">
            <xsl:if test="$ZONE/@population &gt; 0">
                <xsl:attribute name="population">
                    <xsl:value-of select="$ZONE/@population"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="key('assets_by_zone', $ZONE/@zone_id)">
                <xsl:variable name="ASSET" select="key('asset_by_id', @asset_id)" />
                <xsl:variable name="ASSETTYPE" select="key('assettype_by_id', $ASSET/@asset_type_id)" />
                <r_a type="{$ASSETTYPE/@name}" asset_id ="{$ASSET/@asset_id}" asset_type_id="{$ASSET/@asset_type_id}" quantity="{@quantity}" faction_id="{$ASSET/@faction_id}" />
            </xsl:for-each>
            <xsl:for-each select="key('ops_by_zone', $ZONE/@zone_id)">
                <xsl:variable name="OP" select="key('op_by_id', @op_id)" />
                <xsl:variable name="OPTYPE" select="key('optype_by_id', $OP/@op_type_id)" />
                <r_o op_type_id="{$OP/@op_type_id}" quantity="{$OP/@quantity}" faction_id="{$OP/@faction_id}" real_zone_id="{$OP/@zone_id}" />
            </xsl:for-each>
        </rczone>
        <xsl:for-each select="/data/zones/zone[@parent_zone_id=$ZONE/@zone_id]">
            <xsl:variable name="CHILDZONE" select="." />
            <xsl:call-template name="zoneContents">
                <xsl:with-param name="ZONE" select="$CHILDZONE" />
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>