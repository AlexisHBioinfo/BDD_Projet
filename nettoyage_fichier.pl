#!/usr/bin/perl
use strict;
use warnings;
my @tmp;
my @primary;
open (fichier2,">testmartexport_cleaned.csv");
open (fichier1, "test_martexport.csv");
while (<fichier1>){
  chomp;
  @tmp = split (/,/,$_);
  my $dupli;
  if ($tmp[2]){
    for my $x (@primary){
      if ($tmp[2]==$x){
        $dupli=0;
      }
    }
    if ($dupli){
      print fichier2 "\n";
      push (@primary, $tmp[2]);
      if ($tmp[3]){
        print fichier2 $tmp[0], ",", $tmp[1], ",",$tmp[2], ",",$tmp[3];
      }
      else {
        print fichier2 $tmp[0],",", $tmp[1], ",",$tmp[2];
      }
      
    }
  }
}
close (fichier1);
close (fichier2);
