/*
 * Copyright (c) 2019 Taner Sener
 *
 * This file is part of FlutterFFmpeg.
 *
 * FlutterFFmpeg is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * FlutterFFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with FlutterFFmpeg.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "EmptyLogDelegate.h"
#import "FlutterExecuteDelegate.h"
#import "FlutterFFmpegPlugin.h"

#import <stdlib.h>
#import <mobileffmpeg/ArchDetect.h>
#import <mobileffmpeg/MobileFFmpegConfig.h>
#import <mobileffmpeg/MobileFFmpeg.h>
#import <mobileffmpeg/MobileFFprobe.h>

static NSString *const PLATFORM_NAME = @"ios";

static NSString *const KEY_VERSION = @"version";
static NSString *const KEY_RC = @"rc";
static NSString *const KEY_PLATFORM = @"platform";
static NSString *const KEY_PACKAGE_NAME = @"packageName";
static NSString *const KEY_LAST_RC = @"lastRc";
static NSString *const KEY_LAST_COMMAND_OUTPUT = @"lastCommandOutput";
static NSString *const KEY_PIPE = @"pipe";

static NSString *const KEY_LOG_EXECUTION_ID = @"executionId";
static NSString *const KEY_LOG_LEVEL = @"level";
static NSString *const KEY_LOG_TEXT = @"log";

static NSString *const KEY_STAT_EXECUTION_ID = @"executionId";
static NSString *const KEY_STAT_TIME = @"time";
static NSString *const KEY_STAT_SIZE = @"size";
static NSString *const KEY_STAT_BITRATE = @"bitrate";
static NSString *const KEY_STAT_SPEED = @"speed";
static NSString *const KEY_STAT_VIDEO_FRAME_NUMBER = @"videoFrameNumber";
static NSString *const KEY_STAT_VIDEO_QUALITY = @"videoQuality";
static NSString *const KEY_STAT_VIDEO_FPS = @"videoFps";

static NSString *const KEY_EXECUTION_ID = @"executionId";
static NSString *const KEY_EXECUTION_START_TIME = @"startTime";
static NSString *const KEY_EXECUTION_COMMAND = @"command";

static NSString *const EVENT_LOG = @"FlutterFFmpegLogCallback";
static NSString *const EVENT_STAT = @"FlutterFFmpegStatisticsCallback";

/**
 * Flutter FFmpeg Plugin
 */
