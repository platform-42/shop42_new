# Shops42
eee
## deployment steps
1. deploy OAuth config -> Misc/HTML/shops42 -> 
    https://platform-42.com/oauth/
2. configure allowed redirect URL in shopify developer portal -> https://platform-42.com/oauth/
3. deploy Shopify config -> Misc/HTML/shopify ->
    https://platform-42.com/oauth/shopify
4. configure app URL in shopify developer portal ->
    https://platform-42.com/shopify/
5. configure CFBuldeURLSchemes to shops42 in info.plist (meaning shops42:// as url schema) so that AppAuth can listen to incoming URL
    ```
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>shops42</string>
            </array>
        </dict>
    </array>
    ```
6.  deploy .htaccess to domain root for http to https rerouting
    ```
    RewriteEngine On
    RewriteCond %{HTTPS} !on
    RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
    ```
7.  obtain rights for order details
    shopify developer portal
    -> apps -> Shops42 -> API access 
        request Protected customer data access
        

## Things to remember
* ScrollView treats views same as ListView and PickerView - content moves to top
* tint influences tint of childViews


## Project settings
* ENABLE_USER_SCRIPT_SANDBOXING No -> buildsettings -> use search
* remove iPad, Mac, and Apple vision from supported destinations
* App category -> Business
* minimum deployment -> iOS 17.0
* iPhone orientation -> portrait, remove -> landscape
* create storekit file with subscriptions for simulating purchases - dont forget to refresh storekit file after updating appstoreconnect
 

## Overview
* app utilises OAuth pod
* pod is part of GIT-repo, since we modified callback handling slightly (works with Info.plist defined uri shops42:// )


## Instructions for usage
* deploy HTML pages on server
* adjust internal link in index.php
** <!-- <a href="<?php echo "Flytox://oauth/shopify/?" . $_SERVER['QUERY_STRING']; ?>"> -->


## Info.plist
* configure URL-type Flytox
```    
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>Flytox</string>
            </array>
        </dict>
    </array>
```

https://chatgpt.com/share/677a57c0-3b70-8006-b9c5-72ad6607ea0b
