// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.


#import <Cordova/NSDictionary+CordovaPreferences.h>

#import "AppCenterAnalyticsPlugin.h"
#import "AppCenterShared.h"

@import AppCenterAnalytics;

@implementation AppCenterAnalyticsPlugin

- (void)pluginInitialize
{
    [AppCenterShared configureWithSettings: self.commandDelegate.settings];
    [MSACAppCenter startService:[MSACAnalytics class]];

    BOOL enableInJs = [self.commandDelegate.settings
                       cordovaBoolSettingForKey:@"APPCENTER_ANALYTICS_ENABLE_IN_JS"
                       defaultValue:NO];

    if (enableInJs) {
        // Avoid starting an analytics session.
        // Note that we don't call this if startEnabled is true, because
        // that causes a session to try and start before MSACAnalytics is started.
        [MSACAnalytics setEnabled:false];
    }

    //[MSACAnalytics setAutoPageTrackingEnabled:false]; // TODO: once the underlying SDK supports this, make sure to call this
}

- (void)isEnabled:(CDVInvokedUrlCommand *)command
{
    BOOL isEnabled = [MSACAnalytics isEnabled];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsBool:isEnabled];

    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}

- (void)setEnabled:(CDVInvokedUrlCommand *)command
{
    BOOL shouldEnable = [[command argumentAtIndex:0] boolValue];
    [MSACAnalytics setEnabled:shouldEnable];

    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}

- (void)trackEvent:(CDVInvokedUrlCommand *)command
{
    NSString* eventName = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
    NSDictionary* properties = [command argumentAtIndex:1];

    [MSACAnalytics trackEvent:eventName withProperties:properties];

    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}

/*
// TODO: once the underlying SDK supports this
- (void)trackEvent:(CDVInvokedUrlCommand *)command
{
    NSString pageName = [command argumentAtIndex:0];
    NSDictionary properties = [command argumentAtIndex:1];

    [MSACAnalytics trackPage:pageName withProperties:properties];

    [self.commandDelegate sendPluginResult:CDVCommandStatus_OK
                                callbackId:command.callbackId];
}
*/

@end