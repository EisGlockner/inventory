import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/bloc/cubits/health_cubit.dart';
import 'package:inventory/bloc/cubits/mana_cubit.dart';
import 'package:inventory/data/model.dart';

void healthCubitTest() {
  group('HealthCubit', () {
    /**
        healthcubit.addPlayer(playerId, currentHealth)
        IncrementHealth(valueToChange, playerId, maxHealth)
        DecrementHealth(valueToChange, playerId, maxHealth)
        SetHealth(valueToChange, playerId, maxHealth)
        getPlayerHealth(playerId)
     */
    test('Health should be incremented', () {
      final healthCubit = HealthCubit();
      healthCubit.addPlayer(1, 50);
      final event = IncrementHealth(20, 1, 60);
      healthCubit.handleEvent(event);

      expect(healthCubit.getPlayerHealth(1), 60);
    });

    test('Health should be decremented', () {
      final healthCubit = HealthCubit();
      healthCubit.addPlayer(1, 50);
      final event = DecrementHealth(60, 1, 60);
      healthCubit.handleEvent(event);

      expect(healthCubit.getPlayerHealth(1), 0);
    });

    test('Health should be set', () {
      final healthCubit = HealthCubit();
      healthCubit.addPlayer(1, 50);
      final event = SetHealth(20, 1, 60);
      healthCubit.handleEvent(event);

      expect(healthCubit.getPlayerHealth(1), 20);
    });
  });

  group('ManaCubit', () {
    /**
        IncrementMana(valueToChange, player, currentMana)
        DecrementMana(valueToChange, player, currentMana)
        SetMana(valueToChange, player)
     */
    Spieler player = Spieler(id: 1, name: 'Test', spielerName: 'TestName', leben: 50, maxLeben: 50, mana: 24, maxMana: 24, seelenkraft: 2, zaehigkeit: 3, schicksalspunkte: 2, proviant: 2, isGlaesern: 1, isEisern: 1, isZaeh: 1, isZerbrechlich: 1, hasAsp: 1, hasKap: 1, kreuzer: 1, heller: 1, silber: 1, dukaten: 1);

    test("Mana should be incremented", () {
      final manaCubit = ManaCubit();
      final event = IncrementMana(8, player, 18);
      manaCubit.handleEvent(event);

      expect(manaCubit.state.mana, 24);
    });

    test('Mana should be decremented', () {
      final manaCubit = ManaCubit();
      final event = DecrementMana(6, player, 3);
      manaCubit.handleEvent(event);

      expect(manaCubit.state.mana, 0);
    });

    test('Mana should be set', () {
      final manaCubit = ManaCubit();
      final event = SetMana(28, player);
      manaCubit.handleEvent(event);

      expect(manaCubit.state.mana, 20);
    });
  });
}
