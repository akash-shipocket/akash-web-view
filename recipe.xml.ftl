<?xml version="1.0"?>
<#import "root://activities/common/kotlin_macros.ftl" as kt>
<recipe>
    <@kt.addAllKotlinDependencies />

    <#--Add Dependencies Starts here-->
    <dependency mavenUrl="com.wang.avi:library:2.1.3"/>
    <#--Add Dependencies Ends here-->

    <#-- AndroidManifest Instantiation Starts here-->

    <instantiate from="AndroidManifest.xml.ftl"
                 to="${escapeXmlAttribute(manifestOut)}/AndroidManifest.xml"/>

    <#-- AndroidManifest Instantiation Ends here-->


    <#--Java/Kotlin Class Instantiation Starts here-->

    <#--Main Activity-->
    <instantiate from="src/app_package/MainActivity.java.ftl"
                 to="${escapeXmlAttribute(srcOut)}/MainActivity.java"/>

    <#--Browsers-->
    <instantiate from="src/app_package/browse/ChromeBrowser.java.ftl"
                 to="${escapeXmlAttribute(srcOut)}/browse/ChromeBrowser.java"/>
    <instantiate from="src/app_package/browse/WebViewBrowser.java.ftl"
                 to="${escapeXmlAttribute(srcOut)}/browse/WebViewBrowser.java"/>

    <#--JsInterfaces-->
    <instantiate from="src/app_package/jsinterface/ActivityBrowserContract.java.ftl"
                 to="${escapeXmlAttribute(srcOut)}/jsinterface/ActivityBrowserContract.java"/>

    <#--Util-->
    <instantiate from="src/app_package/util/ConnectivityReceiver.java.ftl"
                 to="${escapeXmlAttribute(srcOut)}/util/ConnectivityReceiver.java"/>
    <instantiate from="src/app_package/util/Helper.java.ftl"
                 to="${escapeXmlAttribute(srcOut)}/util/Helper.java"/>
    <instantiate from="src/app_package/util/ObservableObject.java.ftl"
                 to="${escapeXmlAttribute(srcOut)}/util/ObservableObject.java"/>

    <#--Java/Kotlin Class Instaniation Ends here-->



    <#--Resource Instantiation Starts here-->

    <#--anim-->
    <instantiate from="res/anim/no_internet_fade_in.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/anim/no_internet_fade_in.xml"/>
    <instantiate from="res/anim/no_internet_fade_out.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/anim/no_internet_fade_out.xml"/>

    <#--drawable-->
    <copy from="res/drawable"
          to="${escapeXmlAttribute(resOut)}/drawable"/>

    <#--Layout-->
    <instantiate from="res/layout/activity_main.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/layout/activity_main.xml"/>
    <instantiate from="res/layout/full_page_loader.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/layout/full_page_loader.xml"/>
    <instantiate from="res/layout/no_internet_layout.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/layout/no_internet_layout.xml"/>
    <instantiate from="res/layout/progress_dialog_layout.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/layout/progress_dialog_layout.xml"/>

    <#--Values-->
    <merge from="res/values/colors.xml.ftl"
           to="${escapeXmlAttribute(resOut)}/values/colors.xml"/>
    <instantiate from="res/values/dimens.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/values/dimens.xml"/>
    <instantiate from="res/values/strings.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/values/strings.xml"/>
    <instantiate from="res/values/styles.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/values/styles.xml"/>

    <#--Resource Instantiation Ends here-->


    <open file="${srcOut}/MainActivity.java"/>
</recipe>