@implementation FlutterFFmpegPlugin {
    FlutterEventSink _eventSink;
    EmptyLogDelegate *_emptyLogDelegate;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _emptyLogDelegate = [[EmptyLogDelegate alloc] init];
    }

    return self;
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    _eventSink = nil;
    return nil;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterFFmpegPlugin* instance = [[FlutterFFmpegPlugin alloc] init];

    FlutterMethodChannel* methodChannel = [FlutterMethodChannel methodChannelWithName:@"flutter_ffmpeg" binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:methodChannel];

    FlutterEventChannel* eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter_ffmpeg_event" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    // ARGUMENTS
    NSArray* arguments = call.arguments[@"arguments"];

    if ([@"getPlatform" isEqualToString:call.method]) {

        NSString *architecture = [ArchDetect getArch];
        result([FlutterFFmpegPlugin toStringDictionary:KEY_PLATFORM :[NSString stringWithFormat:@"%@-%@", PLATFORM_NAME, architecture]]);

    } else if ([@"getFFmpegVersion" isEqualToString:call.method]) {

        result([FlutterFFmpegPlugin toStringDictionary:KEY_VERSION :[MobileFFmpegConfig getFFmpegVersion]]);

    } else if ([@"executeFFmpegWithArguments" isEqualToString:call.method]) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int rc = [MobileFFmpeg executeWithArguments:arguments];
            result([FlutterFFmpegPlugin toIntDictionary:KEY_RC :[NSNumber numberWithInt:rc]]);
        });

    } else if ([@"executeFFmpegAsyncWithArguments" isEqualToString:call.method]) {

        FlutterExecuteDelegate* executeDelegate = [[FlutterExecuteDelegate alloc] initWithEventSink:_eventSink];
        long executionId = [MobileFFmpeg executeWithArgumentsAsync:arguments withCallback:executeDelegate];

        result([FlutterFFmpegPlugin toIntDictionary:KEY_EXECUTION_ID :[NSNumber numberWithLong:executionId]]);

    } else if ([@"executeFFprobeWithArguments" isEqualToString:call.method]) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int rc = [MobileFFprobe executeWithArguments:arguments];
            result([FlutterFFmpegPlugin toIntDictionary:KEY_RC :[NSNumber numberWithInt:rc]]);
        });

    } else if ([@"cancel" isEqualToString:call.method]) {

        NSNumber* executionId = call.arguments[@"executionId"];
        if (executionId == nil) {
            [MobileFFmpeg cancel];
        } else {
            [MobileFFmpeg cancel:[executionId longValue]];
        }

    } else if ([@"enableRedirection" isEqualToString:call.method]) {

        [MobileFFmpegConfig enableRedirection];

    } else if ([@"disableRedirection" isEqualToString:call.method]) {

        [MobileFFmpegConfig disableRedirection];

    } else if ([@"getLogLevel" isEqualToString:call.method]) {

        int logLevel = [MobileFFmpegConfig getLogLevel];
        result([FlutterFFmpegPlugin toIntDictionary:KEY_LOG_LEVEL :[NSNumber numberWithInt:logLevel]]);

    } else if ([@"setLogLevel" isEqualToString:call.method]) {

        NSNumber* logLevel = call.arguments[@"level"];
        [MobileFFmpegConfig setLogLevel:[logLevel intValue]];

    } else if ([@"enableLogs" isEqualToString:call.method]) {

        [MobileFFmpegConfig setLogDelegate:self];

    } else if ([@"disableLogs" isEqualToString:call.method]) {

        [MobileFFmpegConfig setLogDelegate:_emptyLogDelegate];

    } else if ([@"enableStatistics" isEqualToString:call.method]) {

        [MobileFFmpegConfig setStatisticsDelegate:self];

    } else if ([@"disableStatistics" isEqualToString:call.method]) {

        [MobileFFmpegConfig setStatisticsDelegate:nil];

    } else if ([@"getLastReceivedStatistics" isEqualToString:call.method]) {

        Statistics *statistics = [MobileFFmpegConfig getLastReceivedStatistics];
        result([FlutterFFmpegPlugin toStatisticsDictionary:statistics]);

    } else if ([@"resetStatistics" isEqualToString:call.method]) {

        [MobileFFmpegConfig resetStatistics];

    } else if ([@"setFontconfigConfigurationPath" isEqualToString:call.method]) {

        NSString* path = call.arguments[@"path"];
        [MobileFFmpegConfig setFontconfigConfigurationPath:path];

    } else if ([@"setFontDirectory" isEqualToString:call.method]) {

        NSString* fontDirectoryPath = call.arguments[@"fontDirectory"];
        NSDictionary* fontNameMapping = call.arguments[@"fontNameMap"];
        [MobileFFmpegConfig setFontDirectory:fontDirectoryPath with:fontNameMapping];

    } else if ([@"getPackageName" isEqualToString:call.method]) {

        NSString *packageName = [MobileFFmpegConfig getPackageName];
        result([FlutterFFmpegPlugin toStringDictionary:KEY_PACKAGE_NAME :packageName]);

    } else if ([@"getExternalLibraries" isEqualToString:call.method]) {

        NSArray *externalLibraries = [MobileFFmpegConfig getExternalLibraries];
        result(externalLibraries);

    } else if ([@"getLastReturnCode" isEqualToString:call.method]) {

        int lastReturnCode = [MobileFFmpegConfig getLastReturnCode];
        result([FlutterFFmpegPlugin toIntDictionary:KEY_LAST_RC :[NSNumber numberWithInt:lastReturnCode]]);

    } else if ([@"getLastCommandOutput" isEqualToString:call.method]) {

        NSString *lastCommandOutput = [MobileFFmpegConfig getLastCommandOutput];
        result([FlutterFFmpegPlugin toStringDictionary:KEY_LAST_COMMAND_OUTPUT :lastCommandOutput]);

    } else if ([@"getMediaInformation" isEqualToString:call.method]) {

        NSString* path = call.arguments[@"path"];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MediaInformation *mediaInformation = [MobileFFprobe getMediaInformation:path];
            result([FlutterFFmpegPlugin toMediaInformationDictionary:mediaInformation]);
        });

    } else if ([@"registerNewFFmpegPipe" isEqualToString:call.method]) {

        NSString *pipe = [MobileFFmpegConfig registerNewFFmpegPipe];
        result([FlutterFFmpegPlugin toStringDictionary:KEY_PIPE :pipe]);

    } else if ([@"setEnvironmentVariable" isEqualToString:call.method]) {

        NSString* variableName = call.arguments[@"variableName"];
        NSString* variableValue = call.arguments[@"variableValue"];

        setenv([variableName UTF8String], [variableValue UTF8String], true);

    } else if ([@"listExecutions" isEqualToString:call.method]) {

        NSArray* executionsArray = [FlutterFFmpegPlugin toExecutionsArray:[MobileFFmpeg listExecutions]];
        result(executionsArray);

    } else {

        result(FlutterMethodNotImplemented);

    }
}

