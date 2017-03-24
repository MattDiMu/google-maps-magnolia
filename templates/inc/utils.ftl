[#function calcApiKey content=content]
    [#local apiKey = sitefn.site().getParameters()["google-maps-magnolia-api-key"]!"" /]
    [#return .locals.apiKey]
[/#function]

[#function calcFrameSrc content=content]
    [#local apiKey = calcApiKey(content) /]
    [#if .locals.apiKey?has_content]
        [#local baseUrl = "https://www.google.com/maps/embed/v1/place?key=" + .locals.apiKey /]
        [#if content.location?has_content]
            [#local baseUrl = baseUrl + "&amp;q=" + content.location?url]
        [/#if]
        [#if content.mapType?has_content]
            [#local baseUrl = baseUrl + "&amp;maptype=" + content.mapType?url]
        [/#if]
        [#if content.zoom?has_content && content.zoom != "autodetect"]
            [#local baseUrl = baseUrl + "&amp;zoom=" + content.zoom?url]
        [/#if]
        [#if content.language?has_content && content.language != "autodetect"]
            [#local baseUrl = baseUrl + "&amp;language=" + content.language?url]
        [/#if]
        [#return .locals.baseUrl /]
    [/#if]
    [#return "" /]
[/#function]


[#function calcDirectionsFrameSrc content=content]
    [#local apiKey = calcApiKey(content) /]
    [#if .locals.apiKey?has_content]
        [#local baseUrl = "https://www.google.com/maps/embed/v1/directions?key=" + .locals.apiKey /]
        [#if content.origin?has_content]
            [#local baseUrl = baseUrl + "&amp;origin=" + content.origin?url]
        [/#if]
        [#if content.destination?has_content]
            [#local baseUrl = baseUrl + "&amp;destination=" + content.destination?url]
        [/#if]
        [#if content.mode?has_content && content.mode != "autodetect"]
            [#local baseUrl = baseUrl + "&amp;mode=" + content.mode?url]
        [/#if]
        [#if content.units?has_content && content.units != "autodetect"]
            [#local baseUrl = baseUrl + "&amp;units=" + content.units?url]
        [/#if]
        [#if content.avoid?has_content && content.avoid?size > 0]
            [#local avoids = '' /]
            [#list content.avoid as avoidString]
                [#local avoids = .locals.avoids + avoidString /]
                [#if avoidString_has_next]
                    [#local avoids = .locals.avoids + "|" /]
                [/#if]
            [/#list]
            [#if .locals.avoids?has_content]
                [#local baseUrl = baseUrl + "&amp;avoid=" + .locals.avoids?url]
            [/#if]
        [/#if]
        [#if content.mapType?has_content]
            [#local baseUrl = baseUrl + "&amp;maptype=" + content.mapType?url]
        [/#if]
        [#if content.zoom?has_content && content.zoom != "autodetect"]
            [#local baseUrl = baseUrl + "&amp;zoom=" + content.zoom?url]
        [/#if]
        [#if content.language?has_content && content.language != "autodetect"]
            [#local baseUrl = baseUrl + "&amp;language=" + content.language?url]
        [/#if]
        [#return .locals.baseUrl /]
    [/#if]
    [#return "" /]
[/#function]


[#function calcAspectRatio content=content]
    [#local aspectRatio = "500px" /] [#-- fallback --]
    [#if content.sizeType?has_content && content.sizeType == "responsiveHeight"]
        [#local aspectRatio = content.sizeTyperesponsiveHeight /]
    [#elseif content.sizeTypefixedHeight?has_content]
        [#local aspectRatio = content.sizeTypefixedHeight + "px" /]
    [/#if]
    [#return .locals.aspectRatio /]
[/#function]

[#macro renderGoogleMapsComponent content=content]
    [#local iFrameSrc = calcFrameSrc(content) /]
    [#local aspectRatio = calcAspectRatio(content) /]
    [#if .locals.iFrameSrc?has_content]
        <div class="google-maps-magnolia__google-directions"[#if cmsfn.isEditMode()] cms:edit[/#if]>
            <div class="google-maps-magnolia__google-directions-outer" style="width: 100%; position: relative;">
                <div class="google-maps-magnolia__google-directions-inner" style="width: 100%; padding-top: ${aspectRatio};">
                    <iframe
                        width="100%"
                        height="500"
                        frameborder="0" style="border:0; position: absolute; left: 0; top: 0; width: 100%; height: 100%;"
                        src="${.locals.iFrameSrc!}" allowfullscreen>
                    </iframe>
                </div>
            </div>
        </div>
    [#elseif cmsfn.isEditMode()]
        <div class="google-maps-magnolia__google-maps" cms:edit>
            <div class="google-maps-magnolia__google-maps-error" style="color: #9a3332; font-weight: bold; font-size: 20px; padding: 2em; text-align: center;">
                Developer Info: Please provide a valid Google API Key in your site definition in the parameters property "google-maps-magnolia-api-key".
            </div>
        </div>
    [/#if]
[/#macro]

[#macro renderGoogleDirectionsComponent content=content]
    [#local iFrameSrc = calcDirectionsFrameSrc(content) /]
    [#local aspectRatio = calcAspectRatio(content) /]
    [#if .locals.iFrameSrc?has_content]
        <div class="google-maps-magnolia__google-directions"[#if cmsfn.isEditMode()] cms:edit[/#if]>
            <div class="google-maps-magnolia__google-directions-outer" style="width: 100%; position: relative;">
                <div class="google-maps-magnolia__google-directions-inner" style="width: 100%; padding-top: ${aspectRatio};">
                    <iframe
                        width="100%"
                        height="500"
                        frameborder="0" style="border:0; position: absolute; left: 0; top: 0; width: 100%; height: 100%;"
                        src="${.locals.iFrameSrc!}" allowfullscreen>
                    </iframe>
                </div>
            </div>
        </div>
    [#elseif cmsfn.isEditMode()]
        <div class="google-maps-magnolia__google-directions" cms:edit>
            <div class="google-maps-magnolia__google-directions-error" style="color: #9a3332; font-weight: bold; font-size: 20px; padding: 2em; text-align: center;">
                Developer Info: Please provide a valid Google API Key in your site definition in the parameters property "google-maps-magnolia-api-key".
            </div>
        </div>
    [/#if]
[/#macro]