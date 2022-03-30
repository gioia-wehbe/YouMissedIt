use File::Slurp;
use Data::Dumper;
use Algorithm::LibLinear;
use strict;
use warnings;


#directories and paths
my $home_gioia_desktop='/home/gioia/Desktop';#What changes from one PC to another...




my $you_missed_it='/YouMissedIt';
my $classification="/Classification";
my $Emails='/Emails';
my $output='/Output';
my $directory_of_emails=$home_gioia_desktop.$you_missed_it.$classification.$Emails."";
my $features_file=$home_gioia_desktop.$you_missed_it.$classification."/features.txt";
print "directory of features: ".$features_file."\n";
my $directory_of_output=$home_gioia_desktop.$you_missed_it.$classification.$output."";
print "directory of output: ".$directory_of_output."\n";
my $output_file=$directory_of_output."/data.txt";







#####################################################################################################################################################
# Create the training data file where each record represents a document and each column represents a feature. if the document contains the feature, the value it set to; otherwise, it is set to 0. The actual class of the document is found in the file name. if it is a task email, the class is 1; otherwise the class is 0.
#####################################################################################################################################################
 
my @files = read_dir $directory_of_emails;
foreach my $path (@files)
{
	my $file = $directory_of_emails."/".$path;
	open (EMAILFILE, $file) or die "Error opening file - $!\n";#read the file content
	my $content="";
	while (<EMAILFILE>) 
	{
		chomp;
		$content=$content."$_\n";
	}
	close(EMAILFILE);
	open (OUT, '>>'.$output_file) or die "Error opening file - $!\n";
	my @email_name = split('%',$path);
	my $class = $email_name[1];
	if($class =~ /NT/)
	{
		$class=0;#NT
	}
	else
	{
		$class=1;#T
	}
	print OUT $class." "; 

	open (FEATUREFILE, $features_file) or die "Error opening file - $!\n";#read the file content
	my $counter=1;
	while (<FEATUREFILE>) 
	{
		my $term=$_;
		my @values = split(':', $term);
		$term = $values[0];
		if ($content =~ /$term/)
		{
		 print OUT $counter.":1 "; 
		}
		else
		{
		print OUT $counter.":0 "; 
		}
		$counter=$counter+1;
	}
	close(FEATUREFILE);
	print OUT "\n";
	close (OUT);
}



####################################################################
# Construct the logistic regression model for classification 
####################################################################
my $learner = Algorithm::LibLinear->new(solver => 'L2R_LR');

#************************************************
# Load training data set 
#************************************************
my $data_set = Algorithm::LibLinear::DataSet->load(filename => $output_file."");

#************************************************************
# Execute cross validation and output the average accuracy
#************************************************************
my $accuracy = $learner->cross_validation(data_set => $data_set, num_folds => 5);-
open (OUT, '>>'.$directory_of_output."/accuracy.txt") or die "Error opening file - $!\n";
print OUT "accuracy: ".$accuracy."\n";
close(OUT);

#**************************************************************************
# Execute training and save the trained model which can be used to predict/classify future models.
#**************************************************************************
my $classifier = $learner->train(data_set => $data_set);
$classifier->save(filename => $directory_of_output.'/trained.model');

