import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final videoProvider =
    StateNotifierProvider<VideoNotifier, YoutubePlayerController>((ref) {
  return VideoNotifier(ref);
});

class VideoNotifier extends StateNotifier<YoutubePlayerController> {
  VideoNotifier(this.ref)
      : super(YoutubePlayerController(initialVideoId: 'uGRIREKQpE4'));

  final StateNotifierProviderRef ref;

  playTrailer(String videoId) {
    // Elimina el listener del controlador actual
    state.removeListener(_onPlayerStateChange);

    state = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        disableDragSeek: true,
      ),
    );

    // Agrega el listener al nuevo controlador
    state.addListener(_onPlayerStateChange);

    state.toggleFullScreenMode();
  }

  // Listener para gestionar los cambios de estado
  void _onPlayerStateChange() {
    if (!state.value.isFullScreen) {
      // Restaura la visibilidad de las barras del sistema al salir de pantalla completa
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    // Limpia el listener al destruir el provider
    state.removeListener(_onPlayerStateChange);
    super.dispose();
  }
}
