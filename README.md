# Calculadora gráfica en ensamblador 8086

Programa para DOS escrito en ensamblador (MASM, ~3,700 líneas) que:

- Lee un polinomio de hasta grado 4 (coeficientes de un dígito, con signo)
- Calcula su **derivada** y su **integral** y las muestra en pantalla
- Resuelve ecuaciones de **primer y segundo grado**
- **Grafica** la función, la derivada o la integral en modo de video 13h (320×200), con rango opcional de −99 a 99
- Genera un **reporte** con fecha y hora en un archivo (servicios de DOS `int 21h`)

**Demo:** https://andreanicte02.github.io/calculadora-assembler/

La demo corre el mismo programa en DOSBox dentro del navegador con [js-dos](https://js-dos.com).
Tiene una guía con un ejemplo: ingresar f(x) = x² − 4, ver su derivada e integral y graficarla.

## Ensamblar

El código es MASM. Para no depender de herramientas de DOS se usa
[JWasm](https://github.com/Baron-von-Riedesel/JWasm), un ensamblador libre compatible con MASM que genera el
`.EXE` directamente:

```bash
jwasm -mz -Fo=CALC.EXE pro2.asm
```

`web/build.sh` ensambla el programa, arma el paquete para js-dos (`CALC.EXE` + `web/dosbox.conf`) y genera la
página en `web/publicar/`. Cada push a `master` la publica con `.github/workflows/pages.yml`.
