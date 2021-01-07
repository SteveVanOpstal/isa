import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isa/bloc/notesBloc.dart';
import 'package:isa/bloc/sectionBloc.dart';
import 'package:isa/models/section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:isa/widgets/color/colorsDialogWidget.dart';
import 'package:rive/rive.dart';

class LinearHoldAnimationInstance extends LinearAnimationInstance {
  int _direction = 1; // super `set time()` sets the direction to 1

  LinearHoldAnimationInstance(animation) : super(animation);

  toggle() {
    _direction = _direction == 1 ? -1 : 1;
  }

  @override
  bool advance(double elapsedSeconds) {
    super.time += elapsedSeconds * animation.speed * _direction;
    double frames = super.time * animation.fps;
    var start = animation.enableWorkArea ? animation.workStart : 0;
    var end = animation.enableWorkArea ? animation.workEnd : animation.duration;

    if (_direction == 1 && frames > end) {
      frames = end.toDouble();
      super.time = frames / animation.fps;
      return false;
    }

    if (_direction == -1 && frames < start) {
      frames = start.toDouble();
      super.time = frames / animation.fps;
      return false;
    }
    return true;
  }
}

class LinearHoldAnimationController
    extends RiveAnimationController<RuntimeArtboard> {
  LinearHoldAnimationController(this.animationName);

  LinearHoldAnimationInstance _instance;
  final String animationName;

  LinearHoldAnimationInstance get instance => _instance;

  @override
  bool init(RuntimeArtboard artboard) {
    var animation = artboard.animations.firstWhere(
      (animation) =>
          animation is LinearAnimation && animation.name == animationName,
      orElse: () => null,
    );
    if (animation != null) {
      _instance = LinearHoldAnimationInstance(animation as LinearAnimation);
    }
    isActive = true;
    return _instance != null;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    _instance.animation.apply(_instance.time, coreContext: artboard);
    if (!_instance.advance(elapsedSeconds)) {
      isActive = false;
    }
  }
}

// ignore: must_be_immutable
class CustomRive extends LeafRenderObjectWidget {
  final Artboard artboard;
  final bool useIntrinsicSize;
  final BoxFit fit;
  final Alignment alignment;
  final LinearHoldAnimationInstance animationInstance;
  CustomRiveRenderObject _renderObjectInstance;

  CustomRive({
    @required this.artboard,
    this.useIntrinsicSize = false,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.animationInstance,
  });

  hit(Offset position) {
    if (this._renderObjectInstance != null &&
        this._renderObjectInstance.hit(position)) {
      return true;
    }
    return false;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    this._renderObjectInstance = CustomRiveRenderObject(animationInstance)
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..useIntrinsicSize = useIntrinsicSize;
    return _renderObjectInstance;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant CustomRiveRenderObject renderObject) {
    renderObject
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..useIntrinsicSize = useIntrinsicSize;
    this._renderObjectInstance = renderObject;
  }

  @override
  void didUnmountRenderObject(covariant CustomRiveRenderObject renderObject) {
    renderObject.dispose();
  }
}

class CustomRiveRenderObject extends RiveRenderObject {
  final LinearHoldAnimationInstance animationInstance;
  Path _path = Path();
  Path _hitPath = Path();
  Offset _offset = Offset.zero;

  CustomRiveRenderObject(this.animationInstance);

  _updateClipPath(Offset offset) {
    double distance = (170 * animationInstance.time).clamp(0, 170);
    double distanceInverse = (170 - distance).clamp(0, 170);
    _hitPath.reset();
    _hitPath.addPolygon([
      offset + Offset((distanceInverse - 15).clamp(-15, 110).toDouble(), 170),
      offset + Offset(distanceInverse + 40, 170),
      offset + Offset(170, distanceInverse + 40),
      offset + Offset(170, (distanceInverse - 15).clamp(-15, 110).toDouble())
    ], true);
    _hitPath.close();

    _path.reset();
    _path.addPolygon([
      offset + Offset(-30, 170),
      offset + Offset(distanceInverse + 30, 170),
      offset + Offset(170, distanceInverse + 30),
      offset + Offset(170, -30)
    ], true);
    _path.close();

    _offset = offset;
  }

