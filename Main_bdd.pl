#!/usr/bin/perl
use strict;
use warnings;
use DBI;

print "Creation de la base de donnée en cours !\n";
my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
$dbh->do("CREATE table Main(Entry varchar(20) primary key, Status varchar(20) constraint R_U check(Status in ('reviewed','unreviewed')), Organism text, Protein_name text, Length int constraint LENGTH_POSITIF check(Length>0), EnsemblPlants text, Sequence text, Gene_names text)");
my @tmp;
my $a;
my $processing=0;
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
    $a += $dbh -> do ("INSERT INTO Main (Entry, Status, Organism, Protein_name, Length, EnsemblPlants, Sequence, Gene_names) VALUES ('$tmp[0]', '$tmp[2]', '$tmp[5]', '$tmp[3]', '$tmp[6]', '$tmp[9]', '$tmp[10]', '$tmp[4]')");
  }
  $header=1;
}
close (fichier1);
$dbh->disconnect();
