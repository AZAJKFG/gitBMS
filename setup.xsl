<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    <xsl:key name="assets_by_zone" match="/data/z_as/z_a" use="@zone_id"/>
    <xsl:key name="assettype_by_id" match="/data/asset_types/asset_type" use="@asset_type_id"/>
    <xsl:key name="assets_by_type" match="/data/assets/asset" use="@asset_type_id"/>
    <xsl:key name="asset_by_id" match="/data/assets/asset" use="@asset_id"/>
    <xsl:key name="ops_by_zone" match="/data/ops/op" use="@zone_id"/>
    <xsl:key name="op_by_id" match="/data/ops/op" use="@op_id"/>
    <xsl:key name="optype_by_id" match="/data/op_types/op_type" use="@op_type_id"/>
    <xsl:key name="zone_by_id" match="/data/zones/zone" use="@zone_id"/>

    <xsl:template match="/data">
        <div class="popupBackground">
            <img src="images/controls/blank.png" class="ilg close" style="float:right;" onclick="document.all('divSetup').style.display='none';"/>
        </div>
        <div class="popupBox">
            TEST
        </div>
    </xsl:template>
</xsl:stylesheet>