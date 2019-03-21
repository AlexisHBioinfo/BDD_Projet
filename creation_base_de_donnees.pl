#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
# $dbh->do("CREATE table A(UniProtKB varchar(20) primary key, Transcript_stable_ID varchar(20), Gene_stable_ID varchar(20), Plant_Reactome_Reaction_ID varchar(20))");
my @tmp;
my $a;
open (fichier1, "martexport_cleaned.csv");
my $header=0;
while (<fichier1>){
  chomp;
  if ($header){
    @tmp = split (/,/,$_);
    if ($tmp[3]){
      $a += $dbh -> do ("INSERT INTO A (UniProtKB, Transcript_stable_ID, Gene_stable_ID, Plant_Reactome_Reaction_ID) VALUES ('$tmp[2]', '$tmp[1]', '$tmp[0]', '$tmp[3]')");
    }
    else {
      $a += $dbh -> do ("INSERT INTO A (UniProtKB, Transcript_stable_ID, Gene_stable_ID, Plant_Reactome_Reaction_ID) VALUES ('$tmp[2]', '$tmp[1]', '$tmp[0]', 'None')");
    }
  }
  $header++;
}
close (fichier1);
$dbh->disconnect();
