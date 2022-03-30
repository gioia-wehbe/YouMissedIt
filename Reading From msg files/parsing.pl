#!/usr/bin/perl
use strict;
use warnings;
use Email::Outlook::Message;
use MIME::Base64::Perl;
use MIME::QuotedPrint::Perl;
use Mail::Exchange::Message;
use Email::MIME;

print "Hello World.\n";

my $filename = "/home/gioia/Desktop/Labeled/NT/\%NT\%Away from the office.msg";
#my $verbose = false;

my $msg = new Email::Outlook::Message $filename;
my $mime = $msg->to_email_mime;
my $body = $mime->body_str;
#my $txt=$mime->as_string;
#my $decoded = decode_qp($txt);
print"\n\n\n\n\nTHE EMAIL IS:".$body;

#my $msg=Mail::Exchange::Message->new($filename);
#my $rtf=$msg->getRtfBody();
#print"\n\n\n\n\nTHE EMAIL IS:".$rtf;
