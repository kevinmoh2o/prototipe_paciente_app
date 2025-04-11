import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/recommendation_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class RecommendationDetailScreen extends StatelessWidget {
  final RecommendationModel recommendation;

  const RecommendationDetailScreen({Key? key, required this.recommendation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recommendation.title),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recommendation.resources.length,
        itemBuilder: (ctx, i) {
          final resource = recommendation.resources[i];
          return _buildResourceItem(resource);
        },
      ),
    );
  }

  Widget _buildResourceItem(ResourceModel resource) {
    switch (resource.type) {
      case ResourceType.text:
        // Texto motivacional o descriptivo (con decoraciones de ejemplo)
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            resource.content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        );

      case ResourceType.image:
        // Mostrar una imagen de assets
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              resource.content,
              fit: BoxFit.cover,
            ),
          ),
        );

      case ResourceType.video:
        // Mostrar un reproductor de video con Chewie
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _ChewieVideoPlayerWidget(assetPath: resource.content),
        );

      case ResourceType.audio:
        // Mostrar un reproductor de audio con audioplayers
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _AudioPlayerWidget(assetPath: resource.content),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

/////////////////////////////////////////////////////////
// Reproductor de video con Chewie
/////////////////////////////////////////////////////////
class _ChewieVideoPlayerWidget extends StatefulWidget {
  final String assetPath;

  const _ChewieVideoPlayerWidget({Key? key, required this.assetPath}) : super(key: key);

  @override
  State<_ChewieVideoPlayerWidget> createState() => _ChewieVideoPlayerWidgetState();
}

class _ChewieVideoPlayerWidgetState extends State<_ChewieVideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    // Iniciamos el controlador del video
    _videoPlayerController = VideoPlayerController.asset(widget.assetPath);
    // Configuramos Chewie para usar el controlador del video_player
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      // Más configuraciones
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    // Importante para liberar recursos
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      // Muestra una carga inicial
      return const Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Chewie(controller: _chewieController!),
    );
  }
}

/////////////////////////////////////////////////////////
// Reproductor de audio con audioplayers
/////////////////////////////////////////////////////////
class _AudioPlayerWidget extends StatefulWidget {
  final String assetPath;

  const _AudioPlayerWidget({Key? key, required this.assetPath}) : super(key: key);

  @override
  State<_AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<_AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  PlayerState _audioPlayerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Variable para almacenar el valor inicial del slider cuando se empieza a mover.
  double? _sliderStartValue;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Configurar listeners
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_audioPlayerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      // Extrae la ruta relativa quitando "assets/" del inicio, si existe.
      String relativePath = widget.assetPath;
      if (relativePath.startsWith("assets/")) {
        relativePath = relativePath.substring("assets/".length);
      }
      await _audioPlayer.play(AssetSource(relativePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Reproductor de audio",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          IconButton(
            icon: Icon(
              _audioPlayerState == PlayerState.playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
              size: 40,
            ),
            onPressed: _togglePlay,
          ),
          Slider(
            min: 0,
            max: _duration.inMilliseconds.toDouble() > 0 ? _duration.inMilliseconds.toDouble() : 1,
            value: _position.inMilliseconds.toDouble().clamp(0.0, _duration.inMilliseconds.toDouble()),
            onChangeStart: (value) {
              // Guardamos el valor inicial del slider al comenzar a moverlo.
              _sliderStartValue = value;
            },
            onChanged: (value) {
              setState(() {
                // Solo actualizamos la posición en la UI, sin afectar el audio todavía.
                _position = Duration(milliseconds: value.toInt());
              });
            },
            onChangeEnd: (value) async {
              final newPosition = Duration(milliseconds: value.toInt());
              // Si el usuario retrocede (valor final menor que el valor inicial), pausamos el audio.
              if (_sliderStartValue != null && value < _sliderStartValue!) {
                await _audioPlayer.pause();
              }
              await _audioPlayer.seek(newPosition);
            },
          ),
          Text(
            "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
