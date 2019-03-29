#!/usr/bin/perl
use strict;
use warnings;
use DBI;
my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
print "Bienvenue dans le menu d'accès à la base de données\n";
my $choix;
while (1){
  print "Que voulez vous faire ?\n\t0 pour ajouter une protéine,\n\t1 pour modifier ou corriger une séquence, \n\t2 pour afficher le nom des protéines (identiant UniProt) qui sont référencées dans le fichier EnsemblPlant, \n\t3 pour afficher le nom des gènes du fichier UniProt qui sont également référencés dans le fichier EnsemblPlant, \n\t4 pour Afficher les protéines ayant une longueur au moins égale à une valeur donnée par l'utilisateur,\n\t5 pour afficher les caractéristiques de la ou les protéines correspondant à un E.C. number(dans le champs protein name) donné par l'utilisateur\n";
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
    print "Quel est son synonyme ?\n";
    my $synonyme=<STDIN>;
    print "Quel est son ontologie ?\n";
    my $ontology=<STDIN>;
    $dbh -> do ("INSERT INTO Protein(Entry, Protein_name, Length, EnsemblPlants, Sequence) VALUES ('$uniprot', '$protein_name', '$length', '$ensemblPlants', '$sequence')");
    $dbh -> do ("INSERT INTO Genes(Gene_names, Genename_synonym, Gene_ontology) VALUES ($gene_name, $synonyme, $ontology)");
  }
  if ($choix==1){
    print "Quelle protéine voulez vous en modifier la séquence ?\n";
    my $requete_proteine=<STDIN>;
    print "Veuillez entrer la nouvelle séquence !\n";
    my $newSequence=<STDIN>;
    $dbh -> do ("UPDATE Protein SET Sequence='$newSequence' WHERE Entry='$requete_proteine';");
  }
  if ($choix==2){
    my $req = $dbh->prepare("SELECT Entry_uniprot FROM Reaction") or die $dbh->errstr();
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print join(" ",@t),"\n";
    }
    $req->finish;
  }
  if ($choix==3){
    my $req = $dbh->prepare("SELECT Gene_names FROM Genes A JOIN Reaction B on A.Gene_names=B.Gene_stable_ID");
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print join(" ",@t),"\n";
    }
    $req->finish;
  }
  if ($choix==4){
    print ("Quelle longueur minimale ?\n");
    my $input=<STDIN>;
    my $req = $dbh->prepare("SELECT Entry FROM Protein WHERE Length>'$input'");
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print join(" ",@t),"\n";
    }
    $req->finish;
  }

}
