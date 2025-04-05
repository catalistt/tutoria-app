import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Archivo que contiene los widgets comunes reutilizables para la aplicación

// CustomTextField - Campo de texto personalizado
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// CustomButton - Botón personalizado
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isSmall;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          );

    final textWidget = Text(
      text,
      style: TextStyle(
        fontSize: isSmall ? 14 : 16,
        fontWeight: FontWeight.bold,
      ),
    );

    final buttonSize = Size(
      double.infinity,
      isSmall ? 40 : 50,
    );

    if (icon != null) {
      return SizedBox(
        width: double.infinity,
        height: isSmall ? 40 : 50,
        child: isOutlined
            ? OutlinedButton.icon(
                style: buttonStyle.copyWith(
                  minimumSize: MaterialStateProperty.all(buttonSize),
                ),
                onPressed: onPressed,
                icon: Icon(icon),
                label: textWidget,
              )
            : ElevatedButton.icon(
                style: buttonStyle.copyWith(
                  minimumSize: MaterialStateProperty.all(buttonSize),
                ),
                onPressed: onPressed,
                icon: Icon(icon),
                label: textWidget,
              ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: isSmall ? 40 : 50,
      child: isOutlined
          ? OutlinedButton(
              style: buttonStyle.copyWith(
                minimumSize: MaterialStateProperty.all(buttonSize),
              ),
              onPressed: onPressed,
              child: textWidget,
            )
          : ElevatedButton(
              style: buttonStyle.copyWith(
                minimumSize: MaterialStateProperty.all(buttonSize),
              ),
              onPressed: onPressed,
              child: textWidget,
            ),
    );
  }
}

// LoadingIndicator - Indicador de carga
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.size = 36,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

// ErrorMessage - Mensaje de error
class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SuccessMessage - Mensaje de éxito
class SuccessMessage extends StatelessWidget {
  final String message;

  const SuccessMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomCard - Tarjeta personalizada para contenido
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double elevation;
  final Color? color;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.elevation = 2,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color ?? Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

// SectionTitle - Título de sección
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onMorePressed;

  const SectionTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.onMorePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (onMorePressed != null)
            TextButton(
              onPressed: onMorePressed,
              child: const Text('Ver más'),
            ),
        ],
      ),
    );
  }
}

// EmptyState - Estado vacío
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyState({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.hourglass_empty,
    this.onActionPressed,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: actionLabel!,
                onPressed: onActionPressed!,
                isSmall: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
