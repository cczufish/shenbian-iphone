/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/sysctl.h>
#include <mach/mach.h>
#import "UIDevice+Hardware.h"

@implementation UIDevice (Hardware)

#pragma mark sysctlbyname utils
+ (NSString *) getSysInfoByName:(const char *)typeSpecifier
{
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
	free(answer);
	return results;
}

+ (NSString *)platform
{
    NSString *info = [self getSysInfoByName:"hw.machine"];
    if([info isEqualToString:@"iPhone1,1"])
	{	
		return iPhone;
	}
	else if([info isEqualToString:@"iPhone1,2"])
	{
		return iPhone3G;
	}
	else if([info isEqualToString:@"iPhone2,1"])
	{	
		return iPhone3GS;
	}
	else if([info isEqualToString:@"iPod1,1"])
	{
		return iPod1;
	}
	else if([info isEqualToString:@"iPod2,1"])
	{
		return iPod2;
	}
	else if([info isEqualToString:@"iPod3,1"])
	{
		return iPod3;
	}
    else if([info isEqualToString:@"iPad1,1"])
    {
		return iPad1;
	}
    else if([info isEqualToString:@"iPad2,1"])
    {
        return iPad2;
    }
    else 
    {
		return iPhone4;
	}
}

#pragma mark sysctl utils
+ (NSUInteger) getSysInfo: (uint) typeSpecifier
{
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return (NSUInteger) results;
}

+ (NSUInteger) cpuFrequency
{
	return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger) busFrequency
{
	return [self getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger) totalMemory
{
	return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger) userMemory
{
	return [self getSysInfo:HW_USERMEM];
}

+ (NSUInteger) maxSocketBufferSize
{
	return [self getSysInfo:KIPC_MAXSOCKBUF];
}

+ (NSUInteger) availableMemory
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
	
	return (vm_page_size * vmStats.free_count);
}

+ (NSUInteger) wireMemory
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
	
	return (vm_page_size * vmStats.wire_count);
}

+ (NSUInteger) activeMemory
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
	
	return (vm_page_size * vmStats.active_count);
}

+ (NSUInteger) inactiveMemory
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
	
	return (vm_page_size * vmStats.inactive_count);
}

+ (NSUInteger) moreInfo
{
	return [self getSysInfo:KERN_ARGMAX];
}

@end
