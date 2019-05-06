#!/usr/bin/perl
use strict;
use warnings;
my @tmp;
my @primary;
my $processing=0;
print "process en cours...\n";
open (fichier1, "mart_export.csv");
open (fichier2,">martexport_cleaned.csv");
while (<fichier1>){
  $processing++;
  if ($processing%5000==0){
    print "...\n";
  }
  chomp;
  @tmp = split (/,/,$_);
  my $dupli=1;
  if ($tmp[2]){
    for my $x (@primary){
      if ($tmp[2] eq $x){
        $dupli=0;
      }
    }
    if ($dupli){
      push (@primary, $tmp[2]);
      if ($tmp[3]){
        print fichier2 $tmp[0], ",", $tmp[1], ",",$tmp[2], ",",$tmp[3];
      }
      else {
        print fichier2 $tmp[0], ",", $tmp[1], ",",$tmp[2], ",";
      }
      print fichier2 "\n";
    }
  }
}
close (fichier1);
close (fichier2);
print "FINI !\n";
