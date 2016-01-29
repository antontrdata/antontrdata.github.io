#!/usr/bin/perl -w
use strict; use warnings;

open(my $input, "<", "Totalizator.csv") 
or die "cannot open input file \n$!\n";	

open(my $output, ">", "Totalizator.json") 
or die "cannot open output file \n$!\n";

open(my $output2, ">", "Stat.json") 
or die "cannot open output file \n$!\n";

open(my $output3, ">", "Textures.json") 
or die "cannot open output file \n$!\n";


print $output "[\n";

my $old_date = "";
my $date_counter = -1;

my $min_value = 10000;
my $max_value = 0;

my $i = 0;
my @value_array;
my @date_array;

my @min_array;
my @max_array;


my $new_line;
while( defined($new_line = <$input>) )
{
	print $output "{\n";

	my @tmp = split (";",$new_line);
	$tmp[0] =~ s/"//g;
	$tmp[0] =~ s/\(/;/;
	$tmp[0] =~ s/\)//;
	$tmp[1] =~ s/,/./;
	$tmp[3] =~ s/:/./;

	my @tmp2 = split (";",$tmp[0]);

	if ($old_date ne $tmp[2])
	{
		$date_counter++;
		$old_date = $tmp[2];
	}

	if ($tmp[1] < $min_value)
	{
		$min_value = $tmp[1];
	}
	if ($tmp[1] > $max_value)
	{
		$max_value = $tmp[1];
	}	

	$value_array[$i] = $tmp[1];
	$date_array[$i] = $date_counter;
	$i++;

	{
		print $output "\"Name\": \"".$tmp2[0]."\",\n";
		print $output "\"Company\": \"".$tmp2[1]."\",\n";
		print $output "\"Value\": ".$tmp[1].",\n";
		print $output "\"Date\": ".$date_counter.",\n";
		print $output "\"Time\": ".$tmp[3]."\n";
	}

	print $output "},\n";
}

print $output "]";

print $output2 "[\n{\n";
print $output2 "\"daysAmount\": ".$date_counter.",\n";
print $output2 "\"minValue\": ".$min_value.",\n";
print $output2 "\"maxValue\": ".$max_value."\n";
print $output2 "}\n]\n";


my $current_date = -1;
my $cntr = 0;

print $output3 "[\n";
for (my $j=0;$j<@date_array;$j++)
{
	if ($current_date < $date_array[$j])
	{
		if ($current_date > -1)
		{
			print $output3 "{\n";
			print $output3 "\"date\": ".$current_date.",\n";
			print $output3 "\"minValue\": ".$min_array[$cntr].",\n";
			print $output3 "\"maxValue\": ".$max_array[$cntr]."\n";
			print $output3 "},\n";
		}

		$min_array[$cntr] = $value_array[$j];
		$max_array[$cntr] = $value_array[$j];
		$current_date = $date_array[$j];
	}
	else
	{
		if ($min_array[$cntr] > $value_array[$j])
		{
			$min_array[$cntr] = $value_array[$j];
		}
		if ($max_array[$cntr] < $value_array[$j])
		{
			$max_array[$cntr] = $value_array[$j];
		}

	}
}

print $output3 "{\n";
print $output3 "\"date\": ".$current_date.",\n";
print $output3 "\"minValue\": ".$min_array[$cntr].",\n";
print $output3 "\"maxValue\": ".$max_array[$cntr]."\n";
print $output3 "}\n]\n";

close ($input);
close ($output);
close ($output2);


