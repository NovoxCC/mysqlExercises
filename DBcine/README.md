# DBcine

El Proyecto tiene como objetivo desarrollar una aplicación para administrar una sala de cine. La aplicación permitirá gestionar reservas de sillas y registrar los pagos correspondientes. La sala de cine en cuestión consta de 220 sillas, cada una con detalles específicos que incluyen fila, número de silla, tipo y estado.

- **Detalles de las sillas:**
    - Cada silla está ubicada en una fila representada por una letra entre A y K.
    - El número de la silla varía de 1 a 20.
    - Las sillas pueden ser de tipo general o preferencial.
    - El estado de la silla puede ser disponible, reservada o vendida.
- **Costo de las boletas:**
    - Para las sillas en las filas A - H (tipo general), el costo por boleta es de $8,000.
    - Para las sillas en las filas I - K (tipo preferencial), el costo por boleta es de $11,000.
- **Reservas:**
    - Para adquirir una boleta, el cliente debe realizar una reserva.
    - Cada cliente puede reservar hasta 8 sillas.
    - De cada reserva se registra la cédula del cliente, las sillas reservadas y el estado de pago.
- **Pago de reservas:**
    - Las reservas pueden pagarse en efectivo o utilizando la tarjeta CINEMAS.
    - La tarjeta CINEMAS otorga un descuento del 10% en las boletas.
    - Se registra la cédula del dueño de la tarjeta y el saldo disponible en la misma.
- **Funcionalidades de la aplicación:**
    - Crear una nueva tarjeta CINEMAS.
    - Recargar una tarjeta existente.
    - Realizar una nueva reserva.
    - Eliminar una reserva existente.
    - Pagar una reserva en efectivo.
    - Pagar una reserva con tarjeta CINEMAS.
    - Visualizar el estado de las sillas en la sala de cine.
    - Visualizar el dinero acumulado en caja.
