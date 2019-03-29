#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
$dbh->do("CREATE table Protein(Entry varchar(20) primary key, Protein_name text, Length int, EnsemblPlants text, Sequence text)");
my @tmp;
my $a;
open (fichier1, "uniprot_file.csv");
my $header=0;
while (<fichier1>){
  chomp;
  if ($header){
    @tmp = split (/\t/,$_);
    $a += $dbh -> do ("INSERT INTO Protein(Entry, Protein_name, Length, EnsemblPlants, Sequence) VALUES ('$tmp[0]', '$tmp[3]', '$tmp[6]', '$tmp[9]', '$tmp[10]')");
  }
  $header=1;
}
close (fichier1);
$dbh->disconnect();
