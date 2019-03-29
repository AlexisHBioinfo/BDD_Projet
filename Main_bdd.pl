#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
$dbh->do("CREATE table Main(Entry varchar(20) primary key, Entry_name varchar(20), Status varchar(20), Organism text)");
my @tmp;
my $a;
open (fichier1, "uniprot_file.csv");
my $header=0;
while (<fichier1>){
  chomp;
  if ($header){
    @tmp = split (/\t/,$_);
    $a += $dbh -> do ("INSERT INTO Main (Entry, Entry_name, Status, Organism) VALUES ('$tmp[0]', '$tmp[1]', '$tmp[2]', '$tmp[5]')");
  }
  $header=1;
}
close (fichier1);
$dbh->disconnect();
