[#function calcApiKey content=content]
    [#local apiKey = sitefn.site().getParameters()["google-maps-magnolia-api-key"]!"" /]
    [#return .locals.apiKey]
[/#function]

[#function calcFrameSrc content=content]
    [#local apiKey = calcApiKey(content) /]
    [#local location = content.location!"" /]
    [#if .locals.apiKey?has_content]
        [#return "https://www.google.com/maps/embed/v1/place?key=" + apiKey + "&amp;q=" + .locals.location?url /]
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
        <div class="google-maps-magnolia__google-maps"[#if cmsfn.isEditMode()] cms:edit[/#if]>
            <div class="google-maps-magnolia__google-maps-outer" style="width: 100%; position: relative;">
                <div class="google-maps-magnolia__google-maps-inner" style="width: 100%; padding-top: ${aspectRatio};">
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