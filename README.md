### App Clima

 Aplicacion movil de android la cual nos permite medir el clima dependiendo de nuestra ubicación diciendo:
 - La ubicacion en la que nos encontramos
 - El pronostico aproximado con un icono alusivo
 - Por ultimo la temperatura aproximada en grados celcius 

#### Instrucciones de uso y de instalación

Para instalar la app de clima en nuestros dispositivos Android desde de Visual Studio hay dos opciones: 

## Opcion #1

Es quizas la opcion mas dificil pero con ella podremos saber si tendremos errores en los codigos internos de nuestra app:
- Como primer paso tendremos que abrir nuestra carpeta madre en el editor de codigo Visual Studio que contiene todos los archivos de nuestra app.
- El segundo paso es conectar por USB nuestro disposivo movil al PC.
- El tercer paso es configurar nuestro telefono en modo desarrollador para asi despues activar "La depuracion por USB", esto nos permitira que nuestro PC le envie la app al dispositivo movil
- Nuestro Pc idenificara que nuestro telefono esta sirviendo como un emulador fisico y solamente queda presionar la tecla "F5" y ya empezara la instalación

## Opcion #2

Es la opcion mas facil y rapida para la instalación de la app:
- Con nuestra carpeta madre abierta en el editor de codigo de Visual Studio, abriremos la terminal y escribiremos este comando "flutter build apk --release", esto hara que Visual nos haga una APK de nuestro proyecto
- Al final del proceso, la terminal nos mostrara una ruta, solo debemos copiar esa ruta y pegarla en el administrador de archivos de nuestro pc, ahi encontraremos varios archivos, pero el que nos sirve es el .APK
- Ya como ultimo paso, queda pasar ese archivo por medio de USB a nuestro telefono y apenas acabe la transferencia solo es cuestion de dar click y aceptar la instakación de la app

#### LA APP YA TIENE UNA API KEY DE OPENWATHER DENTRO DE LOS CODIGOS, NO HAY NECESIDAD DE CAMBIAR O PONER OTRA

https://github.com/user-attachments/assets/95528875-6e45-44fe-95f3-1db02a25bcc1