  bool hit(Offset position) {
    return _hitPath.contains(position);
  }

  bool hitTest(BoxHitTestResult result, {Offset position}) {
    assert(() {
      if (!hasSize) {
        if (debugNeedsLayout) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
                'Cannot hit test a render box that has never been laid out.'),
            describeForError(
                'The hitTest() method was called on this RenderBox'),
            ErrorDescription(
                "Unfortunately, this object's geometry is not known at this time, "
                'probably because it has never been laid out. '
                'This means it cannot be accurately hit-tested.'),
            ErrorHint('If you are trying '
                'to perform a hit test during the layout phase itself, make sure '
                "you only hit test nodes that have completed layout (e.g. the node's "
                'children, after their layout() method has been called).'),
          ]);
        }
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot hit test a render box with no size.'),
          describeForError('The hitTest() method was called on this RenderBox'),
          ErrorDescription(
              'Although this node is not marked as needing layout, '
              'its size is not set.'),
          ErrorHint('A RenderBox object must have an '
              'explicit size before it can be hit-tested. Make sure '
              'that the RenderBox in question sets its size during layout.'),
        ]);
      }
      return true;
    }());
    if (_path.contains(position + _offset)) {
      if (hitTestChildren(result, position: position) ||
          hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }

  @override
  void beforeDraw(Canvas canvas, Offset offset) {
    _updateClipPath(offset);
    canvas.clipPath(_path);
  }
}

class CornerButtonsClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.addPolygon([Offset(0, 170), Offset(170, 170), Offset(170, 0)], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SectionHeadingWidget extends StatefulWidget {
  final Section section;
  final double width;
  final double height;

  const SectionHeadingWidget(
      {@required this.section, @required this.width, @required this.height});

  @override
  _SectionHeadingWidgetState createState() => _SectionHeadingWidgetState();
}

class _SectionHeadingWidgetState extends State<SectionHeadingWidget> {
  Artboard _artboard;
  LinearHoldAnimationController _controller;
  AsyncValueSetter onAnimationChange;

  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/corner.riv');
    final file = RiveFile();

    if (file.import(bytes)) {
      _artboard = file.mainArtboard;
      _controller = LinearHoldAnimationController('curl');
      setState(() {
        _artboard.addController(_controller);
        var background = _artboard.drawables
            .firstWhere((drawable) => drawable.name == 'background') as Shape;
        for (var fill in background.fills) {
          fill.paint.color = widget.section.color;
        }
        if (_artboard is Artboard) {
          for (var drawable in _artboard.drawables) {
            for (var stroke in (drawable as Shape).strokes) {
              stroke.paint.color = Theme.of(context).scaffoldBackgroundColor;
            }
          }
        }
      });
    }
  }

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _rive = _artboard == null
        ? null
        : CustomRive(
            artboard: _artboard,
            animationInstance: _controller.instance,
          );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(10.0),
            child: Text(widget.section.title),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            height: 170,
            width: 170,
            child: ClipPath(
              clipper: CornerButtonsClipper(),
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 0, 0),
                color: Theme.of(context).scaffoldBackgroundColor,
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 110,
                  height: 110,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      SizedBox(),
                      IconButton(
                        color: widget.section.color,
                        alignment: Alignment.center,
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            context.read<NotesBloc>().add(AddNewNoteEvent());
                          });
                        },
                      ),
                      IconButton(
                        color: widget.section.color,
                        alignment: Alignment.center,
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        color: widget.section.color,
                        alignment: Alignment.center,
                        icon: Icon(Icons.color_lens),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => ColorsDialogWidget(
                              activeColor: widget.section.color,
                              onPressed: (color) {
                                setState(() {
                                  context
                                      .read<SectionBloc>()
                                      .add(UpdateSectionColorEvent(color));
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            height: 170,
            width: 170,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 2.5, 2.0),
              child: Listener(
                onPointerDown: (event) {
                  if (_rive != null && _rive.hit(event.position)) {
                    setState(() {
                      _controller.instance.toggle();
                      _controller.isActive = true;
                    });
                  }
                },
                child: _rive ?? const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
