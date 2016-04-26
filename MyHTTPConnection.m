#import "MyHTTPConnection.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPResponseTest.h"
#import "HTTPLogging.h"
#import "IMUDataManager.h"
#import "GyroAccel-Swift.h"


// Log levels: off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;


@implementation MyHTTPConnection


- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	// Use HTTPConnection's filePathForURI method.
	// This method takes the given path (which comes directly from the HTTP request),
	// and converts it to a full path by combining it with the configured document root.
	// 
	// It also does cool things for us like support for converting "/" to "/index.html",
	// and security restrictions (ensuring we don't serve documents outside configured document root folder).
	
	NSString *filePath = [self filePathForURI:path];
	
	// Convert to relative path
	
	NSString *documentRoot = [config documentRoot];
	
	if (![filePath hasPrefix:documentRoot])
	{
		// Uh oh.
		// HTTPConnection's filePathForURI was supposed to take care of this for us.
		return nil;
	}
	
	NSString *relativePath = [filePath substringFromIndex:[documentRoot length]];
	
	if ([relativePath isEqualToString:@"/index.html"])
	{
		HTTPLogVerbose(@"%@[%p]: Serving up dynamic content", THIS_FILE, self);
		
		// The index.html file contains several dynamic fields that need to be completed.
		// For example:
		// 
		// Computer name: %%COMPUTER_NAME%%
		// 
		// We need to replace "%%COMPUTER_NAME%%" with whatever the computer name is.
		// We can accomplish this easily with the HTTPDynamicFileResponse class,
		// which takes a dictionary of replacement key-value pairs,
		// and performs replacements on the fly as it uploads the file.
		
		NSString *computerName = @"Hongyu";
		NSString *currentTime = [[NSDate date] description];
        
        
        IMUDataManager * dataManager = [IMUDataManager sharedIMUDataManager];
        
        NSString * x_accVal = dataManager.accVal_x;
        NSString * y_accVal = dataManager.accVal_y;
        NSString * z_accVal = dataManager.accVal_z;
        NSString * x_pos = [[NSString alloc] initWithFormat:@"%f", dataManager.distance_x];
        NSString * y_pos = [[NSString alloc] initWithFormat:@"%f", dataManager.distance_y];
        
        if (x_accVal.length == 0) {
            x_accVal = @"No data";
        }
        
        if (y_accVal.length == 0) {
            y_accVal = @"No data";
        }
        
        if (z_accVal.length == 0) {
            z_accVal = @"No data";
        }
				
		NSMutableDictionary *replacementDict = [NSMutableDictionary dictionaryWithCapacity:5];
		
		[replacementDict setObject:computerName forKey:@"COMPUTER_NAME"];
		[replacementDict setObject:currentTime  forKey:@"TIME"];
        [replacementDict setObject:x_accVal     forKey:@"AccX"];
        [replacementDict setObject:y_accVal     forKey:@"AccY"];
		[replacementDict setObject:z_accVal     forKey:@"AccZ"];
        [replacementDict setObject:x_pos        forKey:@"PosX"];
        [replacementDict setObject:y_pos        forKey:@"PosY"];

		
		HTTPLogVerbose(@"%@[%p]: replacementDict = \n%@", THIS_FILE, self, replacementDict);
		
		return [[HTTPDynamicFileResponse alloc] initWithFilePath:[self filePathForURI:path]
		                                            forConnection:self
		                                                separator:@"%%"
		                                    replacementDictionary:replacementDict];
	}
	else if ([relativePath isEqualToString:@"/unittest.html"])
	{
		HTTPLogVerbose(@"%@[%p]: Serving up HTTPResponseTest (unit testing)", THIS_FILE, self);
		
		return [[HTTPResponseTest alloc] initWithConnection:self];
	}
	
	return [super httpResponseForMethod:method URI:path];
}

@end
