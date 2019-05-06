#!/usr/bin/perl
use strict;
use warnings;
my @tmp;
open(Uniprot_file,"uniprot-arabidopsisthalianaSequence.tab");
print ("Quelle est la longueur minimale des protéines recherchées ?\n");
my $lengthInput=<STDIN>;
chomp($lengthInput);
my $header=0;
while (<Uniprot_file>){
  if ($header!=0){
    @tmp=split(/\t/,$_);
    my $length=$tmp[6];
    if ($length>$lengthInput){
      print "La protéine ", $tmp[3], " avec l'ID ", $tmp[0], " a une taille supérieure à ", $lengthInput ," (", $length, ")\n";
      if ($tmp[7]){
        print "\t\t\t Cette protéine est codée par le gène ", $tmp[4], " appelé aussi ", $tmp[7], " chez l'organisme ", $tmp[5], "\n";
      }
      print "\t\t\t Cette protéine est codée par le gène ", $tmp[4], " chez l'organisme ", $tmp[5], "\n";
    }
  }
  $header=1;
}
close(Uniprot_file);
