#!/usr/bin/perl
use LWP::Simple;  
use Getopt::Long;
use warnings;
use strict;

my $url="$ARGV[0]";
print "$url\n";
my $text = get ($url);
if ($text eq "") # null string means got nothing from server
{ 
    die("\nFAILURE \n)");
}
$_ = $text;
while (/.*?entry.*?media:content url='(.*?)'/gs)
{    
    print "$1\n";
}
