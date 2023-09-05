import '../../data/model.dart';

abstract class PlayerOverviewState {}

class PlayerOverviewInitial extends PlayerOverviewState {}

class PlayerOverviewLoading extends PlayerOverviewState {}

class PlayerOverviewLoaded extends PlayerOverviewState {
  List<Spieler> players = [];
  final String? groupName;
  final List<Gruppen> groups;

  PlayerOverviewLoaded(this.players, this.groupName, this.groups);
}

class PlayerOverviewError extends PlayerOverviewState {}

class GroupAdded extends PlayerOverviewState {}

class GroupDeleted extends PlayerOverviewState {}

class PlayerDeleted extends PlayerOverviewState {}
