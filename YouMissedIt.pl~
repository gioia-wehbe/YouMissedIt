use File::Slurp;
use Data::Dumper;
use Algorithm::LibLinear;
use Lingua::StopWords qw( getStopWords );
use Lingua::Stem;
use strict;
use warnings;


#directories and paths
my $home_gioia_desktop='/home/gioia/Desktop';#What changes from one PC to another...

my $you_missed_it='/YouMissedIt';
my $the_tool='/TheTool';
my $emails='/Emails';
my $output='/Output';
my $no_task_emails='/NoTaskEmails';
my $task_emails='/TaskEmails';
my $stemmed = '/Stemmed';
my $classification="/Classification";
my $email_directory= $home_gioia_desktop.$you_missed_it.$the_tool.$emails."";
my $output_directory = $home_gioia_desktop.$you_missed_it.$the_tool.$output."";
my $stemmed_directory=$output_directory.$stemmed."";
my $features_file=$home_gioia_desktop.$you_missed_it.$classification."/features.txt";
my $directory_of_trained_model=$home_gioia_desktop.$you_missed_it.$classification.$output.'/trained.model';
my $no_task_mail_directory=$output_directory.$no_task_emails."";
my $task_mail_directory=$output_directory.$task_emails."";




######################################################################
# Reads through the emails to be classified, remove stop words & apply stemming, then output the stemmed files which will be used for classification.
#######################################################################

my @files = read_dir $email_directory;
foreach my $path (@files)
{
	my $file = $email_directory."/".$path;
	open (EMAILFILE, $file) or die "Error opening file - $!\n";#read the file content
	my $content="";
	while (<EMAILFILE>) 
	{
		#print "READING FROM FILE!!!";
		chomp;
		$content=$content."$_\n";
	}
	close(EMAILFILE);
	my @words = split(" ",$content);#put the words in an array    
my $stopwords = getStopWords('en');#get stop words
@words = grep { !$stopwords->{$_} } @words;#remove all stop words from the array of all words
my $stemmer = Lingua::Stem->new(-locale => 'EN-UK');#create the object used for stemming
$stemmer->stem_caching({ -level => 2 });#create a cash for stemming
my $stem_array = $stemmer->stem(@words);#create an array of stemmed words
my $stemmed_file_name=$stemmed_directory."/".$path;
open (MYFILE, ">>$stemmed_file_name");
print MYFILE "$_ " for (@$stem_array);
close (MYFILE); 

}

##########################################################################
# for each stemmed email, generate the feature vactor (what terms are found in this email and which aren't found).
########################################################################## 
my @stemmed_files = read_dir $stemmed_directory;
foreach my $path (@stemmed_files)
{
	my $file = $stemmed_directory."/".$path;
	open (EMAILFILE, $file) or die "Error opening file - $!\n";#read the file content
	my $content="";
	while (<EMAILFILE>) 
	{
		chomp;
		$content=$content."$_\n";
	}
	close(EMAILFILE);

	open (FEATUREFILE, $features_file) or die "Error opening file - $!\n";#read the file content
	my $counter=1;
	my $feature_hash={};
	while (<FEATUREFILE>) 
	{
		my $term=$_;
		my @values = split(':', $term);
		$term = $values[0];
		if ($content =~ /$term/)
		{
		 $feature_hash->{$counter}=1; 
		}
		else
		{
		$feature_hash->{$counter}=0; 
		}
		$counter=$counter+1;
	}
	close(FEATUREFILE);
	
###########################################################################
# load the save classification model and determine the class of the current email based on its feature vector. Based on the class lable, copy the email into the corresponding folder (Task or NoTask)
###########################################################################
	my $classifier = Algorithm::LibLinear::Model->load(filename => $directory_of_trained_model);
	# Determines which (+1 or -1) is the class for the given feature to belong.
  	my $class_label = $classifier->predict(feature => $feature_hash);
	#print "class label of ".$path." ".$class_label."\n";
	my $file_copy="";
	if($class_label=~1)
	{
		$file_copy=$task_mail_directory."/".$path;
		print "task mail path: ".$file_copy."\n";
		open (MAIL, ">>".$file_copy) or die "Error opening file copy - $!\n";
		my $file = $email_directory."/".$path;
		open (EMAILFILE, $file) or die "Error opening email file - $!\n";#read the file content
		my $content="";
		while (<EMAILFILE>) 
		{
			chomp;
			$content=$content."$_\n";
		}
		close(EMAILFILE);
		print MAIL $content;
		close(MAIL);
	}
	else
	{
		$file_copy=$no_task_mail_directory."/".$path;
		print "no task mail path: ".$file_copy."\n";
		open (MAIL, ">>".$file_copy) or die "Error opening file_copy - $!\n";
		my $file = $email_directory."/".$path;
		open (EMAILFILE, $file) or die "Error opening email file - $!\n";#read the file content
		my $content="";
		while (<EMAILFILE>) 
		{
			chomp;
			$content=$content."$_\n";
		}
		close(EMAILFILE);
		print MAIL $content;
		close(MAIL);
	}
}


