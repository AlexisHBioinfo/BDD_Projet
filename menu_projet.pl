#!/usr/bin/perl
use strict;
use warnings;
use DBI;
my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
print "Bienvenue dans le menu d'accès à la base de données\n";
my $choix;
while (1){
  print "Que voulez vous faire ? (0 pour ajouter une protéine,1 pour , 2 pour )\n";
  $choix = <STDIN>;
  if ($choix==0){
    print "Vous avez choisi d'ajouter une protéine !\nEntrez son identifiant Uniprot !\n";
    my $uniprot=<STDIN>;
    print "Veuillez rentrer les données que vous avez sur cette protéine. ('None si inconnu')\n \n";
    print "Quel est le nom de la protéine ?\n";
    my $protein_name=<STDIN>;
    print "Quelle est la longueur de cette protéine ?\n";
    my $length=<STDIN>;
    if (not $length=~/\d/){
      $length=0;
    }
    print "Quel est son identifiant sur EnsemblPlants ? \n";
    my $ensemblPlants=<STDIN>;
    print "Quelle est sa séquence ?\n";
    my $sequence=<STDIN>;
    print "Quel est le nom de son gène ?\n";
    my $gene_name=<STDIN>;
    print "Quel ";
    $dbh -> do ("INSERT INTO Protein(Entry, Protein_name, Length, EnsemblPlants, Sequence) VALUES ('$uniprot', '$protein_name', '$length', '$ensemblPlants', '$sequence')");
  }
}
