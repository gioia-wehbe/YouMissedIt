#!/usr/local/bin/perl -w

# for our MIME parsing needs
use MIME::Parser;

# for our filename/path parsing needs
use File::Basename;

# please use me - i like it!
use strict;

# where to put the decoded parts
my $output_path = '/home/gioia/Desktop/Parser2';

# derive the base filenames of extracted parts from
# the name of the script. uses basename method of
# File::Basename.yippee.
my ($parsed) = (basename($0))[0];

# our input file, a multipart message
my $input_file = '/home/gioia/Desktop/Parser2/%NT%460 Syllabus.msg';

my $parser = MIME::Parser->new();

# output directory for parsed files
$parser->output_dir($output_path);

# Basenames for parsed files
$parser->output_prefix($parsed);

# KEY PART: Now, write the entities (parsed from boundaries) 
# to the filesystem
$parser->output_to_core();

# Parse the input file: (which can be @ARGV if you want it to be!)
open(INPUT, "$input_file") or die("Input error: $!");
my $entity = $parser->read(\*INPUT) 
    or die "couldn't parse MIME stream";
close(INPUT);

# Tell us about the MIME entities!  You can suppress
# this if you don't want output for the sake of debugging
print "DUMP";
$entity->dump_skeleton;          # for debugging 
