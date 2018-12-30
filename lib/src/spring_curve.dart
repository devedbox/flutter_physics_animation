import 'dart:math';
import 'package:flutter/animation.dart' show Curve;
import 'package:flutter/physics.dart' show 
  Tolerance,
  SpringSimulation,
  SpringDescription
;

class SpringCurve extends Curve {
  final SpringSimulation _spring;
  final double _settlingDuration;

  SpringCurve(
    SpringDescription spring,
    {  
      Tolerance tolerance = const Tolerance(time: 1e-4),
      double velocity = 0.0
    }
  ) : this._spring = SpringSimulation(
    spring, 0.0, 1.0, velocity
  ), this._settlingDuration = _settlingDurationForSpring(spring, tolerance: tolerance);

  static double _settlingDurationForSpring(SpringDescription spring, { Tolerance tolerance }) {
    final  beta      = spring.damping / (2 * spring.mass);
    final  omega0    = sqrt(spring.stiffness / spring.mass);
    final  duration  = -(log(tolerance.time)) / min(beta, omega0);

    return duration;
  }

  @override
  double transform(double t) {
    if (t == 0.0) return 0.0; // Forbids the tolerance.
    if (t == 1.0) return 1.0; // Forbids the tolerance.
    
    return _spring.x(_settlingDuration * t).clamp(0.0, 1.0);
  }
}