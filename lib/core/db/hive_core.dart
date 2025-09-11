abstract class HiveCore {
  Future<void> init();

  Future<void> close();

  Future<void> ensureBoxOpen();
}
