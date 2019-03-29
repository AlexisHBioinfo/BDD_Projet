#!/usr/bin/perl
use strict;
use warnings;
my @tmp3;
open(fichier3,"uniprot-arabidopsisthalianaSequence.tab");
open(fichier4,">uniprot_file.csv");
while (<fichier3>){
  chomp;
  @tmp3=split(/\t/,$_);
  my $cpt=0;
  for my $x (@tmp3){
    $tmp3[$cpt]=~tr/\'/ /;
    $cpt++;
  }
  for my $element (@tmp3){
    print fichier4 "$element";
    print fichier4 "\t";
  }
  print fichier4 "\n";
}
