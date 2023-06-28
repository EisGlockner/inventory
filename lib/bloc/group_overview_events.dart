abstract class PlayerOverviewEvent {}

class LoadPlayers extends PlayerOverviewEvent {}

class AddGroup extends PlayerOverviewEvent {
  final String name;

  AddGroup(this.name);
}

class DeleteGroup extends PlayerOverviewEvent {
  final bool deleteSpieler;

  DeleteGroup(this.deleteSpieler);
}
