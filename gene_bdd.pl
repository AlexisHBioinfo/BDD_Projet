#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
$dbh->do("CREATE table Genes(Gene_names text primary key, Genename_synonym text, Gene_ontology text)");
my @tmp;
my $a;
my $processing=0;
my @list_primary_key;
push (@list_primary_key, "");
my $dupli=1;
open (fichier1, "uniprot_file.tab");
my $header=0;
while (<fichier1>){
  if ($processing%1000==0){
    print "Process en cours ! \t Actuellement à la ligne : ",$processing, "\n";
  }
  $processing++;
  chomp;
  if ($header){
    @tmp = split (/\t/,$_);
    if ($tmp[4] ~~ @list_primary_key){
      $dupli=0;
    }
    if ($dupli){
      if ($tmp[7]){
        $a += $dbh -> do ("INSERT INTO Genes(Gene_names, Genename_synonym, Gene_ontology) VALUES ('$tmp[4]', '$tmp[7]', '$tmp[8]')");
      }
      else {
        $a += $dbh -> do ("INSERT INTO Genes(Gene_names, Genename_synonym, Gene_ontology) VALUES ('$tmp[4]', NULL, '$tmp[8]')");
      }
      push (@list_primary_key, $tmp[4]);
    }
    $dupli=1;
  }
  $header=1;
}
close (fichier1);
$dbh->disconnect();
