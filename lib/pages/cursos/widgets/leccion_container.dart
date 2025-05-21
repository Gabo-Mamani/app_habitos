import 'package:flutter/material.dart';

class LeccionContainer extends StatelessWidget {
  final Widget child;
  final String titulo;
  final IconData icono;
  final Color colorIcono;
  final EdgeInsetsGeometry? padding;

  const LeccionContainer({
    super.key,
    required this.child,
    required this.titulo,
    required this.icono,
    this.colorIcono = Colors.blueAccent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: colorIcono, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