- (void)logCallback: (long)executionId :(int)level :(NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary[KEY_LOG_EXECUTION_ID] = [NSNumber numberWithLong:executionId];
        dictionary[KEY_LOG_LEVEL] = [NSNumber numberWithInt:level];
        dictionary[KEY_LOG_TEXT] = message;

        [self emitLogMessage: dictionary];
    });
}

- (void)statisticsCallback:(Statistics *)statistics {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self emitStatistics: statistics];
    });
}

- (void)emitLogMessage:(NSDictionary*)logMessage{
    _eventSink([FlutterFFmpegPlugin toStringDictionary:EVENT_LOG withDictionary:logMessage]);
}

- (void)emitStatistics:(Statistics*)statistics{
    NSDictionary *dictionary = [FlutterFFmpegPlugin toStatisticsDictionary:statistics];
    _eventSink([FlutterFFmpegPlugin toStringDictionary:EVENT_STAT withDictionary:dictionary]);
}

+ (NSDictionary *)toStringDictionary:(NSString*)key :(NSString*)value {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[key] = value;

    return dictionary;
}

+ (NSDictionary *)toStringDictionary:(NSString*)key withDictionary:(NSDictionary*)value {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[key] = value;

    return dictionary;
}

+ (NSDictionary *)toIntDictionary:(NSString*)key :(NSNumber*)value {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[key] = value;

    return dictionary;
}

+ (NSDictionary *)toStatisticsDictionary:(Statistics*)statistics {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    if (statistics != nil) {
        dictionary[KEY_STAT_EXECUTION_ID] = [NSNumber numberWithLong: [statistics getExecutionId]];

        dictionary[KEY_STAT_TIME] = [NSNumber numberWithInt: [statistics getTime]];
        dictionary[KEY_STAT_SIZE] = [NSNumber numberWithLong: [statistics getSize]];

        dictionary[KEY_STAT_BITRATE] = [NSNumber numberWithDouble: [statistics getBitrate]];
        dictionary[KEY_STAT_SPEED] = [NSNumber numberWithDouble: [statistics getSpeed]];

        dictionary[KEY_STAT_VIDEO_FRAME_NUMBER] = [NSNumber numberWithInt: [statistics getVideoFrameNumber]];
        dictionary[KEY_STAT_VIDEO_QUALITY] = [NSNumber numberWithFloat: [statistics getVideoQuality]];
        dictionary[KEY_STAT_VIDEO_FPS] = [NSNumber numberWithFloat: [statistics getVideoFps]];
    }

    return dictionary;
}

+ (NSArray *)toExecutionsArray:(NSArray*)ffmpegExecutions {
    NSMutableArray *executions = [[NSMutableArray alloc] init];

    for (int i = 0; i < [ffmpegExecutions count]; i++) {
        FFmpegExecution* execution = [ffmpegExecutions objectAtIndex:i];

        NSMutableDictionary *executionDictionary = [[NSMutableDictionary alloc] init];
        executionDictionary[KEY_EXECUTION_ID] = [NSNumber numberWithLong: [execution getExecutionId]];
        executionDictionary[KEY_EXECUTION_START_TIME] = [NSNumber numberWithDouble:[[execution getStartTime] timeIntervalSince1970]*1000];
        executionDictionary[KEY_EXECUTION_COMMAND] = [execution getCommand];

        [executions addObject: executionDictionary];
    }

    return executions;
}

+ (NSDictionary *)toMediaInformationDictionary:(MediaInformation*)mediaInformation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    if (mediaInformation != nil) {
        NSDictionary* allProperties = [mediaInformation getAllProperties];
        if (allProperties != nil) {
            for(NSString *key in [allProperties allKeys]) {
                dictionary[key] = [allProperties objectForKey:key];
            }
        }
    }

    return dictionary;
}

@end
