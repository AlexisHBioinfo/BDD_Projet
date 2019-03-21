#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","135264/Huct/Alex",{’RaiseError’ => 1});
$dbh->do("create table Main(Entry varchar(20) primary key, )")
