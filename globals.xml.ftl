<?xml version="1.0"?>
<globals>

    <#--<global id="hasNoActionBar" type="boolean" value="false" />
    <global id="parentActivityClass" value="" />
    <global id="simpleLayoutName" value="${layoutName}" />
    <global id="excludeMenu" type="boolean" value="true" />
    <global id="generateActivityTitle" type="boolean" value="false" />-->

    <global id="manifestOut" value="${manifestDir}" />
    <global id="resOut" value="${resDir}"/>
    <global id="srcOut" value="${srcDir}/${slashedPackageName(packageName)}"/>
    <#include "root://activities/common/common_globals.xml.ftl" />

</globals>
