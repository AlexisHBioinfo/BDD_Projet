#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
$dbh->do("CREATE table Reaction(Entry_Uniprot varchar(20) primary key, Gene_stable_ID varchar(20), Transcript_stable_ID varchar(20), Plant_Reactom varchar(20))");
open (fichier2, "martexport_cleaned.csv");
my $b;
my @tmp2;
my $header2=0;
while (<fichier2>){
  chomp;
  if ($header2){
    @tmp2=split(/,/,$_);
    if ($tmp2[3]){
      $b += $dbh -> do ("INSERT INTO Reaction (Entry_Uniprot, Gene_stable_ID, Transcript_stable_ID, Plant_Reactom) VALUES ('$tmp2[2]','$tmp2[0]','$tmp2[1]','$tmp2[3]')");
    }
    else {
      $b += $dbh -> do ("INSERT INTO Reaction (Entry_Uniprot, Gene_stable_ID, Transcript_stable_ID, Plant_Reactom) VALUES ('$tmp2[2]','$tmp2[0]','$tmp2[1]',NULL)");
    }
  }
  $header2=1;
}
close (fichier2);
$dbh->disconnect();
