import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Service/NotificationService.dart';
import 'package:escuchamos_flutter/Api/Command/NotificationCommand.dart';
import 'package:escuchamos_flutter/Api/Service/NotificationLive.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/NotificationPopup.dart';


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int localNotificationValue = 0;
  bool showPopup = false; // Controla si el popup está visible

  @override
  void initState() {
    super.initState();
    _IsSeen(); // Llamada al servicio
    notification.addListener(_onNotificationChange);
  }

  void _onNotificationChange() {
    if (!mounted) return;
    if (notification.value > localNotificationValue) {
      setState(() {
        showPopup = true; // Mostrar popup al recibir nuevas notificaciones
      });
    } else {
      setState(() {
        showPopup = false; // Ocultar popup cuando no hay nuevas notificaciones
      });
    }
  }

  Future<void> _IsSeen() async {
    final isSeenCommand = IsSeenCommand(IsSeenService());
    try {
      final response = await isSeenCommand.execute();
      if (mounted) {
        if (response is SuccessResponse) {
          // Aquí puedes manejar la respuesta exitosa si lo necesitas
        } else {
          await showDialog(
            context: context,
            builder: (context) => AutoClosePopupFail(
              child: const FailAnimationWidget(),
              message: response.message,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    notification.removeListener(_onNotificationChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Hola Mundo',
              style: TextStyle(fontSize: 24),
            ),
          ),
          if (showPopup)
            Positioned(
              top: 6,
              left: 0,
              right: 0,
              child: NotificationPopup(
                message: '¡Tienes nuevas notificaciones!',
                onDismiss: () {
                  setState(() {
                    showPopup = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

